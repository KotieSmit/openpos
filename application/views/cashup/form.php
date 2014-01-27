<?php $this->load->view("partial/header"); ?>
<div id="title_bar">
    <div id="title" style="margin-bottom:8px;"><?php echo $this->lang->line('module_cashups'); ?></div>
</div>
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

            foreach ($sales_payments as $sales_payments) {
                ?>
                <tr>

                    <td>
                        <?php echo $sales_payments['name']; ?>&nbsp;
                    </td>

                    <td>
                        <input id="declared_line_total_<?php echo $i ?>" class="calc" type="number" step="any"
                               maxlength="10"
                               name="input_<?php $sales_payments['name'] ?>" type="text">&nbsp;
                    </td>

                    <td id="recorded_line_total_<?php echo $i ?>"
                        value="<?php $recorded_line_total = trim(number_format($sales_payments['total'], 2));
                        echo $recorded_line_total ?>"><?php echo $recorded_line_total ?></td>

                    <td>
                        <label id="line_total_<?php echo $i ?>" class="line_total_<?php echo $i ?>"></label>
                        &nbsp;
                    </td>

                </tr>
                <?php
                $i += 1;
            }?>
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
                var line_varience = 0;
                var count = 0;
                $('.calc').each(function () {
                        line_varience = 0;
                        if ($(this).val() !== '') {
                            total += parseFloat($(this).val());
                            line_varience = parseFloat($(this).val()) - parseFloat($("#recorded_line_total_" + count).text());
                            $('#line_total_' + count).html(line_varience.toFixed(2));
//                      } else {
//                          $('#line_total_'.count).html("0.00");
//                          $('#line_total_0').html(total);
                        }
                        count +=1;
                    }
                )
                ;
                $('#total_result').html(total.toFixed(2));
            });
        });

        //        $(document).ready(function () {
        //            $('.calc').change(function () {
        //                var total = 0;
        //                $('.calc').each(function () {
        //                    if ($(this).val() !== '') {
        //                        total += parseFloat($(this).val());
        //                    }
        //                });
        //                $('#total_result').html(total.toFixed(2));
        //            });
        //        })(jQuery);
    </script>

