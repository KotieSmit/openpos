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
        'page_width'=>$this->input->post('page_width'),
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

    function save_payment_methods()
    {
        $methods = $_POST;
        $payment_methods = array();
        foreach ($methods as $method){
            if (is_array($method)){
                $payment_method = array($method['name'] => array(
                    'name' => $method['name'],
                    'active' => (isset($method['active'])) ? 1 : 0,
                    'allow_over_tender' => (isset($method['allow_over_tender'])) ? 1 : 0,
                    'is_change' => (isset($method['is_change'])) ? 1 : 0));
                $payment_methods += $payment_method;
            }
        }
        $this->Payment_methods->save($payment_methods);
        $this->_reload();
    }

    function _reload()
    {
        $data['paymentMethods'] = $this->createLinks('config/paymentMethods', 'Payment Methods', array('class'=>"thickbox"));
        $this->load->view("config/config", $data);
    }

    public function createLinks($method, $title,  array $attributes){
        return anchor($method, $title, $attributes);
    }

    function paymentMethods()
    {
        $data['paymentMethods'] = $this->Payment_methods->get_all();
        $data['paymentmethods_data_table'] = get_payment_methods_manage_table($data['paymentMethods']);
        $this->load->view("config/payment_methods",$data);
    }

}
?>