<?php
/**
 * User: Kotie Smit
 * Date: 2013/12/12
 * Time: 12:49 PM
  */

class Cashup  extends Model{

    function get_full_cashup_info($cashup_id){
        $cashup_data = array();
        $cashup_data['employee_list'] = $this->get_employee_cashup_list();
        $cashup_data['cashup_info'] = $this->get_cashup_info($cashup_id);
        $cashup_data['sales_payments'] = $this->get_all_payment_methods_and_totals($cashup_id);
//        $cashup_data['payment_methods'] = $this->Payment_methods->get_all();
        return $cashup_data;
    }

    function get_outstanding_cashup_list(){
        return $this->db->query("select
                    tbl.cashup_id,
                    tbl.first_name,
                    tbl.last_name,
                    sum(payment_amount) as amount
                from
                    (select
                        openpos_cashups.cashup_id,
                            openpos_people.first_name,
                            openpos_people.last_name
                    from
                        openpos_cashups
                    inner join openpos_people ON openpos_cashups.employee_id = openpos_people.person_id
                    where
                        openpos_cashups.closed IS NULL
                    group by openpos_cashups.cashup_id , openpos_people.first_name , openpos_people.last_name) as tbl
                        inner join
                    openpos_sales_payments ON tbl.cashup_id = openpos_sales_payments.cashup_id
                group by tbl.cashup_id", false);

		return $this->db->get();
    }

    function get_init_page_info(){
        $cashup_data['employee_list'] = $this->get_employee_cashup_list();
        $cashup_data['sales_payments'] = array();
        return $cashup_data;
    }

    function get_cashup_info($cashup_id){
        $this->db->from('cashups');
        $this->db->where('cashup_id',$cashup_id);
		return $this->db->get()->result_array();
    }

    function get_payment_totals_by_cashup_id($cashup_id){
        $this->db->select('SUM(payment_amount) as payment_amount');
        $this->db->select('payment_type');
		$this->db->from('sales_payments');
		$this->db->where('cashup_id',$cashup_id);
        $this->db->group_by("payment_type");
		$this->db->order_by("payment_type");
		return $this->db->get()->result_array();
    }

    function get_all_payment_methods_and_totals($cashup_id){
        $payment_totals= $this->get_payment_totals_by_cashup_id($cashup_id);
        $payment_methods = $this->Payment_methods->get_all();

        $payments = array();
        foreach ($payment_methods as $payment_method) {
            foreach ($payment_totals as $payment_total) {
                $payments[$payment_method['Name']] = array('name' => $payment_method['Name'], 'reported_total' => 0);
                if ($payment_method['Name'] == $payment_total['payment_type']) {
                    $payments[$payment_method['Name']] = array('name' => $payment_method['Name'], 'reported_total' => $payment_total['payment_amount']);
                    break;
                }
            }
        }

        unset($payment_totals);
        unset($payment_methods);
        return $payments;
    }

    /** Get list of employees with open/active cashups */
    function get_employee_cashup_list(){
        $this->db->select('username');
        $this->db->from('employees');
        $this->db->join('cashups', 'employees.person_id = openpos_cashups.employee_id');
        $this->db->where('closed IS NULL');
		$this->db->order_by("username", "desc");

        $result = $this->db->get()->result_array();
        $user_list =array();
        foreach ($result as $row) {
            $username = $row['username'];
            $user_list[$username] = $username;
        }
		return $user_list;;
    }

    function get_active_cashup_id_by_employee_id($employee_id){
        $this->db->from('cashups');
		$this->db->where('employee_id',$employee_id);
        $this->db->where('`closed`');
        $query = $this->db->get();
        if($query->num_rows()==1)
        {
            return $query->row()->cashup_id;
        }
        if($query->num_rows()!=0)
        {
            return -1;
        }

		return 0;
    }

    function get_active_cashup_id_by_username($username){
        $this->db->from('employees');
		$this->db->where('username',$username);
        $employee = $this->db->get()->first_row();
        $employee_id = $employee->person_id;

        $this->db->from('cashups');
        $this->db->where('employee_id',$employee_id);

        $query = $this->db->get();
        if($query->num_rows()==1)
        {
            return $query->row()->cashup_id;
        }
        if($query->num_rows()!=0)
        {
            return -1;
        }

        return 0;
    }


    function saveCashup($data){
        $this->db->trans_start();
        $result = false ;
        foreach($data['payment_methods'] as $payment_method){
            if(!$this->db->insert('cashups_declared',$payment_method)){return false;}
        }

        $this->db->where('cashup_id', $data['cashup_id']);
        if (!$this->db->update('cashups',array('closed'=>date("Y-m-d H:i:s")))){return false;};
        $result = $this->db->trans_complete();
        return $result;
    }

    	/*
	Inserts or updates a cashup
	*/
	function set_new_active_cashup($employee_id)
    {
        $data = array('employee_id'=>$employee_id, 'started'=>date("Y-m-d H:i:s"));

        if($this->db->insert('cashups',$data))
        {
            $item_data['item_id']=$this->db->insert_id();
            return $this->get_active_cashup_id_by_employee_id($employee_id);
        }
        return false;
    }

}