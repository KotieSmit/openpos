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
		$this->db->order_by("payment_type", "desc");
		return $this->db->get()->result_array();
    }

    function get_all_payment_methods_and_totals($cashup_id){
        $payment_totals= $this->get_payment_totals_by_cashup_id($cashup_id);
        $payment_methods = $this->Payment_methods->get_all();

        $payments = array();
        foreach ($payment_methods as $payment_method) {
            foreach ($payment_totals as $payment_total) {
                if ($payment_method['Name'] == $payment_total['payment_type']) {
                    $payments[$payment_method['Name']] = array('name' => $payment_method['Name'], 'total' => $payment_total['payment_amount']);
                } else {
                    $payments[$payment_method['Name']] = array('name' => $payment_method['Name'], 'total' => 0);
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

    function get_active_cashup_id_by_employee($employee_id){
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
}