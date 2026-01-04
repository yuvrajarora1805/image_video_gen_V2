-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: laravel
-- ------------------------------------------------------
-- Server version	5.5.5-10.11.0-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `before_genration`
--

DROP TABLE IF EXISTS `before_genration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `before_genration` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `taskid` int(11) NOT NULL,
  `mastertemplateid` int(11) NOT NULL,
  `backgroundimage` varchar(255) DEFAULT NULL,
  `backgroundpath` varchar(500) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `before_genration`
--

LOCK TABLES `before_genration` WRITE;
/*!40000 ALTER TABLE `before_genration` DISABLE KEYS */;
INSERT INTO `before_genration` VALUES (11,10,2,'bg1765396880.jpg','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765396880.jpg',0,'2025-12-10 14:31:22','2025-12-10 15:15:08'),(12,11,1,'bg1765397670.jpg','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765397670.jpg',1,'2025-12-10 14:44:37','2025-12-10 14:49:26'),(15,14,2,'bg1765399541.jpg','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765399541.jpg',0,'2025-12-10 15:15:43','2025-12-10 15:17:02'),(16,15,1,'bg1765446074.jpg','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765446074.jpg',0,'2025-12-11 04:11:16','2025-12-11 04:11:24'),(17,16,2,'bg1765446195.jpg','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765446195.jpg',0,'2025-12-11 04:13:17','2025-12-11 04:13:22'),(18,17,3,'bg1765453733.png','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765453733.png',0,'2025-12-11 06:19:09','2025-12-11 06:19:31'),(19,18,1,'bg1765453755.png','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765453755.png',0,'2025-12-11 06:19:16','2025-12-11 06:19:25');
/*!40000 ALTER TABLE `before_genration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `whatsappgroup` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'A',NULL,NULL,'A',NULL,NULL,'2025-12-10 12:34:46','2025-12-10 12:34:46'),(2,'sp',NULL,NULL,'Sp',NULL,NULL,'2025-12-10 15:04:46','2025-12-10 15:04:46'),(3,'A01 KHALID JI BJP CHANDNI CHOWK',NULL,NULL,'A01 KHALID JI BJP CHANDNI CHOWK',NULL,NULL,'2025-12-11 06:17:24','2025-12-11 06:17:24');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `errorlogs`
--

DROP TABLE IF EXISTS `errorlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `errorlogs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `errorlogs`
--

