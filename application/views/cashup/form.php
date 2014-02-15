<body>
<?php $this->load->view("partial/header"); ?>
<?php
echo form_open('cashups/reload/');
?>



<div id="content_area_wrapper">
    <div id="content_area">
        <div id="title_bar">
            <div id="title" class="float_left"
                 style="margin-bottom:8px;"><?php echo $this->lang->line('module_cashups'); ?>
            </div>
        </div>
        <div id="action_area">
            <?php
            echo $manage_table;
//                echo form_dropdown('employee', $employee_list);
//                echo form_submit(array(
//                'name' => 'submit',
//                'id' => 'submit',
//                'value' => $this->lang->line('common_select'),
//                'class' => 'submit_button float_left')
//                );
            ?>
        </div>
<!--        <div id="table_holder">-->
<!--            <table id="table_payment_capture" align="left" border="0" cellpadding="1" cellspacing="1"-->
<!--                   style="width: 500px; text-align: left; ">-->
<!--                <caption>Capture</caption>-->
<!--                <thead>-->
<!--                <tr>-->
<!--                    <th>Method</th>-->
<!--                    <th>Declared</th>-->
<!--                    <th>Reported</th>-->
<!--                    <th>Difference</th>-->
<!--                </tr>-->
<!--                </thead>-->
<!--                <tbody>-->
<!---->
<!--                --><?php
//                $i = 0;
//                if (isset($sales_payments)) {
//                    foreach ($sales_payments as $sales_payment) {
//                        ?>
<!--                        <tr>-->
<!---->
<!--                            <td>-->
<!--                                --><?php //echo $sales_payment['name']; ?><!--&nbsp;-->
<!--                            </td>-->
<!---->
<!--                            <td>-->
<!--                                <input id="declared_line_total_--><?php //echo $i ?><!--" class="calc" type="number" step="any"-->
<!--                                       maxlength="10"-->
<!--                                       name="input_--><?php //echo $sales_payment['name'] ?><!--" type="text" </input>&nbsp;-->
<!--                            </td>-->
<!---->
<!--                            <td id="recorded_line_total_--><?php //echo $i ?><!--"-->
<!--                                value="--><?php //$recorded_line_total = trim(number_format($sales_payment['total'], 2));
//                                echo $recorded_line_total ?><!--">--><?php //echo $recorded_line_total ?><!--</td>-->
<!---->
<!--                            <td>-->
<!--                                <label id="line_total_--><?php //echo $i ?><!--" class="line_total_--><?php //echo $i ?><!--"></label>-->
<!--                                &nbsp;-->
<!--                            </td>-->
<!---->
<!--                        </tr>-->
<!--                        --><?php
//                        $i += 1;
//                    }
//                }?>
<!--                <tr>-->
<!--                    <td>TOTAL:</td>-->
<!--                    <td id="total_result"></td>-->
<!--                </tr>-->
<!--                </tbody>-->
<!--            </table>-->
<!--        </div>-->
    </div>

</body>




