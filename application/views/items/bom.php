<div id="required_fields_message"><?php echo $this->lang->line('common_fields_required_message'); ?></div>
<ul id="error_message_box"></ul>
<?php
echo form_open('items/save_bom/'.$item_info->item_id,array('id'=>'bom_form'));
?>
<fieldset id="bom_info">
<legend><?php echo $this->lang->line("items_info"); ?></legend>


<div class="field_row clearfix">
    <?php echo form_label($this->lang->line('items_name').':', 'name',array('class'=>'wide required')); ?>
    <div class='form_field'>
        <?php echo form_input(array(
                'name'=>'item_id',
                'id'=>'item_id',
                'value'=>$item_info->item_id)
        );?>
    </div>
</div>

<div class="field_row clearfix">
<?php echo form_label($this->lang->line('items_name').':', 'name',array('class'=>'wide required')); ?>
	<div class='form_field'>
	<?php echo form_input(array(
		'name'=>'name',
		'id'=>'name',
		'value'=>$item_info->name)
	);?>
	</div>
</div>

<div class="field_row clearfix">
<?php echo form_label($this->lang->line('items_description').':', 'description',array('class'=>'wide')); ?>
	<div class='form_field'>
	<?php echo form_textarea(array(
		'name'=>'description',
		'id'=>'description',
		'value'=>$item_info->description,
		'rows'=>'5',
		'cols'=>'17')
	);?>
	</div>
</div>


<div class="field_row clearfix">
<?php echo form_label($this->lang->line('items_add_item').':', 'item',array('class'=>'wide')); ?>
	<div class='form_field'>
		<?php echo form_input(array(
			'name'=>'item',
			'id'=>'item'
		));?>
	</div>
</div>

<table id="item_kit_items">
	<tr>
        <th><?php echo $this->lang->line('common_delete');?></th>
        <th><?php echo $this->lang->line('items_item');?></th>
        <th><?php echo $this->lang->line('common_quantity');?></th>
	</tr>
    <?php $bom_items = $item_info->bom->result(); ?>
	<?php foreach ($bom_items as $item_bom_item) {?>
		<tr>
			<?php
			$item_info = $this->Item->get_info($item_bom_item->bom_item_id);
			?>
			<td><a href="#" onclick='return deleteItemBomRow(this);'>X</a></td>
			<td><?php echo $item_info->name; ?></td>
			<td><input class='quantity' id='bom_item_<?php echo $item_bom_item->item_id ?>' type='text' size='3' name=bom_item[<?php echo $item_info->item_id ?>] value='<?php echo $item_bom_item->quantity ?>'/></td>
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

function post_bom_item_form_submit(response)
{
    if(!response.success)
    {
        set_feedback(response.message,'error_message',true);
    }
    else
    {
        set_feedback(response.message,'success_message',false);
    }
}

$("#item").autocomplete('<?php echo site_url("items/item_search"); ?>',
{
	minChars:0,
	max:100,
	selectFirst: false,
   	delay:10,
	formatItem: function(row) {
		return row[1];
	}
});

$("#item").result(function(event, data, formatted)
{
	$("#item").val("");

	if ($("#bom_item"+data[0]).length ==1)
	{
		$("#bom_item"+data[0]).val(parseFloat($("#bom_item"+data[0]).val()) + 1);
	}
	else
	{
		$("#item_kit_items").append("<tr><td><a href='#' onclick='return deleteItemKitRow(this);'>X</a></td><td>"+data[1]+"</td><td><input class='quantity' id='bom_item"+data[0]+"' type='text' size='3' name=bom_item["+data[0]+"] value='1'/></td></tr>");
	}
});


//validation and submit handling
$(document).ready(function()
{
	$('#bom_form').validate({
		submitHandler:function(form)
		{
			$(form).ajaxSubmit({
			success:function(response)
			{
				tb_remove();
                post_bom_item_form_submit(response);
			},
			dataType:'json'
		});

		},
		errorLabelContainer: "#error_message_box",
 		wrapper: "li",
		rules:
		{
			name:"required",
			category:"required"
		},
		messages:
		{
			name:"<?php echo $this->lang->line('items_name_required'); ?>",
			category:"<?php echo $this->lang->line('items_category_required'); ?>"
		}
	});
});

function deleteItemBomRow(link)
{
	$(link).parent().parent().remove();
	return false;
}
</script>