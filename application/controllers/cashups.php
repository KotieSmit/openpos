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
        $cashup_data = $this->Cashup->get_full_cashup_info(1);
        $cashup_data = $this->Cashup->get_init_page_info(1);
        $cashup_data['manage_table']=get_cashup_manage_table($this->Cashup->get_outstanding_cashup_list(), $this);
        $this->load->view('cashup/form', $cashup_data);
    }

    function reload()
    {
        $data = $_POST;
        $cashup_id = $this->Cashup->get_active_cashup_id_by_username($data['employee']);
        $cashup_data = $this->Cashup->get_full_cashup_info($cashup_id);
        $this->load->view('cashup/form', $cashup_data);
    }


//    function post(){
//        switch ($_POST['submit']) {
//            case 'clear': $this->loadCashupData();
//            case 'select':$this->loadCashupData($_POST);
//            case 'submit':{}
//        }
//    }
//
    function declareCashup($cashup_id){
        $cashup_data = $this->Cashup->get_full_cashup_info($cashup_id);
        $cashup_data['cashup_id'] = $cashup_id;
        $cashup_data['controller_name']=strtolower(get_class());
        $cashup_data['form_width'] = $this->get_form_width();
        $this->load->view('cashup/declare', $cashup_data);
    }




//
//	public function search(){}
//	public function suggest(){}
//	public function get_row(){}
//	public function view($data_item_id=-1){}
//	public function save($data_item_id=-1){}
//	public function delete(){}
	public function get_form_width(){
        return 750;
    }
}
?>