LOCK TABLES `errorlogs` WRITE;
/*!40000 ALTER TABLE `errorlogs` DISABLE KEYS */;
INSERT INTO `errorlogs` VALUES (1,NULL,'Template Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.logs\' doesn\'t exist (Connection: mysql, SQL: insert into `logs` (`task_id`, `status`, `message`, `updated_at`, `created_at`) values (1, success, Template created successfully, 2025-12-10 16:01:22, 2025-12-10 16:01:22))','2025-12-10 10:31:22','2025-12-10 10:31:22'),(2,NULL,'Template Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.logs\' doesn\'t exist (Connection: mysql, SQL: insert into `logs` (`task_id`, `status`, `message`, `updated_at`, `created_at`) values (2, success, Template created successfully, 2025-12-10 16:01:59, 2025-12-10 16:01:59))','2025-12-10 10:31:59','2025-12-10 10:31:59'),(3,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:16','2025-12-10 10:34:16'),(4,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:19','2025-12-10 10:34:19'),(5,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:21','2025-12-10 10:34:21'),(6,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:21','2025-12-10 10:34:21'),(7,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:21','2025-12-10 10:34:21'),(8,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:21','2025-12-10 10:34:21'),(9,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:21','2025-12-10 10:34:21'),(10,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:22','2025-12-10 10:34:22'),(11,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:40','2025-12-10 10:34:40'),(12,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:44','2025-12-10 10:34:44'),(13,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:45','2025-12-10 10:34:45'),(14,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:45','2025-12-10 10:34:45'),(15,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:45','2025-12-10 10:34:45'),(16,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:37:44','2025-12-10 10:37:44'),(17,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:38:49','2025-12-10 10:38:49'),(18,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:40:46','2025-12-10 10:40:46'),(19,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:41:32','2025-12-10 10:41:32'),(20,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:41:46','2025-12-10 10:41:46'),(21,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:43:22','2025-12-10 10:43:22'),(22,NULL,'Task Creation','SQLSTATE[42S22]: Column not found: 1054 Unknown column \'backgroundpath\' in \'field list\' (Connection: mysql, SQL: insert into `before_genration` (`mastertemplateid`, `backgroundimage`, `backgroundpath`, `taskid`, `updated_at`, `created_at`) values (1, bg1765389075.jpg, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765389075.jpg, 1, 2025-12-10 17:51:18, 2025-12-10 17:51:18))','2025-12-10 12:21:18','2025-12-10 12:21:18'),(23,NULL,'Customer Creation','SQLSTATE[42S22]: Column not found: 1054 Unknown column \'whatsappgroup\' in \'where clause\' (Connection: mysql, SQL: select * from `customers` where `name` = 1 and `whatsappgroup` = A limit 1)','2025-12-10 12:24:39','2025-12-10 12:24:39'),(24,NULL,'Customer Creation','SQLSTATE[42S22]: Column not found: 1054 Unknown column \'whatsappgroup\' in \'where clause\' (Connection: mysql, SQL: select * from `customers` where `name` = A and `whatsappgroup` = A limit 1)','2025-12-10 12:25:23','2025-12-10 12:25:23'),(25,NULL,'Customer Creation','SQLSTATE[HY000]: General error: 1364 Field \'email\' doesn\'t have a default value (Connection: mysql, SQL: insert into `customers` (`name`, `whatsappgroup`, `updated_at`, `created_at`) values (A, A, 2025-12-10 18:00:21, 2025-12-10 18:00:21))','2025-12-10 12:30:21','2025-12-10 12:30:21'),(26,NULL,'Customer Creation','SQLSTATE[HY000]: General error: 1364 Field \'email\' doesn\'t have a default value (Connection: mysql, SQL: insert into `customers` (`name`, `whatsappgroup`, `updated_at`, `created_at`) values (A, A, 2025-12-10 18:02:11, 2025-12-10 18:02:11))','2025-12-10 12:32:11','2025-12-10 12:32:11'),(27,NULL,'Customer Creation','SQLSTATE[HY000]: General error: 1364 Field \'email\' doesn\'t have a default value (Connection: mysql, SQL: insert into `customers` (`name`, `whatsappgroup`, `updated_at`, `created_at`) values (A, A, 2025-12-10 18:02:29, 2025-12-10 18:02:29))','2025-12-10 12:32:29','2025-12-10 12:32:29'),(28,NULL,'Customer Template Creation/Update','SQLSTATE[22001]: String data, right truncated: 1406 Data too long for column \'template_path\' at row 1 (Connection: mysql, SQL: insert into `templates_by_user` (`master_template_id`, `customer_id`, `customer_template`, `template_path`, `memtype`, `updated_at`, `created_at`) values (1, 1, user_template_1765389947_6939b67bdb4b8.png, img/user_template/user_template_1765389947_6939b67bdb4b8.png, png, 2025-12-10 18:05:47, 2025-12-10 18:05:47))','2025-12-10 12:35:47','2025-12-10 12:35:47'),(29,5,NULL,'SQLSTATE[HY000]: General error: 1364 Field \'user_template_id\' doesn\'t have a default value (Connection: mysql, SQL: insert into `generated_image` (`customer_id`, `master_template_id`, `taskid`, `beforeid`, `genarted_path`, `genarted_image`, `updated_at`, `created_at`) values (1, 1, 5, 6, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765396006_6939ce26f2335.jpg, combined_image_1765396006_6939ce26f2335.jpg, 2025-12-10 19:46:46, 2025-12-10 19:46:46))','2025-12-10 14:16:46','2025-12-10 14:16:46'),(30,5,NULL,'SQLSTATE[HY000]: General error: 1364 Field \'user_template_id\' doesn\'t have a default value (Connection: mysql, SQL: insert into `generated_image` (`customer_id`, `master_template_id`, `taskid`, `beforeid`, `genarted_path`, `genarted_image`, `updated_at`, `created_at`) values (1, 1, 5, 6, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765396011_6939ce2b21f0c.jpg, combined_image_1765396011_6939ce2b21f0c.jpg, 2025-12-10 19:46:51, 2025-12-10 19:46:51))','2025-12-10 14:16:51','2025-12-10 14:16:51'),(31,11,NULL,'SQLSTATE[HY000]: General error: 1364 Field \'memtype\' doesn\'t have a default value (Connection: mysql, SQL: insert into `generated_image` (`customer_id`, `master_template_id`, `user_template_id`, `taskid`, `beforeid`, `genarted_path`, `genarted_image`, `updated_at`, `created_at`) values (1, 1, 1, 11, 12, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765397891_6939d58352cdf.jpg, combined_image_1765397891_6939d58352cdf.jpg, 2025-12-10 20:18:11, 2025-12-10 20:18:11))','2025-12-10 14:48:11','2025-12-10 14:48:11'),(32,11,NULL,'SQLSTATE[HY000]: General error: 1364 Field \'memtype\' doesn\'t have a default value (Connection: mysql, SQL: insert into `generated_image` (`customer_id`, `master_template_id`, `user_template_id`, `taskid`, `beforeid`, `genarted_path`, `genarted_image`, `updated_at`, `created_at`) values (1, 1, 1, 11, 12, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765397895_6939d5873f38b.jpg, combined_image_1765397895_6939d5873f38b.jpg, 2025-12-10 20:18:15, 2025-12-10 20:18:15))','2025-12-10 14:48:15','2025-12-10 14:48:15'),(33,11,NULL,'SQLSTATE[HY000]: General error: 1364 Field \'memtype\' doesn\'t have a default value (Connection: mysql, SQL: insert into `generated_image` (`customer_id`, `master_template_id`, `user_template_id`, `taskid`, `beforeid`, `genarted_path`, `genarted_image`, `updated_at`, `created_at`) values (1, 1, 1, 11, 12, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765397912_6939d5983fae8.jpg, combined_image_1765397912_6939d5983fae8.jpg, 2025-12-10 20:18:32, 2025-12-10 20:18:32))','2025-12-10 14:48:32','2025-12-10 14:48:32');
/*!40000 ALTER TABLE `errorlogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generated_image`
--

DROP TABLE IF EXISTS `generated_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generated_image` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `taskid` int(11) DEFAULT NULL,
  `beforeid` int(11) DEFAULT NULL,
  `customer_id` int(11) NOT NULL,
  `master_template_id` int(11) DEFAULT NULL,
  `user_template_id` int(11) DEFAULT NULL,
  `genarted_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `genarted_image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sent` tinyint(1) DEFAULT 0,
  `sent_date` timestamp NULL DEFAULT NULL,
  `memtype` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_image`
--

LOCK TABLES `generated_image` WRITE;
/*!40000 ALTER TABLE `generated_image` DISABLE KEYS */;
INSERT INTO `generated_image` VALUES (1,11,12,1,1,1,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765397966_6939d5ce1fc58.jpg','combined_image_1765397966_6939d5ce1fc58.jpg',1,'2025-12-10 14:51:32','jpg',NULL,'2025-12-10 14:49:26','2025-12-10 14:51:32'),(2,10,11,1,2,2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765399508_6939dbd44b2ea.jpg','combined_image_1765399508_6939dbd44b2ea.jpg',1,'2025-12-11 04:31:47','jpg',NULL,'2025-12-10 15:15:08','2025-12-11 04:31:47'),(3,10,11,2,2,3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765399508_6939dbd46f861.jpg','combined_image_1765399508_6939dbd46f861.jpg',1,'2025-12-11 04:31:47','jpg',NULL,'2025-12-10 15:15:08','2025-12-11 04:31:47'),(4,14,15,1,2,2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765399621_6939dc45e11d5.jpg','combined_image_1765399621_6939dc45e11d5.jpg',1,'2025-12-10 15:17:31','jpg',NULL,'2025-12-10 15:17:01','2025-12-10 15:17:31'),(5,14,15,2,2,3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765399622_6939dc4612efa.jpg','combined_image_1765399622_6939dc4612efa.jpg',1,'2025-12-10 15:17:32','jpg',NULL,'2025-12-10 15:17:02','2025-12-10 15:17:32'),(6,15,16,1,1,1,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765446084_693a91c4ee529.jpg','combined_image_1765446084_693a91c4ee529.jpg',0,NULL,'jpg',NULL,'2025-12-11 04:11:24','2025-12-11 04:11:24'),(7,16,17,1,2,2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765446202_693a923a5503a.jpg','combined_image_1765446202_693a923a5503a.jpg',1,'2025-12-11 04:17:53','jpg',NULL,'2025-12-11 04:13:22','2025-12-11 04:17:53'),(8,16,17,2,2,3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765446202_693a923a745c8.jpg','combined_image_1765446202_693a923a745c8.jpg',1,'2025-12-11 04:17:54','jpg',NULL,'2025-12-11 04:13:22','2025-12-11 04:17:54'),(9,18,19,1,1,1,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765453765_693aafc5797c2.jpg','combined_image_1765453765_693aafc5797c2.jpg',1,'2025-12-11 06:20:37','jpg',NULL,'2025-12-11 06:19:25','2025-12-11 06:20:37'),(10,18,19,3,1,5,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765453765_693aafc5af674.jpg','combined_image_1765453765_693aafc5af674.jpg',1,'2025-12-11 06:20:38','jpg',NULL,'2025-12-11 06:19:25','2025-12-11 06:20:38'),(11,17,18,3,3,4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765453771_693aafcb0d03f.jpg','combined_image_1765453771_693aafcb0d03f.jpg',1,'2025-12-11 06:20:40','jpg',NULL,'2025-12-11 06:19:31','2025-12-11 06:20:40');
/*!40000 ALTER TABLE `generated_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (1,1,'success','Customer created successfully','2025-12-10 12:34:46','2025-12-10 12:34:46'),(2,1,'success','Customer Template created successfully','2025-12-10 12:36:31','2025-12-10 12:36:31'),(7,4,'success','Task created successfully','2025-12-10 14:00:28','2025-12-10 14:00:28'),(8,5,'success','Task created successfully','2025-12-10 14:01:33','2025-12-10 14:01:33'),(9,5,'success','Images generated successfully. Ready to send.','2025-12-10 14:02:11','2025-12-10 14:02:11'),(10,6,'success','Task created successfully','2025-12-10 14:17:11','2025-12-10 14:17:11'),(11,6,'success','Images generated successfully. Ready to send.','2025-12-10 14:17:29','2025-12-10 14:17:29'),(12,7,'success','Task created successfully','2025-12-10 14:20:34','2025-12-10 14:20:34'),(13,7,'success','Images generated successfully. Ready to send.','2025-12-10 14:20:45','2025-12-10 14:20:45'),(14,1,'success','Customer Template updated successfully','2025-12-10 14:21:52','2025-12-10 14:21:52'),(15,1,'success','Customer Template updated successfully','2025-12-10 14:22:23','2025-12-10 14:22:23'),(16,1,'success','Customer Template updated successfully','2025-12-10 14:24:04','2025-12-10 14:24:04'),(20,9,'success','Task created successfully','2025-12-10 14:28:38','2025-12-10 14:28:38'),(21,9,'success','Images generated successfully. Ready to send.','2025-12-10 14:30:07','2025-12-10 14:30:07'),(22,10,'success','Task created successfully','2025-12-10 14:31:22','2025-12-10 14:31:22'),(23,10,'success','Images generated successfully. Ready to send.','2025-12-10 14:31:35','2025-12-10 14:31:35'),(24,11,'success','Task created successfully','2025-12-10 14:44:37','2025-12-10 14:44:37'),(25,11,'success','Images generated successfully. Ready to send.','2025-12-10 14:44:47','2025-12-10 14:44:47'),(26,11,'success','Images generated successfully. Ready to send.','2025-12-10 14:49:31','2025-12-10 14:49:31'),(33,10,'success','Images generated successfully. Ready to send.','2025-12-10 15:15:13','2025-12-10 15:15:13'),(34,14,'success','Task created successfully','2025-12-10 15:15:43','2025-12-10 15:15:43'),(35,14,'success','Images generated successfully. Ready to send.','2025-12-10 15:17:07','2025-12-10 15:17:07'),(36,15,'success','Task created successfully','2025-12-11 04:11:16','2025-12-11 04:11:16'),(37,15,'success','Images generated successfully. Ready to send.','2025-12-11 04:11:29','2025-12-11 04:11:29'),(38,16,'success','Task created successfully','2025-12-11 04:13:17','2025-12-11 04:13:17'),(39,16,'success','Images generated successfully. Ready to send.','2025-12-11 04:13:27','2025-12-11 04:13:27'),(40,3,'success','Template created successfully','2025-12-11 06:16:49','2025-12-11 06:16:49'),(41,3,'success','Customer created successfully','2025-12-11 06:17:24','2025-12-11 06:17:24'),(42,4,'success','Customer Template created successfully','2025-12-11 06:17:58','2025-12-11 06:17:58'),(43,5,'success','Customer Template created successfully','2025-12-11 06:18:25','2025-12-11 06:18:25'),(44,17,'success','Task created successfully','2025-12-11 06:19:09','2025-12-11 06:19:09'),(45,18,'success','Task created successfully','2025-12-11 06:19:16','2025-12-11 06:19:16'),(46,18,'success','Images generated successfully. Ready to send.','2025-12-11 06:19:30','2025-12-11 06:19:30'),(47,17,'success','Images generated successfully. Ready to send.','2025-12-11 06:19:36','2025-12-11 06:19:36');
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2014_10_12_000000_create_users_table',1),(2,'2014_10_12_100000_create_password_reset_tokens_table',1),(3,'2019_08_19_000000_create_failed_jobs_table',1),(4,'2019_12_14_000001_create_personal_access_tokens_table',1),(5,'2024_05_15_165659_customer',1),(6,'2024_05_16_045432_templates',1),(7,'2024_05_16_051028_generated_image',1),(8,'2024_05_16_090410_template_by_user',1),(9,'2024_05_16_091248_add_user_template_id_to_generated_image_table',2),(10,'2024_05_16_094830_upload_images',2),(11,'2025_12_10_155003_create_task_table',2);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `taskname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remark` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `sent_status` tinyint(1) DEFAULT 0,
  `finished_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES (10,'Task09','Success - All Images Sent',1,'2025-12-10 14:31:22','2025-12-10 15:15:13',1,'2025-12-10 15:15:13',1),(11,'Task10','Generated - Ready to Send',1,'2025-12-10 14:44:37','2025-12-10 14:49:31',0,'2025-12-10 14:49:31',1),(14,'Task13','Generated - Ready to Send',1,'2025-12-10 15:15:43','2025-12-10 15:17:07',0,'2025-12-10 15:17:07',1),(15,'Task04','Generated - Ready to Send',1,'2025-12-11 04:11:16','2025-12-11 04:11:29',0,'2025-12-11 04:11:29',1),(16,'Task05','Generated - Ready to Send',1,'2025-12-11 04:13:17','2025-12-11 04:13:27',0,'2025-12-11 04:13:27',1),(17,'Task06','Success - All Images Sent',1,'2025-12-11 06:19:09','2025-12-11 06:20:40',1,'2025-12-11 06:19:36',1),(18,'Task07','Success - All Images Sent',1,'2025-12-11 06:19:16','2025-12-11 06:20:38',1,'2025-12-11 06:19:30',1);
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tempgeneration`
--

DROP TABLE IF EXISTS `tempgeneration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tempgeneration` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mastertemplateid` int(11) NOT NULL,
  `backgroundimage` varchar(255) DEFAULT NULL,
  `backgroundpath` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tempgeneration`
--

LOCK TABLES `tempgeneration` WRITE;
/*!40000 ALTER TABLE `tempgeneration` DISABLE KEYS */;
/*!40000 ALTER TABLE `tempgeneration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `templates`
--

DROP TABLE IF EXISTS `templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `memtype` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templates`
--

LOCK TABLES `templates` WRITE;
/*!40000 ALTER TABLE `templates` DISABLE KEYS */;
INSERT INTO `templates` VALUES (1,'1','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/master_template/template_1765382482_6939995297ca1.png','template_1765382482_6939995297ca1.png','png',NULL,'2025-12-10 10:31:22','2025-12-10 10:31:22'),(2,'2','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/master_template/template_1765382519_693999771aaa8.png','template_1765382519_693999771aaa8.png','png',NULL,'2025-12-10 10:31:59','2025-12-10 10:31:59'),(3,'BJP','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/master_template/template_1765453609_693aaf2932564.png','template_1765453609_693aaf2932564.png','png',NULL,'2025-12-11 06:16:49','2025-12-11 06:16:49');
/*!40000 ALTER TABLE `templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `templates_by_user`
--

DROP TABLE IF EXISTS `templates_by_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `templates_by_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `master_template_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer_template` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `template_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `memtype` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templates_by_user`
--

LOCK TABLES `templates_by_user` WRITE;
/*!40000 ALTER TABLE `templates_by_user` DISABLE KEYS */;
INSERT INTO `templates_by_user` VALUES (1,1,1,'user_template_1765396444_6939cfdc5e060.png','img/user_template/user_template_1765396444_6939cfdc5e060.png','png',NULL,'2025-12-10 12:36:31','2025-12-10 14:24:04'),(2,2,1,'user_template_1765396491_6939d00bc8a9e.png','img/user_template/user_template_1765396491_6939d00bc8a9e.png','png',NULL,'2025-12-10 14:24:51','2025-12-10 14:24:51'),(3,2,2,'user_template_1765398963_6939d9b31addd.png','img/user_template/user_template_1765398963_6939d9b31addd.png','png',NULL,'2025-12-10 15:06:03','2025-12-10 15:06:03'),(4,3,3,'user_template_1765453678_693aaf6eae0e8.png','img/user_template/user_template_1765453678_693aaf6eae0e8.png','png',NULL,'2025-12-11 06:17:58','2025-12-11 06:17:58'),(5,1,3,'user_template_1765453705_693aaf8973d87.png','img/user_template/user_template_1765453705_693aaf8973d87.png','png',NULL,'2025-12-11 06:18:25','2025-12-11 06:18:25');
/*!40000 ALTER TABLE `templates_by_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `upload_images`
--

DROP TABLE IF EXISTS `upload_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `upload_images` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `master_template_id` int(11) NOT NULL,
  `path` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `uploadedimage` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mimetype` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upload_images`
--

LOCK TABLES `upload_images` WRITE;
/*!40000 ALTER TABLE `upload_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `upload_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'UVA Creations','uvacreation@gmail.com',NULL,'$2y$12$gdfI6p0s2FOS797lQ1hlPev1uue5nu7iSNqyxPie.Z2TqsPbnj9.W',NULL,'2025-12-10 10:16:41','2025-12-10 10:16:41');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-11 21:43:33
