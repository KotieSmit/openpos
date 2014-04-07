<!--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"-->
<!--    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">-->
<!--<html xmlns="http://www.w3.org/1999/xhtml">-->
<!--<head>-->
<!--    <title>--><?php //echo $this->lang->line('items_generate_barcodes'); ?><!--</title>-->
<!--</head>-->
<!--<body>-->
<!--<table width='50%' align='center' cellpadding='20'>-->
<!--    <tr>-->
<!--        --><?php
//        $count = 0;
//        foreach($items as $item)
//        {
//            $barcode = $item['id'];
//            $text = $item['name'];
//
//            if ($count % 2 ==0 and $count!=0)
//            {
//                echo '</tr><tr>';
//            }
//            echo "<div id='barcode'><img src='index.php?c=barcode&barcode=150&text=jhkh&width=256&height=50' /></div>";
//            $count++;
//        }
//        ?>
<!--    </tr>-->
<!--</table>-->
<!--</body>-->
<!--</html>-->




<?php
if (isset($error_message))
{
    echo '<h1 style="text-align: center;">'.$error_message.'</h1>';
    exit;
}
?>
<div id="receipt_wrapper">



    <div id="sale_return_policy">
        <?php echo nl2br($this->config->item('return_policy')); ?>
    </div>
    <div id='barcode'>
        <?php echo "<img src='index.php?c=barcode&barcode=123=321&width=250&height=50' />"; ?>
    </div>
</div>
