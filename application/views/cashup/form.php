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
            ?>
        </div>

    </div>

</body>




