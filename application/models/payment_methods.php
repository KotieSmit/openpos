<?php
/**
 * User: Kotie Smit
 * Date: 2013/12/05
 * Time: 11:37 PM
  */

class Payment_methods extends Model{

    function get_info($payment_method_name)
    {
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
        return $this->db->get()->result_array();;
    }

    /*
    Inserts or updates a payment_method
    */
    function save(&$payment_method_data, $payment_method_id=null)
    {
        if (!$payment_method_id)
        {
            if ($this->db->insert('payment_methods',$payment_method_data))
            {
                $person_data['payment_methods']=$this->db->insert_id();
                return true;
            }

            return false;
        }

        $this->db->where('person_id', $payment_method_id);
        return $this->db->update('people',$payment_method_data);
    }

//    function save_multiple(&$items_taxes_data, $item_ids)
//    {
//        foreach($item_ids as $item_id)
//        {
//            $this->save($items_taxes_data, $item_id);
//        }
//    }

}
?>
