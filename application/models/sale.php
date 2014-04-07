<?php
class Sale extends Model
{
    var $full_bom;
    var $main_item;
    var $b;
    var $sale_qty;
    var $sale_item_id;
    var $bom_qty_factor;
    var $curr_bom_quantity;
    var $parent_item_id;
    var $tmp_item_id;
    var $tmp_parent_id;

	public function get_info($sale_id)
	{
		$this->db->from('sales');
		$this->db->where('sale_id',$sale_id);
		return $this->db->get();
	}

	function exists($sale_id)
	{
		$this->db->from('sales');
		$this->db->where('sale_id',$sale_id);
		$query = $this->db->get();

		return ($query->num_rows()==1);
	}

	function update($sale_data, $sale_id)
	{
		$this->db->where('sale_id', $sale_id);
		$success = $this->db->update('sales',$sale_data);

		return $success;
	}

	function save   ($items,$customer_id,$employee_id,$comment,$payments,$sale_id=false, $change)
	{
		if(count($items)==0)
			return -1;

		//Alain Multiple payments
		//Build payment types string
		$payment_types='';
		foreach($payments as $payment_id=>$payment)
		{
			$payment_types=$payment_types.$payment['payment_type'].': '.to_currency($payment['payment_amount']).'<br />';
		}

		$sales_data = array(
			'sale_time' => date('Y-m-d H:i:s'),
			'customer_id'=> $this->Customer->exists($customer_id) ? $customer_id : null,
			'employee_id'=>$employee_id,
			'payment_type'=>$payment_types,
			'comment'=>$comment,
            'cashup_id' => $this->session->userdata['cashup_id']
		);

		//Run these queries as a transaction, we want to make sure we do all or nothing
		$this->db->trans_start();
		$this->db->insert('sales',$sales_data);
		$sale_id = $this->db->insert_id();

		foreach($payments as $payment_id=>$payment)
		{
            $payment_type = $payment['payment_type'];
			if ( substr( $payment['payment_type'], 0, strlen( $this->lang->line('sales_giftcard') ) ) == $this->lang->line('sales_giftcard') )
			{
				/* We have a gift card and we have to deduct the used value from the total value of the card. */
				$splitpayment = explode( ':', $payment['payment_type'] );
				$cur_giftcard_value = $this->Giftcard->get_giftcard_value( $splitpayment[1] );
				$this->Giftcard->update_giftcard_value( $splitpayment[1], $cur_giftcard_value - $payment['payment_amount'] );
                $payment_type = $splitpayment[0];
			}


			$sales_payments_data = array
			(
				'sale_id'=>$sale_id,
				'payment_type'=>$payment_type,
				'payment_amount'=>$payment['payment_amount'],
                'fk_reason'=>$payment['fk_reason'],
                'cashup_id' => $this->session->userdata['cashup_id']
			);
			$this->db->insert('sales_payments',$sales_payments_data);
		}

        if (is_array($change)){
            foreach($change as $payment_id=>$value){
                $sales_payments_data = array
                (
                    'sale_id'=>$sale_id,
                    'payment_type'=>$value['payment_type'],
                    'payment_amount'=>$value['payment_amount'],
                    'fk_reason'=>$value['fk_reason'],
                'cashup_id' => $this->session->userdata['cashup_id']

                );
                $this->db->insert('sales_payments',$sales_payments_data);
             }
        }

		foreach($items as $line=>$item)
		{
			$cur_item_info = $this->Item->get_info($item['item_id']);
			$sales_items_data = array
			(
				'sale_id'=>$sale_id,
				'item_id'=>$item['item_id'],
				'line'=>$item['line'],
				'description'=>$item['description'],
				'serialnumber'=>$item['serialnumber'],
				'quantity_purchased'=>$item['quantity'],
				'discount_percent'=>$item['discount'],
				'item_cost_price' => $cur_item_info->cost_price,
				'item_unit_price'=>$item['price']
			);
			$this->db->insert('sales_items',$sales_items_data);

			//Update stock quantity
            $item_info = array(
                'item_id'=>$cur_item_info->item_id,
                'stock_keeping_item'=>$cur_item_info->stock_keeping_item
            );
            $this->update_stock_quantity($item_info, $cur_item_info->quantity - $item['quantity']);
            $this->update_stock_tracking($item, $sale_id, $employee_id);
            //* Update BOM items qty and stock tracking
            $this->update_bom_stock_items($this->get_bom_items($item), $sale_id, $employee_id);

			$customer = $this->Customer->get_info($customer_id);
 			if ($customer_id == -1 or $customer->taxable)
 			{
				foreach($this->Item_taxes->get_info($item['item_id']) as $row)
				{
					$this->db->insert('sales_items_taxes', array(
						'sale_id' 	=>$sale_id,
						'item_id' 	=>$item['item_id'],
						'line'      =>$item['line'],
						'name'		=>$row['name'],
						'percent' 	=>$row['percent']
					));
				}
			}
		}
		$this->db->trans_complete();

		if ($this->db->trans_status() === FALSE)
		{
			return -1;
		}

		return $sale_id;
	}



