<div id="required_fields_message"><?php echo $this->lang->line('common_fields_required_message'); ?></div>
<ul id="error_message_box"></ul>
<?php
echo form_open('config/save_payment_methods/');
?>
<fieldset id="item_basic_info">
    <legend><?php echo $this->lang->line("payment_method_setup"); ?></legend>
    <table border="1" width="100%" class="field_row clearfix">
        <thead>
            <th>  Name  </th>
            <th>  Active  </th>
            <th>  Can Over Tender  </th>
            <th>  Give out as Change  </th>

        </thead>
        <?php foreach ($paymentMethods as $payment_method) {?>

            <tr>
                <td class='form_field'>
                    <?php echo form_input(array(
                            'name'=>'payment_method_'.$payment_method['Name'].'[name]',
                            'id'=>'name-'.$payment_method['Name'].'[name]',
                            'size'=>'8',
                            'value'=> $payment_method['Name'])
                    );?>
                </td>

                <td class='form_field'>
                    <?php echo form_checkbox(array(
                        'name'=>'payment_method_'.$payment_method['Name'].'[active]',
                        'id'=>'active-'.$payment_method['Name'].'[name]',
                        'size'=>'3',
                        'value'=> 1,
                        'checked' => $payment_method['active']));
                    ;?>
                </td>

                <td class='form_field'>
                    <?php echo form_checkbox(array(
                        'name'=>'payment_method_'.$payment_method['Name'].'[allow_over_tender]',
                        'id'=>'allow_over_tender-'.$payment_method['Name'].'[name]',
                        'size'=>'3',
                        'value'=> 1,
                        'checked' => $payment_method['allow_over_tender']));
                    ;?>
                </td>

                <td class='form_field'>
                    <?php echo form_checkbox(array(
                        'name'=>'payment_method_'.$payment_method['Name'].'[is_change]',
                        'id'=>'is_change'.$payment_method['Name'].'[name]',
                        'size'=>'3',
                        'value'=> 1,
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
                name:
                {
                    required:true,
                    number:true
                }
            },
            messages:
            {
                name:"<?php echo $this->lang->line('items_name_required'); ?>",
        });
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
                name:
                {
                    required:true,
                    number:true
                }
            },
            messages:
            {
                name:"<?php echo $this->lang->line('items_name_required'); ?>",
        });
    });
</script>