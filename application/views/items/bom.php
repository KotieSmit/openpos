<div id="required_fields_message"><?php echo $this->lang->line('common_fields_required_message'); ?></div>
<ul id="error_message_box"></ul>
<?php
echo form_open('items/save_bom/' . $item_info->item_id, array('id' => 'bom_form'));
?>
<fieldset id="bom_info">
    <legend><?php echo $this->lang->line("items_info"); ?></legend>


    <div class="field_row clearfix">
        <?php echo form_label($this->lang->line('items_name') . ':', 'name', array('class' => 'wide required')); ?>
        <div class='form_field'>
            <?php echo form_input(array(
                    'name' => 'item_id',
                    'id' => 'item_id',
                    'value' => $item_info->item_id)
            );?>
        </div>
    </div>

    <div class="field_row clearfix">
        <?php echo form_label($this->lang->line('items_name') . ':', 'name', array('class' => 'wide required')); ?>
        <div class='form_field'>
            <?php echo form_input(array(
                    'name' => 'name',
                    'id' => 'name',
                    'value' => $item_info->name)
            );?>
        </div>
    </div>

    <div class="field_row clearfix">
        <?php echo form_label($this->lang->line('items_description') . ':', 'description', array('class' => 'wide')); ?>
        <div class='form_field'>
            <?php echo form_textarea(array(
                    'name' => 'description',
                    'id' => 'description',
                    'value' => $item_info->description,
                    'rows' => '5',
                    'cols' => '17')
            );?>
        </div>
    </div>


    <div class="field_row clearfix">
        <?php echo form_label($this->lang->line('items_add_item') . ':', 'item', array('class' => 'wide')); ?>
        <div class='form_field'>
            <?php echo form_input(array(
                'name' => 'item',
                'id' => 'item'
            ));?>
        </div>
    </div>

    <table id="item_kit_items">
        <tr>
            <th><?php echo $this->lang->line('common_delete'); ?></th>
            <th><?php echo $this->lang->line('items_item'); ?></th>
            <th><?php echo $this->lang->line('common_quantity'); ?></th>
            <th><?php echo $this->lang->line('items_cost'); ?></th>
        </tr>
        <?php
        $bom_items = $item_info->bom;
        $count = 0;
        $total_cost = 0;
        foreach ($bom_items as $item_bom_item) {
            ?>
            <tr class="bom_item">
                <?php
                $item_info = $this->Item->get_info($item_bom_item['bom_item_id']);
                ?>
                <td><a href="#" onclick='return deleteItemBomRow(this);'>X</a></td>
                <td><?php echo $item_info->name; ?></td>
                <td>
                    <input class="quantity quantity_<?php echo $count; ?>"
                           id='bom_item_<?php echo $item_bom_item['item_id'] ?>' type='text' size='3'
                           name=bom_item[<?php echo $item_info->item_id ?>]
                           onchange=calc_cost()
                           value='<?php echo $item_bom_item['quantity'] ?>'
                        />
                </td>
                <td class="unit_cost_<?php echo $count; ?>"
                    id=item_cost_<?php echo $count ?>
                    data-unit_cost_<?php echo $count . '=' . $item_bom_item['cost'] ?> ><?php echo number_format($item_bom_item['cost'] * $item_bom_item['quantity'], 2); ?>
                </td>
                <?php $total_cost += $item_bom_item['cost'] * $item_bom_item['quantity'] ?>

            </tr>
            <?php $count = $count + 1;
        } ?>
    </table>

    <div class="field_row clearfix">
        <?php echo form_label($this->lang->line('items_bom_cost') . ':', 'total_bom_cost', array('class' => 'wide')); ?>
        <div class='form_field'>
            <?php echo form_input(array(
                'value' => $total_cost,
                'name' => 'total_bom_cost',
                'id' => 'bom_cost'
            ));?>
        </div>
    </div>

    <?php
    echo form_submit(array(
            'name' => 'submit',
            'id' => 'submit',
            'value' => $this->lang->line('common_submit'),
            'class' => 'submit_button float_right')
    );
    ?>
</fieldset>
<?php
echo form_close();
?>
<script type='text/javascript'>


    function post_bom_item_form_submit(response) {
        if (!response.success) {
            set_feedback(response.message, 'error_message', true);
        }
        else {
            set_feedback(response.message, 'success_message', false);
        }
    }

    $("#item").autocomplete('<?php echo site_url("items/item_search"); ?>',
        {
            minChars: 0,
            max: 100,
            selectFirst: false,
            delay: 10,
            formatItem: function (row) {
                return row[1];
            }
        });

    $("#item").result(function (event, data, formatted) {
        $("#item").val("");

        if ($("#bom_item" + data[0]).length == 1) {
            $("#bom_item" + data[0]).val(parseFloat($("#bom_item" + data[0]).val()) + 1);
        }
        else {
            var count = 0;
            $('.quantity').each(function () {count = count + 1;});
            $("#item_kit_items").append("<tr class='bom_item'><td><a href='#' onclick='return deleteItemBomRow(this);'>X</a></td><td>" + data[1] + "</td><td><input class='quantity quantity_" + count + "' id='bom_item_" + data[0] + "' type='text' size='3' name=bom_item[" + data[0] + "] onchange='calc_cost()' value='1'/></td><td class=unit_cost_" + count + " id=item_cost_" + count + " data-Unit_cost_"+count+"=" + data[2] + ">" + data[2] + "</td></tr>");

            var elem = document.getElementById("bom_cost");
            elem.value = parseFloat(elem.value) + parseFloat(data[2]);
        }
        ;
    });


function calc_cost()
{
    var count = 0;
    var line_cost = 0;
    var cost = 0;
    var line_cost_total = 0;
    var line_qty = 0;
    $('.quantity').each(function () {

        if ($(this).val() !== '') {
            line_qty = parseFloat($(".quantity_" + count).val());
            var cost_elm = document.getElementById('item_cost_' + count);
            line_cost = parseFloat(cost_elm.getAttribute("data-unit_cost_" + count));
            line_cost_total = line_cost * line_qty;
            if (line_cost != null) {
                $('.unit_cost_' + count).html(line_cost_total.toFixed(2));
                var elem = document.getElementsByTagName('.unit_cost_' + count);
                elem.value = line_cost_total.toFixed(2);
                cost += line_cost_total;
            }
            count += 1;
        }
        ;
    });
    var elem = document.getElementById("bom_cost");
    elem.value = cost.toFixed(2);
}


    //validation and submit handling
    $(document).ready(function () {
        $('#bom_form').validate({
            submitHandler: function (form) {
                $(form).ajaxSubmit({
                    success: function (response) {
                        tb_remove();
                        post_bom_item_form_submit(response);
                    },
                    dataType: 'json'
                });

            },
            errorLabelContainer: "#error_message_box",
            wrapper: "li",
            rules: {
                name: "required",
                category: "required"
            },
            messages: {
                name: "<?php echo $this->lang->line('items_name_required'); ?>",
                category: "<?php echo $this->lang->line('items_category_required'); ?>"
            }
        });
    });

    function deleteItemBomRow(link) {
        $(link).parent().parent().remove();
        calc_cost()
        return false;
    }
</script>