    function build_bom($item, $key){
        if (!isset($bom_qty_factor)) $bom_qty_factor = $this->sale_qty;
        if ($key  == 'item_id') $this->parent_item_id = $item;
        if ($key  == 'bom_item_id') $this->tmp_item_id = $item;
        if ((isset($this->parent_item_id) and isset($this->tmp_item_id) and ($key == 'item_id' or $key == 'bom_item_id'))){
            $item=$this->tmp_item_id;
            unset($this->tmp_item_id);
            if ($key  == 'bom_item_id') {
                $bom_item = (array) $this->Item->get_info($item);
                $this->curr_bom_quantity = $this->Item->get_bom_item_quantity($this->parent_item_id, $bom_item['item_id']);

                if ($bom_item['stock_keeping_item'] == 1) {
                    array_push($this->full_bom, ['item_id'=>$item, 'parent_item_id'=>$this->parent_item_id ,'quantity'=>$bom_qty_factor * $this->curr_bom_quantity]);
                } else {
                    $bom_qty_factor = $bom_qty_factor * $this->curr_bom_quantity;
                    $this->parent_item_id = $bom_item['item_id'];
                    array_walk_recursive($bom_item ,array($this, 'build_bom'));
                }
            }
        }
    }

    function get_bom_items($item){
        $this->full_bom = array();
        $this->sale_qty = $item['quantity'];
        $this->parent_item_id = $item['item_id'];
        array_walk_recursive($item ,array($this, 'build_bom'));
        return $this->full_bom;
    }

    function update_bom_stock_items($item, $sale_id, $employee_id){
        foreach ($item as $bom_item){
            $bom_item_info = $this->Item->get_info($bom_item['item_id']);
            $parent_item_info = $this->Item->get_info($bom_item['parent_item_id']);
            $bom_item = array(
                'item_id'=>$bom_item['item_id'],
                'stock_keeping_item'=>$bom_item_info->stock_keeping_item,
                'quantity'=>$bom_item['quantity'],
                'main_item'=>$parent_item_info->name
            );

            $this->update_stock_quantity($bom_item, $bom_item_info->quantity  - $bom_item['quantity']);
            $this->update_stock_tracking($bom_item, $sale_id, $employee_id);

        }
    }

    function update_stock_quantity($item, $quantity){
        if ($item['stock_keeping_item']){
            $item_data = array('quantity'=>$quantity);
            $this->Item->save($item_data,$item['item_id']);
        }
    }

    function update_stock_tracking($item, $sale_id, $employee_id){
        if ($item['stock_keeping_item']){
            //Ramel Inventory Tracking
            //Inventory Count Details
            $qty_buy = -$item['quantity'];
            $sale_remarks ='POS '.$sale_id;
            if (isset($item['main_item'])) {$sale_remarks = 'POS '.$sale_id . 'Item: ' . $item['main_item'];}
            $inv_data = array
            (
                'trans_date'=>date('Y-m-d H:i:s'),
                'trans_items'=>$item['item_id'],
                'trans_user'=>$employee_id,
                'trans_comment'=>$sale_remarks,
                'trans_inventory'=>$qty_buy
            );
            $this->Inventory->insert($inv_data);
            //------------------------------------Ramel
        }
    }

	function delete($sale_id)
	{
		//Run these queries as a transaction, we want to make sure we do all or nothing
		$this->db->trans_start();

		$this->db->delete('sales_payments', array('sale_id' => $sale_id));
		$this->db->delete('sales_items_taxes', array('sale_id' => $sale_id));
		$this->db->delete('sales_items', array('sale_id' => $sale_id));
		$this->db->delete('sales', array('sale_id' => $sale_id));

		$this->db->trans_complete();

		return $this->db->trans_status();
	}

	function get_sale_items($sale_id)
	{
		$this->db->from('sales_items');
		$this->db->where('sale_id',$sale_id);
		return $this->db->get();
	}

	function get_sale_payments($sale_id)
	{
		$this->db->from('sales_payments');
		$this->db->where('sale_id',$sale_id);
		return $this->db->get();
	}

	function get_customer($sale_id)
	{
		$this->db->from('sales');
		$this->db->where('sale_id',$sale_id);
		return $this->Customer->get_info($this->db->get()->row()->customer_id);
	}

