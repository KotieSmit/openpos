<div id="required_fields_message"><?php echo $this->lang->line('common_fields_required_message'); ?></div>
<ul id="error_message_box"></ul>
<?php
//echo form_open('items/save/'.$item_info->item_id,array('id'=>'item_form'));
?>
<fieldset id="item_basic_info">
    <legend><?php echo $this->lang->line("items_basic_information"); ?></legend>
    <table border="1" width="100%" class="field_row clearfix">
        <thead>
            <th>  Name  </th>
            <th>  Active  </th>
            <th>  Can Over Tender  </th>
            <th>  Give out as Change  </th>>

        </thead>
        <?php foreach ($paymentMethods as $payment_method) {?>

<!--        --><?php //echo form_label($this->lang->line('items_tax_1').':', 'tax_percent_1',array('class'=>'wide')); ?>
            <tr>
                <td class='form_field'>
                    <?php echo form_input(array(
                            'name'=>'tax_names[]',
                            'id'=>'tax_name_1',
                            'size'=>'8',
                            'value'=> $payment_method['name'])
                    );?>
                </td>

                <td class='form_field'>
                    <?php echo form_checkbox(array(
                        'name'=>'tax_percents[]',
                        'id'=>'tax_percent_name_1',
                        'size'=>'3',
                        'value'=> $payment_method['over_tender'],
                        'checked' => $payment_method['over_tender']));
                    ;?>
                </td>

                <td class='form_field'>
                    <?php echo form_checkbox(array(
                        'name'=>'tax_percents[]',
                        'id'=>'tax_percent_name_1',
                        'size'=>'3',
                        'value'=> $payment_method['over_tender'],
                        'checked' => $payment_method['over_tender']));
                    ;?>
                </td>

                <td class='form_field'>
                    <?php echo form_checkbox(array(
                        'name'=>'tax_percents[]',
                        'id'=>'tax_percent_name_1',
                        'size'=>'3',
                        'value'=> $payment_method['is_change'],
                        'checked' => $payment_method['is_change']));
                    ;?>
                </td>
            </tr>
        <?php } ?>
    </table>



    <?php
    echo form_submit(array(
            'name'=>'submit',
            'id'=>'submit',
            'value'=>$this->lang->line('common_submit'),
            'class'=>'submit_button float_right')
    );
    ?>
</fieldset>
<?php
echo form_close();
?>
<script type='text/javascript'>

    //validation and submit handling
    $(document).ready(function()
    {
        $("#category").autocomplete("<?php echo site_url('items/suggest_category');?>",{max:100,minChars:0,delay:10});
        $("#category").result(function(event, data, formatted){});
        $("#category").search();


        $('#item_form').validate({
            submitHandler:function(form)
            {
                /*
                 make sure the hidden field #item_number gets set
                 to the visible scan_item_number value
                 */
                $('#item_number').val($('#scan_item_number').val());
                $(form).ajaxSubmit({
                    success:function(response)
                    {
                        tb_remove();
                        post_item_form_submit(response);
                    },
                    dataType:'json'
                });

            },
            errorLabelContainer: "#error_message_box",
            wrapper: "li",
            rules:
            {
                name:"required",
                category:"required",
                cost_price:
                {
                    required:true,
                    number:true
                },

                unit_price:
                {
                    required:true,
                    number:true
                },
                tax_percent:
                {
                    required:true,
                    number:true
                },
                quantity:
                {
                    required:true,
                    number:true
                },
                reorder_level:
                {
                    required:true,
                    number:true
                }
            },
            messages:
            {
                name:"<?php echo $this->lang->line('items_name_required'); ?>",
                category:"<?php echo $this->lang->line('items_category_required'); ?>",
                cost_price:
                {
                    required:"<?php echo $this->lang->line('items_cost_price_required'); ?>",
                    number:"<?php echo $this->lang->line('items_cost_price_number'); ?>"
                },
                unit_price:
                {
                    required:"<?php echo $this->lang->line('items_unit_price_required'); ?>",
                    number:"<?php echo $this->lang->line('items_unit_price_number'); ?>"
                },
                tax_percent:
                {
                    required:"<?php echo $this->lang->line('items_tax_percent_required'); ?>",
                    number:"<?php echo $this->lang->line('items_tax_percent_number'); ?>"
                },
                quantity:
                {
                    required:"<?php echo $this->lang->line('items_quantity_required'); ?>",
                    number:"<?php echo $this->lang->line('items_quantity_number'); ?>"
                },
                reorder_level:
                {
                    required:"<?php echo $this->lang->line('items_reorder_level_required'); ?>",
                    number:"<?php echo $this->lang->line('items_reorder_level_number'); ?>"
                }

            }
        });
    });
</script>