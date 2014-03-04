<ul id="error_message_box"></ul>
<?php
echo form_open('config/save_payment_methods/');
?>
<fieldset id="item_basic_info">
    <legend><?php echo $this->lang->line("payment_method_setup"); ?></legend>
    <div id="table_action_header">
        <ul>
            <li class="float_left"><span></span></li>
            <li class="float_right"></li>
        </ul>
    </div>
    <?php
        echo $paymentmethods_data_table;
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