	//We create a temp table that allows us to do easy report/sales queries
	public function create_sales_items_temp_table()
	{
        if (USE_VAT){
            $this->db->query("CREATE TEMPORARY TABLE ".$this->db->dbprefix('sales_items_temp')."
            (SELECT date(sale_time) as sale_date, ".$this->db->dbprefix('sales_items').".sale_id, comment,payment_type, customer_id, employee_id,
            ".$this->db->dbprefix('items').".item_id, supplier_id, quantity_purchased, item_cost_price, item_unit_price, SUM(percent) as item_tax_percent,
            discount_percent, (item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100) as total,
            ".$this->db->dbprefix('sales_items').".line as line, serialnumber, ".$this->db->dbprefix('sales_items').".description as description,
            ROUND(((item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100)/(1+ SUM(percent)/100)),2) as subtotal,
            ROUND((item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100) - ((item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100)/(1+ SUM(percent)/100)),2) as tax,
            ROUND((item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100),2) - ROUND((item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100) - ((item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100)/(1+ SUM(percent)/100)),2) - (item_cost_price*quantity_purchased) as profit
            FROM ".$this->db->dbprefix('sales_items')."
            INNER JOIN ".$this->db->dbprefix('sales')." ON  ".$this->db->dbprefix('sales_items').'.sale_id='.$this->db->dbprefix('sales').'.sale_id'."
            INNER JOIN ".$this->db->dbprefix('items')." ON  ".$this->db->dbprefix('sales_items').'.item_id='.$this->db->dbprefix('items').'.item_id'."
            LEFT OUTER JOIN ".$this->db->dbprefix('suppliers')." ON  ".$this->db->dbprefix('items').'.supplier_id='.$this->db->dbprefix('suppliers').'.person_id'."
            LEFT OUTER JOIN ".$this->db->dbprefix('sales_items_taxes')." ON  "
            .$this->db->dbprefix('sales_items').'.sale_id='.$this->db->dbprefix('sales_items_taxes').'.sale_id'." and "
            .$this->db->dbprefix('sales_items').'.item_id='.$this->db->dbprefix('sales_items_taxes').'.item_id'." and "
            .$this->db->dbprefix('sales_items').'.line='.$this->db->dbprefix('sales_items_taxes').'.line'."
            GROUP BY sale_id, item_id, line)");
        }else{
            $this->db->query("CREATE TEMPORARY TABLE ".$this->db->dbprefix('sales_items_temp')."
            (SELECT date(sale_time) as sale_date, ".$this->db->dbprefix('sales_items').".sale_id, comment,payment_type, customer_id, employee_id,
            ".$this->db->dbprefix('items').".item_id, supplier_id, quantity_purchased, item_cost_price, item_unit_price, SUM(percent) as item_tax_percent,
            discount_percent, (item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100) as subtotal,
            ".$this->db->dbprefix('sales_items').".line as line, serialnumber, ".$this->db->dbprefix('sales_items').".description as description,
            ROUND((item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100)*(1+(SUM(percent)/100)),2) as total,
            ROUND((item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100)*(SUM(percent)/100),2) as tax,
            (item_unit_price*quantity_purchased-item_unit_price*quantity_purchased*discount_percent/100) - (item_cost_price*quantity_purchased) as profit
            FROM ".$this->db->dbprefix('sales_items')."
            INNER JOIN ".$this->db->dbprefix('sales')." ON  ".$this->db->dbprefix('sales_items').'.sale_id='.$this->db->dbprefix('sales').'.sale_id'."
            INNER JOIN ".$this->db->dbprefix('items')." ON  ".$this->db->dbprefix('sales_items').'.item_id='.$this->db->dbprefix('items').'.item_id'."
            LEFT OUTER JOIN ".$this->db->dbprefix('suppliers')." ON  ".$this->db->dbprefix('items').'.supplier_id='.$this->db->dbprefix('suppliers').'.person_id'."
            LEFT OUTER JOIN ".$this->db->dbprefix('sales_items_taxes')." ON  "
            .$this->db->dbprefix('sales_items').'.sale_id='.$this->db->dbprefix('sales_items_taxes').'.sale_id'." and "
            .$this->db->dbprefix('sales_items').'.item_id='.$this->db->dbprefix('sales_items_taxes').'.item_id'." and "
            .$this->db->dbprefix('sales_items').'.line='.$this->db->dbprefix('sales_items_taxes').'.line'."
            GROUP BY sale_id, item_id, line)");
        }

		//Update null item_tax_percents to be 0 instead of null
		$this->db->where('item_tax_percent IS NULL');
		$this->db->update('sales_items_temp', array('item_tax_percent' => 0));

		//Update null tax to be 0 instead of null
		$this->db->where('tax IS NULL');
		$this->db->update('sales_items_temp', array('tax' => 0));

		//Update null subtotals to be equal to the total as these don't have tax
		$this->db->query('UPDATE '.$this->db->dbprefix('sales_items_temp'). ' SET total=subtotal WHERE total IS NULL');
	}

	public function get_giftcard_value( $giftcardNumber )
	{
		if ( !$this->Giftcard->exists( $this->Giftcard->get_giftcard_id($giftcardNumber)))
			return 0;

		$this->db->from('giftcards');
		$this->db->where('giftcard_number',$giftcardNumber);
		return $this->db->get()->row()->value;
	}
}
?>
