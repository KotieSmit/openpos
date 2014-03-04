<?php
/**
 * User: Kotie Smit
 * Date: 2013/12/12
 * Time: 12:35 PM
  */
require_once ("secure_area.php");
class Cashups extends Secure_area
{
    function __construct()
    {
        parent::__construct('cashups');
    }

    function index()
    {
//        $cashup_data = $this->Cashup->get_full_cashup_info(1);
        $this->loadCashupListView();
    }

    function loadCashupListView(){
        $cashup_data = $this->Cashup->get_init_page_info(1);
        $cashup_data['manage_table']=get_cashup_manage_table($this->Cashup->get_outstanding_cashup_list(), $this);
        $this->load->view('cashup/form', $cashup_data);
    }

    function declareCashup($cashup_id){
        $cashup_data = $this->Cashup->get_full_cashup_info($cashup_id);
        $cashup_data['cashup_id'] = $cashup_id;
        $cashup_data['controller_name']=strtolower(get_class());
        $cashup_data['form_width'] = $this->get_form_width();
        $this->load->view('cashup/declare', $cashup_data);
    }


    function declare_submit()
    {
        // get data
        $data = $_POST;
        $declare_data = $this->declare_validate($data);
        $declare_data = $this->getCashupData($declare_data);
        // Save to database
        $this->Cashup->saveCashup($declare_data);
        // Success message

        // Reload Cashup grid/screen
        $this->loadCashupListView();
    }

    function declare_validate($data){
        $declare_data['cashup_id'] = $data['cashup_id'];
        foreach ($data as $key=>$data_item){
            if (substr($key, 0, 15) == 'payment_method_'){
                if ($data_item == '')  $data_item = '0';
                $declare_data['payment_methods'][substr($key,15)]['declared_value'] = $data_item;
            }
        }
        return $declare_data;
    }

    function getCashupData($declare_data){
        $employee_id = $this->Employee->get_logged_in_employee_info()->person_id;
        $cashup_data['payment_methods'] = $this->Cashup->get_all_payment_methods_and_totals($declare_data['cashup_id']);
        $declare_data['payment_methods'] = array_merge_recursive($declare_data['payment_methods'],$cashup_data['payment_methods']);
        foreach($declare_data['payment_methods'] as $Key=>$payment_method){
            $declare_data['payment_methods'][$Key]['cashup_id'] = $declare_data['cashup_id'];
            $declare_data['payment_methods'][$Key]['payment_method_id'] = $this->Payment_methods->getPayment_method_ID_By_Name($Key);
            $declare_data['payment_methods'][$Key]['employee_id'] = $employee_id;
            unset ($declare_data['payment_methods'][$Key]['name']);
        }
        return $declare_data;
    }






//
//	public function search(){}
//	public function suggest(){}
//	public function get_row(){}
//	public function view($data_item_id=-1){}
//	public function save($data_item_id=-1){}
//	public function delete(){}
	public function get_form_width(){
        return 600;
    }
}
?>