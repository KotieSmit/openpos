<?php
/**
 * User: Kotie Smit
 * Date: 2013/12/05
 * Time: 11:37 PM
  */

class Payment_methods extends Model{

    function exists($name)
    {
        $this->db->from('payment_methods');
        $this->db->where('Name',$name);
        $query = $this->db->get();

        return ($query->num_rows()==1);
    }

    function get_info($payment_method_name)
    {
        if (strpos($payment_method_name, ":") > 0) {
            $payment_method_name = substr($payment_method_name, 0, strpos($payment_method_name, ":"));
        }
        $query = $this->db->get_where('payment_methods', array('name' => $payment_method_name), 1);

        if($query->num_rows()==1)
        {
            return $query->row();
        }
        else
        {
            //create object with empty properties.
            $fields = $this->db->list_fields('payment_methods');
            $payment_method_obj = new stdClass;

            foreach ($fields as $field)
            {
                $payment_method_obj->$field='';
            }

            return $payment_method_obj;
        }
    }

    /*Gets all payment methods*/
    function get_all($limit=100)
    {
        $this->db->from('payment_methods');
        $this->db->order_by("name", "asc");
        $this->db->limit($limit);
        return $this->db->get()->result_array();
    }

    function get_all_active($limit=100)
    {
        $this->db->from('payment_methods');
        $this->db->where('active', 1);
        $this->db->order_by("name", "asc");
        $this->db->limit($limit);
        return $this->db->get()->result_array();
    }

    function get_default_change_method(){
        $this->db->where('is_change',1);
        $this->db->select('Name');
        $this->db->from('payment_methods');
        return $this->db->get()->row_array();
    }

    /*
    Inserts or updates a payment_method
    */
    function save(&$payment_method_data)
    {
        $result = true;
        foreach ($payment_method_data as $method){
            if (is_array($method)){
                if (!$this->exists($method['name']))
                {
                    if ($this->db->insert('payment_methods',$method))
                    {
                        $method['payment_methods']=$this->db->insert_id();
                        return true;
                    }
                    $result = false;
                } else {
                    $this->db->where('Name', $method['name']);
                    $this->db->update('payment_methods',$method);
                }
                if (!$result) {
                    return false;
                }
            }

        }

        return true;
    }

    function getPayment_method_ID_By_Name($name){
        $this->db->select('payment_method_id');
        $this->db->from('payment_methods');
        $this->db->where('name', $name);
        $this->db->limit(1);
        $result = $this->db->get()->result_array();
        return $result[0]['payment_method_id'];
    }

}
?>
