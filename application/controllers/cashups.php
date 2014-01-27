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
        $cashup_data = $this->Cashup->get_full_cashup_info(1);
        $this->load->view('cashup/form', $cashup_data);
    }
//
//	public function search(){}
//	public function suggest(){}
//	public function get_row(){}
//	public function view($data_item_id=-1){}
//	public function save($data_item_id=-1){}
//	public function delete(){}
//	public function get_form_width(){}
}
?>