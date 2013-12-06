<?php
require_once ("secure_area.php");
class Config extends Secure_area 
{
	function __construct()
	{
		parent::__construct('config');
	}
	
	function index()
	{
        $data['paymentMethods'] = $this->createLinks('config/paymentMethods', 'Payment Methods', array('class'=>"thickbox"));
		$this->load->view("config/config", $data);
	}
		
	function save()
	{
		$batch_save_data=array(
		'company'=>$this->input->post('company'),
		'address'=>$this->input->post('address'),
		'phone'=>$this->input->post('phone'),
		'email'=>$this->input->post('email'),
		'fax'=>$this->input->post('fax'),
		'website'=>$this->input->post('website'),
		'default_tax_1_rate'=>$this->input->post('default_tax_1_rate'),		
		'default_tax_1_name'=>$this->input->post('default_tax_1_name'),		
		'default_tax_2_rate'=>$this->input->post('default_tax_2_rate'),	
		'default_tax_2_name'=>$this->input->post('default_tax_2_name'),
        'config_use_tax_rate_2'=>$this->input->post('config_use_tax_rate_2'),
		'currency_symbol'=>$this->input->post('currency_symbol'),
		'return_policy'=>$this->input->post('return_policy'),
		'language'=>$this->input->post('language'),
		'timezone'=>$this->input->post('timezone'),
		'print_after_sale'=>$this->input->post('print_after_sale'),
		);
		
		if($_SERVER['HTTP_HOST'] !='ospos.pappastech.com' && $this->Appconfig->batch_save($batch_save_data))
		{
			echo json_encode(array('success'=>true,'message'=>$this->lang->line('config_saved_successfully')));
		}
		else
		{
			echo json_encode(array('success'=>false,'message'=>$this->lang->line('config_saved_unsuccessfully')));
	
		}
	}

    public function createLinks($method, $title,  array $attributes){
        return anchor($method, $title, $attributes);
    }

    function paymentMethods(){
        $data['paymentMethods'] = array(0 => array('name' => 'Cash', 'active' => 1, 'over_tender' => 1, 'is_change' => 1),
                                        1 => array('name' => 'Card', 'active' => 1, 'over_tender' => 1, 'is_change' => 0),
                                        2 => array('name' => 'Voucher',  'active' => 1, 'over_tender' => 1, 'is_change' => 0),);
        $this->load->view("config/payment_methods",$data);
    }

}
?>