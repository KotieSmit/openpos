-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 04, 2014 at 10:34 PM
-- Server version: 5.5.32
-- PHP Version: 5.4.26-1+deb.sury.org~precise+1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `openpos`
--

-- --------------------------------------------------------

--
-- Table structure for table `openpos_app_config`
--

CREATE TABLE IF NOT EXISTS `openpos_app_config` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Dumping data for table `openpos_app_config`
--

INSERT INTO `openpos_app_config` (`key`, `value`) VALUES
('address', '123 Nowhere street'),
('company', 'OpenPOS'),
('default_tax_rate', '8'),
('email', 'em@il.com'),
('fax', ''),
('phone', '555-555-5555'),
('return_policy', 'Test'),
('timezone', 'America/New_York'),
('website', '');


-- --

-- Table structure for table `openpos_cashups`
--



CREATE TABLE IF NOT EXISTS `openpos_cashups` (
  `cashup_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` varchar(45) NOT NULL,
  `started` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  PRIMARY KEY (`cashup_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_cashups_declared`
--

CREATE TABLE IF NOT EXISTS `openpos_cashups_declared` (
  `openpos_cashups_payments_id` int(11) NOT NULL AUTO_INCREMENT,
  `cashup_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `declared_value` decimal(15,2) NOT NULL DEFAULT '0.00',
  `reported_total` decimal(15,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`openpos_cashups_payments_id`,`cashup_id`,`payment_method_id`,`employee_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=120 ;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_customers`
--

CREATE TABLE IF NOT EXISTS `openpos_customers` (
  `person_id` int(10) NOT NULL,
  `account_number` varchar(255) DEFAULT NULL,
  `taxable` int(1) NOT NULL DEFAULT '1',
  `deleted` int(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `account_number` (`account_number`),
  KEY `person_id` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_employees`
--

CREATE TABLE IF NOT EXISTS `openpos_employees` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `person_id` int(10) NOT NULL,
  `deleted` int(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `username` (`username`),
  KEY `person_id` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_employees`
--

INSERT INTO `openpos_employees` (`username`, `password`, `person_id`, `deleted`) VALUES
('admin', '439a6de57d475c1a0ba9bcb1c39f0af6', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `openpos_giftcards`
--

CREATE TABLE IF NOT EXISTS `openpos_giftcards` (
  `giftcard_id` int(11) NOT NULL AUTO_INCREMENT,
  `giftcard_number` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `value` double(15,2) NOT NULL,
  `deleted` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`giftcard_id`),
  UNIQUE KEY `giftcard_number` (`giftcard_number`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

--
-- Dumping data for table `openpos_giftcards`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_inventory`
--

CREATE TABLE IF NOT EXISTS `openpos_inventory` (
  `trans_id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_items` int(11) NOT NULL DEFAULT '0',
  `trans_user` int(11) NOT NULL DEFAULT '0',
  `trans_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `trans_comment` text NOT NULL,
  `trans_inventory` double(15,3) NOT NULL DEFAULT '0.000',
  PRIMARY KEY (`trans_id`),
  KEY `openpos_inventory_ibfk_1` (`trans_items`),
  KEY `openpos_inventory_ibfk_2` (`trans_user`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=670 ;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_items`
--

CREATE TABLE IF NOT EXISTS `openpos_items` (
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
  `is_serialized` tinyint(1) NOT NULL,
  `stock_keeping_item` tinyint(1) NOT NULL,
  `production_item` tinyint(1) NOT NULL,
  `cost_from_bom` tinyint(1) NOT NULL,
  `deleted` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  UNIQUE KEY `item_number` (`item_number`),
  KEY `openpos_items_ibfk_1` (`supplier_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_items_taxes`
--

CREATE TABLE IF NOT EXISTS `openpos_items_taxes` (
  `item_id` int(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `percent` double(15,2) NOT NULL,
  PRIMARY KEY (`item_id`,`name`,`percent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_item_bom`
--

CREATE TABLE IF NOT EXISTS `openpos_item_bom` (
  `item_bom_id` int(10) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `bom_item_id` int(11) NOT NULL,
  `quantity` double(15,3) NOT NULL,
  PRIMARY KEY (`item_bom_id`,`item_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=300 ;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_item_kits`
--

CREATE TABLE IF NOT EXISTS `openpos_item_kits` (
  `item_kit_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`item_kit_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_item_kit_items`
--

CREATE TABLE IF NOT EXISTS `openpos_item_kit_items` (
  `item_kit_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` double(15,2) NOT NULL,
  PRIMARY KEY (`item_kit_id`,`item_id`,`quantity`),
  KEY `openpos_item_kit_items_ibfk_2` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_modules`
--

CREATE TABLE IF NOT EXISTS `openpos_modules` (
  `name_lang_key` varchar(255) NOT NULL,
  `desc_lang_key` varchar(255) NOT NULL,
  `sort` int(10) NOT NULL,
  `module_id` varchar(255) NOT NULL,
  PRIMARY KEY (`module_id`),
  UNIQUE KEY `desc_lang_key` (`desc_lang_key`),
  UNIQUE KEY `name_lang_key` (`name_lang_key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_modules`
--

INSERT INTO `openpos_modules` (`name_lang_key`, `desc_lang_key`, `sort`, `module_id`) VALUES
('module_config', 'module_config_desc', 100, 'config'),
('module_customers', 'module_customers_desc', 10, 'customers'),
('module_employees', 'module_employees_desc', 80, 'employees'),
('module_giftcards', 'module_giftcards_desc', 90, 'giftcards'),
('module_items', 'module_items_desc', 20, 'items'),
('module_item_kits', 'module_item_kits_desc', 30, 'item_kits'),
('module_receivings', 'module_receivings_desc', 60, 'receivings'),
('module_reports', 'module_reports_desc', 50, 'reports'),
('module_sales', 'module_sales_desc', 70, 'sales'),
('module_suppliers', 'module_suppliers_desc', 40, 'suppliers');

-- --------------------------------------------------------

--
-- Table structure for table `openpos_payment_methods`
--

CREATE TABLE IF NOT EXISTS `openpos_payment_methods` (
  `payment_method_id` int(3) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `active` int(1) NOT NULL DEFAULT '0',
  `language_id` varchar(255) NOT NULL,
  `allow_over_tender` int(1) NOT NULL DEFAULT '0',
  `is_change` int(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `Name` (`payment_method_id`,`Name`),
  KEY `payment_method_id` (`payment_method_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_payment_reason`
--

CREATE TABLE IF NOT EXISTS `openpos_payment_reason` (
  `payment_reson_id` int(11) NOT NULL,
  `reason` varchar(45) NOT NULL,
  PRIMARY KEY (`payment_reson_id`),
  UNIQUE KEY `payment_reson_id_UNIQUE` (`payment_reson_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `openpos_people`
--

CREATE TABLE IF NOT EXISTS `openpos_people` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `openpos_people`
--

INSERT INTO `openpos_people` (`first_name`, `last_name`, `phone_number`, `email`, `address_1`, `address_2`, `city`, `state`, `zip`, `country`, `comments`, `person_id`) VALUES
('John', 'Doe', '555-555-5555', 'admin@pappastech.com', 'Address 1', '', '', '', '', '', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `openpos_permissions`
--

CREATE TABLE IF NOT EXISTS `openpos_permissions` (
  `module_id` varchar(255) NOT NULL,
  `person_id` int(10) NOT NULL,
  PRIMARY KEY (`module_id`,`person_id`),
  KEY `person_id` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_permissions`
--

INSERT INTO `openpos_permissions` (`module_id`, `person_id`) VALUES
('config', 1),
('customers', 1),
('employees', 1),
('giftcards', 1),
('items', 1),
('item_kits', 1),
('receivings', 1),
('reports', 1),
('sales', 1),
('suppliers', 1);

-- --------------------------------------------------------

--
-- Table structure for table `openpos_receivings`
--

CREATE TABLE IF NOT EXISTS `openpos_receivings` (
  `receiving_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int(10) DEFAULT NULL,
  `employee_id` int(10) NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  `receiving_id` int(10) NOT NULL AUTO_INCREMENT,
  `payment_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`receiving_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `openpos_receivings`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_receivings_items`
--

CREATE TABLE IF NOT EXISTS `openpos_receivings_items` (
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
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_receivings_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_sales`
--

CREATE TABLE IF NOT EXISTS `openpos_sales` (
  `sale_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customer_id` int(10) DEFAULT NULL,
  `employee_id` int(10) NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  `sale_id` int(10) NOT NULL AUTO_INCREMENT,
  `payment_type` varchar(512) DEFAULT NULL,
  `cashup_id` int(10) NOT NULL,
  PRIMARY KEY (`sale_id`),
  KEY `customer_id` (`customer_id`),
  KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=528 ;

--
-- Dumping data for table `openpos_sales`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_sales_items`
--

CREATE TABLE IF NOT EXISTS `openpos_sales_items` (
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
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_sales_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_sales_items_taxes`
--

CREATE TABLE IF NOT EXISTS `openpos_sales_items_taxes` (
  `sale_id` int(10) NOT NULL,
  `item_id` int(10) NOT NULL,
  `line` int(3) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `percent` double(15,2) NOT NULL,
  PRIMARY KEY (`sale_id`,`item_id`,`line`,`name`,`percent`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_sales_items_taxes`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_sales_payments`
--

CREATE TABLE IF NOT EXISTS `openpos_sales_payments` (
  `sale_id` int(10) NOT NULL,
  `payment_type` varchar(40) NOT NULL,
  `payment_amount` decimal(15,2) NOT NULL,
  `fk_reason` int(3) NOT NULL,
  `cashup_id` int(11) NOT NULL,
  PRIMARY KEY (`sale_id`,`payment_type`,`fk_reason`,`cashup_id`),
  KEY `fk_openpos_sales_payments_1` (`fk_reason`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_sales_payments`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_sales_suspended`
--

CREATE TABLE IF NOT EXISTS `openpos_sales_suspended` (
  `sale_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customer_id` int(10) DEFAULT NULL,
  `employee_id` int(10) NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  `sale_id` int(10) NOT NULL AUTO_INCREMENT,
  `payment_type` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`sale_id`),
  KEY `customer_id` (`customer_id`),
  KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `openpos_sales_suspended`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_sales_suspended_items`
--

CREATE TABLE IF NOT EXISTS `openpos_sales_suspended_items` (
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
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_sales_suspended_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_sales_suspended_items_taxes`
--

CREATE TABLE IF NOT EXISTS `openpos_sales_suspended_items_taxes` (
  `sale_id` int(10) NOT NULL,
  `item_id` int(10) NOT NULL,
  `line` int(3) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `percent` double(15,2) NOT NULL,
  PRIMARY KEY (`sale_id`,`item_id`,`line`,`name`,`percent`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_sales_suspended_items_taxes`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_sales_suspended_payments`
--

CREATE TABLE IF NOT EXISTS `openpos_sales_suspended_payments` (
  `sale_id` int(10) NOT NULL,
  `payment_type` varchar(40) NOT NULL,
  `payment_amount` decimal(15,2) NOT NULL,
  `fk_reason` int(11) NOT NULL,
  PRIMARY KEY (`sale_id`,`payment_type`,`fk_reason`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_sales_suspended_payments`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_sessions`
--

CREATE TABLE IF NOT EXISTS `openpos_sessions` (
  `session_id` varchar(40) NOT NULL DEFAULT '0',
  `ip_address` varchar(16) NOT NULL DEFAULT '0',
  `user_agent` varchar(50) NOT NULL,
  `last_activity` int(10) unsigned NOT NULL DEFAULT '0',
  `user_data` text,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `openpos_sessions`
--


-- --------------------------------------------------------

--
-- Table structure for table `openpos_suppliers`
--

CREATE TABLE IF NOT EXISTS `openpos_suppliers` (
  `person_id` int(10) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `account_number` varchar(255) DEFAULT NULL,
  `deleted` int(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `account_number` (`account_number`),
  KEY `person_id` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_item_bom_cost`
--
CREATE TABLE IF NOT EXISTS `view_item_bom_cost` (
   `item_id` int(11)
  ,`bom_line_cost` double(20,3)
  ,`item_cost_price` double(15,2)
  ,`cost_from_bom` tinyint(1)
);
-- --------------------------------------------------------

--
-- Structure for view `view_item_bom_cost`
--
DROP TABLE IF EXISTS `view_item_bom_cost`;

CREATE ALGORITHM=UNDEFINED DEFINER=`openpos`@`localhost` SQL SECURITY DEFINER VIEW `view_item_bom_cost` AS select `ib`.`item_id` AS `item_id`,sum((`bi`.`cost_price` * `ib`.`quantity`)) AS `bom_line_cost`,`i`.`cost_price` AS `item_cost_price`,`i`.`cost_from_bom` AS `cost_from_bom` from ((`openpos_item_bom` `ib` left join `openpos_items` `i` on((`ib`.`item_id` = `i`.`item_id`))) left join `openpos_items` `bi` on((`ib`.`bom_item_id` = `bi`.`item_id`))) group by `ib`.`item_id`;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `openpos_customers`
--
ALTER TABLE `openpos_customers`
ADD CONSTRAINT `openpos_customers_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `openpos_people` (`person_id`);

--
-- Constraints for table `openpos_employees`
--
ALTER TABLE `openpos_employees`
ADD CONSTRAINT `openpos_employees_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `openpos_people` (`person_id`);

--
-- Constraints for table `openpos_inventory`
--
ALTER TABLE `openpos_inventory`
ADD CONSTRAINT `openpos_inventory_ibfk_1` FOREIGN KEY (`trans_items`) REFERENCES `openpos_items` (`item_id`),
ADD CONSTRAINT `openpos_inventory_ibfk_2` FOREIGN KEY (`trans_user`) REFERENCES `openpos_employees` (`person_id`);

--
-- Constraints for table `openpos_items`
--
ALTER TABLE `openpos_items`
ADD CONSTRAINT `openpos_items_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `openpos_suppliers` (`person_id`);

--
-- Constraints for table `openpos_items_taxes`
--
ALTER TABLE `openpos_items_taxes`
ADD CONSTRAINT `openpos_items_taxes_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`) ON DELETE CASCADE;

--
-- Constraints for table `openpos_item_kit_items`
--
ALTER TABLE `openpos_item_kit_items`
ADD CONSTRAINT `openpos_item_kit_items_ibfk_1` FOREIGN KEY (`item_kit_id`) REFERENCES `openpos_item_kits` (`item_kit_id`) ON DELETE CASCADE,
ADD CONSTRAINT `openpos_item_kit_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`) ON DELETE CASCADE;

--
-- Constraints for table `openpos_permissions`
--
ALTER TABLE `openpos_permissions`
ADD CONSTRAINT `openpos_permissions_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `openpos_employees` (`person_id`),
ADD CONSTRAINT `openpos_permissions_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `openpos_modules` (`module_id`);

--
-- Constraints for table `openpos_receivings`
--
ALTER TABLE `openpos_receivings`
ADD CONSTRAINT `openpos_receivings_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `openpos_employees` (`person_id`),
ADD CONSTRAINT `openpos_receivings_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `openpos_suppliers` (`person_id`);

--
-- Constraints for table `openpos_receivings_items`
--
ALTER TABLE `openpos_receivings_items`
ADD CONSTRAINT `openpos_receivings_items_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`),
ADD CONSTRAINT `openpos_receivings_items_ibfk_2` FOREIGN KEY (`receiving_id`) REFERENCES `openpos_receivings` (`receiving_id`);

--
-- Constraints for table `openpos_sales`
--
ALTER TABLE `openpos_sales`
ADD CONSTRAINT `openpos_sales_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `openpos_employees` (`person_id`),
ADD CONSTRAINT `openpos_sales_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `openpos_customers` (`person_id`);

--
-- Constraints for table `openpos_sales_items`
--
ALTER TABLE `openpos_sales_items`
ADD CONSTRAINT `openpos_sales_items_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`),
ADD CONSTRAINT `openpos_sales_items_ibfk_2` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales` (`sale_id`);

--
-- Constraints for table `openpos_sales_items_taxes`
--
ALTER TABLE `openpos_sales_items_taxes`
ADD CONSTRAINT `openpos_sales_items_taxes_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales_items` (`sale_id`),
ADD CONSTRAINT `openpos_sales_items_taxes_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`);

--
-- Constraints for table `openpos_sales_payments`
--
ALTER TABLE `openpos_sales_payments`
ADD CONSTRAINT `fk_openpos_sales_payments_1` FOREIGN KEY (`fk_reason`) REFERENCES `openpos_payment_reason` (`payment_reson_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `openpos_sales_payments_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales` (`sale_id`);

--
-- Constraints for table `openpos_sales_suspended`
--
ALTER TABLE `openpos_sales_suspended`
ADD CONSTRAINT `openpos_sales_suspended_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `openpos_employees` (`person_id`),
ADD CONSTRAINT `openpos_sales_suspended_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `openpos_customers` (`person_id`);

--
-- Constraints for table `openpos_sales_suspended_items`
--
ALTER TABLE `openpos_sales_suspended_items`
ADD CONSTRAINT `openpos_sales_suspended_items_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`),
ADD CONSTRAINT `openpos_sales_suspended_items_ibfk_2` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales_suspended` (`sale_id`);

--
-- Constraints for table `openpos_sales_suspended_items_taxes`
--
ALTER TABLE `openpos_sales_suspended_items_taxes`
ADD CONSTRAINT `openpos_sales_suspended_items_taxes_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales_suspended_items` (`sale_id`),
ADD CONSTRAINT `openpos_sales_suspended_items_taxes_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `openpos_items` (`item_id`);

--
-- Constraints for table `openpos_sales_suspended_payments`
--
ALTER TABLE `openpos_sales_suspended_payments`
ADD CONSTRAINT `openpos_sales_suspended_payments_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `openpos_sales_suspended` (`sale_id`);

--
-- Constraints for table `openpos_suppliers`
--
ALTER TABLE `openpos_suppliers`
ADD CONSTRAINT `openpos_suppliers_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `openpos_people` (`person_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;