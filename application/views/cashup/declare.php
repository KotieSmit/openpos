
<div id="required_fields_message"><?php echo $this->lang->line('common_fields_required_message'); ?></div>
<ul id="error_message_box"></ul>
<?php
echo form_open('cashups/declare_submit/');
?>
<fieldset id="item_kit_info">
    <legend><?php echo $this->lang->line("cashup_declare"); ?></legend>

    <input type="text" maxlength="10" name="cashup_id" style="display:none" value="<?php echo  $cashup_id ?>"</input>&nbsp;
    <div id="table_holder">
        <table id="table_payment_capture" align="left" border="0" cellpadding="1" cellspacing="1"
               style="width: 500px; text-align: left; ">
            <caption>Capture</caption>
            <thead>
            <tr>
                <th>Method</th>
                <th>Declared</th>
                <th>Reported</th>
                <th>Difference</th>
            </tr>
            </thead>
            <tbody>

            <?php
            $i = 0;
            if (isset($sales_payments)) {
                foreach ($sales_payments as $sales_payment) {
                    ?>
                    <tr>

                        <td>
                            <?php echo $sales_payment['name']; ?>&nbsp;
                        </td>

                        <td>
                            <input id="declared_line_total_<?php echo $i ?>" class="calc" type="number" step="any"
                                   maxlength="10"
                                   name="payment_method_<?php echo $sales_payment['name'] ?>" type="text" </input>&nbsp;
                        </td>

                        <td id="reported_line_total_<?php echo $i ?>" name="reported_<?php echo $sales_payment['name'] ?>"
                            value="<?php $recorded_line_total = trim(number_format($sales_payment['reported_total'], 2));
                            echo $recorded_line_total ?>"><?php echo $recorded_line_total ?></td>

                        <td>
                            <label id="line_total_<?php echo $i ?>" class="line_total_<?php echo $i ?>" name="variance_<?php echo $sales_payment['name'] ?>"></label>
                            &nbsp;
                        </td>

                    </tr>
                    <?php
                    $i += 1;
                }
            }?>
            <tr>
                <td>TOTAL:</td>
                <td id="total_result"></td>
            </tr>
            </tbody>
        </table>
        <?php
        echo form_submit(array(
                'name'=>'submit',
                'id'=>'declare_submit',
                'value'=>$this->lang->line('common_submit'),
                'class'=>'submit_button float_right')
        );
        ?>
    </div>





</fieldset>
<?php
echo form_close();
?>

<script>
    $(document).ready(function () {
        $('.calc').change(function () {
            var total = 0;
            var line_varience = 0;
            var count = 0;
            $('.calc').each(function () {
                    line_varience = 0;
                    if ($(this).val() !== '') {
                        total += parseFloat($(this).val());
                        line_varience = parseFloat($(this).val()) - parseFloat($("#reported_line_total_" + count).text());
                        $('#line_total_' + count).html(line_varience.toFixed(2));
                    }
                    count += 1;
                }
            );
            $('#total_result').html(total.toFixed(2));
        });
    });
</script>
