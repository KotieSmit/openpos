<?php
/**
 * Created by PhpStorm.
 * User: kotie
 * Date: 2014/01/15
 * Time: 7:38 AM
 */

$options = array(
    "customers"=>"List of Customers",
    "items"=>"List of Items",
    "item_kits"=>"List of Item Kits",
    "suppliers"=>"List of Suppliers",
    "reports"=>"Reports",
    "receivings"=>"Items Receivings",
    "sales"=>"Sales Register",
    "employees"=>"List of Employees",
    "gift_cards"=>"List of Gift Cards",
    "store_config"=>"Store Config"
);


$I = new WebGuy($scenario);
$I->am('a user');
$I->wantTo("log in and test option links on the home page and header");
$I->expectTo('use both icons in the header and the body of the home page');

$I->maximizeWindow();
$I->amOnPage('/');

$I->fillField(str::strSelenium('username'), 'admin');
$I->fillField(str::strSelenium('password'), 'pointofsale');
$I->click(str::strSelenium('submit'));
$I->canSeeInCurrentUrl('/home');


foreach ($options as $option => $value) {
    $I->click(str::strSelenium("header_" . strtolower($option)));
    $I->cansee($value,'//*[@id="title"]');
}