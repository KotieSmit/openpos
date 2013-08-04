<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <!--<link rel="stylesheet" rev="stylesheet" href="<?php echo base_url();?>css/login.css" />-->
    <link rel="stylesheet" rev="stylesheet" href="<?php echo base_url();?>css/reset.css" />
    <link rel="stylesheet" rev="stylesheet" href="<?php echo base_url();?>css/login_structure.css" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>OpenPOS <?php echo $this->lang->line('login_login'); ?></title>
<script src="<?php echo base_url();?>js/jquery-1.2.6.min.js" type="text/javascript" language="javascript" charset="UTF-8"></script>
</head>
<body>
    <?php
        echo form_open('login',array('class'=>'box login'));
            echo img('images/logo.png');
            echo validation_errors();
            echo form_fieldset('',array('class'=>'boxBody'));
            //echo $this->lang->line('login_welcome_message');
            echo form_label($this->lang->line('login_username'), 'username');
            echo form_input('username');
            echo form_label($this->lang->line('login_password'), 'password');
            echo form_password('password');
            echo form_fieldset_close();
            echo "<footer>";
            echo form_submit('loginButton','Log In',array('class'=>'btnLogin'));
            echo "</footer>";
        echo form_close();
    ?>
</body>
</html>
