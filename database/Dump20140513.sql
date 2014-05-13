CREATE DATABASE  IF NOT EXISTS `openpos` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `openpos`;
-- MySQL dump 10.13  Distrib 5.5.37, for debian-linux-gnu (i686)
--
-- Host: 127.0.0.1    Database: openpos
-- ------------------------------------------------------
-- Server version	5.5.37-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `openpos_customers`
--

DROP TABLE IF EXISTS `openpos_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_customers` (
  `person_id` int(10) NOT NULL,
  `account_number` varchar(255) DEFAULT NULL,
  `taxable` int(1) NOT NULL DEFAULT '1',
  `deleted` int(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `account_number` (`account_number`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `openpos_customers_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `openpos_people` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_customers`
--

LOCK TABLES `openpos_customers` WRITE;
/*!40000 ALTER TABLE `openpos_customers` DISABLE KEYS */;
INSERT INTO `openpos_customers` VALUES (2,NULL,1,0);
/*!40000 ALTER TABLE `openpos_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_sales_suspended_items`
--

DROP TABLE IF EXISTS `openpos_sales_suspended_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_sales_suspended_items` (
  `sale_id` int(10) NOT NULL DEFAULT '0',
  `item_id` int(10) NOT NULL DEFAULT '0',
  `description` varchar(30) DEFAULT NULL,
  `serialnumber` varchar(30) DEFAULT NULL,
  `line` int(3) NOT NULL DEFAULT '0',
  `quantity_purchased` double(15,2) NOT NULL DEFAULT '0.00',
  `item_cost_price` decimal(15,2) NOT NULL,
  `item_unit_price` double(15,2) NOT NULL,
  `discount_percent` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`sale_id`,`item_id`,`line`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `openpos_sales_suspended_items_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`),
  CONSTRAINT `openpos_sales_suspended_items_ibfk_2` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales_suspended` (`sale_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_sales_suspended_items`
--

LOCK TABLES `openpos_sales_suspended_items` WRITE;
/*!40000 ALTER TABLE `openpos_sales_suspended_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `openpos_sales_suspended_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_sales_items`
--

DROP TABLE IF EXISTS `openpos_sales_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_sales_items` (
  `sale_id` int(10) NOT NULL DEFAULT '0',
  `item_id` int(10) NOT NULL DEFAULT '0',
  `description` varchar(30) DEFAULT NULL,
  `serialnumber` varchar(30) DEFAULT NULL,
  `line` int(3) NOT NULL DEFAULT '0',
  `quantity_purchased` double(15,2) NOT NULL DEFAULT '0.00',
  `item_cost_price` decimal(15,2) NOT NULL,
  `item_unit_price` double(15,2) NOT NULL,
  `discount_percent` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`sale_id`,`item_id`,`line`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `openpos_sales_items_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`),
  CONSTRAINT `openpos_sales_items_ibfk_2` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales` (`sale_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `openpos_sales_payments`
--

DROP TABLE IF EXISTS `openpos_sales_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_sales_payments` (
  `sale_id` int(10) NOT NULL,
  `payment_type` varchar(40) NOT NULL,
  `payment_amount` decimal(15,2) NOT NULL,
  `fk_reason` int(3) NOT NULL,
  `cashup_id` int(11) NOT NULL,
  PRIMARY KEY (`sale_id`,`payment_type`,`fk_reason`,`cashup_id`),
  KEY `fk_openpos_sales_payments_1` (`fk_reason`),
  CONSTRAINT `fk_openpos_sales_payments_1` FOREIGN KEY (`fk_reason`) REFERENCES `openpos_payment_reason` (`payment_reson_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `openpos_sales_payments_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales` (`sale_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Temporary table structure for view `openpos_full_cashup_view`
--

DROP TABLE IF EXISTS `openpos_full_cashup_view`;
/*!50001 DROP VIEW IF EXISTS `openpos_full_cashup_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `openpos_full_cashup_view` (
  `cashup_id` tinyint NOT NULL,
  `employee_id` tinyint NOT NULL,
  `first_name` tinyint NOT NULL,
  `last_name` tinyint NOT NULL,
  `payment_method_id` tinyint NOT NULL,
  `payment_method_name` tinyint NOT NULL,
  `cashup_employeed_id` tinyint NOT NULL,
  `cashup_employee_first_name` tinyint NOT NULL,
  `cashup_employee_last_name` tinyint NOT NULL,
  `declared_value` tinyint NOT NULL,
  `reported_total` tinyint NOT NULL,
  `started` tinyint NOT NULL,
  `closed` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `openpos_item_kit_items`
--

DROP TABLE IF EXISTS `openpos_item_kit_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_item_kit_items` (
  `item_kit_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` double(15,2) NOT NULL,
  PRIMARY KEY (`item_kit_id`,`item_id`,`quantity`),
  KEY `openpos_item_kit_items_ibfk_2` (`item_id`),
  CONSTRAINT `openpos_item_kit_items_ibfk_1` FOREIGN KEY (`item_kit_id`) REFERENCES `openpos_item_kits` (`item_kit_id`) ON DELETE CASCADE,
  CONSTRAINT `openpos_item_kit_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_item_kit_items`
--

LOCK TABLES `openpos_item_kit_items` WRITE;
/*!40000 ALTER TABLE `openpos_item_kit_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `openpos_item_kit_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_app_config`
--

DROP TABLE IF EXISTS `openpos_app_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_app_config` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_app_config`
--

LOCK TABLES `openpos_app_config` WRITE;
/*!40000 ALTER TABLE `openpos_app_config` DISABLE KEYS */;
INSERT INTO `openpos_app_config` VALUES ('address','123 Nowhere street'),('company','OpenPOS'),('config_use_tax_rate_2','0'),('currency_symbol','R'),('default_tax_1_name','VAT'),('default_tax_1_rate','14'),('default_tax_2_name','0'),('default_tax_2_rate','0'),('default_tax_rate','8'),('email','em@il.com'),('fax',''),('language','english'),('page_width','a4'),('phone','555-555-5555'),('print_after_sale','0'),('return_policy','Test'),('timezone','America/New_York'),('website','');
/*!40000 ALTER TABLE `openpos_app_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_receivings`
--

DROP TABLE IF EXISTS `openpos_receivings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_receivings` (
  `receiving_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int(10) DEFAULT NULL,
  `employee_id` int(10) NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  `receiving_id` int(10) NOT NULL AUTO_INCREMENT,
  `payment_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`receiving_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `openpos_receivings_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `openpos_employees` (`person_id`),
  CONSTRAINT `openpos_receivings_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `openpos_suppliers` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `openpos_sales`
--

DROP TABLE IF EXISTS `openpos_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_sales` (
  `sale_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customer_id` int(10) DEFAULT NULL,
  `employee_id` int(10) NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  `sale_id` int(10) NOT NULL AUTO_INCREMENT,
  `payment_type` varchar(512) DEFAULT NULL,
  `cashup_id` int(10) NOT NULL,
  PRIMARY KEY (`sale_id`),
  KEY `customer_id` (`customer_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `openpos_sales_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `openpos_employees` (`person_id`),
  CONSTRAINT `openpos_sales_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `openpos_customers` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `openpos_modules`
--

DROP TABLE IF EXISTS `openpos_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_modules` (
  `name_lang_key` varchar(255) NOT NULL,
  `desc_lang_key` varchar(255) NOT NULL,
  `sort` int(10) NOT NULL,
  `module_id` varchar(255) NOT NULL,
  PRIMARY KEY (`module_id`),
  UNIQUE KEY `desc_lang_key` (`desc_lang_key`),
  UNIQUE KEY `name_lang_key` (`name_lang_key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_modules`
--

LOCK TABLES `openpos_modules` WRITE;
/*!40000 ALTER TABLE `openpos_modules` DISABLE KEYS */;
INSERT INTO `openpos_modules` VALUES ('module_cashups','module_cashups_desc',75,'cashups'),('module_config','module_config_desc',100,'config'),('module_customers','module_customers_desc',10,'customers'),('module_employees','module_employees_desc',80,'employees'),('module_giftcards','module_giftcards_desc',90,'giftcards'),('module_items','module_items_desc',20,'items'),('module_item_kits','module_item_kits_desc',30,'item_kits'),('module_receivings','module_receivings_desc',60,'receivings'),('module_reports','module_reports_desc',50,'reports'),('module_sales','module_sales_desc',70,'sales'),('module_suppliers','module_suppliers_desc',40,'suppliers');
/*!40000 ALTER TABLE `openpos_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_inventory`
--

DROP TABLE IF EXISTS `openpos_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_inventory` (
  `trans_id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_items` int(11) NOT NULL DEFAULT '0',
  `trans_user` int(11) NOT NULL DEFAULT '0',
  `trans_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `trans_comment` text NOT NULL,
  `trans_inventory` double(15,3) NOT NULL DEFAULT '0.000',
  PRIMARY KEY (`trans_id`),
  KEY `openpos_inventory_ibfk_1` (`trans_items`),
  KEY `openpos_inventory_ibfk_2` (`trans_user`),
  CONSTRAINT `openpos_inventory_ibfk_1` FOREIGN KEY (`trans_items`) REFERENCES `openpos_items` (`item_id`),
  CONSTRAINT `openpos_inventory_ibfk_2` FOREIGN KEY (`trans_user`) REFERENCES `openpos_employees` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `openpos_cashups_declared`
--

DROP TABLE IF EXISTS `openpos_cashups_declared`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_cashups_declared` (
  `openpos_cashups_payments_id` int(11) NOT NULL AUTO_INCREMENT,
  `cashup_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `declared_value` decimal(15,2) NOT NULL DEFAULT '0.00',
  `reported_total` decimal(15,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`openpos_cashups_payments_id`,`cashup_id`,`payment_method_id`,`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `openpos_items`
--

DROP TABLE IF EXISTS `openpos_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_items` (
  `name` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `item_number` varchar(255) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `cost_price` double(15,2) NOT NULL,
  `unit_price` double(15,2) NOT NULL,
  `quantity` double(15,3) NOT NULL DEFAULT '0.000',
  `reorder_level` double(15,3) NOT NULL DEFAULT '0.000',
  `location` varchar(255) NOT NULL,
  `item_id` int(10) NOT NULL AUTO_INCREMENT,
  `allow_alt_description` tinyint(1) NOT NULL,
  `is_serialized` tinyint(1) NOT NULL DEFAULT '0',
  `stock_keeping_item` tinyint(1) NOT NULL DEFAULT '0',
  `production_item` tinyint(1) NOT NULL DEFAULT '0',
  `cost_from_bom` tinyint(1) NOT NULL DEFAULT '0',
  `cost_from_receiving` tinyint(1) NOT NULL DEFAULT '0',
  `cost_ave` tinyint(1) NOT NULL DEFAULT '0',
  `cost_last` tinyint(1) NOT NULL DEFAULT '0',
  `deleted` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  UNIQUE KEY `item_number` (`item_number`),
  KEY `openpos_items_ibfk_1` (`supplier_id`),
  CONSTRAINT `openpos_items_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `openpos_suppliers` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `openpos_giftcards`
--

DROP TABLE IF EXISTS `openpos_giftcards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_giftcards` (
  `giftcard_id` int(11) NOT NULL AUTO_INCREMENT,
  `giftcard_number` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `value` double(15,2) NOT NULL,
  `deleted` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`giftcard_id`),
  UNIQUE KEY `giftcard_number` (`giftcard_number`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `openpos_payment_methods`
--

DROP TABLE IF EXISTS `openpos_payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_payment_methods` (
  `payment_method_id` int(3) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `active` int(1) NOT NULL DEFAULT '0',
  `language_id` varchar(255) NOT NULL,
  `allow_over_tender` int(1) NOT NULL DEFAULT '0',
  `is_change` int(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `Name` (`payment_method_id`,`Name`),
  KEY `payment_method_id` (`payment_method_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_payment_methods`
--

LOCK TABLES `openpos_payment_methods` WRITE;
/*!40000 ALTER TABLE `openpos_payment_methods` DISABLE KEYS */;
INSERT INTO `openpos_payment_methods` VALUES (1,'Cash',1,'cash',1,1),(3,'Credit Card',1,'card',0,0),(4,'Gift Voucher',1,'gift_voucher',0,0);
/*!40000 ALTER TABLE `openpos_payment_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_people`
--

DROP TABLE IF EXISTS `openpos_people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_people` (
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `phone_number` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `address_1` varchar(255) NOT NULL,
  `address_2` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `zip` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `comments` text NOT NULL,
  `person_id` int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_people`
--

LOCK TABLES `openpos_people` WRITE;
/*!40000 ALTER TABLE `openpos_people` DISABLE KEYS */;
INSERT INTO `openpos_people` VALUES ('John','Doe','555-555-5555','admin@pappastech.com','Address 1','','','','','','',1),('Customer','1','','','','','','','','','',2),('cashier 1','1','','','','','','','','','',3);
/*!40000 ALTER TABLE `openpos_people` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_payment_reason`
--

DROP TABLE IF EXISTS `openpos_payment_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_payment_reason` (
  `payment_reson_id` int(11) NOT NULL,
  `reason` varchar(45) NOT NULL,
  PRIMARY KEY (`payment_reson_id`),
  UNIQUE KEY `payment_reson_id_UNIQUE` (`payment_reson_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_payment_reason`
--

LOCK TABLES `openpos_payment_reason` WRITE;
/*!40000 ALTER TABLE `openpos_payment_reason` DISABLE KEYS */;
INSERT INTO `openpos_payment_reason` VALUES (0,'Sale');
/*!40000 ALTER TABLE `openpos_payment_reason` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_items_taxes`
--

DROP TABLE IF EXISTS `openpos_items_taxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_items_taxes` (
  `item_id` int(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `percent` double(15,2) NOT NULL,
  PRIMARY KEY (`item_id`,`name`,`percent`),
  CONSTRAINT `openpos_items_taxes_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_items_taxes`
--

LOCK TABLES `openpos_items_taxes` WRITE;
/*!40000 ALTER TABLE `openpos_items_taxes` DISABLE KEYS */;
INSERT INTO `openpos_items_taxes` VALUES (1,'VAT',14.00),(2,'VAT',14.00),(3,'VAT',14.00),(4,'VAT',0.00),(5,'VAT',0.00);
/*!40000 ALTER TABLE `openpos_items_taxes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_sales_items_taxes`
--

DROP TABLE IF EXISTS `openpos_sales_items_taxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_sales_items_taxes` (
  `sale_id` int(10) NOT NULL,
  `item_id` int(10) NOT NULL,
  `line` int(3) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `percent` double(15,2) NOT NULL,
  PRIMARY KEY (`sale_id`,`item_id`,`line`,`name`,`percent`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `openpos_sales_items_taxes_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales_items` (`sale_id`),
  CONSTRAINT `openpos_sales_items_taxes_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `openpos_receivings_items`
--

DROP TABLE IF EXISTS `openpos_receivings_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_receivings_items` (
  `receiving_id` int(10) NOT NULL DEFAULT '0',
  `item_id` int(10) NOT NULL DEFAULT '0',
  `description` varchar(30) DEFAULT NULL,
  `serialnumber` varchar(30) DEFAULT NULL,
  `line` int(3) NOT NULL,
  `quantity_purchased` int(10) NOT NULL DEFAULT '0',
  `item_cost_price` decimal(15,2) NOT NULL,
  `item_unit_price` double(15,2) NOT NULL,
  `discount_percent` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`receiving_id`,`item_id`,`line`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `openpos_receivings_items_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`),
  CONSTRAINT `openpos_receivings_items_ibfk_2` FOREIGN KEY (`receiving_id`) REFERENCES `openpos_receivings` (`receiving_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `openpos_suppliers`
--

DROP TABLE IF EXISTS `openpos_suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_suppliers` (
  `person_id` int(10) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `account_number` varchar(255) DEFAULT NULL,
  `deleted` int(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `account_number` (`account_number`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `openpos_suppliers_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `openpos_people` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_suppliers`
--

LOCK TABLES `openpos_suppliers` WRITE;
/*!40000 ALTER TABLE `openpos_suppliers` DISABLE KEYS */;
/*!40000 ALTER TABLE `openpos_suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_item_kits`
--

DROP TABLE IF EXISTS `openpos_item_kits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_item_kits` (
  `item_kit_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`item_kit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_item_kits`
--

LOCK TABLES `openpos_item_kits` WRITE;
/*!40000 ALTER TABLE `openpos_item_kits` DISABLE KEYS */;
/*!40000 ALTER TABLE `openpos_item_kits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_sales_suspended`
--

DROP TABLE IF EXISTS `openpos_sales_suspended`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_sales_suspended` (
  `sale_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customer_id` int(10) DEFAULT NULL,
  `employee_id` int(10) NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  `sale_id` int(10) NOT NULL AUTO_INCREMENT,
  `payment_type` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`sale_id`),
  KEY `customer_id` (`customer_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `openpos_sales_suspended_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `openpos_employees` (`person_id`),
  CONSTRAINT `openpos_sales_suspended_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `openpos_customers` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_sales_suspended`
--

LOCK TABLES `openpos_sales_suspended` WRITE;
/*!40000 ALTER TABLE `openpos_sales_suspended` DISABLE KEYS */;
/*!40000 ALTER TABLE `openpos_sales_suspended` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_sales_suspended_payments`
--

DROP TABLE IF EXISTS `openpos_sales_suspended_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_sales_suspended_payments` (
  `sale_id` int(10) NOT NULL,
  `payment_type` varchar(40) NOT NULL,
  `payment_amount` decimal(15,2) NOT NULL,
  `fk_reason` int(11) NOT NULL,
  PRIMARY KEY (`sale_id`,`payment_type`,`fk_reason`),
  CONSTRAINT `openpos_sales_suspended_payments_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales_suspended` (`sale_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_sales_suspended_payments`
--

LOCK TABLES `openpos_sales_suspended_payments` WRITE;
/*!40000 ALTER TABLE `openpos_sales_suspended_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `openpos_sales_suspended_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_sessions`
--

DROP TABLE IF EXISTS `openpos_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_sessions` (
  `session_id` varchar(40) NOT NULL DEFAULT '0',
  `ip_address` varchar(16) NOT NULL DEFAULT '0',
  `user_agent` varchar(50) NOT NULL,
  `last_activity` int(10) unsigned NOT NULL DEFAULT '0',
  `user_data` text,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `openpos_employees`
--

DROP TABLE IF EXISTS `openpos_employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_employees` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `person_id` int(10) NOT NULL,
  `deleted` int(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `username` (`username`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `openpos_employees_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `openpos_people` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_employees`
--

LOCK TABLES `openpos_employees` WRITE;
/*!40000 ALTER TABLE `openpos_employees` DISABLE KEYS */;
INSERT INTO `openpos_employees` VALUES ('admin','439a6de57d475c1a0ba9bcb1c39f0af6',1,0),('cash1','b59c67bf196a4758191e42f76670ceba',3,0);
/*!40000 ALTER TABLE `openpos_employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openpos_permissions`
--

DROP TABLE IF EXISTS `openpos_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_permissions` (
  `module_id` varchar(255) NOT NULL,
  `person_id` int(10) NOT NULL,
  PRIMARY KEY (`module_id`,`person_id`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `openpos_permissions_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `openpos_employees` (`person_id`),
  CONSTRAINT `openpos_permissions_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `openpos_modules` (`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_permissions`
--

LOCK TABLES `openpos_permissions` WRITE;
/*!40000 ALTER TABLE `openpos_permissions` DISABLE KEYS */;
INSERT INTO `openpos_permissions` VALUES ('cashups',1),('config',1),('customers',1),('employees',1),('giftcards',1),('items',1),('item_kits',1),('receivings',1),('reports',1),('sales',1),('suppliers',1),('sales',3);
/*!40000 ALTER TABLE `openpos_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `view_item_bom_cost`
--

DROP TABLE IF EXISTS `view_item_bom_cost`;
/*!50001 DROP VIEW IF EXISTS `view_item_bom_cost`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `view_item_bom_cost` (
  `item_id` tinyint NOT NULL,
  `bom_line_cost` tinyint NOT NULL,
  `item_cost_price` tinyint NOT NULL,
  `cost_from_bom` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `openpos_item_bom`
--

DROP TABLE IF EXISTS `openpos_item_bom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_item_bom` (
  `item_bom_id` int(10) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `bom_item_id` int(11) NOT NULL,
  `quantity` double(15,3) NOT NULL,
  PRIMARY KEY (`item_bom_id`,`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `openpos_cashups`
--

DROP TABLE IF EXISTS `openpos_cashups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_cashups` (
  `cashup_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` varchar(45) NOT NULL,
  `started` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  PRIMARY KEY (`cashup_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `openpos_sales_suspended_items_taxes`
--

DROP TABLE IF EXISTS `openpos_sales_suspended_items_taxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openpos_sales_suspended_items_taxes` (
  `sale_id` int(10) NOT NULL,
  `item_id` int(10) NOT NULL,
  `line` int(3) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `percent` double(15,2) NOT NULL,
  PRIMARY KEY (`sale_id`,`item_id`,`line`,`name`,`percent`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `openpos_sales_suspended_items_taxes_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales_suspended_items` (`sale_id`),
  CONSTRAINT `openpos_sales_suspended_items_taxes_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openpos_sales_suspended_items_taxes`
--

LOCK TABLES `openpos_sales_suspended_items_taxes` WRITE;
/*!40000 ALTER TABLE `openpos_sales_suspended_items_taxes` DISABLE KEYS */;
/*!40000 ALTER TABLE `openpos_sales_suspended_items_taxes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `openpos_full_cashup_view`
--

/*!50001 DROP TABLE IF EXISTS `openpos_full_cashup_view`*/;
/*!50001 DROP VIEW IF EXISTS `openpos_full_cashup_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `openpos_full_cashup_view` AS select `c`.`cashup_id` AS `cashup_id`,`c`.`employee_id` AS `employee_id`,`p`.`first_name` AS `first_name`,`p`.`last_name` AS `last_name`,`cd`.`payment_method_id` AS `payment_method_id`,`pm`.`Name` AS `payment_method_name`,`cd`.`employee_id` AS `cashup_employeed_id`,`p2`.`first_name` AS `cashup_employee_first_name`,`p2`.`last_name` AS `cashup_employee_last_name`,`cd`.`declared_value` AS `declared_value`,`cd`.`reported_total` AS `reported_total`,`c`.`started` AS `started`,`c`.`closed` AS `closed` from ((((`openpos_cashups` `c` join `openpos_cashups_declared` `cd` on((`c`.`cashup_id` = `cd`.`cashup_id`))) join `openpos_people` `p` on((`p`.`person_id` = `c`.`employee_id`))) join `openpos_payment_methods` `pm` on((`pm`.`payment_method_id` = `cd`.`payment_method_id`))) join `openpos_people` `p2` on((`p2`.`person_id` = `cd`.`employee_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_item_bom_cost`
--

/*!50001 DROP TABLE IF EXISTS `view_item_bom_cost`*/;
/*!50001 DROP VIEW IF EXISTS `view_item_bom_cost`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`openpos`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_item_bom_cost` AS select `ib`.`item_id` AS `item_id`,sum((`bi`.`cost_price` * `ib`.`quantity`)) AS `bom_line_cost`,`i`.`cost_price` AS `item_cost_price`,`i`.`cost_from_bom` AS `cost_from_bom` from ((`openpos_item_bom` `ib` left join `openpos_items` `i` on((`ib`.`item_id` = `i`.`item_id`))) left join `openpos_items` `bi` on((`ib`.`bom_item_id` = `bi`.`item_id`))) group by `ib`.`item_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-05-13 15:26:45
