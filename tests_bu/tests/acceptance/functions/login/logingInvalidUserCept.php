<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Kotie Smit
 * Date: 2013/10/22
 * Time: 1:57 PM
 */

$I = new WebGuy($scenario);
$I->am('a admin user');
$I->wantTo("Login");
$I->expectTo('be able to login with valid user login details');

$I->amOnPage('/');
$I->fillField(str::strSelenium('username'), 'invaliduser');
$I->fillField(str::strSelenium('password'), 'pointofsale');
$I->click(str::strSelenium('submit'));
$I->cantSeeInCurrentUrl('/home');

