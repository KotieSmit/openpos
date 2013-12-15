<?php $this->load->view("partial/header"); ?>
<div id="page_title"><?php echo $this->lang->line('module_cashup'); ?></div>
<?php
//echo form_open('config/save/', array('id' => 'config_form'));
?>
<div id="config_wrapper">
    <div id="required_fields_message"><?php echo $this->lang->line('common_fields_required_message'); ?></div>

    <body>
    <p style="text-align: center;">
        Cash up
    </p>

    <div>
        <select>
            <?php foreach ($employee_list as $row => $key) { ?>
                <option><?php echo $key ?></option>
            <?php } ?>
        </select>
    </div>
    <p>&nbsp;</p>

    <p>&nbsp;</p>

    <p>&nbsp;</p>
    <a>
        <table id="table_payment_capture" align="left" border="0" cellpadding="1" cellspacing="1" style="width: 500px; text-align: left; " >
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

            <?php foreach ($payment_methods as $payment_method) { ?>
                <tr>

                    <td>
                        <?php echo $payment_method['Name']; ?>&nbsp;
                    </td>

                    <td>
                        <input class="calc" type="number" step="any" maxlength="10"
                               name="input_"<?php $payment_method['Name'] ?> type="text">&nbsp;
                    </td>

                    <td>
                        &nbsp;
                    </td>

                </tr>
            <?php } ?>
            <tr>
                <td>TOTAL:</td>
                <td id="total_result"></td>
            </tr>
            </tbody>
        </table>
    </a>

    </body>


    <script>

        $(document).ready(function () {
            $('.calc').change(function () {
                var total = 0;
                $('.calc').each(function () {
                    if ($(this).val() !== '') {
                        total += parseFloat($(this).val());
                    }
                });
                $('#total_result').html(total.toFixed(2));
            });
        })(jQuery);


    </script>

