-- MariaDB dump 10.19  Distrib 10.11.0-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: laravel
-- ------------------------------------------------------
-- Server version	10.11.0-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `before_genration`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `before_genration` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `taskid` int(11) NOT NULL,
  `content_type` enum('image','video') NOT NULL DEFAULT 'image',
  `video_type` enum('portrait','landscape') DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `mastertemplateid` int(11) NOT NULL,
  `backgroundimage` varchar(255) DEFAULT NULL,
  `backgroundvideo` varchar(255) DEFAULT NULL,
  `backgroundvideopath` text DEFAULT NULL,
  `backgroundpath` varchar(500) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `animation_effect` varchar(50) DEFAULT 'wipe-in',
  `rendering_engine` varchar(20) NOT NULL DEFAULT 'moviepy' COMMENT 'Rendering engine: moviepy or ffmpeg',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=320 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `before_genration`
--

LOCK TABLES `before_genration` WRITE;
/*!40000 ALTER TABLE `before_genration` DISABLE KEYS */;
INSERT  IGNORE INTO `before_genration` VALUES
(11,10,'image',NULL,NULL,2,'bg1765396880.jpg',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765396880.jpg',0,'2025-12-10 14:31:22','2025-12-10 15:15:08','wipe-in','moviepy'),
(12,11,'image',NULL,NULL,1,'bg1765397670.jpg',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765397670.jpg',1,'2025-12-10 14:44:37','2025-12-10 14:49:26','wipe-in','moviepy'),
(15,14,'image',NULL,NULL,2,'bg1765399541.jpg',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765399541.jpg',0,'2025-12-10 15:15:43','2025-12-10 15:17:02','wipe-in','moviepy'),
(16,15,'image',NULL,NULL,1,'bg1765446074.jpg',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765446074.jpg',0,'2025-12-11 04:11:16','2025-12-11 04:11:24','wipe-in','moviepy'),
(17,16,'image',NULL,NULL,2,'bg1765446195.jpg',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765446195.jpg',0,'2025-12-11 04:13:17','2025-12-11 04:13:22','wipe-in','moviepy'),
(18,17,'image',NULL,NULL,3,'bg1765453733.png',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765453733.png',0,'2025-12-11 06:19:09','2025-12-11 06:19:31','wipe-in','moviepy'),
(19,18,'image',NULL,NULL,1,'bg1765453755.png',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765453755.png',0,'2025-12-11 06:19:16','2025-12-11 06:19:25','wipe-in','moviepy'),
(20,19,'image',NULL,NULL,1,'bg1765632913.jpg',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765632913.jpg',0,'2025-12-13 08:05:15','2025-12-13 08:06:20','wipe-in','moviepy'),
(21,20,'video','landscape',NULL,1,'bg_video_1765744306.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765744306.mp4',0,'2025-12-14 15:01:48','2025-12-14 15:01:59','wipe-in','moviepy'),
(22,21,'video','landscape',NULL,1,'bg_video_1765746463.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765746463.mp4',0,'2025-12-14 15:37:46','2025-12-14 15:37:54','wipe-in','moviepy'),
(23,22,'video','landscape',NULL,1,'bg_video_1765747606.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765747606.mp4',0,'2025-12-14 15:56:49','2025-12-14 15:57:06','wipe-in','moviepy'),
(24,23,'video','landscape',NULL,1,'bg_video_1765748581.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765748581.mp4',0,'2025-12-14 16:13:04','2025-12-14 16:13:24','wipe-in','moviepy'),
(25,24,'video','landscape',NULL,1,'bg_video_1765749407.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765749407.mp4',0,'2025-12-14 16:26:49','2025-12-14 16:27:07','wipe-in','moviepy'),
(26,25,'video','landscape',NULL,2,'bg_video_1765750187.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765750187.mp4',0,'2025-12-14 16:39:54','2025-12-14 16:47:38','wipe-in','moviepy'),
(27,26,'video','landscape',NULL,2,'bg_video_1765750242.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765750242.mp4',0,'2025-12-14 16:41:37','2025-12-14 16:47:48','wipe-in','moviepy'),
(28,27,'video','landscape',NULL,2,'bg_video_1765750409.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765750409.mp4',0,'2025-12-14 16:43:32','2025-12-14 16:47:57','wipe-in','moviepy'),
(29,28,'video','landscape',NULL,2,'bg_video_1765750449.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765750449.mp4',0,'2025-12-14 16:44:25','2025-12-14 16:48:06','wipe-in','moviepy'),
(30,28,'video','landscape',NULL,1,'bg_video_1765750463.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765750463.mp4',0,'2025-12-14 16:44:25','2025-12-14 16:48:16','wipe-in','moviepy'),
(31,29,'video','landscape',NULL,2,'bg_video_1765752314.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765752314.mp4',0,'2025-12-14 17:17:37','2025-12-14 17:26:57','wipe-in','moviepy'),
(32,29,'video','landscape',NULL,2,'bg_video_1765752340.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765752340.mp4',0,'2025-12-14 17:17:37','2025-12-14 17:27:07','wipe-in','moviepy'),
(33,30,'video','landscape',NULL,2,'bg_video_1765752609.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765752609.mp4',0,'2025-12-14 17:20:12','2025-12-14 17:27:18','wipe-in','moviepy'),
(34,31,'video','landscape',NULL,2,'bg_video_1765753228.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765753228.mp4',0,'2025-12-14 17:30:37','2025-12-14 17:42:58','wipe-in','moviepy'),
(35,32,'video','landscape',NULL,2,'bg_video_1765753326.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765753326.mp4',0,'2025-12-14 17:32:09','2025-12-14 17:37:34','wipe-in','moviepy'),
(36,33,'video','landscape',NULL,2,'bg_video_1765754040.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765754040.mp4',0,'2025-12-14 17:44:03','2025-12-14 17:56:42','wipe-in','moviepy'),
(37,34,'video','landscape',NULL,2,'bg_video_1765754088.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765754088.mp4',0,'2025-12-14 17:44:50','2025-12-14 17:45:49','wipe-in','moviepy'),
(38,35,'video','landscape',NULL,2,'bg_video_1765754342.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765754342.mp4',0,'2025-12-14 17:49:09','2025-12-14 17:49:56','wipe-in','moviepy'),
(39,36,'video','landscape',NULL,2,'bg_video_1765754650.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765754650.mp4',0,'2025-12-14 17:54:13','2025-12-14 17:55:32','wipe-in','moviepy'),
(40,37,'video','landscape',NULL,2,'bg_video_1765755081.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765755081.mp4',0,'2025-12-14 18:01:26','2025-12-15 03:33:43','wipe-in','moviepy'),
(41,38,'video','portrait',NULL,3,'bg_video_1765786689.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765786689.mp4',0,'2025-12-15 02:49:19','2025-12-15 02:50:57','wipe-in','moviepy'),
(42,38,'video','portrait',NULL,3,'bg_video_1765786756.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765786756.mp4',0,'2025-12-15 02:49:19','2025-12-15 02:51:22','wipe-in','moviepy'),
(43,39,'video','portrait',NULL,3,'bg_video_1765789444.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765789444.mp4',0,'2025-12-15 03:34:06','2025-12-15 03:34:39','wipe-in','moviepy'),
(44,40,'video','portrait',NULL,3,'bg_video_1765789492.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765789492.mp4',0,'2025-12-15 03:34:54','2025-12-15 03:35:24','wipe-in','moviepy'),
(45,41,'video','portrait',NULL,3,'bg_video_1765789637.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765789637.mp4',0,'2025-12-15 03:37:26','2025-12-15 03:38:02','wipe-in','moviepy'),
(46,41,'video','portrait',NULL,3,'bg_video_1765789644.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765789644.mp4',0,'2025-12-15 03:37:26','2025-12-15 03:38:29','wipe-in','moviepy'),
(47,42,'video','portrait',NULL,3,'bg_video_1765789820.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765789820.mp4',0,'2025-12-15 03:40:22','2025-12-15 04:52:43','wipe-in','moviepy'),
(48,43,'video','portrait',NULL,3,'bg_video_1765792217.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765792217.mp4',0,'2025-12-15 04:20:28','2025-12-15 04:21:59','zoom-in','moviepy'),
(49,44,'video','portrait',NULL,3,'bg_video_1765792252.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765792252.mp4',0,'2025-12-15 04:20:55','2025-12-15 04:21:28','zoom-in','moviepy'),
(50,45,'video','portrait',NULL,3,'bg_video_1765792398.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765792398.mp4',0,'2025-12-15 04:23:48','2025-12-15 04:24:21','zoom-in','moviepy'),
(51,45,'video','portrait',NULL,3,'bg_video_1765792411.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765792411.mp4',0,'2025-12-15 04:23:48','2025-12-15 04:24:49','fade-in','moviepy'),
(52,45,'video','portrait',NULL,3,'bg_video_1765792425.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765792425.mp4',0,'2025-12-15 04:23:48','2025-12-15 04:25:17','slide-in','moviepy'),
(53,46,'video','portrait',NULL,3,'bg_video_1765792790.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765792790.mp4',0,'2025-12-15 04:30:04','2025-12-15 04:30:35','wipe-in','moviepy'),
(54,46,'video','portrait',NULL,3,'bg_video_1765792802.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765792802.mp4',0,'2025-12-15 04:30:04','2025-12-15 04:31:01','zoom-in','moviepy'),
(55,47,'video','portrait',NULL,3,'bg_video_1765793089.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765793089.mp4',0,'2025-12-15 04:34:52','2025-12-15 04:35:23','bounce-in','moviepy'),
(56,48,'video','portrait',NULL,3,'bg_video_1765793221.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765793221.mp4',0,'2025-12-15 04:37:24','2025-12-15 04:37:56','curtain','moviepy'),
(57,48,'video','portrait',NULL,3,'bg_video_1765793240.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765793240.mp4',0,'2025-12-15 04:37:24','2025-12-15 04:38:26','curtain','moviepy'),
(58,49,'video','portrait',NULL,3,'bg_video_1765793327.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765793327.mp4',0,'2025-12-15 04:38:48','2025-12-15 04:39:25','spiral-in','moviepy'),
(59,50,'image',NULL,NULL,4,'bg_1765793693.jpg',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg_1765793693.jpg',0,'2025-12-15 04:44:55','2025-12-15 04:45:00','wipe-in','moviepy'),
(60,51,'image',NULL,NULL,4,'bg_1765793735.png',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg_1765793735.png',0,'2025-12-15 04:45:48','2025-12-15 04:45:53','wipe-in','moviepy'),
(61,51,'image',NULL,NULL,4,'bg_1765793744.jpg',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg_1765793744.jpg',0,'2025-12-15 04:45:48','2025-12-15 04:45:54','wipe-in','moviepy'),
(62,52,'video','portrait',NULL,3,'bg_video_1765794656.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765794656.mp4',0,'2025-12-15 05:01:32','2025-12-15 05:02:05','curtain','moviepy'),
(63,52,'video','portrait',NULL,3,'bg_video_1765794665.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765794665.mp4',0,'2025-12-15 05:01:32','2025-12-15 05:02:35','bounce-in','moviepy'),
(64,52,'video','portrait',NULL,3,'bg_video_1765794677.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765794677.mp4',0,'2025-12-15 05:01:32','2025-12-15 05:03:02','wipe-in','moviepy'),
(65,52,'video','portrait',NULL,3,'bg_video_1765794690.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765794690.mp4',0,'2025-12-15 05:01:32','2025-12-15 05:03:29','curtain','moviepy'),
(66,53,'video','portrait',NULL,3,'bg_video_1765794983.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765794983.mp4',0,'2025-12-15 05:06:55','2025-12-15 05:08:09','wipe-in','moviepy'),
(67,53,'video','portrait',NULL,3,'bg_video_1765794992.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765794992.mp4',0,'2025-12-15 05:06:55','2025-12-15 05:08:09','bounce-in','moviepy'),
(68,53,'video','portrait',NULL,3,'bg_video_1765795001.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795001.mp4',0,'2025-12-15 05:06:55','2025-12-15 05:08:09','curtain','moviepy'),
(69,53,'video','portrait',NULL,3,'bg_video_1765795012.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795012.mp4',0,'2025-12-15 05:06:55','2025-12-15 05:08:09','fade-in','moviepy'),
(70,54,'video','portrait',NULL,3,'bg_video_1765795272.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795272.mp4',0,'2025-12-15 05:11:37','2025-12-15 05:19:58','wipe-in','moviepy'),
(71,54,'video','portrait',NULL,3,'bg_video_1765795280.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795280.mp4',0,'2025-12-15 05:11:37','2025-12-15 05:19:58','spiral-in','moviepy'),
(72,54,'video','portrait',NULL,3,'bg_video_1765795287.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795287.mp4',0,'2025-12-15 05:11:37','2025-12-15 05:19:58','wipe-in','moviepy'),
(73,54,'video','portrait',NULL,3,'bg_video_1765795295.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795295.mp4',0,'2025-12-15 05:11:37','2025-12-15 05:19:58','bounce-in','moviepy'),
(74,55,'video','portrait',NULL,3,'bg_video_1765795323.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795323.mp4',0,'2025-12-15 05:12:54','2025-12-15 05:16:33','slide-in','moviepy'),
(75,55,'video','portrait',NULL,3,'bg_video_1765795339.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795339.mp4',0,'2025-12-15 05:12:54','2025-12-15 05:16:33','flip-in','moviepy'),
(76,55,'video','portrait',NULL,3,'bg_video_1765795346.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795346.mp4',0,'2025-12-15 05:12:54','2025-12-15 05:16:33','zoom-in','moviepy'),
(77,55,'video','portrait',NULL,3,'bg_video_1765795358.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795358.mp4',0,'2025-12-15 05:12:54','2025-12-15 05:16:33','curtain','moviepy'),
(78,55,'video','portrait',NULL,3,'bg_video_1765795368.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765795368.mp4',0,'2025-12-15 05:12:54','2025-12-15 05:16:33','bounce-in','moviepy'),
(79,56,'video','portrait',NULL,3,'bg_video_1765801890.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765801890.mp4',0,'2025-12-15 07:02:45','2025-12-15 07:28:57','wipe-in','moviepy'),
(80,56,'video','portrait',NULL,3,'bg_video_1765801904.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765801904.mp4',0,'2025-12-15 07:02:45','2025-12-15 07:28:57','fade-in','moviepy'),
(81,56,'video','portrait',NULL,3,'bg_video_1765801920.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765801920.mp4',0,'2025-12-15 07:02:45','2025-12-15 07:28:57','corner-wipe','moviepy'),
(82,56,'video','portrait',NULL,3,'bg_video_1765801945.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765801945.mp4',0,'2025-12-15 07:02:45','2025-12-15 07:28:57','flip-in','moviepy'),
(83,56,'video','portrait',NULL,3,'bg_video_1765801961.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765801961.mp4',0,'2025-12-15 07:02:45','2025-12-15 07:28:57','slide-in','moviepy'),
(84,57,'video','portrait',NULL,3,'bg_video_1765812136.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765812136.mp4',0,'2025-12-15 09:52:44','2025-12-15 09:53:32','wipe-in','moviepy'),
(85,57,'video','portrait',NULL,3,'bg_video_1765812148.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765812148.mp4',0,'2025-12-15 09:52:44','2025-12-15 09:53:32','wipe-in','moviepy'),
(86,57,'video','portrait',NULL,3,'bg_video_1765812162.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765812162.mp4',0,'2025-12-15 09:52:44','2025-12-15 09:53:32','flip-in','moviepy'),
(87,58,'video','portrait',NULL,3,'bg_video_1765812656.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765812656.mp4',0,'2025-12-15 10:01:13','2025-12-15 10:01:29','wipe-in','moviepy'),
(88,58,'video','portrait',NULL,3,'bg_video_1765812671.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765812671.mp4',0,'2025-12-15 10:01:13','2025-12-15 10:01:29','spiral-in','moviepy'),
(89,59,'video','portrait',NULL,3,'bg_video_1765812768.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765812768.mp4',0,'2025-12-15 10:03:28','2025-12-15 12:19:27','curtain','moviepy'),
(90,59,'video','portrait',NULL,3,'bg_video_1765812775.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765812775.mp4',0,'2025-12-15 10:03:28','2025-12-15 12:19:27','curtain','moviepy'),
(91,59,'video','portrait',NULL,3,'bg_video_1765812785.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765812785.mp4',0,'2025-12-15 10:03:28','2025-12-15 12:19:27','spiral-in','moviepy'),
(92,59,'video','portrait',NULL,3,'bg_video_1765812795.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765812795.mp4',0,'2025-12-15 10:03:28','2025-12-15 12:19:27','slide-in','moviepy'),
(93,59,'video','portrait',NULL,3,'bg_video_1765812804.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765812804.mp4',0,'2025-12-15 10:03:28','2025-12-15 12:19:27','bounce-in','moviepy'),
(94,60,'video','portrait',NULL,3,'bg_video_1765820578.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765820578.mp4',0,'2025-12-15 12:13:19','2025-12-15 12:13:36','fade-in','moviepy'),
(95,60,'video','portrait',NULL,3,'bg_video_1765820590.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765820590.mp4',0,'2025-12-15 12:13:19','2025-12-15 12:13:36','zoom-in','moviepy'),
(96,60,'video','portrait',NULL,3,'bg_video_1765820597.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765820597.mp4',0,'2025-12-15 12:13:19','2025-12-15 12:13:36','fade-in','moviepy'),
(97,61,'video','portrait',NULL,3,'bg_video_1765821329.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765821329.mp4',0,'2025-12-15 12:25:48','2025-12-15 12:26:03','wipe-in','moviepy'),
(98,61,'video','portrait',NULL,3,'bg_video_1765821338.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765821338.mp4',0,'2025-12-15 12:25:48','2025-12-15 12:26:03','slide-in','moviepy'),
(99,61,'video','portrait',NULL,3,'bg_video_1765821346.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765821346.mp4',0,'2025-12-15 12:25:48','2025-12-15 12:26:03','spiral-in','moviepy'),
(100,62,'video','portrait',NULL,3,'bg_video_1765821573.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765821573.mp4',0,'2025-12-15 12:29:52','2025-12-15 12:30:01','fade-in','moviepy'),
(101,62,'video','portrait',NULL,3,'bg_video_1765821590.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765821590.mp4',0,'2025-12-15 12:29:52','2025-12-15 12:30:01','zoom-in','moviepy'),
(102,63,'video','portrait',NULL,3,'bg_video_1765822274.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765822274.mp4',0,'2025-12-15 12:41:23','2025-12-15 12:41:31','wipe-in','moviepy'),
(103,63,'video','portrait',NULL,3,'bg_video_1765822281.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765822281.mp4',0,'2025-12-15 12:41:23','2025-12-15 12:41:31','zoom-in','moviepy'),
(104,64,'video','portrait',NULL,3,'bg_video_1765822352.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765822352.mp4',0,'2025-12-15 12:42:43','2025-12-15 12:42:51','wipe-in','moviepy'),
(105,64,'video','portrait',NULL,3,'bg_video_1765822361.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765822361.mp4',0,'2025-12-15 12:42:43','2025-12-15 12:42:51','zoom-in','moviepy'),
(106,65,'video','portrait',NULL,3,'bg_video_1765822448.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765822448.mp4',0,'2025-12-15 12:45:01','2025-12-15 12:45:39','fade-in','moviepy'),
(107,65,'video','portrait',NULL,3,'bg_video_1765822473.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765822473.mp4',0,'2025-12-15 12:45:01','2025-12-15 12:45:39','spiral-in','moviepy'),
(108,65,'video','portrait',NULL,3,'bg_video_1765822484.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765822484.mp4',0,'2025-12-15 12:45:01','2025-12-15 12:45:39','corner-wipe','moviepy'),
(109,65,'video','portrait',NULL,3,'bg_video_1765822499.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765822499.mp4',0,'2025-12-15 12:45:01','2025-12-15 12:45:39','curtain','moviepy'),
(110,66,'video','portrait',NULL,3,'bg_video_1765823247.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765823247.mp4',0,'2025-12-15 12:57:59','2025-12-15 12:58:12','slide-in','moviepy'),
(111,66,'video','portrait',NULL,3,'bg_video_1765823260.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765823260.mp4',0,'2025-12-15 12:57:59','2025-12-15 12:58:12','spiral-in','moviepy'),
(112,66,'video','portrait',NULL,3,'bg_video_1765823267.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765823267.mp4',0,'2025-12-15 12:57:59','2025-12-15 12:58:12','wipe-in','moviepy'),
(113,66,'video','portrait',NULL,3,'bg_video_1765823276.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1765823276.mp4',0,'2025-12-15 12:57:59','2025-12-15 12:58:12','corner-wipe','moviepy'),
(114,67,'video','landscape',NULL,4,'bg_video_1766047551.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1766047551.mp4',0,'2025-12-18 03:16:38','2025-12-18 03:16:51','fade-in','moviepy'),
(115,67,'video','landscape',NULL,4,'bg_video_1766047580.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1766047580.mp4',0,'2025-12-18 03:16:38','2025-12-18 03:16:51','slide-in','moviepy'),
(116,67,'video','landscape',NULL,4,'bg_video_1766047591.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1766047591.mp4',0,'2025-12-18 03:16:38','2025-12-18 03:16:51','flip-in','moviepy'),
(117,68,'video','portrait',NULL,3,'bg_video_1767024090.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767024090.mp4',0,'2025-12-29 10:31:39','2025-12-29 10:31:50','wipe-in','moviepy'),
(118,69,'video','landscape',NULL,6,'bg_video_1767026236.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767026236.mp4',0,'2025-12-29 11:07:21','2025-12-29 11:07:30','wipe-in','moviepy'),
(119,70,'video','landscape',NULL,6,'bg_video_1767100945.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767100945.mp4',0,'2025-12-30 07:52:28','2025-12-30 07:57:10','wipe-in','moviepy'),
(120,71,'video','landscape',NULL,6,'bg_video_1767102122.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767102122.mp4',0,'2025-12-30 08:12:05','2025-12-30 10:25:57','wipe-in','moviepy'),
(121,72,'video','landscape',NULL,6,'bg_video_1767102235.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767102235.mp4',0,'2025-12-30 08:13:57','2025-12-30 08:14:20','wipe-in','moviepy'),
(122,73,'video','landscape',NULL,4,'bg_video_1767102320.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767102320.mp4',0,'2025-12-30 08:15:23','2025-12-30 08:15:29','wipe-in','moviepy'),
(123,74,'video','landscape',NULL,6,'bg_video_1767105641.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767105641.mp4',0,'2025-12-30 09:10:46','2025-12-30 09:10:59','wipe-in','moviepy'),
(124,75,'video','landscape',NULL,6,'bg_video_1767111369.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767111369.mp4',0,'2025-12-30 10:46:11','2025-12-30 10:46:19','wipe-in','moviepy'),
(125,76,'video','landscape',NULL,6,'bg_video_1767277239.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767277239.mp4',0,'2026-01-01 08:50:44','2026-01-01 08:50:54','wipe-in','moviepy'),
(126,77,'video','landscape',NULL,6,'bg_video_1767290903.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767290903.mp4',0,'2026-01-01 12:38:25','2026-01-01 12:38:33','wipe-in','moviepy'),
(127,78,'video','landscape',NULL,6,'bg_video_1767291558.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767291558.mp4',0,'2026-01-01 12:49:20','2026-01-01 12:49:25','slide-in','moviepy'),
(128,79,'video','landscape',NULL,6,'bg_video_1767291681.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767291681.mp4',0,'2026-01-01 12:51:33','2026-01-01 12:51:59','wipe-in','moviepy'),
(129,80,'video','landscape',NULL,6,'bg_video_1767353016.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767353016.mp4',0,'2026-01-02 05:53:38','2026-01-02 05:54:02','wipe-in','moviepy'),
(130,81,'video','landscape',NULL,6,'bg_video_1767354551.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767354551.mp4',0,'2026-01-02 06:19:13','2026-01-02 06:22:59','wipe-in','moviepy'),
(131,82,'video','landscape',NULL,7,'bg_video_1767358332.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767358332.mp4',0,'2026-01-02 07:22:15','2026-01-02 07:22:25','wipe-in','moviepy'),
(132,83,'video','landscape',NULL,7,'bg_video_1767366240.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767366240.mp4',0,'2026-01-02 09:34:02','2026-01-02 09:34:14','bounce-in','moviepy'),
(133,84,'video','landscape',NULL,6,'bg_video_1767372288.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767372288.mp4',0,'2026-01-02 11:14:50','2026-01-02 12:01:22','wipe-in','moviepy'),
(134,85,'video','landscape',NULL,6,'bg_video_1767375071.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767375071.mp4',0,'2026-01-02 12:01:13','2026-01-02 12:01:20','wipe-in','moviepy'),
(135,86,'video','landscape',NULL,6,'bg_video_1767375205.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767375205.mp4',1,'2026-01-02 12:03:42','2026-01-02 12:03:49','wipe-in','moviepy'),
(136,86,'video','landscape',NULL,6,'bg_video_1767375220.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767375220.mp4',1,'2026-01-02 12:03:42','2026-01-02 12:03:49','wipe-in','moviepy'),
(137,87,'video','landscape',NULL,6,'bg_video_1767375457.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767375457.mp4',1,'2026-01-02 12:07:50','2026-01-02 12:08:00','wipe-in','moviepy'),
(138,87,'video','landscape',NULL,6,'bg_video_1767375468.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767375468.mp4',1,'2026-01-02 12:07:50','2026-01-02 12:08:00','wipe-in','moviepy'),
(139,88,'video','landscape',NULL,6,'bg_video_1767375788.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767375788.mp4',1,'2026-01-02 12:13:22','2026-01-02 12:13:37','wipe-in','moviepy'),
(140,88,'video','landscape',NULL,6,'bg_video_1767375800.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767375800.mp4',1,'2026-01-02 12:13:22','2026-01-02 12:13:37','wipe-in','moviepy'),
(141,89,'video','landscape',NULL,6,'bg_video_1767376093.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767376093.mp4',1,'2026-01-02 12:18:35','2026-01-02 12:18:46','wipe-in','moviepy'),
(142,89,'video','landscape',NULL,6,'bg_video_1767376112.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767376112.mp4',1,'2026-01-02 12:18:35','2026-01-02 12:18:46','flip-in','moviepy'),
(143,90,'video','landscape',NULL,6,'bg_video_1767377108.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767377108.mp4',0,'2026-01-02 12:35:32','2026-01-02 12:35:48','wipe-in','moviepy'),
(144,90,'video','landscape',NULL,6,'bg_video_1767377124.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767377124.mp4',0,'2026-01-02 12:35:32','2026-01-02 12:35:48','bounce-in','moviepy'),
(145,91,'video','landscape',NULL,6,'bg_video_1767377406.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767377406.mp4',0,'2026-01-02 12:40:31','2026-01-02 12:40:41','wipe-in','moviepy'),
(146,91,'video','landscape',NULL,6,'bg_video_1767377422.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767377422.mp4',0,'2026-01-02 12:40:31','2026-01-02 12:40:41','corner-wipe','moviepy'),
(147,92,'video','landscape',NULL,6,'bg_video_1767377568.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767377568.mp4',0,'2026-01-02 12:43:07','2026-01-02 12:43:14','corner-wipe','moviepy'),
(148,92,'video','landscape',NULL,6,'bg_video_1767377580.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767377580.mp4',0,'2026-01-02 12:43:07','2026-01-02 12:43:14','curtain','moviepy'),
(149,93,'video','landscape',NULL,6,'bg_video_1767378373.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767378373.mp4',0,'2026-01-02 12:56:39','2026-01-02 13:30:06','wipe-in','moviepy'),
(150,93,'video','landscape',NULL,6,'bg_video_1767378395.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767378395.mp4',0,'2026-01-02 12:56:40','2026-01-02 13:30:06','wipe-in','moviepy'),
(151,94,'video','landscape',NULL,6,'bg_video_1767380783.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767380783.mp4',0,'2026-01-02 13:36:37','2026-01-02 13:36:44','none','moviepy'),
(152,94,'video','landscape',NULL,6,'bg_video_1767380796.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767380796.mp4',0,'2026-01-02 13:36:37','2026-01-02 13:36:44','wipe-in','moviepy'),
(153,95,'video','landscape',NULL,6,'bg_video_1767381059.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767381059.mp4',0,'2026-01-02 13:41:10','2026-01-02 13:41:16','corner-wipe','moviepy'),
(154,95,'video','landscape',NULL,6,'bg_video_1767381069.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767381069.mp4',0,'2026-01-02 13:41:10','2026-01-02 13:41:16','wipe-in','moviepy'),
(155,96,'video','landscape',NULL,6,'bg_video_1767381490.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767381490.mp4',0,'2026-01-02 13:48:29','2026-01-02 13:48:37','fade-in','moviepy'),
(156,96,'video','landscape',NULL,6,'bg_video_1767381503.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767381503.mp4',0,'2026-01-02 13:48:29','2026-01-02 13:48:37','wipe-in','moviepy'),
(157,97,'video','landscape',NULL,6,'bg_video_1767381728.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767381728.mp4',0,'2026-01-02 13:52:25','2026-01-02 13:52:31','wipe-in','moviepy'),
(158,97,'video','landscape',NULL,6,'bg_video_1767381742.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767381742.mp4',0,'2026-01-02 13:52:25','2026-01-02 13:52:31','flip-in','moviepy'),
(159,98,'video','landscape',NULL,6,'bg_video_1767382419.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767382419.mp4',0,'2026-01-02 14:04:09','2026-01-02 14:04:20','wipe-in','moviepy'),
(160,98,'video','landscape',NULL,6,'bg_video_1767382447.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767382447.mp4',0,'2026-01-02 14:04:09','2026-01-02 14:04:20','flip-in','moviepy'),
(161,99,'video','landscape',NULL,6,'bg_video_1767386939.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767386939.mp4',0,'2026-01-02 15:19:38','2026-01-02 15:19:52','wipe-in','moviepy'),
(162,99,'video','landscape',NULL,6,'bg_video_1767386976.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767386976.mp4',0,'2026-01-02 15:19:38','2026-01-02 15:19:52','bounce-in','moviepy'),
(163,100,'video','landscape',NULL,6,'bg_video_1767387226.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767387226.mp4',0,'2026-01-02 15:24:00','2026-01-02 15:24:09','wipe-in','moviepy'),
(164,100,'video','landscape',NULL,6,'bg_video_1767387238.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767387238.mp4',0,'2026-01-02 15:24:00','2026-01-02 15:24:09','slide-in','moviepy'),
(165,101,'video','landscape',NULL,6,'bg_video_1767387886.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767387886.mp4',0,'2026-01-02 15:35:02','2026-01-02 15:35:09','wipe-in','moviepy'),
(166,101,'video','landscape',NULL,6,'bg_video_1767387899.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767387899.mp4',0,'2026-01-02 15:35:02','2026-01-02 15:35:09','blur-in','moviepy'),
(167,102,'video','landscape',NULL,6,'bg_video_1767387983.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767387983.mp4',1,'2026-01-02 15:36:37','2026-01-02 15:36:37','wipe-in','moviepy'),
(168,102,'video','landscape',NULL,6,'bg_video_1767387993.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767387993.mp4',1,'2026-01-02 15:36:37','2026-01-02 15:36:37','spiral-in','moviepy'),
(169,103,'video','landscape',NULL,6,'bg_video_1767388368.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767388368.mp4',0,'2026-01-02 15:42:50','2026-01-02 15:42:58','wipe-in','moviepy'),
(170,104,'video','landscape',NULL,6,'bg_video_1767388590.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767388590.mp4',0,'2026-01-02 15:46:31','2026-01-02 15:46:37','wipe-in','moviepy'),
(171,105,'video','landscape',NULL,6,'bg_video_1767388839.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767388839.mp4',0,'2026-01-02 15:50:52','2026-01-02 15:50:58','wipe-in','moviepy'),
(172,106,'video','landscape',NULL,6,'bg_video_1767389030.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767389030.mp4',0,'2026-01-02 15:53:52','2026-01-02 15:54:00','wipe-in','moviepy'),
(173,107,'video','landscape',NULL,6,'bg_video_1767389342.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767389342.mp4',0,'2026-01-02 15:59:04','2026-01-02 15:59:08','wipe-in','moviepy'),
(174,108,'video','landscape',NULL,6,'bg_video_1767389429.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767389429.mp4',0,'2026-01-02 16:00:43','2026-01-02 16:00:50','wipe-in','moviepy'),
(175,108,'video','landscape',NULL,6,'bg_video_1767389441.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767389441.mp4',0,'2026-01-02 16:00:43','2026-01-02 16:00:50','bounce-in','moviepy'),
(176,109,'video','landscape',NULL,6,'bg_video_1767389633.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767389633.mp4',0,'2026-01-02 16:04:46','2026-01-02 16:04:54','wipe-in','moviepy'),
(177,109,'video','landscape',NULL,6,'bg_video_1767389643.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767389643.mp4',0,'2026-01-02 16:04:46','2026-01-02 16:04:54','wipe-in','moviepy'),
(178,109,'video','landscape',NULL,6,'bg_video_1767389662.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767389662.mp4',0,'2026-01-02 16:04:46','2026-01-02 16:04:54','wipe-in','moviepy'),
(179,109,'video','landscape',NULL,6,'bg_video_1767389673.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767389673.mp4',0,'2026-01-02 16:04:46','2026-01-02 16:04:55','curtain','moviepy'),
(180,109,'video','landscape',NULL,6,'bg_video_1767389684.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767389684.mp4',0,'2026-01-02 16:04:46','2026-01-02 16:04:55','bounce-in','moviepy'),
(181,110,'video','landscape',NULL,6,'bg_video_1767390280.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767390280.mp4',0,'2026-01-02 16:15:19','2026-01-02 16:16:07','spiral-in','moviepy'),
(182,110,'video','landscape',NULL,6,'bg_video_1767390291.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767390291.mp4',0,'2026-01-02 16:15:19','2026-01-02 16:16:07','flip-in','moviepy'),
(183,110,'video','landscape',NULL,6,'bg_video_1767390301.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767390301.mp4',0,'2026-01-02 16:15:19','2026-01-02 16:16:07','wipe-in','moviepy'),
(184,110,'video','landscape',NULL,6,'bg_video_1767390312.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767390312.mp4',0,'2026-01-02 16:15:19','2026-01-02 16:16:07','wipe-in','moviepy'),
(185,111,'video','landscape',NULL,6,'bg_video_1767391062.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767391062.mp4',0,'2026-01-02 16:27:51','2026-01-02 16:27:58','wipe-in','moviepy'),
(186,112,'video','landscape',NULL,6,'bg_video_1767419882.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767419882.mp4',0,'2026-01-03 00:28:05','2026-01-03 00:39:16','wipe-in','moviepy'),
(187,113,'video','landscape',NULL,7,'bg_video_1767421548.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767421548.mp4',0,'2026-01-03 00:55:52','2026-01-03 00:56:03','wipe-in','moviepy'),
(188,114,'video','landscape',NULL,6,'bg_video_1767421854.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767421854.mp4',0,'2026-01-03 01:02:05','2026-01-03 01:02:18','wipe-in','moviepy'),
(189,115,'video','landscape',NULL,6,'bg_video_1767460535.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767460535.mp4',0,'2026-01-03 11:45:39','2026-01-03 11:45:48','bounce-in','moviepy'),
(190,116,'video','landscape',NULL,6,'bg_video_1767460949.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767460949.mp4',0,'2026-01-03 11:52:32','2026-01-03 11:52:39','curtain','moviepy'),
(191,117,'video','landscape',NULL,6,'bg_video_1767461012.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767461012.mp4',0,'2026-01-03 11:53:34','2026-01-03 11:53:40','curtain','moviepy'),
(192,118,'video','landscape',NULL,6,'bg_video_1767461151.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767461151.mp4',0,'2026-01-03 11:55:57','2026-01-03 11:56:03','curtain','moviepy'),
(193,119,'video','landscape',NULL,6,'bg_video_1767462377.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767462377.mp4',0,'2026-01-03 12:16:22','2026-01-03 12:16:29','curtain','moviepy'),
(194,120,'video','landscape',NULL,6,'bg_video_1767462565.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767462565.mp4',0,'2026-01-03 12:19:28','2026-01-03 12:19:34','curtain','moviepy'),
(195,121,'video','landscape',NULL,6,'bg_video_1767463237.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767463237.mp4',0,'2026-01-03 12:30:39','2026-01-03 12:30:45','curtain','moviepy'),
(196,122,'video','landscape',NULL,6,'bg_video_1767463587.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767463587.mp4',0,'2026-01-03 12:36:29','2026-01-03 12:36:36','curtain','moviepy'),
(197,123,'video','landscape',NULL,6,'bg_video_1767465349.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767465349.mp4',0,'2026-01-03 13:05:50','2026-01-03 13:05:56','curtain','moviepy'),
(198,124,'video','landscape',NULL,6,'bg_video_1767465457.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767465457.mp4',0,'2026-01-03 13:07:39','2026-01-03 13:07:46','wipe-in','moviepy'),
(199,125,'video','landscape',NULL,6,'bg_video_1767465596.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767465596.mp4',0,'2026-01-03 13:09:58','2026-01-03 13:10:06','wipe-in','moviepy'),
(200,126,'video','landscape',NULL,6,'bg_video_1767465945.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767465945.mp4',0,'2026-01-03 13:15:48','2026-01-03 13:16:42','wipe-in','moviepy'),
(201,127,'video','landscape',NULL,6,'bg_video_1767466182.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767466182.mp4',0,'2026-01-03 13:19:44','2026-01-03 13:19:51','wipe-in','moviepy'),
(202,128,'video','landscape',NULL,6,'bg_video_1767466293.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767466293.mp4',0,'2026-01-03 13:21:35','2026-01-03 13:21:46','wipe-in','moviepy'),
(203,129,'video','landscape',NULL,6,'bg_video_1767806875.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767806875.mp4',0,'2026-01-07 11:58:03','2026-01-07 11:58:25','spiral-in','ffmpeg'),
(204,130,'video','landscape',NULL,6,'bg_video_1767807145.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767807145.mp4',0,'2026-01-07 12:02:27','2026-01-07 12:02:32','wipe-in','ffmpeg'),
(205,131,'video','landscape',NULL,6,'bg_video_1767807720.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767807720.mp4',0,'2026-01-07 12:12:02','2026-01-07 12:12:17','spiral-in','ffmpeg'),
(206,132,'video','landscape',NULL,6,'bg_video_1767808027.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767808027.mp4',0,'2026-01-07 12:17:09','2026-01-07 12:17:13','spiral-in','ffmpeg'),
(207,133,'video','landscape',NULL,6,'bg_video_1767808679.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767808679.mp4',0,'2026-01-07 12:28:01','2026-01-07 12:28:09','spiral-in','ffmpeg'),
(208,134,'video','landscape',NULL,6,'bg_video_1767808754.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767808754.mp4',0,'2026-01-07 12:29:16','2026-01-07 12:29:22','spiral-in','ffmpeg'),
(209,135,'video','landscape',NULL,6,'bg_video_1767810069.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767810069.mp4',0,'2026-01-07 12:51:13','2026-01-07 12:51:19','spiral-in','ffmpeg'),
(210,136,'video','landscape',NULL,6,'bg_video_1767872376.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767872376.mp4',0,'2026-01-08 06:10:20','2026-01-08 06:10:26','spin-reveal','ffmpeg'),
(211,136,'video','landscape',NULL,6,'bg_video_1767872418.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767872418.mp4',0,'2026-01-08 06:10:20','2026-01-08 06:10:26','curtain','moviepy'),
(212,137,'video','landscape',NULL,6,'bg_video_1767873195.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767873195.mp4',0,'2026-01-08 06:23:31','2026-01-08 06:24:04','curtain','moviepy'),
(213,137,'video','landscape',NULL,6,'bg_video_1767873207.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767873207.mp4',0,'2026-01-08 06:23:31','2026-01-08 06:24:04','spin-reveal','ffmpeg'),
(214,138,'video','landscape',NULL,6,'bg_video_1767957371.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767957371.mp4',0,'2026-01-09 05:46:25','2026-01-09 05:47:06','spin-reveal','ffmpeg'),
(215,139,'video','landscape',NULL,6,'bg_video_1767958130.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767958130.mp4',0,'2026-01-09 05:58:51','2026-01-09 06:13:44','spin-reveal','ffmpeg'),
(216,140,'video','landscape',NULL,6,'bg_video_1767958619.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767958619.mp4',1,'2026-01-09 06:07:00','2026-01-09 13:55:56','spin-reveal','ffmpeg'),
(217,141,'video','landscape',NULL,6,'bg_video_1767958922.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767958922.mp4',0,'2026-01-09 06:12:03','2026-01-09 06:13:44','spin-reveal','ffmpeg'),
(218,142,'video','landscape',NULL,6,'bg_video_1767978355.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767978355.mp4',1,'2026-01-09 11:49:06','2026-01-09 11:49:06','spin-reveal','ffmpeg'),
(219,142,'video','landscape',NULL,6,'bg_video_1767979141.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767979141.mp4',1,'2026-01-09 11:49:06','2026-01-09 11:49:06','spin-reveal','ffmpeg'),
(220,143,'video','landscape',NULL,6,'bg_video_1767979572.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767979572.mp4',0,'2026-01-09 11:56:13','2026-01-09 11:56:18','spin-reveal','ffmpeg'),
(221,144,'video','landscape',NULL,6,'bg_video_1767979869.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767979869.mp4',0,'2026-01-09 12:01:15','2026-01-09 12:01:22','spin-reveal','ffmpeg'),
(222,145,'video','landscape',NULL,6,'bg_video_1767980405.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767980405.mp4',0,'2026-01-09 12:10:06','2026-01-09 12:10:12','spin-reveal','ffmpeg'),
(223,146,'video','landscape',NULL,6,'bg_video_1767981755.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767981755.mp4',0,'2026-01-09 12:32:37','2026-01-09 12:32:50','spin-reveal','ffmpeg'),
(224,147,'video','landscape',NULL,6,'bg_video_1767981882.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767981882.mp4',0,'2026-01-09 12:34:44','2026-01-09 12:34:50','spin-reveal','ffmpeg'),
(225,148,'video','landscape',NULL,6,'bg_video_1767982001.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767982001.mp4',0,'2026-01-09 12:36:43','2026-01-09 12:45:35','spin-reveal','ffmpeg'),
(226,149,'video','landscape',NULL,6,'bg_video_1767982138.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767982138.mp4',0,'2026-01-09 12:38:59','2026-01-09 12:44:59','spin-reveal','ffmpeg'),
(227,150,'video','landscape',NULL,6,'bg_video_1767982993.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767982993.mp4',0,'2026-01-09 12:53:20','2026-01-09 12:53:25','spin-reveal','ffmpeg'),
(228,151,'video','landscape',NULL,6,'bg_video_1767983202.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767983202.mp4',0,'2026-01-09 12:56:45','2026-01-09 12:56:53','spin-reveal','ffmpeg'),
(229,152,'video','landscape',NULL,6,'bg_video_1767983551.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767983551.mp4',0,'2026-01-09 13:02:34','2026-01-09 13:02:40','spin-reveal','ffmpeg'),
(230,153,'video','landscape',NULL,6,'bg_video_1767983645.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767983645.mp4',0,'2026-01-09 13:04:07','2026-01-09 13:04:43','spin-reveal','ffmpeg'),
(231,154,'video','landscape',NULL,6,'bg_video_1767983723.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767983723.mp4',0,'2026-01-09 13:06:05','2026-01-09 13:06:13','spin-reveal','ffmpeg'),
(232,155,'video','landscape',NULL,6,'bg_video_1767983810.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767983810.mp4',0,'2026-01-09 13:06:51','2026-01-09 13:06:56','spin-reveal','ffmpeg'),
(233,156,'video','landscape',NULL,6,'bg_video_1767984090.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767984090.mp4',0,'2026-01-09 13:13:18','2026-01-09 13:13:23','spin-reveal','ffmpeg'),
(234,156,'video','landscape',NULL,6,'bg_video_1767984110.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767984110.mp4',0,'2026-01-09 13:13:18','2026-01-09 13:13:23','elastic-scale','ffmpeg'),
(235,156,'video','landscape',NULL,6,'bg_video_1767984122.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767984122.mp4',0,'2026-01-09 13:13:18','2026-01-09 13:13:23','flip-vertical','ffmpeg'),
(236,156,'video','landscape',NULL,6,'bg_video_1767984139.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767984139.mp4',0,'2026-01-09 13:13:18','2026-01-09 13:13:23','bounce-slide','ffmpeg'),
(237,156,'video','landscape',NULL,6,'bg_video_1767984164.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767984164.mp4',0,'2026-01-09 13:13:18','2026-01-09 13:13:23','bounce-drop','ffmpeg'),
(238,156,'video','landscape',NULL,6,'bg_video_1767984189.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767984189.mp4',0,'2026-01-09 13:13:18','2026-01-09 13:13:23','flip-in','ffmpeg'),
(239,157,'video','landscape',NULL,6,'bg_video_1767984861.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767984861.mp4',0,'2026-01-09 13:25:07','2026-01-09 13:26:45','elastic-scale','ffmpeg'),
(240,157,'video','landscape',NULL,6,'bg_video_1767984885.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767984885.mp4',0,'2026-01-09 13:25:07','2026-01-09 13:26:45','flip-vertical','ffmpeg'),
(241,157,'video','landscape',NULL,6,'bg_video_1767984905.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767984905.mp4',0,'2026-01-09 13:25:07','2026-01-09 13:26:45','bounce-slide','ffmpeg'),
(242,158,'video','landscape',NULL,6,'bg_video_1767985235.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985235.mp4',0,'2026-01-09 13:31:51','2026-01-09 13:31:55','spin-reveal','ffmpeg'),
(243,158,'video','landscape',NULL,6,'bg_video_1767985250.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985250.mp4',0,'2026-01-09 13:31:51','2026-01-09 13:31:55','elastic-scale','ffmpeg'),
(244,158,'video','landscape',NULL,6,'bg_video_1767985268.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985268.mp4',0,'2026-01-09 13:31:51','2026-01-09 13:31:55','bounce-slide','ffmpeg'),
(245,158,'video','landscape',NULL,6,'bg_video_1767985282.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985282.mp4',0,'2026-01-09 13:31:51','2026-01-09 13:31:55','bounce-in','ffmpeg'),
(246,158,'video','landscape',NULL,6,'bg_video_1767985296.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985296.mp4',0,'2026-01-09 13:31:51','2026-01-09 13:31:55','bounce-drop','ffmpeg'),
(247,158,'video','landscape',NULL,6,'bg_video_1767985309.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985309.mp4',0,'2026-01-09 13:31:51','2026-01-09 13:31:55','zoom-in','ffmpeg'),
(248,159,'video','landscape',NULL,6,'bg_video_1767985775.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985775.mp4',0,'2026-01-09 13:42:09','2026-01-09 13:42:17','elastic-scale','ffmpeg'),
(249,159,'video','landscape',NULL,6,'bg_video_1767985785.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985785.mp4',0,'2026-01-09 13:42:09','2026-01-09 13:42:17','bounce-slide','ffmpeg'),
(250,159,'video','landscape',NULL,6,'bg_video_1767985802.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985802.mp4',0,'2026-01-09 13:42:09','2026-01-09 13:42:17','flip-in','ffmpeg'),
(251,159,'video','landscape',NULL,6,'bg_video_1767985834.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985834.mp4',0,'2026-01-09 13:42:09','2026-01-09 13:42:17','flip-vertical','ffmpeg'),
(252,159,'video','landscape',NULL,6,'bg_video_1767985855.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985855.mp4',0,'2026-01-09 13:42:09','2026-01-09 13:42:17','bounce-drop','ffmpeg'),
(253,159,'video','landscape',NULL,6,'bg_video_1767985874.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985874.mp4',0,'2026-01-09 13:42:09','2026-01-09 13:42:17','bounce-slide','ffmpeg'),
(254,159,'video','landscape',NULL,6,'bg_video_1767985890.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985890.mp4',0,'2026-01-09 13:42:09','2026-01-09 13:42:17','bounce-in','ffmpeg'),
(255,159,'video','landscape',NULL,6,'bg_video_1767985923.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985923.mp4',0,'2026-01-09 13:42:09','2026-01-09 13:42:17','slide-in','ffmpeg'),
(256,160,'video','landscape',NULL,6,'bg_video_1767985968.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767985968.mp4',0,'2026-01-09 13:42:49','2026-01-09 13:42:54','zoom-in','ffmpeg'),
(257,161,'video','landscape',NULL,6,'bg_video_1767986190.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767986190.mp4',0,'2026-01-09 13:48:55','2026-01-09 13:49:00','spin-reveal','ffmpeg'),
(258,161,'video','landscape',NULL,6,'bg_video_1767986211.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767986211.mp4',0,'2026-01-09 13:48:55','2026-01-09 13:49:00','flip-vertical','ffmpeg'),
(259,161,'video','landscape',NULL,6,'bg_video_1767986227.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767986227.mp4',0,'2026-01-09 13:48:55','2026-01-09 13:49:00','bounce-slide','ffmpeg'),
(260,161,'video','landscape',NULL,6,'bg_video_1767986246.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767986246.mp4',0,'2026-01-09 13:48:55','2026-01-09 13:49:00','flip-vertical','ffmpeg'),
(261,161,'video','landscape',NULL,6,'bg_video_1767986264.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767986264.mp4',0,'2026-01-09 13:48:55','2026-01-09 13:49:00','zoom-in','ffmpeg'),
(262,161,'video','landscape',NULL,6,'bg_video_1767986281.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767986281.mp4',0,'2026-01-09 13:48:55','2026-01-09 13:49:00','zoom-in','ffmpeg'),
(263,161,'video','landscape',NULL,6,'bg_video_1767986301.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767986301.mp4',0,'2026-01-09 13:48:55','2026-01-09 13:49:00','bounce-in','ffmpeg'),
(264,161,'video','landscape',NULL,6,'bg_video_1767986321.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767986321.mp4',0,'2026-01-09 13:48:55','2026-01-09 13:49:00','slide-in','ffmpeg'),
(265,162,'video','landscape',NULL,6,'bg_video_1767987531.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767987531.mp4',0,'2026-01-09 14:09:27','2026-01-09 14:09:39','fade-in','ffmpeg'),
(266,162,'video','landscape',NULL,6,'bg_video_1767987541.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767987541.mp4',0,'2026-01-09 14:09:27','2026-01-09 14:09:39','flip-in','ffmpeg'),
(267,162,'video','landscape',NULL,6,'bg_video_1767987551.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767987551.mp4',0,'2026-01-09 14:09:27','2026-01-09 14:09:39','zoom-in','ffmpeg'),
(268,162,'video','landscape',NULL,6,'bg_video_1767987565.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767987565.mp4',0,'2026-01-09 14:09:27','2026-01-09 14:09:39','bounce-in','ffmpeg'),
(269,163,'video','landscape',NULL,6,'bg_video_1767987639.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767987639.mp4',0,'2026-01-09 14:14:03','2026-01-09 14:14:09','bounce-slide','ffmpeg'),
(270,163,'video','landscape',NULL,6,'bg_video_1767987697.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767987697.mp4',0,'2026-01-09 14:14:03','2026-01-09 14:14:09','bounce-slide','ffmpeg'),
(271,163,'video','landscape',NULL,6,'bg_video_1767987710.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767987710.mp4',0,'2026-01-09 14:14:03','2026-01-09 14:14:09','spin-reveal','ffmpeg'),
(272,163,'video','landscape',NULL,6,'bg_video_1767987807.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767987807.mp4',0,'2026-01-09 14:14:03','2026-01-09 14:14:09','fade-in','ffmpeg'),
(273,163,'video','landscape',NULL,6,'bg_video_1767987821.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767987821.mp4',0,'2026-01-09 14:14:03','2026-01-09 14:14:09','flip-vertical','ffmpeg'),
(274,163,'video','landscape',NULL,6,'bg_video_1767987839.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767987839.mp4',0,'2026-01-09 14:14:03','2026-01-09 14:14:09','bounce-drop','ffmpeg'),
(275,164,'video','landscape',NULL,6,'bg_video_1767988195.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988195.mp4',0,'2026-01-09 14:21:35','2026-01-09 14:21:40','flip-in','ffmpeg'),
(276,164,'video','landscape',NULL,6,'bg_video_1767988211.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988211.mp4',0,'2026-01-09 14:21:35','2026-01-09 14:21:40','bounce-drop','ffmpeg'),
(277,164,'video','landscape',NULL,6,'bg_video_1767988227.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988227.mp4',0,'2026-01-09 14:21:35','2026-01-09 14:21:40','bounce-in','ffmpeg'),
(278,164,'video','landscape',NULL,6,'bg_video_1767988242.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988242.mp4',0,'2026-01-09 14:21:35','2026-01-09 14:21:40','flip-in','ffmpeg'),
(279,164,'video','landscape',NULL,6,'bg_video_1767988260.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988260.mp4',0,'2026-01-09 14:21:35','2026-01-09 14:21:40','bounce-drop','ffmpeg'),
(280,164,'video','landscape',NULL,6,'bg_video_1767988274.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988274.mp4',0,'2026-01-09 14:21:35','2026-01-09 14:21:40','flip-vertical','ffmpeg'),
(281,164,'video','landscape',NULL,6,'bg_video_1767988293.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988293.mp4',0,'2026-01-09 14:21:35','2026-01-09 14:21:40','spin-reveal','ffmpeg'),
(282,165,'video','landscape',NULL,6,'bg_video_1767988514.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988514.mp4',0,'2026-01-09 14:27:24','2026-01-09 14:27:30','zoom-in','ffmpeg'),
(283,165,'video','landscape',NULL,6,'bg_video_1767988525.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988525.mp4',0,'2026-01-09 14:27:24','2026-01-09 14:27:30','bounce-in','ffmpeg'),
(284,165,'video','landscape',NULL,6,'bg_video_1767988548.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988548.mp4',0,'2026-01-09 14:27:24','2026-01-09 14:27:30','fade-in','ffmpeg'),
(285,165,'video','landscape',NULL,6,'bg_video_1767988562.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988562.mp4',0,'2026-01-09 14:27:24','2026-01-09 14:27:30','zoom-in','ffmpeg'),
(286,165,'video','landscape',NULL,6,'bg_video_1767988612.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988612.mp4',0,'2026-01-09 14:27:24','2026-01-09 14:27:30','slide-in','ffmpeg'),
(287,165,'video','landscape',NULL,6,'bg_video_1767988640.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767988640.mp4',0,'2026-01-09 14:27:24','2026-01-09 14:27:30','bounce-in','ffmpeg'),
(288,166,'video','landscape',NULL,6,'bg_video_1767990179.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990179.mp4',0,'2026-01-09 14:54:35','2026-01-09 14:54:41','fade-in','ffmpeg'),
(289,166,'video','landscape',NULL,6,'bg_video_1767990196.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990196.mp4',0,'2026-01-09 14:54:35','2026-01-09 14:54:41','spin-reveal','ffmpeg'),
(290,166,'video','landscape',NULL,6,'bg_video_1767990203.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990203.mp4',0,'2026-01-09 14:54:35','2026-01-09 14:54:41','flip-vertical','moviepy'),
(291,166,'video','landscape',NULL,6,'bg_video_1767990214.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990214.mp4',0,'2026-01-09 14:54:35','2026-01-09 14:54:41','elastic-scale','ffmpeg'),
(292,166,'video','landscape',NULL,6,'bg_video_1767990225.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990225.mp4',0,'2026-01-09 14:54:35','2026-01-09 14:54:41','zoom-in','ffmpeg'),
(293,166,'video','landscape',NULL,6,'bg_video_1767990235.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990235.mp4',0,'2026-01-09 14:54:35','2026-01-09 14:54:41','bounce-in','ffmpeg'),
(294,166,'video','landscape',NULL,6,'bg_video_1767990244.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990244.mp4',0,'2026-01-09 14:54:35','2026-01-09 14:54:41','bounce-in','ffmpeg'),
(295,166,'video','landscape',NULL,6,'bg_video_1767990256.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990256.mp4',0,'2026-01-09 14:54:35','2026-01-09 14:54:41','slide-in','ffmpeg'),
(296,166,'video','landscape',NULL,6,'bg_video_1767990271.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990271.mp4',0,'2026-01-09 14:54:35','2026-01-09 14:54:41','bounce-drop','ffmpeg'),
(297,167,'video','landscape',NULL,6,'bg_video_1767990634.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990634.mp4',1,'2026-01-09 15:02:54','2026-01-09 15:02:54','elastic-scale','ffmpeg'),
(298,167,'video','landscape',NULL,6,'bg_video_1767990703.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990703.mp4',0,'2026-01-09 15:02:54','2026-01-09 15:02:59','zoom-in','ffmpeg'),
(299,167,'video','landscape',NULL,6,'bg_video_1767990713.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990713.mp4',0,'2026-01-09 15:02:54','2026-01-09 15:02:59','zoom-in','ffmpeg'),
(300,167,'video','landscape',NULL,6,'bg_video_1767990723.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990723.mp4',0,'2026-01-09 15:02:54','2026-01-09 15:02:59','bounce-in','ffmpeg'),
(301,167,'video','landscape',NULL,6,'bg_video_1767990733.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990733.mp4',0,'2026-01-09 15:02:54','2026-01-09 15:02:59','bounce-in','ffmpeg'),
(302,167,'video','landscape',NULL,6,'bg_video_1767990744.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990744.mp4',0,'2026-01-09 15:02:54','2026-01-09 15:02:59','flip-vertical','ffmpeg'),
(303,167,'video','landscape',NULL,6,'bg_video_1767990754.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990754.mp4',0,'2026-01-09 15:02:54','2026-01-09 15:02:59','slide-in','moviepy'),
(304,167,'video','landscape',NULL,6,'bg_video_1767990763.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767990763.mp4',0,'2026-01-09 15:02:54','2026-01-09 15:02:59','bounce-in','ffmpeg'),
(305,168,'video','landscape',NULL,6,'bg_video_1767993979.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767993979.mp4',0,'2026-01-09 15:56:21','2026-01-09 15:56:26','slide-in','moviepy'),
(306,169,'video','landscape',NULL,6,'bg_video_1767994890.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767994890.mp4',0,'2026-01-09 16:12:01','2026-01-09 16:12:09','fade-in','moviepy'),
(307,169,'video','landscape',NULL,6,'bg_video_1767994908.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1767994908.mp4',0,'2026-01-09 16:12:01','2026-01-09 16:12:09','spin-reveal','ffmpeg'),
(308,170,'video','landscape',NULL,6,'bg_video_1768047092.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1768047092.mp4',0,'2026-01-10 06:41:41','2026-01-10 07:04:55','curtain','moviepy'),
(309,171,'video','landscape',NULL,6,'bg_video_1768047246.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1768047246.mp4',0,'2026-01-10 06:44:37','2026-01-10 06:44:48','fade-in','ffmpeg'),
(310,171,'video','landscape',NULL,6,'bg_video_1768047267.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1768047267.mp4',0,'2026-01-10 06:44:37','2026-01-10 06:44:48','spin-reveal','ffmpeg'),
(311,172,'video','landscape',NULL,6,'bg_video_1768047789.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1768047789.mp4',0,'2026-01-10 06:53:46','2026-01-10 06:53:53','spin-reveal','ffmpeg'),
(312,172,'video','landscape',NULL,6,'bg_video_1768047803.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1768047803.mp4',0,'2026-01-10 06:53:46','2026-01-10 06:53:53','bounce-slide','ffmpeg'),
(313,172,'video','landscape',NULL,6,'bg_video_1768047823.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1768047823.mp4',0,'2026-01-10 06:53:46','2026-01-10 06:53:53','elastic-scale','ffmpeg'),
(314,173,'video','landscape',NULL,6,'bg_video_1768048561.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1768048561.mp4',0,'2026-01-10 07:06:21','2026-01-10 07:06:28','spin-reveal','ffmpeg'),
(315,173,'video','landscape',NULL,6,'bg_video_1768048577.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1768048577.mp4',0,'2026-01-10 07:06:21','2026-01-10 07:06:28','flip-vertical','ffmpeg'),
(316,174,'video','landscape',NULL,6,'bg_video_1768049412.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1768049412.mp4',0,'2026-01-10 07:20:57','2026-01-10 07:21:54','spin-reveal','ffmpeg'),
(317,174,'video','landscape',NULL,6,'bg_video_1768049428.mp4',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/background_video/bg_video_1768049428.mp4',0,'2026-01-10 07:20:57','2026-01-10 07:21:54','elastic-scale','ffmpeg'),
(318,175,'image',NULL,NULL,5,'bg_1768049832.jpg',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg_1768049832.jpg',0,'2026-01-10 07:27:40','2026-01-10 07:27:55','wipe-in','moviepy'),
(319,175,'image',NULL,NULL,4,'bg_1768049858.jpg',NULL,NULL,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg_1768049858.jpg',0,'2026-01-10 07:27:40','2026-01-10 07:27:55','wipe-in','moviepy');
/*!40000 ALTER TABLE `before_genration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT  IGNORE INTO `customers` VALUES
(1,'A',NULL,NULL,'A',NULL,NULL,'2025-12-10 12:34:46','2025-12-10 12:34:46'),
(2,'sp',NULL,NULL,'Sp',NULL,NULL,'2025-12-10 15:04:46','2025-12-10 15:04:46'),
(3,'A01 KHALID JI BJP CHANDNI CHOWK',NULL,NULL,'A01 KHALID JI BJP CHANDNI CHOWK',NULL,NULL,'2025-12-11 06:17:24','2025-12-11 06:17:24'),
(4,'B47 GYANENDRA BHARDWAJ BJP FDB',NULL,NULL,'B47 GYANENDRA BHARDWAJ BJP FDB',NULL,NULL,'2025-12-18 03:13:14','2025-12-18 03:13:14'),
(6,'yuvraj arora',NULL,NULL,'YA',NULL,NULL,'2025-12-29 11:02:05','2025-12-29 11:02:05'),
(7,'YA2',NULL,NULL,'YA2',NULL,NULL,'2026-01-01 08:37:46','2026-01-01 08:37:46'),
(8,'uva creation',NULL,NULL,'UVA CREATION',NULL,NULL,'2026-01-02 07:19:43','2026-01-02 07:19:43');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `errorlogs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `errorlogs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `errorlogs`
--

LOCK TABLES `errorlogs` WRITE;
/*!40000 ALTER TABLE `errorlogs` DISABLE KEYS */;
INSERT  IGNORE INTO `errorlogs` VALUES
(1,NULL,'Template Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.logs\' doesn\'t exist (Connection: mysql, SQL: insert into `logs` (`task_id`, `status`, `message`, `updated_at`, `created_at`) values (1, success, Template created successfully, 2025-12-10 16:01:22, 2025-12-10 16:01:22))','2025-12-10 10:31:22','2025-12-10 10:31:22'),
(2,NULL,'Template Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.logs\' doesn\'t exist (Connection: mysql, SQL: insert into `logs` (`task_id`, `status`, `message`, `updated_at`, `created_at`) values (2, success, Template created successfully, 2025-12-10 16:01:59, 2025-12-10 16:01:59))','2025-12-10 10:31:59','2025-12-10 10:31:59'),
(3,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:16','2025-12-10 10:34:16'),
(4,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:19','2025-12-10 10:34:19'),
(5,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:21','2025-12-10 10:34:21'),
(6,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:21','2025-12-10 10:34:21'),
(7,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:21','2025-12-10 10:34:21'),
(8,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:21','2025-12-10 10:34:21'),
(9,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:21','2025-12-10 10:34:21'),
(10,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:22','2025-12-10 10:34:22'),
(11,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:40','2025-12-10 10:34:40'),
(12,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:44','2025-12-10 10:34:44'),
(13,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:45','2025-12-10 10:34:45'),
(14,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:45','2025-12-10 10:34:45'),
(15,NULL,'Task Creation','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'laravel.tempgeneration\' doesn\'t exist (Connection: mysql, SQL: select * from `tempgeneration`)','2025-12-10 10:34:45','2025-12-10 10:34:45'),
(16,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:37:44','2025-12-10 10:37:44'),
(17,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:38:49','2025-12-10 10:38:49'),
(18,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:40:46','2025-12-10 10:40:46'),
(19,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:41:32','2025-12-10 10:41:32'),
(20,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:41:46','2025-12-10 10:41:46'),
(21,NULL,'Task Creation','No data found in Tempstore','2025-12-10 10:43:22','2025-12-10 10:43:22'),
(22,NULL,'Task Creation','SQLSTATE[42S22]: Column not found: 1054 Unknown column \'backgroundpath\' in \'field list\' (Connection: mysql, SQL: insert into `before_genration` (`mastertemplateid`, `backgroundimage`, `backgroundpath`, `taskid`, `updated_at`, `created_at`) values (1, bg1765389075.jpg, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg1765389075.jpg, 1, 2025-12-10 17:51:18, 2025-12-10 17:51:18))','2025-12-10 12:21:18','2025-12-10 12:21:18'),
(23,NULL,'Customer Creation','SQLSTATE[42S22]: Column not found: 1054 Unknown column \'whatsappgroup\' in \'where clause\' (Connection: mysql, SQL: select * from `customers` where `name` = 1 and `whatsappgroup` = A limit 1)','2025-12-10 12:24:39','2025-12-10 12:24:39'),
(24,NULL,'Customer Creation','SQLSTATE[42S22]: Column not found: 1054 Unknown column \'whatsappgroup\' in \'where clause\' (Connection: mysql, SQL: select * from `customers` where `name` = A and `whatsappgroup` = A limit 1)','2025-12-10 12:25:23','2025-12-10 12:25:23'),
(25,NULL,'Customer Creation','SQLSTATE[HY000]: General error: 1364 Field \'email\' doesn\'t have a default value (Connection: mysql, SQL: insert into `customers` (`name`, `whatsappgroup`, `updated_at`, `created_at`) values (A, A, 2025-12-10 18:00:21, 2025-12-10 18:00:21))','2025-12-10 12:30:21','2025-12-10 12:30:21'),
(26,NULL,'Customer Creation','SQLSTATE[HY000]: General error: 1364 Field \'email\' doesn\'t have a default value (Connection: mysql, SQL: insert into `customers` (`name`, `whatsappgroup`, `updated_at`, `created_at`) values (A, A, 2025-12-10 18:02:11, 2025-12-10 18:02:11))','2025-12-10 12:32:11','2025-12-10 12:32:11'),
(27,NULL,'Customer Creation','SQLSTATE[HY000]: General error: 1364 Field \'email\' doesn\'t have a default value (Connection: mysql, SQL: insert into `customers` (`name`, `whatsappgroup`, `updated_at`, `created_at`) values (A, A, 2025-12-10 18:02:29, 2025-12-10 18:02:29))','2025-12-10 12:32:29','2025-12-10 12:32:29'),
(28,NULL,'Customer Template Creation/Update','SQLSTATE[22001]: String data, right truncated: 1406 Data too long for column \'template_path\' at row 1 (Connection: mysql, SQL: insert into `templates_by_user` (`master_template_id`, `customer_id`, `customer_template`, `template_path`, `memtype`, `updated_at`, `created_at`) values (1, 1, user_template_1765389947_6939b67bdb4b8.png, img/user_template/user_template_1765389947_6939b67bdb4b8.png, png, 2025-12-10 18:05:47, 2025-12-10 18:05:47))','2025-12-10 12:35:47','2025-12-10 12:35:47'),
(29,5,NULL,'SQLSTATE[HY000]: General error: 1364 Field \'user_template_id\' doesn\'t have a default value (Connection: mysql, SQL: insert into `generated_image` (`customer_id`, `master_template_id`, `taskid`, `beforeid`, `genarted_path`, `genarted_image`, `updated_at`, `created_at`) values (1, 1, 5, 6, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765396006_6939ce26f2335.jpg, combined_image_1765396006_6939ce26f2335.jpg, 2025-12-10 19:46:46, 2025-12-10 19:46:46))','2025-12-10 14:16:46','2025-12-10 14:16:46'),
(30,5,NULL,'SQLSTATE[HY000]: General error: 1364 Field \'user_template_id\' doesn\'t have a default value (Connection: mysql, SQL: insert into `generated_image` (`customer_id`, `master_template_id`, `taskid`, `beforeid`, `genarted_path`, `genarted_image`, `updated_at`, `created_at`) values (1, 1, 5, 6, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765396011_6939ce2b21f0c.jpg, combined_image_1765396011_6939ce2b21f0c.jpg, 2025-12-10 19:46:51, 2025-12-10 19:46:51))','2025-12-10 14:16:51','2025-12-10 14:16:51'),
(31,11,NULL,'SQLSTATE[HY000]: General error: 1364 Field \'memtype\' doesn\'t have a default value (Connection: mysql, SQL: insert into `generated_image` (`customer_id`, `master_template_id`, `user_template_id`, `taskid`, `beforeid`, `genarted_path`, `genarted_image`, `updated_at`, `created_at`) values (1, 1, 1, 11, 12, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765397891_6939d58352cdf.jpg, combined_image_1765397891_6939d58352cdf.jpg, 2025-12-10 20:18:11, 2025-12-10 20:18:11))','2025-12-10 14:48:11','2025-12-10 14:48:11'),
(32,11,NULL,'SQLSTATE[HY000]: General error: 1364 Field \'memtype\' doesn\'t have a default value (Connection: mysql, SQL: insert into `generated_image` (`customer_id`, `master_template_id`, `user_template_id`, `taskid`, `beforeid`, `genarted_path`, `genarted_image`, `updated_at`, `created_at`) values (1, 1, 1, 11, 12, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765397895_6939d5873f38b.jpg, combined_image_1765397895_6939d5873f38b.jpg, 2025-12-10 20:18:15, 2025-12-10 20:18:15))','2025-12-10 14:48:15','2025-12-10 14:48:15'),
(33,11,NULL,'SQLSTATE[HY000]: General error: 1364 Field \'memtype\' doesn\'t have a default value (Connection: mysql, SQL: insert into `generated_image` (`customer_id`, `master_template_id`, `user_template_id`, `taskid`, `beforeid`, `genarted_path`, `genarted_image`, `updated_at`, `created_at`) values (1, 1, 1, 11, 12, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765397912_6939d5983fae8.jpg, combined_image_1765397912_6939d5983fae8.jpg, 2025-12-10 20:18:32, 2025-12-10 20:18:32))','2025-12-10 14:48:32','2025-12-10 14:48:32'),
(34,NULL,'Video Task Creation','SQLSTATE[42S22]: Column not found: 1054 Unknown column \'content_type\' in \'where clause\' (Connection: mysql, SQL: select * from `tempgeneration` where `content_type` = video)','2025-12-14 14:51:14','2025-12-14 14:51:14'),
(35,20,NULL,'Customer 2: Python script failed with code 1: ERROR: Error generating video: VideoClip.write_videofile() got an unexpected keyword argument \'verbose\'\n============================================================\nVideo Generator Script\n============================================================\nBackground Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1765744306.mp4\nTemplate Image: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1765743912_693f1d288d5fd.png\nOutput Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1765744318_693f1ebe8b521.mp4\n============================================================\nLoading background video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1765744306.mp4\nVideo properties - Duration: 15.05s, Size: 480x480\nLoading template: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1765743912_693f1d288d5fd.png\nCreating wipe-in animation...\nCompositing video...\nWriting output video to: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1765744318_693f1ebe8b521.mp4\n============================================================\nVideo generation failed!\nError: Error generating video: VideoClip.write_videofile() got an unexpected keyword argument \'verbose\'\n============================================================','2025-12-14 15:01:59','2025-12-14 15:01:59'),
(36,21,NULL,'Customer 2: Python script failed with code 1: ERROR: Error generating video: VideoClip.write_videofile() got an unexpected keyword argument \'verbose\'\n============================================================\nVideo Generator Script\n============================================================\nBackground Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1765746463.mp4\nTemplate Image: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1765743912_693f1d288d5fd.png\nOutput Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1765746473_693f272932405.mp4\n============================================================\nLoading background video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1765746463.mp4\nVideo properties - Duration: 15.05s, Size: 480x480\nLoading template: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1765743912_693f1d288d5fd.png\nCreating wipe-in animation...\nCompositing video...\nWriting output video to: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1765746473_693f272932405.mp4\n============================================================\nVideo generation failed!\nError: Error generating video: VideoClip.write_videofile() got an unexpected keyword argument \'verbose\'\n============================================================','2025-12-14 15:37:54','2025-12-14 15:37:54'),
(37,22,NULL,'Customer 2: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'master_template_id\' in \'field list\' (Connection: mysql, SQL: insert into `generated_videos` (`customer_id`, `master_template_id`, `user_template_id`, `taskid`, `beforeid`, `generated_path`, `generated_video`, `thumbnail`, `video_type`, `duration`, `file_size`, `sent`, `updated_at`, `created_at`) values (2, 1, 9, 22, 23, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765747617_693f2ba1190ff.mp4, combined_video_1765747617_693f2ba1190ff.mp4, thumb_combined_video_1765747617_693f2ba1190ff.jpg, landscape, 15.05, 557188, 0, 2025-12-14 21:27:06, 2025-12-14 21:27:06))','2025-12-14 15:57:06','2025-12-14 15:57:06'),
(38,23,NULL,'Customer 2: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'master_template_id\' in \'field list\' (Connection: mysql, SQL: insert into `generated_videos` (`customer_id`, `master_template_id`, `user_template_id`, `taskid`, `beforeid`, `generated_path`, `generated_video`, `thumbnail`, `video_type`, `duration`, `file_size`, `sent`, `updated_at`, `created_at`) values (2, 1, 9, 23, 24, D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765748595_693f2f7351ae7.mp4, combined_video_1765748595_693f2f7351ae7.mp4, thumb_combined_video_1765748595_693f2f7351ae7.jpg, landscape, 15.05, 558521, 0, 2025-12-14 21:43:24, 2025-12-14 21:43:24))','2025-12-14 16:13:24','2025-12-14 16:13:24'),
(39,37,NULL,'Customer 2: Image file not found: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg_video_1765755081.mp4','2025-12-15 03:33:43','2025-12-15 03:33:43'),
(40,37,NULL,'Customer 1: Image file not found: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg_video_1765755081.mp4','2025-12-15 03:33:43','2025-12-15 03:33:43'),
(41,37,NULL,'Customer 2: Image file not found: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg_video_1765755081.mp4','2025-12-15 03:33:43','2025-12-15 03:33:43'),
(42,43,NULL,'Customer 2: Image file not found: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/background_image/bg_video_1765792217.mp4','2025-12-15 04:21:59','2025-12-15 04:21:59'),
(43,53,NULL,'Array to string conversion','2025-12-15 05:07:01','2025-12-15 05:07:01'),
(44,54,NULL,'Video 0: [Errno 32] Broken pipe\n\nMoviePy error: FFMPEG encountered the following error while writing file D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795798_693fe7d6941f6.mp4:\n\n ','2025-12-15 05:20:41','2025-12-15 05:20:41'),
(45,54,NULL,'Video 1: [Errno 32] Broken pipe\n\nMoviePy error: FFMPEG encountered the following error while writing file D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795798_693fe7d694595.mp4:\n\n ','2025-12-15 05:20:41','2025-12-15 05:20:41'),
(46,54,NULL,'Video 2: [Errno 32] Broken pipe\n\nMoviePy error: FFMPEG encountered the following error while writing file D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795798_693fe7d694960.mp4:\n\n ','2025-12-15 05:20:41','2025-12-15 05:20:41'),
(47,54,NULL,'Video 3: [Errno 32] Broken pipe\n\nMoviePy error: FFMPEG encountered the following error while writing file D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795798_693fe7d694c94.mp4:\n\n ','2025-12-15 05:20:41','2025-12-15 05:20:41'),
(48,64,NULL,'Video 0: No results returned from parallel script','2025-12-15 12:42:54','2025-12-15 12:42:54'),
(49,64,NULL,'Video 1: No results returned from parallel script','2025-12-15 12:42:54','2025-12-15 12:42:54'),
(50,65,NULL,'Video 0: No results returned from parallel script','2025-12-15 12:45:40','2025-12-15 12:45:40'),
(51,65,NULL,'Video 1: No results returned from parallel script','2025-12-15 12:45:40','2025-12-15 12:45:40'),
(52,65,NULL,'Video 2: No results returned from parallel script','2025-12-15 12:45:40','2025-12-15 12:45:40'),
(53,65,NULL,'Video 3: No results returned from parallel script','2025-12-15 12:45:40','2025-12-15 12:45:40'),
(54,70,NULL,'Video 0: No results returned from parallel script','2025-12-30 07:57:10','2025-12-30 07:57:10'),
(55,72,NULL,'Video 0: No results returned from parallel script','2025-12-30 08:14:20','2025-12-30 08:14:20'),
(56,73,NULL,'Video 0: No results returned from parallel script','2025-12-30 08:15:29','2025-12-30 08:15:29'),
(57,74,NULL,'Video 0: Python script failed with code 1: \'python\' is not recognized as an internal or external command,\noperable program or batch file.','2025-12-30 09:10:59','2025-12-30 09:10:59'),
(66,93,NULL,'SQLSTATE[HY000]: General error: 1205 Lock wait timeout exceeded; try restarting transaction (Connection: mysql, SQL: update `task` set `status` = 2, `task`.`updated_at` = 2026-01-02 18:30:26 where `id` = 93)','2026-01-02 13:01:16','2026-01-02 13:01:16'),
(67,93,NULL,'SQLSTATE[HY000]: General error: 1205 Lock wait timeout exceeded; try restarting transaction (Connection: mysql, SQL: update `task` set `status` = 2, `task`.`updated_at` = 2026-01-02 18:31:13 where `id` = 93)','2026-01-02 13:02:03','2026-01-02 13:02:03'),
(68,93,NULL,'SQLSTATE[HY000]: General error: 1205 Lock wait timeout exceeded; try restarting transaction (Connection: mysql, SQL: update `task` set `status` = 2, `task`.`updated_at` = 2026-01-02 18:35:08 where `id` = 93)','2026-01-02 13:05:58','2026-01-02 13:05:58'),
(69,93,NULL,'SQLSTATE[HY000]: General error: 1205 Lock wait timeout exceeded; try restarting transaction (Connection: mysql, SQL: update `task` set `status` = 2, `task`.`updated_at` = 2026-01-02 18:36:49 where `id` = 93)','2026-01-02 13:07:39','2026-01-02 13:07:39'),
(70,93,NULL,'SQLSTATE[HY000]: General error: 1205 Lock wait timeout exceeded; try restarting transaction (Connection: mysql, SQL: update `task` set `status` = 2, `task`.`updated_at` = 2026-01-02 18:41:01 where `id` = 93)','2026-01-02 13:11:51','2026-01-02 13:11:51'),
(71,93,NULL,'SQLSTATE[HY000]: General error: 1205 Lock wait timeout exceeded; try restarting transaction (Connection: mysql, SQL: update `task` set `status` = 2, `task`.`updated_at` = 2026-01-02 18:43:04 where `id` = 93)','2026-01-02 13:13:54','2026-01-02 13:13:54'),
(72,93,NULL,'SQLSTATE[HY000]: General error: 1205 Lock wait timeout exceeded; try restarting transaction (Connection: mysql, SQL: update `task` set `status` = 2, `task`.`updated_at` = 2026-01-02 18:47:13 where `id` = 93)','2026-01-02 13:18:03','2026-01-02 13:18:03'),
(73,101,NULL,'Video generation failed for combined_video_1767387909_6958330569345.mp4: ERROR: Error generating video: No module named \'scipy\'\n============================================================\nVideo Generator Script\n============================================================\nBackground Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767387899.mp4\nTemplate Image: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767026215_6952ae2754189.png\nOutput Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1767387909_6958330569345.mp4\nAnimation Type: blur-in\n============================================================\nLoading background video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767387899.mp4\nVideo properties - Duration: 45.84s, Size: 360x640\nAnimation type: blur-in\nLoading template: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767026215_6952ae2754189.png\nCreating blur-in animation...\n============================================================\nVideo generation failed!\nError: Error generating video: No module named \'scipy\'\n============================================================','2026-01-02 15:35:15','2026-01-02 15:35:15'),
(74,101,NULL,'Video generation failed for combined_video_1767387909_695833056937a.mp4: ERROR: Error generating video: No module named \'scipy\'\n============================================================\nVideo Generator Script\n============================================================\nBackground Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767387899.mp4\nTemplate Image: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767276545_6956800113766.png\nOutput Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1767387909_695833056937a.mp4\nAnimation Type: blur-in\n============================================================\nLoading background video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767387899.mp4\nVideo properties - Duration: 45.84s, Size: 360x640\nAnimation type: blur-in\nLoading template: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767276545_6956800113766.png\nCreating blur-in animation...\n============================================================\nVideo generation failed!\nError: Error generating video: No module named \'scipy\'\n============================================================','2026-01-02 15:35:15','2026-01-02 15:35:15'),
(77,120,NULL,'Video generation failed for combined_video_1767462574_695956aea8aae.mp4: ffmpeg version 2025-12-31-git-38e89fe502-full_build-www.gyan.dev Copyright (c) 2000-2025 the FFmpeg developers\n  built with gcc 15.2.0 (Rev8, Built by MSYS2 project)\n  configuration: --enable-gpl --enable-version3 --enable-static --disable-w32threads --disable-autodetect --enable-cairo --enable-fontconfig --enable-iconv --enable-gnutls --enable-lcms2 --enable-libxml2 --enable-gmp --enable-bzlib --enable-lzma --enable-libsnappy --enable-zlib --enable-librist --enable-libsrt --enable-libssh --enable-libzmq --enable-avisynth --enable-libbluray --enable-libcaca --enable-libdvdnav --enable-libdvdread --enable-sdl2 --enable-libaribb24 --enable-libaribcaption --enable-libdav1d --enable-libdavs2 --enable-libopenjpeg --enable-libquirc --enable-libuavs3d --enable-libxevd --enable-libzvbi --enable-liboapv --enable-libqrencode --enable-librav1e --enable-libsvtav1 --enable-libvvenc --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxavs2 --enable-libxeve --enable-libxvid --enable-libaom --enable-libjxl --enable-libsvtjpegxs --enable-libvpx --enable-mediafoundation --enable-libass --enable-frei0r --enable-libfreetype --enable-libfribidi --enable-libharfbuzz --enable-liblensfun --enable-libvidstab --enable-libvmaf --enable-libzimg --enable-amf --enable-cuda-llvm --enable-cuvid --enable-dxva2 --enable-d3d11va --enable-d3d12va --enable-ffnvcodec --enable-libvpl --enable-nvdec --enable-nvenc --enable-vaapi --enable-libshaderc --enable-vulkan --enable-libplacebo --enable-opencl --enable-libcdio --enable-openal --enable-libgme --enable-libmodplug --enable-libopenmpt --enable-libopencore-amrwb --enable-libmp3lame --enable-libshine --enable-libtheora --enable-libtwolame --enable-libvo-amrwbenc --enable-libcodec2 --enable-libilbc --enable-libgsm --enable-liblc3 --enable-libopencore-amrnb --enable-libopus --enable-libspeex --enable-libvorbis --enable-ladspa --enable-libbs2b --enable-libflite --enable-libmysofa --enable-librubberband --enable-libsoxr --enable-chromaprint --enable-whisper\n  libavutil      60. 21.102 / 60. 21.102\n  libavcodec     62. 23.102 / 62. 23.102\n  libavformat    62.  8.102 / 62.  8.102\n  libavdevice    62.  2.100 / 62.  2.100\n  libavfilter    11. 10.101 / 11. 10.101\n  libswscale      9.  3.100 /  9.  3.100\n  libswresample   6.  2.100 /  6.  2.100\nInput #0, mov,mp4,m4a,3gp,3g2,mj2, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767462565.mp4\':\n  Metadata:\n    major_brand     : mp42\n    minor_version   : 0\n    compatible_brands: mp42isom\n  Duration: 00:00:45.84, start: 0.000000, bitrate: 318 kb/s\n  Stream #0:0[0x1](und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p(tv, bt709, progressive), 360x640, 266 kb/s, 25 fps, 25 tbr, 12800 tbn, start 0.120000 (default)\n  Stream #0:1[0x2](und): Audio: aac (HE-AAC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 48 kb/s (default)\nInput #1, png_pipe, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767026215_6952ae2754189.png\':\n  Duration: N/A, bitrate: N/A\n  Stream #1:0: Video: png, gray(pc, gbr/unknown/unknown), 360x360, 25 fps, 25 tbr, 25 tbn\nStream mapping:\n  Stream #0:0 (h264) -> overlay\n  Stream #1:0 (png) -> scale:default\n  overlay:default -> Stream #0:0 (h264_nvenc)\n  Stream #0:1 -> #0:1 (copy)\nPress [q] to stop, [?] for help\n[h264_nvenc @ 000002a4acf24a40] dl_fn->cuda_dl->cuInit(0) failed -> CUDA_ERROR_NO_DEVICE: no CUDA-capable device is detected\n[vost#0:0/h264_nvenc @ 000002a4ab194a80] [enc:h264_nvenc @ 000002a4acdf1d00] Error while opening encoder - maybe incorrect parameters such as bit_rate, rate, width or height.\n[fc#0 @ 000002a4ab18a580] Error sending frames to consumers: Unknown error occurred\n[fc#0 @ 000002a4ab18a580] Task finished with error code: -1313558101 (Unknown error occurred)\n[fc#0 @ 000002a4ab18a580] Terminating thread with return code -1313558101 (Unknown error occurred)\n[vost#0:0/h264_nvenc @ 000002a4ab194a80] [enc:h264_nvenc @ 000002a4acdf1d00] Could not open encoder before EOF\n[vost#0:0/h264_nvenc @ 000002a4ab194a80] Task finished with error code: -22 (Invalid argument)\n[vost#0:0/h264_nvenc @ 000002a4ab194a80] Terminating thread with return code -22 (Invalid argument)\n[out#0/mp4 @ 000002a4ab1ad900] Nothing was written into output file, because at least one of its streams received no packets.\nframe=    0 fps=0.0 q=0.0 Lsize=       0KiB time=N/A bitrate=N/A speed=N/A elapsed=0:00:00.05\nConversion failed!\nERROR: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767462565.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767026215_6952ae2754189.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767462574_695956aea8aae.mp4\']\' returned non-zero exit status 2981409195.\n============================================================\nVideo Generator Script\n============================================================\nBackground Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767462565.mp4\nTemplate Image: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767026215_6952ae2754189.png\nOutput Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1767462574_695956aea8aae.mp4\nAnimation Type: curtain\n============================================================\nVideo Info: 360x640, 45.72s\nAnimation: curtain\nEncoder: h264_nvenc\nRunning FFmpeg...\n============================================================\nVideo generation failed!\nError: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767462565.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767026215_6952ae2754189.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767462574_695956aea8aae.mp4\']\' returned non-zero exit status 2981409195.\n============================================================','2026-01-03 12:19:41','2026-01-03 12:19:41'),
(78,120,NULL,'Video generation failed for combined_video_1767462574_695956aea8b7e.mp4: ffmpeg version 2025-12-31-git-38e89fe502-full_build-www.gyan.dev Copyright (c) 2000-2025 the FFmpeg developers\n  built with gcc 15.2.0 (Rev8, Built by MSYS2 project)\n  configuration: --enable-gpl --enable-version3 --enable-static --disable-w32threads --disable-autodetect --enable-cairo --enable-fontconfig --enable-iconv --enable-gnutls --enable-lcms2 --enable-libxml2 --enable-gmp --enable-bzlib --enable-lzma --enable-libsnappy --enable-zlib --enable-librist --enable-libsrt --enable-libssh --enable-libzmq --enable-avisynth --enable-libbluray --enable-libcaca --enable-libdvdnav --enable-libdvdread --enable-sdl2 --enable-libaribb24 --enable-libaribcaption --enable-libdav1d --enable-libdavs2 --enable-libopenjpeg --enable-libquirc --enable-libuavs3d --enable-libxevd --enable-libzvbi --enable-liboapv --enable-libqrencode --enable-librav1e --enable-libsvtav1 --enable-libvvenc --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxavs2 --enable-libxeve --enable-libxvid --enable-libaom --enable-libjxl --enable-libsvtjpegxs --enable-libvpx --enable-mediafoundation --enable-libass --enable-frei0r --enable-libfreetype --enable-libfribidi --enable-libharfbuzz --enable-liblensfun --enable-libvidstab --enable-libvmaf --enable-libzimg --enable-amf --enable-cuda-llvm --enable-cuvid --enable-dxva2 --enable-d3d11va --enable-d3d12va --enable-ffnvcodec --enable-libvpl --enable-nvdec --enable-nvenc --enable-vaapi --enable-libshaderc --enable-vulkan --enable-libplacebo --enable-opencl --enable-libcdio --enable-openal --enable-libgme --enable-libmodplug --enable-libopenmpt --enable-libopencore-amrwb --enable-libmp3lame --enable-libshine --enable-libtheora --enable-libtwolame --enable-libvo-amrwbenc --enable-libcodec2 --enable-libilbc --enable-libgsm --enable-liblc3 --enable-libopencore-amrnb --enable-libopus --enable-libspeex --enable-libvorbis --enable-ladspa --enable-libbs2b --enable-libflite --enable-libmysofa --enable-librubberband --enable-libsoxr --enable-chromaprint --enable-whisper\n  libavutil      60. 21.102 / 60. 21.102\n  libavcodec     62. 23.102 / 62. 23.102\n  libavformat    62.  8.102 / 62.  8.102\n  libavdevice    62.  2.100 / 62.  2.100\n  libavfilter    11. 10.101 / 11. 10.101\n  libswscale      9.  3.100 /  9.  3.100\n  libswresample   6.  2.100 /  6.  2.100\nInput #0, mov,mp4,m4a,3gp,3g2,mj2, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767462565.mp4\':\n  Metadata:\n    major_brand     : mp42\n    minor_version   : 0\n    compatible_brands: mp42isom\n  Duration: 00:00:45.84, start: 0.000000, bitrate: 318 kb/s\n  Stream #0:0[0x1](und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p(tv, bt709, progressive), 360x640, 266 kb/s, 25 fps, 25 tbr, 12800 tbn, start 0.120000 (default)\n  Stream #0:1[0x2](und): Audio: aac (HE-AAC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 48 kb/s (default)\nInput #1, png_pipe, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767276545_6956800113766.png\':\n  Duration: N/A, bitrate: N/A\n  Stream #1:0: Video: png, gray(pc, gbr/unknown/unknown), 360x360, 25 fps, 25 tbr, 25 tbn\nStream mapping:\n  Stream #0:0 (h264) -> overlay\n  Stream #1:0 (png) -> scale:default\n  overlay:default -> Stream #0:0 (h264_nvenc)\n  Stream #0:1 -> #0:1 (copy)\nPress [q] to stop, [?] for help\n[h264_nvenc @ 00000258a5ac4a40] dl_fn->cuda_dl->cuInit(0) failed -> CUDA_ERROR_NO_DEVICE: no CUDA-capable device is detected\n[vost#0:0/h264_nvenc @ 00000258a5534a80] [enc:h264_nvenc @ 00000258a598f0c0] Error while opening encoder - maybe incorrect parameters such as bit_rate, rate, width or height.\n[fc#0 @ 00000258a552a580] Error sending frames to consumers: Unknown error occurred\n[fc#0 @ 00000258a552a580] Task finished with error code: -1313558101 (Unknown error occurred)\n[fc#0 @ 00000258a552a580] Terminating thread with return code -1313558101 (Unknown error occurred)\n[vost#0:0/h264_nvenc @ 00000258a5534a80] [enc:h264_nvenc @ 00000258a598f0c0] Could not open encoder before EOF\n[vost#0:0/h264_nvenc @ 00000258a5534a80] Task finished with error code: -22 (Invalid argument)\n[vost#0:0/h264_nvenc @ 00000258a5534a80] Terminating thread with return code -22 (Invalid argument)\n[out#0/mp4 @ 00000258a554d900] Nothing was written into output file, because at least one of its streams received no packets.\nframe=    0 fps=0.0 q=0.0 Lsize=       0KiB time=N/A bitrate=N/A speed=N/A elapsed=0:00:00.03\nConversion failed!\nERROR: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767462565.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767276545_6956800113766.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767462574_695956aea8b7e.mp4\']\' returned non-zero exit status 2981409195.\n============================================================\nVideo Generator Script\n============================================================\nBackground Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767462565.mp4\nTemplate Image: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767276545_6956800113766.png\nOutput Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1767462574_695956aea8b7e.mp4\nAnimation Type: curtain\n============================================================\nVideo Info: 360x640, 45.72s\nAnimation: curtain\nEncoder: h264_nvenc\nRunning FFmpeg...\n============================================================\nVideo generation failed!\nError: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767462565.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767276545_6956800113766.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767462574_695956aea8b7e.mp4\']\' returned non-zero exit status 2981409195.\n============================================================','2026-01-03 12:19:41','2026-01-03 12:19:41'),
(79,121,NULL,'Video generation failed for combined_video_1767463245_6959594db8e81.mp4: ffmpeg version 2025-12-31-git-38e89fe502-full_build-www.gyan.dev Copyright (c) 2000-2025 the FFmpeg developers\n  built with gcc 15.2.0 (Rev8, Built by MSYS2 project)\n  configuration: --enable-gpl --enable-version3 --enable-static --disable-w32threads --disable-autodetect --enable-cairo --enable-fontconfig --enable-iconv --enable-gnutls --enable-lcms2 --enable-libxml2 --enable-gmp --enable-bzlib --enable-lzma --enable-libsnappy --enable-zlib --enable-librist --enable-libsrt --enable-libssh --enable-libzmq --enable-avisynth --enable-libbluray --enable-libcaca --enable-libdvdnav --enable-libdvdread --enable-sdl2 --enable-libaribb24 --enable-libaribcaption --enable-libdav1d --enable-libdavs2 --enable-libopenjpeg --enable-libquirc --enable-libuavs3d --enable-libxevd --enable-libzvbi --enable-liboapv --enable-libqrencode --enable-librav1e --enable-libsvtav1 --enable-libvvenc --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxavs2 --enable-libxeve --enable-libxvid --enable-libaom --enable-libjxl --enable-libsvtjpegxs --enable-libvpx --enable-mediafoundation --enable-libass --enable-frei0r --enable-libfreetype --enable-libfribidi --enable-libharfbuzz --enable-liblensfun --enable-libvidstab --enable-libvmaf --enable-libzimg --enable-amf --enable-cuda-llvm --enable-cuvid --enable-dxva2 --enable-d3d11va --enable-d3d12va --enable-ffnvcodec --enable-libvpl --enable-nvdec --enable-nvenc --enable-vaapi --enable-libshaderc --enable-vulkan --enable-libplacebo --enable-opencl --enable-libcdio --enable-openal --enable-libgme --enable-libmodplug --enable-libopenmpt --enable-libopencore-amrwb --enable-libmp3lame --enable-libshine --enable-libtheora --enable-libtwolame --enable-libvo-amrwbenc --enable-libcodec2 --enable-libilbc --enable-libgsm --enable-liblc3 --enable-libopencore-amrnb --enable-libopus --enable-libspeex --enable-libvorbis --enable-ladspa --enable-libbs2b --enable-libflite --enable-libmysofa --enable-librubberband --enable-libsoxr --enable-chromaprint --enable-whisper\n  libavutil      60. 21.102 / 60. 21.102\n  libavcodec     62. 23.102 / 62. 23.102\n  libavformat    62.  8.102 / 62.  8.102\n  libavdevice    62.  2.100 / 62.  2.100\n  libavfilter    11. 10.101 / 11. 10.101\n  libswscale      9.  3.100 /  9.  3.100\n  libswresample   6.  2.100 /  6.  2.100\nInput #0, mov,mp4,m4a,3gp,3g2,mj2, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767463237.mp4\':\n  Metadata:\n    major_brand     : mp42\n    minor_version   : 0\n    compatible_brands: mp42isom\n  Duration: 00:00:45.84, start: 0.000000, bitrate: 318 kb/s\n  Stream #0:0[0x1](und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p(tv, bt709, progressive), 360x640, 266 kb/s, 25 fps, 25 tbr, 12800 tbn, start 0.120000 (default)\n  Stream #0:1[0x2](und): Audio: aac (HE-AAC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 48 kb/s (default)\nInput #1, png_pipe, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767026215_6952ae2754189.png\':\n  Duration: N/A, bitrate: N/A\n  Stream #1:0: Video: png, gray(pc, gbr/unknown/unknown), 360x360, 25 fps, 25 tbr, 25 tbn\nStream mapping:\n  Stream #0:0 (h264) -> overlay\n  Stream #1:0 (png) -> scale:default\n  overlay:default -> Stream #0:0 (h264_nvenc)\n  Stream #0:1 -> #0:1 (copy)\nPress [q] to stop, [?] for help\n[h264_nvenc @ 00000201a5e3d0c0] dl_fn->cuda_dl->cuInit(0) failed -> CUDA_ERROR_NO_DEVICE: no CUDA-capable device is detected\n[vost#0:0/h264_nvenc @ 00000201a5e3cd40] [enc:h264_nvenc @ 00000201a78be640] Error while opening encoder - maybe incorrect parameters such as bit_rate, rate, width or height.\n[fc#0 @ 00000201a5e297c0] Error sending frames to consumers: Unknown error occurred\n[fc#0 @ 00000201a5e297c0] Task finished with error code: -1313558101 (Unknown error occurred)\n[fc#0 @ 00000201a5e297c0] Terminating thread with return code -1313558101 (Unknown error occurred)\n[vost#0:0/h264_nvenc @ 00000201a5e3cd40] [enc:h264_nvenc @ 00000201a78be640] Could not open encoder before EOF\n[vost#0:0/h264_nvenc @ 00000201a5e3cd40] Task finished with error code: -22 (Invalid argument)\n[vost#0:0/h264_nvenc @ 00000201a5e3cd40] Terminating thread with return code -22 (Invalid argument)\n[out#0/mp4 @ 00000201a79f4340] Nothing was written into output file, because at least one of its streams received no packets.\nframe=    0 fps=0.0 q=0.0 Lsize=       0KiB time=N/A bitrate=N/A speed=N/A elapsed=0:00:00.03\nConversion failed!\nERROR: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767463237.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767026215_6952ae2754189.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767463245_6959594db8e81.mp4\']\' returned non-zero exit status 2981409195.\n============================================================\nVideo Generator Script\n============================================================\nBackground Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767463237.mp4\nTemplate Image: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767026215_6952ae2754189.png\nOutput Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1767463245_6959594db8e81.mp4\nAnimation Type: curtain\n============================================================\nVideo Info: 360x640, 45.72s\nAnimation: curtain\nEncoder: h264_nvenc\nRunning FFmpeg...\n============================================================\nVideo generation failed!\nError: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767463237.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767026215_6952ae2754189.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767463245_6959594db8e81.mp4\']\' returned non-zero exit status 2981409195.\n============================================================','2026-01-03 12:30:52','2026-01-03 12:30:52'),
(80,121,NULL,'Video generation failed for combined_video_1767463245_6959594db8fbb.mp4: ffmpeg version 2025-12-31-git-38e89fe502-full_build-www.gyan.dev Copyright (c) 2000-2025 the FFmpeg developers\n  built with gcc 15.2.0 (Rev8, Built by MSYS2 project)\n  configuration: --enable-gpl --enable-version3 --enable-static --disable-w32threads --disable-autodetect --enable-cairo --enable-fontconfig --enable-iconv --enable-gnutls --enable-lcms2 --enable-libxml2 --enable-gmp --enable-bzlib --enable-lzma --enable-libsnappy --enable-zlib --enable-librist --enable-libsrt --enable-libssh --enable-libzmq --enable-avisynth --enable-libbluray --enable-libcaca --enable-libdvdnav --enable-libdvdread --enable-sdl2 --enable-libaribb24 --enable-libaribcaption --enable-libdav1d --enable-libdavs2 --enable-libopenjpeg --enable-libquirc --enable-libuavs3d --enable-libxevd --enable-libzvbi --enable-liboapv --enable-libqrencode --enable-librav1e --enable-libsvtav1 --enable-libvvenc --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxavs2 --enable-libxeve --enable-libxvid --enable-libaom --enable-libjxl --enable-libsvtjpegxs --enable-libvpx --enable-mediafoundation --enable-libass --enable-frei0r --enable-libfreetype --enable-libfribidi --enable-libharfbuzz --enable-liblensfun --enable-libvidstab --enable-libvmaf --enable-libzimg --enable-amf --enable-cuda-llvm --enable-cuvid --enable-dxva2 --enable-d3d11va --enable-d3d12va --enable-ffnvcodec --enable-libvpl --enable-nvdec --enable-nvenc --enable-vaapi --enable-libshaderc --enable-vulkan --enable-libplacebo --enable-opencl --enable-libcdio --enable-openal --enable-libgme --enable-libmodplug --enable-libopenmpt --enable-libopencore-amrwb --enable-libmp3lame --enable-libshine --enable-libtheora --enable-libtwolame --enable-libvo-amrwbenc --enable-libcodec2 --enable-libilbc --enable-libgsm --enable-liblc3 --enable-libopencore-amrnb --enable-libopus --enable-libspeex --enable-libvorbis --enable-ladspa --enable-libbs2b --enable-libflite --enable-libmysofa --enable-librubberband --enable-libsoxr --enable-chromaprint --enable-whisper\n  libavutil      60. 21.102 / 60. 21.102\n  libavcodec     62. 23.102 / 62. 23.102\n  libavformat    62.  8.102 / 62.  8.102\n  libavdevice    62.  2.100 / 62.  2.100\n  libavfilter    11. 10.101 / 11. 10.101\n  libswscale      9.  3.100 /  9.  3.100\n  libswresample   6.  2.100 /  6.  2.100\nInput #0, mov,mp4,m4a,3gp,3g2,mj2, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767463237.mp4\':\n  Metadata:\n    major_brand     : mp42\n    minor_version   : 0\n    compatible_brands: mp42isom\n  Duration: 00:00:45.84, start: 0.000000, bitrate: 318 kb/s\n  Stream #0:0[0x1](und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p(tv, bt709, progressive), 360x640, 266 kb/s, 25 fps, 25 tbr, 12800 tbn, start 0.120000 (default)\n  Stream #0:1[0x2](und): Audio: aac (HE-AAC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 48 kb/s (default)\nInput #1, png_pipe, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767276545_6956800113766.png\':\n  Duration: N/A, bitrate: N/A\n  Stream #1:0: Video: png, gray(pc, gbr/unknown/unknown), 360x360, 25 fps, 25 tbr, 25 tbn\nStream mapping:\n  Stream #0:0 (h264) -> overlay\n  Stream #1:0 (png) -> scale:default\n  overlay:default -> Stream #0:0 (h264_nvenc)\n  Stream #0:1 -> #0:1 (copy)\nPress [q] to stop, [?] for help\n[h264_nvenc @ 000001f0ee34d0c0] dl_fn->cuda_dl->cuInit(0) failed -> CUDA_ERROR_NO_DEVICE: no CUDA-capable device is detected\n[vost#0:0/h264_nvenc @ 000001f0ee34cd40] [enc:h264_nvenc @ 000001f0ee7ffa80] Error while opening encoder - maybe incorrect parameters such as bit_rate, rate, width or height.\n[fc#0 @ 000001f0ee3397c0] Error sending frames to consumers: Unknown error occurred\n[fc#0 @ 000001f0ee3397c0] Task finished with error code: -1313558101 (Unknown error occurred)\n[fc#0 @ 000001f0ee3397c0] Terminating thread with return code -1313558101 (Unknown error occurred)\n[vost#0:0/h264_nvenc @ 000001f0ee34cd40] [enc:h264_nvenc @ 000001f0ee7ffa80] Could not open encoder before EOF\n[vost#0:0/h264_nvenc @ 000001f0ee34cd40] Task finished with error code: -22 (Invalid argument)\n[vost#0:0/h264_nvenc @ 000001f0ee34cd40] Terminating thread with return code -22 (Invalid argument)\n[out#0/mp4 @ 000001f0ee934340] Nothing was written into output file, because at least one of its streams received no packets.\nframe=    0 fps=0.0 q=0.0 Lsize=       0KiB time=N/A bitrate=N/A speed=N/A elapsed=0:00:00.03\nConversion failed!\nERROR: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767463237.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767276545_6956800113766.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767463245_6959594db8fbb.mp4\']\' returned non-zero exit status 2981409195.\n============================================================\nVideo Generator Script\n============================================================\nBackground Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767463237.mp4\nTemplate Image: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767276545_6956800113766.png\nOutput Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1767463245_6959594db8fbb.mp4\nAnimation Type: curtain\n============================================================\nVideo Info: 360x640, 45.72s\nAnimation: curtain\nEncoder: h264_nvenc\nRunning FFmpeg...\n============================================================\nVideo generation failed!\nError: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767463237.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767276545_6956800113766.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767463245_6959594db8fbb.mp4\']\' returned non-zero exit status 2981409195.\n============================================================','2026-01-03 12:30:52','2026-01-03 12:30:52'),
(81,122,NULL,'Video generation failed for combined_video_1767463596_69595aace6822.mp4: ffmpeg version 2025-12-31-git-38e89fe502-full_build-www.gyan.dev Copyright (c) 2000-2025 the FFmpeg developers\n  built with gcc 15.2.0 (Rev8, Built by MSYS2 project)\n  configuration: --enable-gpl --enable-version3 --enable-static --disable-w32threads --disable-autodetect --enable-cairo --enable-fontconfig --enable-iconv --enable-gnutls --enable-lcms2 --enable-libxml2 --enable-gmp --enable-bzlib --enable-lzma --enable-libsnappy --enable-zlib --enable-librist --enable-libsrt --enable-libssh --enable-libzmq --enable-avisynth --enable-libbluray --enable-libcaca --enable-libdvdnav --enable-libdvdread --enable-sdl2 --enable-libaribb24 --enable-libaribcaption --enable-libdav1d --enable-libdavs2 --enable-libopenjpeg --enable-libquirc --enable-libuavs3d --enable-libxevd --enable-libzvbi --enable-liboapv --enable-libqrencode --enable-librav1e --enable-libsvtav1 --enable-libvvenc --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxavs2 --enable-libxeve --enable-libxvid --enable-libaom --enable-libjxl --enable-libsvtjpegxs --enable-libvpx --enable-mediafoundation --enable-libass --enable-frei0r --enable-libfreetype --enable-libfribidi --enable-libharfbuzz --enable-liblensfun --enable-libvidstab --enable-libvmaf --enable-libzimg --enable-amf --enable-cuda-llvm --enable-cuvid --enable-dxva2 --enable-d3d11va --enable-d3d12va --enable-ffnvcodec --enable-libvpl --enable-nvdec --enable-nvenc --enable-vaapi --enable-libshaderc --enable-vulkan --enable-libplacebo --enable-opencl --enable-libcdio --enable-openal --enable-libgme --enable-libmodplug --enable-libopenmpt --enable-libopencore-amrwb --enable-libmp3lame --enable-libshine --enable-libtheora --enable-libtwolame --enable-libvo-amrwbenc --enable-libcodec2 --enable-libilbc --enable-libgsm --enable-liblc3 --enable-libopencore-amrnb --enable-libopus --enable-libspeex --enable-libvorbis --enable-ladspa --enable-libbs2b --enable-libflite --enable-libmysofa --enable-librubberband --enable-libsoxr --enable-chromaprint --enable-whisper\n  libavutil      60. 21.102 / 60. 21.102\n  libavcodec     62. 23.102 / 62. 23.102\n  libavformat    62.  8.102 / 62.  8.102\n  libavdevice    62.  2.100 / 62.  2.100\n  libavfilter    11. 10.101 / 11. 10.101\n  libswscale      9.  3.100 /  9.  3.100\n  libswresample   6.  2.100 /  6.  2.100\nInput #0, mov,mp4,m4a,3gp,3g2,mj2, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767463587.mp4\':\n  Metadata:\n    major_brand     : mp42\n    minor_version   : 0\n    compatible_brands: mp42isom\n  Duration: 00:00:45.84, start: 0.000000, bitrate: 318 kb/s\n  Stream #0:0[0x1](und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p(tv, bt709, progressive), 360x640, 266 kb/s, 25 fps, 25 tbr, 12800 tbn, start 0.120000 (default)\n  Stream #0:1[0x2](und): Audio: aac (HE-AAC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 48 kb/s (default)\nInput #1, png_pipe, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767026215_6952ae2754189.png\':\n  Duration: N/A, bitrate: N/A\n  Stream #1:0: Video: png, gray(pc, gbr/unknown/unknown), 360x360, 25 fps, 25 tbr, 25 tbn\nStream mapping:\n  Stream #0:0 (h264) -> overlay\n  Stream #1:0 (png) -> scale:default\n  overlay:default -> Stream #0:0 (h264_nvenc)\n  Stream #0:1 -> #0:1 (copy)\nPress [q] to stop, [?] for help\n[h264_nvenc @ 000002b64e77d780] dl_fn->cuda_dl->cuInit(0) failed -> CUDA_ERROR_NO_DEVICE: no CUDA-capable device is detected\n[vost#0:0/h264_nvenc @ 000002b64e77d200] [enc:h264_nvenc @ 000002b64ec6f440] Error while opening encoder - maybe incorrect parameters such as bit_rate, rate, width or height.\n[fc#0 @ 000002b64e7697c0] Error sending frames to consumers: Unknown error occurred\n[fc#0 @ 000002b64e7697c0] Task finished with error code: -1313558101 (Unknown error occurred)\n[fc#0 @ 000002b64e7697c0] Terminating thread with return code -1313558101 (Unknown error occurred)\n[vost#0:0/h264_nvenc @ 000002b64e77d200] [enc:h264_nvenc @ 000002b64ec6f440] Could not open encoder before EOF\n[vost#0:0/h264_nvenc @ 000002b64e77d200] Task finished with error code: -22 (Invalid argument)\n[vost#0:0/h264_nvenc @ 000002b64e77d200] Terminating thread with return code -22 (Invalid argument)\n[out#0/mp4 @ 000002b64e7abd40] Nothing was written into output file, because at least one of its streams received no packets.\nframe=    0 fps=0.0 q=0.0 Lsize=       0KiB time=N/A bitrate=N/A speed=N/A elapsed=0:00:00.05\nConversion failed!\nERROR: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767463587.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767026215_6952ae2754189.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767463596_69595aace6822.mp4\']\' returned non-zero exit status 2981409195.\n============================================================\nVideo Generator Script\n============================================================\nBackground Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767463587.mp4\nTemplate Image: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767026215_6952ae2754189.png\nOutput Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1767463596_69595aace6822.mp4\nAnimation Type: curtain\n============================================================\nVideo Info: 360x640, 45.72s\nAnimation: curtain\nEncoder: h264_nvenc\nRunning FFmpeg...\n============================================================\nVideo generation failed!\nError: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767463587.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767026215_6952ae2754189.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767463596_69595aace6822.mp4\']\' returned non-zero exit status 2981409195.\n============================================================','2026-01-03 12:36:46','2026-01-03 12:36:46'),
(82,122,NULL,'Video generation failed for combined_video_1767463596_69595aace695b.mp4: ffmpeg version 2025-12-31-git-38e89fe502-full_build-www.gyan.dev Copyright (c) 2000-2025 the FFmpeg developers\n  built with gcc 15.2.0 (Rev8, Built by MSYS2 project)\n  configuration: --enable-gpl --enable-version3 --enable-static --disable-w32threads --disable-autodetect --enable-cairo --enable-fontconfig --enable-iconv --enable-gnutls --enable-lcms2 --enable-libxml2 --enable-gmp --enable-bzlib --enable-lzma --enable-libsnappy --enable-zlib --enable-librist --enable-libsrt --enable-libssh --enable-libzmq --enable-avisynth --enable-libbluray --enable-libcaca --enable-libdvdnav --enable-libdvdread --enable-sdl2 --enable-libaribb24 --enable-libaribcaption --enable-libdav1d --enable-libdavs2 --enable-libopenjpeg --enable-libquirc --enable-libuavs3d --enable-libxevd --enable-libzvbi --enable-liboapv --enable-libqrencode --enable-librav1e --enable-libsvtav1 --enable-libvvenc --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxavs2 --enable-libxeve --enable-libxvid --enable-libaom --enable-libjxl --enable-libsvtjpegxs --enable-libvpx --enable-mediafoundation --enable-libass --enable-frei0r --enable-libfreetype --enable-libfribidi --enable-libharfbuzz --enable-liblensfun --enable-libvidstab --enable-libvmaf --enable-libzimg --enable-amf --enable-cuda-llvm --enable-cuvid --enable-dxva2 --enable-d3d11va --enable-d3d12va --enable-ffnvcodec --enable-libvpl --enable-nvdec --enable-nvenc --enable-vaapi --enable-libshaderc --enable-vulkan --enable-libplacebo --enable-opencl --enable-libcdio --enable-openal --enable-libgme --enable-libmodplug --enable-libopenmpt --enable-libopencore-amrwb --enable-libmp3lame --enable-libshine --enable-libtheora --enable-libtwolame --enable-libvo-amrwbenc --enable-libcodec2 --enable-libilbc --enable-libgsm --enable-liblc3 --enable-libopencore-amrnb --enable-libopus --enable-libspeex --enable-libvorbis --enable-ladspa --enable-libbs2b --enable-libflite --enable-libmysofa --enable-librubberband --enable-libsoxr --enable-chromaprint --enable-whisper\n  libavutil      60. 21.102 / 60. 21.102\n  libavcodec     62. 23.102 / 62. 23.102\n  libavformat    62.  8.102 / 62.  8.102\n  libavdevice    62.  2.100 / 62.  2.100\n  libavfilter    11. 10.101 / 11. 10.101\n  libswscale      9.  3.100 /  9.  3.100\n  libswresample   6.  2.100 /  6.  2.100\nInput #0, mov,mp4,m4a,3gp,3g2,mj2, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767463587.mp4\':\n  Metadata:\n    major_brand     : mp42\n    minor_version   : 0\n    compatible_brands: mp42isom\n  Duration: 00:00:45.84, start: 0.000000, bitrate: 318 kb/s\n  Stream #0:0[0x1](und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p(tv, bt709, progressive), 360x640, 266 kb/s, 25 fps, 25 tbr, 12800 tbn, start 0.120000 (default)\n  Stream #0:1[0x2](und): Audio: aac (HE-AAC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 48 kb/s (default)\nInput #1, png_pipe, from \'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767276545_6956800113766.png\':\n  Duration: N/A, bitrate: N/A\n  Stream #1:0: Video: png, gray(pc, gbr/unknown/unknown), 360x360, 25 fps, 25 tbr, 25 tbn\nStream mapping:\n  Stream #0:0 (h264) -> overlay\n  Stream #1:0 (png) -> scale:default\n  overlay:default -> Stream #0:0 (h264_nvenc)\n  Stream #0:1 -> #0:1 (copy)\nPress [q] to stop, [?] for help\n[h264_nvenc @ 000001f93936d780] dl_fn->cuda_dl->cuInit(0) failed -> CUDA_ERROR_NO_DEVICE: no CUDA-capable device is detected\n[vost#0:0/h264_nvenc @ 000001f93936d200] [enc:h264_nvenc @ 000001f9397bfe00] Error while opening encoder - maybe incorrect parameters such as bit_rate, rate, width or height.\n[fc#0 @ 000001f9393597c0] Error sending frames to consumers: Unknown error occurred\n[fc#0 @ 000001f9393597c0] Task finished with error code: -1313558101 (Unknown error occurred)\n[fc#0 @ 000001f9393597c0] Terminating thread with return code -1313558101 (Unknown error occurred)\n[vost#0:0/h264_nvenc @ 000001f93936d200] [enc:h264_nvenc @ 000001f9397bfe00] Could not open encoder before EOF\n[vost#0:0/h264_nvenc @ 000001f93936d200] Task finished with error code: -22 (Invalid argument)\n[vost#0:0/h264_nvenc @ 000001f93936d200] Terminating thread with return code -22 (Invalid argument)\n[out#0/mp4 @ 000001f93939bd40] Nothing was written into output file, because at least one of its streams received no packets.\nframe=    0 fps=0.0 q=0.0 Lsize=       0KiB time=N/A bitrate=N/A speed=N/A elapsed=0:00:00.03\nConversion failed!\nERROR: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767463587.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767276545_6956800113766.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767463596_69595aace695b.mp4\']\' returned non-zero exit status 2981409195.\n============================================================\nVideo Generator Script\n============================================================\nBackground Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\background_video\\bg_video_1767463587.mp4\nTemplate Image: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img\\user_template\\user_template_1767276545_6956800113766.png\nOutput Video: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos\\generated_video\\combined_video_1767463596_69595aace695b.mp4\nAnimation Type: curtain\n============================================================\nVideo Info: 360x640, 45.72s\nAnimation: curtain\nEncoder: h264_nvenc\nRunning FFmpeg...\n============================================================\nVideo generation failed!\nError: Command \'[\'ffmpeg\', \'-y\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\background_video\\\\bg_video_1767463587.mp4\', \'-i\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\img\\\\user_template\\\\user_template_1767276545_6956800113766.png\', \'-filter_complex\', \"[1:v]scale=360:640,setsar=1,crop=\'iw*min(t,1.5)/1.5\':ih:\'(iw-iw*min(t,1.5)/1.5)/2\':0[ov];[0:v][ov]overlay=0:0:format=auto\", \'-c:a\', \'copy\', \'-shortest\', \'-c:v\', \'h264_nvenc\', \'-preset\', \'p4\', \'-rc\', \'vbr\', \'-cq\', \'24\', \'-b:v\', \'6M\', \'-maxrate\', \'9M\', \'-bufsize\', \'12M\', \'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\\\generated_video\\\\combined_video_1767463596_69595aace695b.mp4\']\' returned non-zero exit status 2981409195.\n============================================================','2026-01-03 12:36:46','2026-01-03 12:36:46'),
(83,129,NULL,'Customer 6: Customer template not found: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/user_template/user_template_1767026215_6952ae2754189.png','2026-01-07 11:58:25','2026-01-07 11:58:25'),
(84,130,NULL,'Customer 6: Customer template not found: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/user_template/user_template_1767026215_6952ae2754189.png','2026-01-07 12:02:32','2026-01-07 12:02:32'),
(85,131,NULL,'Customer 6: Customer template not found: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/user_template/user_template_1767026215_6952ae2754189.png','2026-01-07 12:12:17','2026-01-07 12:12:17'),
(86,132,NULL,'Customer 6: Customer template not found: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/user_template/user_template_1767026215_6952ae2754189.png','2026-01-07 12:17:13','2026-01-07 12:17:13'),
(87,133,NULL,'Customer 6: Customer template not found: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/user_template/user_template_1767026215_6952ae2754189.png','2026-01-07 12:28:09','2026-01-07 12:28:09'),
(88,134,NULL,'Customer 6: Customer template not found: D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/user_template/user_template_1767026215_6952ae2754189.png','2026-01-07 12:29:22','2026-01-07 12:29:22'),
(89,NULL,'Video Task Creation','No video data found in Tempstore','2026-01-09 06:10:27','2026-01-09 06:10:27'),
(90,NULL,'Video Task Creation','No video data found in Tempstore','2026-01-09 06:10:39','2026-01-09 06:10:39');
/*!40000 ALTER TABLE `errorlogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
INSERT  IGNORE INTO `failed_jobs` VALUES
(1,'512582c8-eaef-4684-8026-9983b382388c','database','video_cpu','{\"uuid\":\"512582c8-eaef-4684-8026-9983b382388c\",\"displayName\":\"App\\\\Jobs\\\\ProcessVideoTaskJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":3600,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\ProcessVideoTaskJob\",\"command\":\"O:28:\\\"App\\\\Jobs\\\\ProcessVideoTaskJob\\\":2:{s:6:\\\"taskId\\\";s:3:\\\"142\\\";s:5:\\\"queue\\\";s:9:\\\"video_cpu\\\";}\"}}','Illuminate\\Queue\\MaxAttemptsExceededException: App\\Jobs\\ProcessVideoTaskJob has been attempted too many times. in D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\MaxAttemptsExceededException.php:24\nStack trace:\n#0 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(785): Illuminate\\Queue\\MaxAttemptsExceededException::forJob()\n#1 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(519): Illuminate\\Queue\\Worker->maxAttemptsExceededException()\n#2 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(428): Illuminate\\Queue\\Worker->markJobAsFailedIfAlreadyExceedsMaxAttempts()\n#3 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(389): Illuminate\\Queue\\Worker->process()\n#4 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(176): Illuminate\\Queue\\Worker->runJob()\n#5 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(137): Illuminate\\Queue\\Worker->daemon()\n#6 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(120): Illuminate\\Queue\\Console\\WorkCommand->runWorker()\n#7 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#8 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(41): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#9 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(93): Illuminate\\Container\\Util::unwrapIfClosure()\n#10 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod()\n#11 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(662): Illuminate\\Container\\BoundMethod::call()\n#12 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call()\n#13 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\symfony\\console\\Command\\Command.php(326): Illuminate\\Console\\Command->execute()\n#14 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run()\n#15 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\symfony\\console\\Application.php(1096): Illuminate\\Console\\Command->run()\n#16 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\symfony\\console\\Application.php(324): Symfony\\Component\\Console\\Application->doRunCommand()\n#17 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\symfony\\console\\Application.php(175): Symfony\\Component\\Console\\Application->doRun()\n#18 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(201): Symfony\\Component\\Console\\Application->run()\n#19 D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\artisan(35): Illuminate\\Foundation\\Console\\Kernel->handle()\n#20 {main}','2026-01-09 11:51:29');
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generated_image`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_image`
--

LOCK TABLES `generated_image` WRITE;
/*!40000 ALTER TABLE `generated_image` DISABLE KEYS */;
INSERT  IGNORE INTO `generated_image` VALUES
(1,11,12,1,1,1,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765397966_6939d5ce1fc58.jpg','combined_image_1765397966_6939d5ce1fc58.jpg',1,'2025-12-10 14:51:32','jpg',NULL,'2025-12-10 14:49:26','2025-12-10 14:51:32'),
(2,10,11,1,2,2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765399508_6939dbd44b2ea.jpg','combined_image_1765399508_6939dbd44b2ea.jpg',1,'2025-12-11 04:31:47','jpg',NULL,'2025-12-10 15:15:08','2025-12-11 04:31:47'),
(3,10,11,2,2,3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765399508_6939dbd46f861.jpg','combined_image_1765399508_6939dbd46f861.jpg',1,'2025-12-11 04:31:47','jpg',NULL,'2025-12-10 15:15:08','2025-12-11 04:31:47'),
(4,14,15,1,2,2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765399621_6939dc45e11d5.jpg','combined_image_1765399621_6939dc45e11d5.jpg',1,'2025-12-10 15:17:31','jpg',NULL,'2025-12-10 15:17:01','2025-12-10 15:17:31'),
(5,14,15,2,2,3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765399622_6939dc4612efa.jpg','combined_image_1765399622_6939dc4612efa.jpg',1,'2025-12-10 15:17:32','jpg',NULL,'2025-12-10 15:17:02','2025-12-10 15:17:32'),
(6,15,16,1,1,1,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765446084_693a91c4ee529.jpg','combined_image_1765446084_693a91c4ee529.jpg',0,NULL,'jpg',NULL,'2025-12-11 04:11:24','2025-12-11 04:11:24'),
(7,16,17,1,2,2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765446202_693a923a5503a.jpg','combined_image_1765446202_693a923a5503a.jpg',1,'2025-12-11 04:17:53','jpg',NULL,'2025-12-11 04:13:22','2025-12-11 04:17:53'),
(8,16,17,2,2,3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765446202_693a923a745c8.jpg','combined_image_1765446202_693a923a745c8.jpg',1,'2025-12-11 04:17:54','jpg',NULL,'2025-12-11 04:13:22','2025-12-11 04:17:54'),
(9,18,19,1,1,1,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765453765_693aafc5797c2.jpg','combined_image_1765453765_693aafc5797c2.jpg',1,'2025-12-11 06:20:37','jpg',NULL,'2025-12-11 06:19:25','2025-12-11 06:20:37'),
(10,18,19,3,1,5,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765453765_693aafc5af674.jpg','combined_image_1765453765_693aafc5af674.jpg',1,'2025-12-11 06:20:38','jpg',NULL,'2025-12-11 06:19:25','2025-12-11 06:20:38'),
(11,17,18,3,3,4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765453771_693aafcb0d03f.jpg','combined_image_1765453771_693aafcb0d03f.jpg',1,'2025-12-11 06:20:40','jpg',NULL,'2025-12-11 06:19:31','2025-12-11 06:20:40'),
(12,19,20,3,1,6,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765632980_693d6bd41a2eb.jpg','combined_image_1765632980_693d6bd41a2eb.jpg',0,NULL,'jpg',NULL,'2025-12-13 08:06:20','2025-12-13 08:06:20'),
(13,19,20,2,1,7,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765632980_693d6bd442200.jpg','combined_image_1765632980_693d6bd442200.jpg',0,NULL,'jpg',NULL,'2025-12-13 08:06:20','2025-12-13 08:06:20'),
(14,50,59,2,4,14,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765793700_693fdfa4c6d1f.jpg','combined_image_1765793700_693fdfa4c6d1f.jpg',0,NULL,'jpg',NULL,'2025-12-15 04:45:00','2025-12-15 04:45:00'),
(15,51,60,2,4,14,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765793753_693fdfd9e2926.jpg','combined_image_1765793753_693fdfd9e2926.jpg',0,NULL,'jpg',NULL,'2025-12-15 04:45:53','2025-12-15 04:45:53'),
(16,51,61,2,4,14,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1765793754_693fdfda0ce7b.jpg','combined_image_1765793754_693fdfda0ce7b.jpg',0,NULL,'jpg',NULL,'2025-12-15 04:45:54','2025-12-15 04:45:54'),
(17,175,319,2,4,14,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/generated_image/combined_image_1768049875_69624cd3b6c58.jpg','combined_image_1768049875_69624cd3b6c58.jpg',0,NULL,'jpg',NULL,'2026-01-10 07:27:55','2026-01-10 07:27:55');
/*!40000 ALTER TABLE `generated_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generated_videos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `generated_videos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `taskid` int(11) NOT NULL,
  `beforeid` int(11) DEFAULT NULL,
  `customer_id` bigint(20) unsigned NOT NULL,
  `master_video_id` bigint(20) unsigned DEFAULT NULL,
  `user_video_id` bigint(20) unsigned DEFAULT NULL,
  `generated_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `generated_video` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `video_type` enum('portrait','landscape') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'portrait',
  `duration` int(11) DEFAULT NULL,
  `file_size` bigint(20) DEFAULT NULL COMMENT 'Size in bytes',
  `sent` tinyint(1) NOT NULL DEFAULT 0,
  `sent_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `taskid` (`taskid`),
  KEY `customer_id` (`customer_id`),
  KEY `master_video_id` (`master_video_id`),
  KEY `user_video_id` (`user_video_id`),
  CONSTRAINT `generated_videos_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=272 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_videos`
--

LOCK TABLES `generated_videos` WRITE;
/*!40000 ALTER TABLE `generated_videos` DISABLE KEYS */;
INSERT  IGNORE INTO `generated_videos` VALUES
(1,24,25,2,1,9,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765749416_693f32a8e62d9.mp4','combined_video_1765749416_693f32a8e62d9.mp4','thumb_combined_video_1765749416_693f32a8e62d9.jpg','landscape',15,556566,1,'2025-12-14 16:34:28','2025-12-14 16:27:07','2025-12-14 16:34:28'),
(2,25,26,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765750648_693f3778bb94e.mp4','combined_video_1765750648_693f3778bb94e.mp4','thumb_combined_video_1765750648_693f3778bb94e.jpg','landscape',15,560849,1,NULL,'2025-12-14 16:47:38','2026-01-02 10:26:07'),
(3,26,27,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765750658_693f378287cdb.mp4','combined_video_1765750658_693f378287cdb.mp4','thumb_combined_video_1765750658_693f378287cdb.jpg','landscape',15,562026,1,NULL,'2025-12-14 16:47:48','2026-01-02 10:26:07'),
(4,27,28,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765750668_693f378c3562f.mp4','combined_video_1765750668_693f378c3562f.mp4','thumb_combined_video_1765750668_693f378c3562f.jpg','landscape',15,561634,1,NULL,'2025-12-14 16:47:57','2026-01-02 10:26:07'),
(5,28,29,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765750677_693f379580c01.mp4','combined_video_1765750677_693f379580c01.mp4','thumb_combined_video_1765750677_693f379580c01.jpg','landscape',15,562404,1,NULL,'2025-12-14 16:48:06','2026-01-02 10:26:07'),
(6,28,30,2,1,9,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765750686_693f379ea73b1.mp4','combined_video_1765750686_693f379ea73b1.mp4','thumb_combined_video_1765750686_693f379ea73b1.jpg','landscape',15,556134,1,NULL,'2025-12-14 16:48:16','2026-01-02 10:26:07'),
(7,29,31,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765753005_693f40ad27a53.mp4','combined_video_1765753005_693f40ad27a53.mp4','thumb_combined_video_1765753005_693f40ad27a53.jpg','landscape',15,562903,1,NULL,'2025-12-14 17:26:57','2026-01-02 10:26:07'),
(8,29,32,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765753017_693f40b96cb04.mp4','combined_video_1765753017_693f40b96cb04.mp4','thumb_combined_video_1765753017_693f40b96cb04.jpg','landscape',15,563274,1,NULL,'2025-12-14 17:27:07','2026-01-02 10:26:07'),
(9,30,33,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765753027_693f40c3e759d.mp4','combined_video_1765753027_693f40c3e759d.mp4','thumb_combined_video_1765753027_693f40c3e759d.jpg','landscape',15,563763,1,NULL,'2025-12-14 17:27:18','2026-01-02 10:26:07'),
(10,32,35,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765753623_693f43170fb95.mp4','combined_video_1765753623_693f43170fb95.mp4','thumb_combined_video_1765753623_693f43170fb95.jpg','landscape',15,565035,1,NULL,'2025-12-14 17:37:34','2026-01-02 10:26:07'),
(11,31,34,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765753945_693f44598ce0e.mp4','combined_video_1765753945_693f44598ce0e.mp4','thumb_combined_video_1765753945_693f44598ce0e.jpg','landscape',15,560206,1,NULL,'2025-12-14 17:42:58','2026-01-02 10:26:07'),
(12,34,37,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765754112_693f45008f5b8.mp4','combined_video_1765754112_693f45008f5b8.mp4','thumb_combined_video_1765754112_693f45008f5b8.jpg','landscape',15,560921,1,NULL,'2025-12-14 17:45:49','2026-01-02 10:26:07'),
(13,35,38,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765754359_693f45f792cdc.mp4','combined_video_1765754359_693f45f792cdc.mp4','thumb_combined_video_1765754359_693f45f792cdc.jpg','landscape',15,562054,1,NULL,'2025-12-14 17:49:56','2026-01-02 10:26:07'),
(14,36,39,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765754661_693f4725278ea.mp4','combined_video_1765754661_693f4725278ea.mp4','thumb_combined_video_1765754661_693f4725278ea.jpg','landscape',15,562621,1,'2025-12-14 17:57:41','2025-12-14 17:54:56','2025-12-14 17:57:41'),
(15,36,39,1,2,11,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765754696_693f4748d8147.mp4','combined_video_1765754696_693f4748d8147.mp4','thumb_combined_video_1765754696_693f4748d8147.jpg','landscape',15,558030,1,'2025-12-14 17:57:40','2025-12-14 17:55:32','2025-12-14 17:57:40'),
(16,33,36,2,2,10,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765754732_693f476ca0013.mp4','combined_video_1765754732_693f476ca0013.mp4','thumb_combined_video_1765754732_693f476ca0013.jpg','landscape',15,563539,1,NULL,'2025-12-14 17:56:08','2026-01-02 10:26:07'),
(17,33,36,1,2,11,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765754768_693f4790b1fc7.mp4','combined_video_1765754768_693f4790b1fc7.mp4','thumb_combined_video_1765754768_693f4790b1fc7.jpg','landscape',15,554966,1,NULL,'2025-12-14 17:56:42','2026-01-02 10:26:07'),
(18,38,41,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765786828_693fc4cc02813.mp4','combined_video_1765786828_693fc4cc02813.mp4','thumb_combined_video_1765786828_693fc4cc02813.jpg','portrait',46,3395551,1,NULL,'2025-12-15 02:50:57','2026-01-02 10:26:07'),
(19,38,42,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765786857_693fc4e91cb3f.mp4','combined_video_1765786857_693fc4e91cb3f.mp4','thumb_combined_video_1765786857_693fc4e91cb3f.jpg','portrait',46,3393275,1,NULL,'2025-12-15 02:51:22','2026-01-02 10:26:07'),
(20,39,43,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765789454_693fcf0e2a602.mp4','combined_video_1765789454_693fcf0e2a602.mp4','thumb_combined_video_1765789454_693fcf0e2a602.jpg','portrait',46,3393536,1,NULL,'2025-12-15 03:34:39','2026-01-02 10:26:07'),
(21,40,44,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765789499_693fcf3b1b8ee.mp4','combined_video_1765789499_693fcf3b1b8ee.mp4','thumb_combined_video_1765789499_693fcf3b1b8ee.jpg','portrait',46,3393533,1,NULL,'2025-12-15 03:35:24','2026-01-02 10:26:07'),
(22,41,45,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765789655_693fcfd7a1110.mp4','combined_video_1765789655_693fcfd7a1110.mp4','thumb_combined_video_1765789655_693fcfd7a1110.jpg','portrait',46,3397605,1,NULL,'2025-12-15 03:38:02','2026-01-02 10:26:07'),
(23,41,46,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765789682_693fcff2b55b0.mp4','combined_video_1765789682_693fcff2b55b0.mp4','thumb_combined_video_1765789682_693fcff2b55b0.jpg','portrait',46,3392797,1,NULL,'2025-12-15 03:38:29','2026-01-02 10:26:07'),
(24,44,49,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765792262_693fda06a54be.mp4','combined_video_1765792262_693fda06a54be.mp4','thumb_combined_video_1765792262_693fda06a54be.jpg','portrait',46,3394452,1,NULL,'2025-12-15 04:21:28','2026-01-02 10:26:07'),
(25,45,50,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765792434_693fdab2c9361.mp4','combined_video_1765792434_693fdab2c9361.mp4','thumb_combined_video_1765792434_693fdab2c9361.jpg','portrait',46,3393355,1,NULL,'2025-12-15 04:24:21','2026-01-02 10:26:07'),
(26,45,51,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765792461_693fdacdebd21.mp4','combined_video_1765792461_693fdacdebd21.mp4','thumb_combined_video_1765792461_693fdacdebd21.jpg','portrait',46,3399152,1,NULL,'2025-12-15 04:24:49','2026-01-02 10:26:07'),
(27,45,52,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765792489_693fdae902801.mp4','combined_video_1765792489_693fdae902801.mp4','thumb_combined_video_1765792489_693fdae902801.jpg','portrait',46,3394194,1,NULL,'2025-12-15 04:25:17','2026-01-02 10:26:07'),
(28,46,53,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765792809_693fdc29b0936.mp4','combined_video_1765792809_693fdc29b0936.mp4','thumb_combined_video_1765792809_693fdc29b0936.jpg','portrait',46,3392936,1,NULL,'2025-12-15 04:30:35','2026-01-02 10:26:07'),
(29,46,54,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765792835_693fdc4387744.mp4','combined_video_1765792835_693fdc4387744.mp4','thumb_combined_video_1765792835_693fdc4387744.jpg','portrait',46,3455586,1,NULL,'2025-12-15 04:31:01','2026-01-02 10:26:07'),
(30,47,55,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765793098_693fdd4ac8edf.mp4','combined_video_1765793098_693fdd4ac8edf.mp4','thumb_combined_video_1765793098_693fdd4ac8edf.jpg','portrait',46,3430970,1,'2025-12-15 04:39:37','2025-12-15 04:35:23','2025-12-15 04:39:37'),
(31,48,56,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765793249_693fdde103fcf.mp4','combined_video_1765793249_693fdde103fcf.mp4','thumb_combined_video_1765793249_693fdde103fcf.jpg','portrait',46,3359163,1,'2025-12-15 04:39:36','2025-12-15 04:37:56','2025-12-15 04:39:36'),
(32,48,57,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765793276_693fddfcc8521.mp4','combined_video_1765793276_693fddfcc8521.mp4','thumb_combined_video_1765793276_693fddfcc8521.jpg','portrait',46,3359163,1,'2025-12-15 04:39:35','2025-12-15 04:38:26','2025-12-15 04:39:35'),
(33,49,58,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765793335_693fde376b22b.mp4','combined_video_1765793335_693fde376b22b.mp4','thumb_combined_video_1765793335_693fde376b22b.jpg','portrait',46,3487581,1,'2025-12-15 04:39:34','2025-12-15 04:39:25','2025-12-15 04:39:34'),
(34,42,47,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765794135_693fe157dfb1c.mp4','combined_video_1765794135_693fe157dfb1c.mp4','thumb_combined_video_1765794135_693fe157dfb1c.jpg','portrait',46,3396118,1,NULL,'2025-12-15 04:52:43','2026-01-02 10:26:07'),
(35,52,62,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765794698_693fe38a145f5.mp4','combined_video_1765794698_693fe38a145f5.mp4','thumb_combined_video_1765794698_693fe38a145f5.jpg','portrait',46,3359163,1,NULL,'2025-12-15 05:02:05','2026-01-02 10:26:07'),
(36,52,63,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765794725_693fe3a5a95a8.mp4','combined_video_1765794725_693fe3a5a95a8.mp4','thumb_combined_video_1765794725_693fe3a5a95a8.jpg','portrait',46,3430970,1,NULL,'2025-12-15 05:02:35','2026-01-02 10:26:07'),
(37,52,64,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765794755_693fe3c3197ca.mp4','combined_video_1765794755_693fe3c3197ca.mp4','thumb_combined_video_1765794755_693fe3c3197ca.jpg','portrait',46,3394422,1,NULL,'2025-12-15 05:03:02','2026-01-02 10:26:07'),
(38,52,65,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765794782_693fe3de2d88a.mp4','combined_video_1765794782_693fe3de2d88a.mp4','thumb_combined_video_1765794782_693fe3de2d88a.jpg','portrait',46,3359163,1,NULL,'2025-12-15 05:03:29','2026-01-02 10:26:07'),
(39,53,66,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795089_693fe51108d89.mp4','combined_video_1765795089_693fe51108d89.mp4','thumb_combined_video_1765795089_693fe51108d89.jpg','portrait',46,8027588,1,NULL,'2025-12-15 05:09:21','2026-01-02 10:26:07'),
(40,53,67,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795089_693fe51109139.mp4','combined_video_1765795089_693fe51109139.mp4','thumb_combined_video_1765795089_693fe51109139.jpg','portrait',46,8025647,1,NULL,'2025-12-15 05:09:21','2026-01-02 10:26:07'),
(41,53,68,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795089_693fe51109423.mp4','combined_video_1765795089_693fe51109423.mp4','thumb_combined_video_1765795089_693fe51109423.jpg','portrait',46,8027920,1,NULL,'2025-12-15 05:09:22','2026-01-02 10:26:07'),
(42,53,69,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795089_693fe51109679.mp4','combined_video_1765795089_693fe51109679.mp4','thumb_combined_video_1765795089_693fe51109679.jpg','portrait',46,7978585,1,NULL,'2025-12-15 05:09:22','2026-01-02 10:26:07'),
(43,55,74,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795593_693fe709d9a9c.mp4','combined_video_1765795593_693fe709d9a9c.mp4','thumb_combined_video_1765795593_693fe709d9a9c.jpg','portrait',46,8038071,1,NULL,'2025-12-15 05:17:52','2026-01-02 10:26:07'),
(44,55,75,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795593_693fe709d9eb9.mp4','combined_video_1765795593_693fe709d9eb9.mp4','thumb_combined_video_1765795593_693fe709d9eb9.jpg','portrait',46,8026454,1,NULL,'2025-12-15 05:17:52','2026-01-02 10:26:07'),
(45,55,76,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795593_693fe709da16d.mp4','combined_video_1765795593_693fe709da16d.mp4','thumb_combined_video_1765795593_693fe709da16d.jpg','portrait',46,8400117,1,NULL,'2025-12-15 05:17:52','2026-01-02 10:26:07'),
(46,55,77,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795593_693fe709da3bd.mp4','combined_video_1765795593_693fe709da3bd.mp4','thumb_combined_video_1765795593_693fe709da3bd.jpg','portrait',46,8027145,1,NULL,'2025-12-15 05:17:52','2026-01-02 10:26:07'),
(47,55,78,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765795593_693fe709da63e.mp4','combined_video_1765795593_693fe709da63e.mp4','thumb_combined_video_1765795593_693fe709da63e.jpg','portrait',46,8027185,1,NULL,'2025-12-15 05:17:53','2026-01-02 10:26:07'),
(48,56,79,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765803537_6940061162a55.mp4','combined_video_1765803537_6940061162a55.mp4','thumb_combined_video_1765803537_6940061162a55.jpg','portrait',46,8028357,1,NULL,'2025-12-15 07:30:14','2026-01-02 10:26:07'),
(49,56,80,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765803537_6940061162ea2.mp4','combined_video_1765803537_6940061162ea2.mp4','thumb_combined_video_1765803537_6940061162ea2.jpg','portrait',46,7978585,1,NULL,'2025-12-15 07:30:14','2026-01-02 10:26:07'),
(50,56,81,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765803537_6940061163193.mp4','combined_video_1765803537_6940061163193.mp4','thumb_combined_video_1765803537_6940061163193.jpg','portrait',46,8027965,1,NULL,'2025-12-15 07:30:14','2026-01-02 10:26:07'),
(51,56,82,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765803537_69400611634a4.mp4','combined_video_1765803537_69400611634a4.mp4','thumb_combined_video_1765803537_69400611634a4.jpg','portrait',46,8025164,1,NULL,'2025-12-15 07:30:14','2026-01-02 10:26:07'),
(52,56,83,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765803537_6940061163873.mp4','combined_video_1765803537_6940061163873.mp4','thumb_combined_video_1765803537_6940061163873.jpg','portrait',46,8038071,1,NULL,'2025-12-15 07:30:14','2026-01-02 10:26:07'),
(53,57,84,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765812212_694027f46cef1.mp4','combined_video_1765812212_694027f46cef1.mp4','thumb_combined_video_1765812212_694027f46cef1.jpg','portrait',46,8027576,1,NULL,'2025-12-15 09:54:10','2026-01-02 10:26:07'),
(54,57,85,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765812212_694027f46d2e2.mp4','combined_video_1765812212_694027f46d2e2.mp4','thumb_combined_video_1765812212_694027f46d2e2.jpg','portrait',46,8027772,1,NULL,'2025-12-15 09:54:10','2026-01-02 10:26:07'),
(55,57,86,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765812212_694027f46d5da.mp4','combined_video_1765812212_694027f46d5da.mp4','thumb_combined_video_1765812212_694027f46d5da.jpg','portrait',46,8029380,1,NULL,'2025-12-15 09:54:10','2026-01-02 10:26:07'),
(56,58,87,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765812689_694029d139d5f.mp4','combined_video_1765812689_694029d139d5f.mp4','thumb_combined_video_1765812689_694029d139d5f.jpg','portrait',46,8026977,1,NULL,'2025-12-15 10:01:53','2026-01-02 10:26:07'),
(57,58,88,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765812689_694029d13a4d4.mp4','combined_video_1765812689_694029d13a4d4.mp4','thumb_combined_video_1765812689_694029d13a4d4.jpg','portrait',46,8028262,1,NULL,'2025-12-15 10:01:53','2026-01-02 10:26:07'),
(58,60,94,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765820616_694048c89d3b5.mp4','combined_video_1765820616_694048c89d3b5.mp4','thumb_combined_video_1765820616_694048c89d3b5.jpg','portrait',46,7978585,1,NULL,'2025-12-15 12:14:13','2026-01-02 10:26:07'),
(59,60,95,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765820616_694048c89d6b7.mp4','combined_video_1765820616_694048c89d6b7.mp4','thumb_combined_video_1765820616_694048c89d6b7.jpg','portrait',46,8400117,1,NULL,'2025-12-15 12:14:14','2026-01-02 10:26:07'),
(60,60,96,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765820616_694048c89d913.mp4','combined_video_1765820616_694048c89d913.mp4','thumb_combined_video_1765820616_694048c89d913.jpg','portrait',46,7978585,1,NULL,'2025-12-15 12:14:14','2026-01-02 10:26:07'),
(61,59,89,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765820967_69404a27da96d.mp4','combined_video_1765820967_69404a27da96d.mp4','thumb_combined_video_1765820967_69404a27da96d.jpg','portrait',46,8027516,1,NULL,'2025-12-15 12:20:42','2026-01-02 10:26:07'),
(62,59,90,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765820967_69404a27dad5b.mp4','combined_video_1765820967_69404a27dad5b.mp4','thumb_combined_video_1765820967_69404a27dad5b.jpg','portrait',46,8027345,1,NULL,'2025-12-15 12:20:42','2026-01-02 10:26:07'),
(63,59,91,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765820967_69404a27db063.mp4','combined_video_1765820967_69404a27db063.mp4','thumb_combined_video_1765820967_69404a27db063.jpg','portrait',46,8027659,1,NULL,'2025-12-15 12:20:42','2026-01-02 10:26:07'),
(64,59,92,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765820967_69404a27db2cd.mp4','combined_video_1765820967_69404a27db2cd.mp4','thumb_combined_video_1765820967_69404a27db2cd.jpg','portrait',46,8038071,1,NULL,'2025-12-15 12:20:42','2026-01-02 10:26:07'),
(65,59,93,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765820967_69404a27db515.mp4','combined_video_1765820967_69404a27db515.mp4','thumb_combined_video_1765820967_69404a27db515.jpg','portrait',46,8027204,1,NULL,'2025-12-15 12:20:43','2026-01-02 10:26:07'),
(66,61,97,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765821363_69404bb3a10b2.mp4','combined_video_1765821363_69404bb3a10b2.mp4','thumb_combined_video_1765821363_69404bb3a10b2.jpg','portrait',46,8026097,1,NULL,'2025-12-15 12:26:48','2026-01-02 10:26:07'),
(67,61,98,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765821363_69404bb3a182f.mp4','combined_video_1765821363_69404bb3a182f.mp4','thumb_combined_video_1765821363_69404bb3a182f.jpg','portrait',46,8038071,1,NULL,'2025-12-15 12:26:48','2026-01-02 10:26:07'),
(68,61,99,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765821363_69404bb3a1ccf.mp4','combined_video_1765821363_69404bb3a1ccf.mp4','thumb_combined_video_1765821363_69404bb3a1ccf.jpg','portrait',46,8027916,1,NULL,'2025-12-15 12:26:48','2026-01-02 10:26:07'),
(69,62,100,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765821601_69404ca1604ff.mp4','combined_video_1765821601_69404ca1604ff.mp4','thumb_combined_video_1765821601_69404ca1604ff.jpg','portrait',46,7978585,1,NULL,'2025-12-15 12:30:31','2026-01-02 10:26:07'),
(70,62,101,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765821601_69404ca16097d.mp4','combined_video_1765821601_69404ca16097d.mp4','thumb_combined_video_1765821601_69404ca16097d.jpg','portrait',46,8400117,1,NULL,'2025-12-15 12:30:31','2026-01-02 10:26:07'),
(71,63,102,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765822291_69404f536974d.mp4','combined_video_1765822291_69404f536974d.mp4','thumb_combined_video_1765822291_69404f536974d.jpg','portrait',46,8026956,1,NULL,'2025-12-15 12:42:05','2026-01-02 10:26:07'),
(72,63,103,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765822291_69404f536a2a3.mp4','combined_video_1765822291_69404f536a2a3.mp4','thumb_combined_video_1765822291_69404f536a2a3.jpg','portrait',46,8400117,1,NULL,'2025-12-15 12:42:05','2026-01-02 10:26:07'),
(73,66,110,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','combined_video_1765823292_6940533cbc0c2.mp4','thumb_combined_video_1765823292_6940533cbc0c2.jpg','portrait',46,8038071,1,NULL,'2025-12-15 12:59:05','2026-01-02 10:26:07'),
(74,66,111,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765823292_6940533cbc769.mp4','combined_video_1765823292_6940533cbc769.mp4','thumb_combined_video_1765823292_6940533cbc769.jpg','portrait',46,8026728,1,NULL,'2025-12-15 12:59:05','2026-01-02 10:26:07'),
(75,66,112,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765823292_6940533cbcca1.mp4','combined_video_1765823292_6940533cbcca1.mp4','thumb_combined_video_1765823292_6940533cbcca1.jpg','portrait',46,8026993,1,NULL,'2025-12-15 12:59:05','2026-01-02 10:26:07'),
(76,66,113,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1765823292_6940533cbcfa7.mp4','combined_video_1765823292_6940533cbcfa7.mp4','thumb_combined_video_1765823292_6940533cbcfa7.jpg','portrait',46,8026646,1,NULL,'2025-12-15 12:59:05','2026-01-02 10:26:07'),
(77,67,114,4,4,15,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1766047611_6943bf7bd33b1.mp4','combined_video_1766047611_6943bf7bd33b1.mp4','thumb_combined_video_1766047611_6943bf7bd33b1.jpg','landscape',15,1194851,1,'2025-12-29 07:14:18','2025-12-18 03:17:05','2025-12-29 07:14:18'),
(78,67,115,4,4,15,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1766047611_6943bf7bd37c8.mp4','combined_video_1766047611_6943bf7bd37c8.mp4','thumb_combined_video_1766047611_6943bf7bd37c8.jpg','landscape',15,1125078,1,'2025-12-29 07:14:17','2025-12-18 03:17:05','2025-12-29 07:14:17'),
(79,67,116,4,4,15,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1766047611_6943bf7bd3ade.mp4','combined_video_1766047611_6943bf7bd3ade.mp4','thumb_combined_video_1766047611_6943bf7bd3ade.jpg','landscape',15,1236338,1,'2025-12-29 07:14:17','2025-12-18 03:17:06','2025-12-29 07:14:17'),
(80,68,117,2,3,13,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767024110_6952a5ee6bad7.mp4','combined_video_1767024110_6952a5ee6bad7.mp4','thumb_combined_video_1767024110_6952a5ee6bad7.jpg','portrait',46,8027632,1,NULL,'2025-12-29 10:32:27','2026-01-02 10:26:07'),
(82,69,118,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767026250_6952ae4a98f3b.mp4','combined_video_1767026250_6952ae4a98f3b.mp4','thumb_combined_video_1767026250_6952ae4a98f3b.jpg','landscape',46,2000891,1,'2025-12-29 11:37:42','2025-12-29 11:07:56','2025-12-29 11:37:42'),
(83,71,120,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','combined_video_1767110157_6953f60d8a531.mp4','thumb_combined_video_1767110157_6953f60d8a531.jpg','landscape',46,1301928,1,NULL,'2025-12-30 10:26:37','2026-01-02 10:26:07'),
(84,75,124,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767111379_6953fad32c320.mp4','combined_video_1767111379_6953fad32c320.mp4','thumb_combined_video_1767111379_6953fad32c320.jpg','landscape',46,1302693,1,'2025-12-30 10:51:48','2025-12-30 10:47:01','2025-12-30 10:51:48'),
(85,76,125,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767277254_695682c658f7a.mp4','combined_video_1767277254_695682c658f7a.mp4','thumb_combined_video_1767277254_695682c658f7a.jpg','landscape',46,1303012,1,'2026-01-01 09:34:52','2026-01-01 08:51:51','2026-01-01 09:34:52'),
(86,76,125,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767277254_695682c659012.mp4','combined_video_1767277254_695682c659012.mp4','thumb_combined_video_1767277254_695682c659012.jpg','landscape',46,1302761,1,'2026-01-01 09:34:27','2026-01-01 08:51:51','2026-01-02 10:26:07'),
(87,77,126,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767290913_6956b8211ae52.mp4','combined_video_1767290913_6956b8211ae52.mp4','thumb_combined_video_1767290913_6956b8211ae52.jpg','landscape',46,1302139,1,'2026-01-01 12:41:29','2026-01-01 12:39:29','2026-01-01 12:41:29'),
(88,77,126,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','combined_video_1767290913_6956b8211aed8.mp4','thumb_combined_video_1767290913_6956b8211aed8.jpg','landscape',46,1302374,1,'2026-01-01 12:41:26','2026-01-01 12:39:30','2026-01-02 10:26:07'),
(89,78,127,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9a999.mp4','combined_video_1767291565_6956baad9a999.mp4','thumb_combined_video_1767291565_6956baad9a999.jpg','landscape',46,936602,1,NULL,'2026-01-01 12:50:18','2026-01-02 10:26:07'),
(90,78,127,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','combined_video_1767291565_6956baad9aa18.mp4','thumb_combined_video_1767291565_6956baad9aa18.jpg','landscape',46,936602,1,'2026-01-02 03:08:07','2026-01-01 12:50:18','2026-01-02 03:08:07'),
(91,79,128,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d777e.mp4','combined_video_1767291719_6956bb47d777e.mp4','thumb_combined_video_1767291719_6956bb47d777e.jpg','landscape',46,1302736,1,NULL,'2026-01-01 12:52:54','2026-01-02 10:26:07'),
(92,79,128,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','combined_video_1767291719_6956bb47d7803.mp4','thumb_combined_video_1767291719_6956bb47d7803.jpg','landscape',46,1302373,1,'2026-01-02 03:07:47','2026-01-01 12:52:54','2026-01-02 03:07:47'),
(93,80,129,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767353042_6957aad241c72.mp4','combined_video_1767353042_6957aad241c72.mp4','thumb_combined_video_1767353042_6957aad241c72.jpg','landscape',46,1302242,1,'2026-01-02 06:02:51','2026-01-02 05:55:26','2026-01-02 06:02:51'),
(94,80,129,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767353042_6957aad241d79.mp4','combined_video_1767353042_6957aad241d79.mp4','thumb_combined_video_1767353042_6957aad241d79.jpg','landscape',46,1302510,1,'2026-01-02 10:43:29','2026-01-02 05:55:27','2026-01-02 10:43:29'),
(95,81,130,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767354779_6957b19b05122.mp4','combined_video_1767354779_6957b19b05122.mp4','thumb_combined_video_1767354779_6957b19b05122.jpg','landscape',46,1303119,1,'2026-01-02 10:43:28','2026-01-02 06:23:57','2026-01-02 10:43:28'),
(96,81,130,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767354779_6957b19b051a2.mp4','combined_video_1767354779_6957b19b051a2.mp4','thumb_combined_video_1767354779_6957b19b051a2.jpg','landscape',46,1303099,0,NULL,'2026-01-02 06:23:57','2026-01-02 06:23:57'),
(97,82,131,8,7,19,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767358345_6957bf8923366.mp4','combined_video_1767358345_6957bf8923366.mp4','thumb_combined_video_1767358345_6957bf8923366.jpg','landscape',18,1073787,1,'2026-01-02 07:26:34','2026-01-02 07:23:10','2026-01-02 07:26:34'),
(98,83,132,8,7,19,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','combined_video_1767366254_6957de6e558b1.mp4','thumb_combined_video_1767366254_6957de6e558b1.jpg','landscape',18,10825189,1,'2026-01-02 10:47:09','2026-01-02 09:35:09','2026-01-02 10:47:09'),
(99,85,134,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767375080_695800e836477.mp4','combined_video_1767375080_695800e836477.mp4','thumb_combined_video_1767375080_695800e836477.jpg','landscape',46,1890435,0,NULL,'2026-01-02 12:02:20','2026-01-02 12:02:20'),
(100,85,134,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767375080_695800e8364fc.mp4','combined_video_1767375080_695800e8364fc.mp4','thumb_combined_video_1767375080_695800e8364fc.jpg','landscape',46,1887619,0,NULL,'2026-01-02 12:02:20','2026-01-02 12:02:20'),
(101,84,133,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767375082_695800ea396e6.mp4','combined_video_1767375082_695800ea396e6.mp4','thumb_combined_video_1767375082_695800ea396e6.jpg','landscape',46,1891672,0,NULL,'2026-01-02 12:02:21','2026-01-02 12:02:21'),
(102,84,133,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767375082_695800ea39765.mp4','combined_video_1767375082_695800ea39765.mp4','thumb_combined_video_1767375082_695800ea39765.jpg','landscape',46,1891246,0,NULL,'2026-01-02 12:02:21','2026-01-02 12:02:21'),
(111,90,143,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377148_695808fc00219.mp4','combined_video_1767377148_695808fc00219.mp4','thumb_combined_video_1767377148_695808fc00219.jpg','landscape',46,1889102,0,NULL,'2026-01-02 12:36:13','2026-01-02 12:36:13'),
(112,90,143,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377148_695808fc0029e.mp4','combined_video_1767377148_695808fc0029e.mp4','thumb_combined_video_1767377148_695808fc0029e.jpg','landscape',46,1888151,0,NULL,'2026-01-02 12:36:37','2026-01-02 12:36:37'),
(113,90,144,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377148_695808fc005ca.mp4','combined_video_1767377148_695808fc005ca.mp4','thumb_combined_video_1767377148_695808fc005ca.jpg','landscape',46,1461496,0,NULL,'2026-01-02 12:37:00','2026-01-02 12:37:00'),
(114,90,144,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377148_695808fc005fc.mp4','combined_video_1767377148_695808fc005fc.mp4','thumb_combined_video_1767377148_695808fc005fc.jpg','landscape',46,1461496,0,NULL,'2026-01-02 12:37:23','2026-01-02 12:37:23'),
(115,91,145,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377441_69580a21d1db2.mp4','combined_video_1767377441_69580a21d1db2.mp4','thumb_combined_video_1767377441_69580a21d1db2.jpg','landscape',46,1888656,0,NULL,'2026-01-02 12:41:23','2026-01-02 12:41:23'),
(116,91,145,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377441_69580a21d1e33.mp4','combined_video_1767377441_69580a21d1e33.mp4','thumb_combined_video_1767377441_69580a21d1e33.jpg','landscape',46,1887846,0,NULL,'2026-01-02 12:41:23','2026-01-02 12:41:23'),
(117,91,146,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377441_69580a21d20e1.mp4','combined_video_1767377441_69580a21d20e1.mp4','thumb_combined_video_1767377441_69580a21d20e1.jpg','landscape',46,1402545,0,NULL,'2026-01-02 12:41:29','2026-01-02 12:41:29'),
(118,91,146,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377441_69580a21d2111.mp4','combined_video_1767377441_69580a21d2111.mp4','thumb_combined_video_1767377441_69580a21d2111.jpg','landscape',46,1402545,0,NULL,'2026-01-02 12:41:52','2026-01-02 12:41:52'),
(119,92,148,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377594_69580ababf127.mp4','combined_video_1767377594_69580ababf127.mp4','thumb_combined_video_1767377594_69580ababf127.jpg','landscape',46,1277656,0,NULL,'2026-01-02 12:44:05','2026-01-02 12:44:05'),
(120,92,148,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377594_69580ababf158.mp4','combined_video_1767377594_69580ababf158.mp4','thumb_combined_video_1767377594_69580ababf158.jpg','landscape',46,1277656,0,NULL,'2026-01-02 12:44:05','2026-01-02 12:44:05'),
(121,92,147,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377594_69580ababedd7.mp4','combined_video_1767377594_69580ababedd7.mp4','thumb_combined_video_1767377594_69580ababedd7.jpg','landscape',46,1402545,0,NULL,'2026-01-02 12:44:11','2026-01-02 12:44:11'),
(122,92,147,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767377594_69580ababee50.mp4','combined_video_1767377594_69580ababee50.mp4','thumb_combined_video_1767377594_69580ababee50.jpg','landscape',46,1402545,0,NULL,'2026-01-02 12:44:11','2026-01-02 12:44:11'),
(123,93,149,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767380406_695815b6367c5.mp4','combined_video_1767380406_695815b6367c5.mp4','thumb_combined_video_1767380406_695815b6367c5.jpg','landscape',46,1888513,0,NULL,'2026-01-02 13:31:24','2026-01-02 13:31:24'),
(124,93,149,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767380406_695815b636839.mp4','combined_video_1767380406_695815b636839.mp4','thumb_combined_video_1767380406_695815b636839.jpg','landscape',46,1890405,0,NULL,'2026-01-02 13:31:53','2026-01-02 13:31:53'),
(125,93,150,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767380406_695815b636ace.mp4','combined_video_1767380406_695815b636ace.mp4','thumb_combined_video_1767380406_695815b636ace.jpg','landscape',46,1888968,0,NULL,'2026-01-02 13:31:58','2026-01-02 13:31:58'),
(126,93,150,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767380406_695815b636afb.mp4','combined_video_1767380406_695815b636afb.mp4','thumb_combined_video_1767380406_695815b636afb.jpg','landscape',46,1889561,0,NULL,'2026-01-02 13:32:01','2026-01-02 13:32:01'),
(127,94,152,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767380804_69581744cd536.mp4','combined_video_1767380804_69581744cd536.mp4','thumb_combined_video_1767380804_69581744cd536.jpg','landscape',46,1889675,0,NULL,'2026-01-02 13:38:10','2026-01-02 13:38:10'),
(128,94,151,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767380804_69581744cd19e.mp4','combined_video_1767380804_69581744cd19e.mp4','thumb_combined_video_1767380804_69581744cd19e.jpg','landscape',46,1202827,0,NULL,'2026-01-02 13:42:39','2026-01-02 13:42:39'),
(129,94,151,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767380804_69581744cd224.mp4','combined_video_1767380804_69581744cd224.mp4','thumb_combined_video_1767380804_69581744cd224.jpg','landscape',46,1202827,0,NULL,'2026-01-02 13:42:39','2026-01-02 13:42:39'),
(130,94,152,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767380804_69581744cd4fd.mp4','combined_video_1767380804_69581744cd4fd.mp4','thumb_combined_video_1767380804_69581744cd4fd.jpg','landscape',46,1889269,0,NULL,'2026-01-02 13:42:41','2026-01-02 13:42:41'),
(131,95,153,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381076_6958185462417.mp4','combined_video_1767381076_6958185462417.mp4','thumb_combined_video_1767381076_6958185462417.jpg','landscape',46,1402545,0,NULL,'2026-01-02 13:42:52','2026-01-02 13:42:52'),
(132,95,154,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381076_6958185462a0e.mp4','combined_video_1767381076_6958185462a0e.mp4','thumb_combined_video_1767381076_6958185462a0e.jpg','landscape',46,1888615,0,NULL,'2026-01-02 13:43:45','2026-01-02 13:43:45'),
(133,95,154,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381076_6958185462a4c.mp4','combined_video_1767381076_6958185462a4c.mp4','thumb_combined_video_1767381076_6958185462a4c.jpg','landscape',46,1888825,0,NULL,'2026-01-02 13:43:46','2026-01-02 13:43:46'),
(134,95,153,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381076_69581854624a2.mp4','combined_video_1767381076_69581854624a2.mp4','thumb_combined_video_1767381076_69581854624a2.jpg','landscape',46,1402545,0,NULL,'2026-01-02 13:43:51','2026-01-02 13:43:51'),
(135,96,155,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381517_69581a0d8ac67.mp4','combined_video_1767381517_69581a0d8ac67.mp4','thumb_combined_video_1767381517_69581a0d8ac67.jpg','landscape',46,1472694,0,NULL,'2026-01-02 13:51:06','2026-01-02 13:51:06'),
(136,96,155,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381517_69581a0d8ace6.mp4','combined_video_1767381517_69581a0d8ace6.mp4','thumb_combined_video_1767381517_69581a0d8ace6.jpg','landscape',46,1472694,0,NULL,'2026-01-02 13:51:06','2026-01-02 13:51:06'),
(137,96,156,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381517_69581a0d8b08f.mp4','combined_video_1767381517_69581a0d8b08f.mp4','thumb_combined_video_1767381517_69581a0d8b08f.jpg','landscape',46,1888630,0,NULL,'2026-01-02 13:51:07','2026-01-02 13:51:07'),
(138,96,156,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381517_69581a0d8b060.mp4','combined_video_1767381517_69581a0d8b060.mp4','thumb_combined_video_1767381517_69581a0d8b060.jpg','landscape',46,1889448,0,NULL,'2026-01-02 13:51:07','2026-01-02 13:51:07'),
(139,97,158,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381751_69581af7d2e66.mp4','combined_video_1767381751_69581af7d2e66.mp4','thumb_combined_video_1767381751_69581af7d2e66.jpg','landscape',46,1510048,0,NULL,'2026-01-02 13:53:47','2026-01-02 13:53:47'),
(140,97,158,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381751_69581af7d2ea5.mp4','combined_video_1767381751_69581af7d2ea5.mp4','thumb_combined_video_1767381751_69581af7d2ea5.jpg','landscape',46,1510048,0,NULL,'2026-01-02 13:53:48','2026-01-02 13:53:48'),
(141,97,157,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381751_69581af7d28dd.mp4','combined_video_1767381751_69581af7d28dd.mp4','thumb_combined_video_1767381751_69581af7d28dd.jpg','landscape',46,1888502,0,NULL,'2026-01-02 13:53:48','2026-01-02 13:53:48'),
(142,97,157,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767381751_69581af7d2986.mp4','combined_video_1767381751_69581af7d2986.mp4','thumb_combined_video_1767381751_69581af7d2986.jpg','landscape',46,1889186,0,NULL,'2026-01-02 13:53:48','2026-01-02 13:53:48'),
(143,98,159,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767382460_69581dbcbf881.mp4','combined_video_1767382460_69581dbcbf881.mp4','thumb_combined_video_1767382460_69581dbcbf881.jpg','landscape',46,1888993,0,NULL,'2026-01-02 14:06:13','2026-01-02 14:06:13'),
(144,98,159,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767382460_69581dbcbf800.mp4','combined_video_1767382460_69581dbcbf800.mp4','thumb_combined_video_1767382460_69581dbcbf800.jpg','landscape',46,1888839,0,NULL,'2026-01-02 14:06:14','2026-01-02 14:06:14'),
(145,98,160,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767382460_69581dbcbfbe3.mp4','combined_video_1767382460_69581dbcbfbe3.mp4','thumb_combined_video_1767382460_69581dbcbfbe3.jpg','landscape',46,1510048,0,NULL,'2026-01-02 14:06:15','2026-01-02 14:06:15'),
(146,98,160,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767382460_69581dbcbfbb2.mp4','combined_video_1767382460_69581dbcbfbb2.mp4','thumb_combined_video_1767382460_69581dbcbfbb2.jpg','landscape',46,1510048,0,NULL,'2026-01-02 14:06:15','2026-01-02 14:06:15'),
(147,99,161,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767386992_69582f70f0472.mp4','combined_video_1767386992_69582f70f0472.mp4','thumb_combined_video_1767386992_69582f70f0472.jpg','landscape',46,1890332,0,NULL,'2026-01-02 15:21:22','2026-01-02 15:21:22'),
(148,99,162,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767386992_69582f70f06fc.mp4','combined_video_1767386992_69582f70f06fc.mp4','thumb_combined_video_1767386992_69582f70f06fc.jpg','landscape',46,1461496,0,NULL,'2026-01-02 15:21:22','2026-01-02 15:21:22'),
(149,99,162,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767386992_69582f70f0729.mp4','combined_video_1767386992_69582f70f0729.mp4','thumb_combined_video_1767386992_69582f70f0729.jpg','landscape',46,1461496,0,NULL,'2026-01-02 15:21:22','2026-01-02 15:21:22'),
(150,99,161,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767386992_69582f70f03fa.mp4','combined_video_1767386992_69582f70f03fa.mp4','thumb_combined_video_1767386992_69582f70f03fa.jpg','landscape',46,1889824,0,NULL,'2026-01-02 15:21:22','2026-01-02 15:21:22'),
(151,100,164,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767387249_695830712ac9d.mp4','combined_video_1767387249_695830712ac9d.mp4','thumb_combined_video_1767387249_695830712ac9d.jpg','landscape',46,1344583,0,NULL,'2026-01-02 15:26:29','2026-01-02 15:26:29'),
(152,100,164,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767387249_695830712ac72.mp4','combined_video_1767387249_695830712ac72.mp4','thumb_combined_video_1767387249_695830712ac72.jpg','landscape',46,1344583,0,NULL,'2026-01-02 15:26:30','2026-01-02 15:26:30'),
(153,100,163,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767387249_695830712a93e.mp4','combined_video_1767387249_695830712a93e.mp4','thumb_combined_video_1767387249_695830712a93e.jpg','landscape',46,1890072,0,NULL,'2026-01-02 15:26:30','2026-01-02 15:26:30'),
(154,100,163,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767387249_695830712a9b9.mp4','combined_video_1767387249_695830712a9b9.mp4','thumb_combined_video_1767387249_695830712a9b9.jpg','landscape',46,1888633,0,NULL,'2026-01-02 15:26:30','2026-01-02 15:26:30'),
(155,101,165,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767387909_6958330568fe8.mp4','combined_video_1767387909_6958330568fe8.mp4','thumb_combined_video_1767387909_6958330568fe8.jpg','landscape',46,1890166,0,NULL,'2026-01-02 15:35:40','2026-01-02 15:35:40'),
(156,101,165,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767387909_6958330568f62.mp4','combined_video_1767387909_6958330568f62.mp4','thumb_combined_video_1767387909_6958330568f62.jpg','landscape',46,1891316,0,NULL,'2026-01-02 15:35:40','2026-01-02 15:35:40'),
(157,115,189,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767460548_69594ec4ac72f.mp4','combined_video_1767460548_69594ec4ac72f.mp4','thumb_combined_video_1767460548_69594ec4ac72f.jpg','landscape',46,706444,0,NULL,'2026-01-03 11:46:13','2026-01-03 11:46:13'),
(158,115,189,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767460548_69594ec4ac565.mp4','combined_video_1767460548_69594ec4ac565.mp4','thumb_combined_video_1767460548_69594ec4ac565.jpg','landscape',46,706444,0,NULL,'2026-01-03 11:46:13','2026-01-03 11:46:13'),
(159,116,190,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767460959_6959505f3a0cb.mp4','combined_video_1767460959_6959505f3a0cb.mp4','thumb_combined_video_1767460959_6959505f3a0cb.jpg','landscape',46,419714,0,NULL,'2026-01-03 11:52:44','2026-01-03 11:52:44'),
(160,116,190,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767460959_6959505f39f59.mp4','combined_video_1767460959_6959505f39f59.mp4','thumb_combined_video_1767460959_6959505f39f59.jpg','landscape',46,419714,0,NULL,'2026-01-03 11:52:44','2026-01-03 11:52:44'),
(161,117,191,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767461020_6959509cde50a.mp4','combined_video_1767461020_6959509cde50a.mp4','thumb_combined_video_1767461020_6959509cde50a.jpg','landscape',46,419714,0,NULL,'2026-01-03 11:54:35','2026-01-03 11:54:35'),
(162,117,191,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767461020_6959509cde48b.mp4','combined_video_1767461020_6959509cde48b.mp4','thumb_combined_video_1767461020_6959509cde48b.jpg','landscape',46,419714,0,NULL,'2026-01-03 11:54:35','2026-01-03 11:54:35'),
(163,118,192,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767461163_6959512bce19c.mp4','combined_video_1767461163_6959512bce19c.mp4','thumb_combined_video_1767461163_6959512bce19c.jpg','landscape',46,419714,0,NULL,'2026-01-03 11:56:18','2026-01-03 11:56:18'),
(164,118,192,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767461163_6959512bce3cc.mp4','combined_video_1767461163_6959512bce3cc.mp4','thumb_combined_video_1767461163_6959512bce3cc.jpg','landscape',46,419714,0,NULL,'2026-01-03 11:56:19','2026-01-03 11:56:19'),
(165,119,193,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767462389_695955f57c175.mp4','combined_video_1767462389_695955f57c175.mp4','thumb_combined_video_1767462389_695955f57c175.jpg','landscape',46,419714,0,NULL,'2026-01-03 12:16:50','2026-01-03 12:16:50'),
(166,119,193,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767462389_695955f57c25e.mp4','combined_video_1767462389_695955f57c25e.mp4','thumb_combined_video_1767462389_695955f57c25e.jpg','landscape',46,419714,0,NULL,'2026-01-03 12:16:50','2026-01-03 12:16:50'),
(167,123,197,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767465356_6959618cbd869.mp4','combined_video_1767465356_6959618cbd869.mp4','thumb_combined_video_1767465356_6959618cbd869.jpg','landscape',46,634810,0,NULL,'2026-01-03 13:06:19','2026-01-03 13:06:19'),
(168,123,197,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767465356_6959618cbd738.mp4','combined_video_1767465356_6959618cbd738.mp4','thumb_combined_video_1767465356_6959618cbd738.jpg','landscape',46,634810,0,NULL,'2026-01-03 13:06:19','2026-01-03 13:06:19'),
(169,124,198,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767465466_695961fa82cc6.mp4','combined_video_1767465466_695961fa82cc6.mp4','thumb_combined_video_1767465466_695961fa82cc6.jpg','landscape',46,2016402,0,NULL,'2026-01-03 13:08:32','2026-01-03 13:08:32'),
(170,124,198,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767465466_695961fa82c3c.mp4','combined_video_1767465466_695961fa82c3c.mp4','thumb_combined_video_1767465466_695961fa82c3c.jpg','landscape',46,1996028,0,NULL,'2026-01-03 13:08:32','2026-01-03 13:08:32'),
(171,128,202,6,6,17,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767466306_695965425dec2.mp4','combined_video_1767466306_695965425dec2.mp4','thumb_combined_video_1767466306_695965425dec2.jpg','landscape',46,2027101,0,NULL,'2026-01-03 13:22:40','2026-01-03 13:22:40'),
(172,128,202,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767466306_695965425df6c.mp4','combined_video_1767466306_695965425df6c.mp4','thumb_combined_video_1767466306_695965425df6c.jpg','landscape',46,2028490,0,NULL,'2026-01-03 13:22:40','2026-01-03 13:22:40'),
(173,134,208,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767808762_695e9efa077b0.mp4','combined_video_1767808762_695e9efa077b0.mp4','thumb_combined_video_1767808762_695e9efa077b0.jpg','landscape',NULL,NULL,0,NULL,'2026-01-07 12:41:18','2026-01-07 12:41:18'),
(174,135,209,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767810079_695ea41f1e54d.mp4','combined_video_1767810079_695ea41f1e54d.mp4','thumb_combined_video_1767810079_695ea41f1e54d.jpg','landscape',NULL,NULL,0,NULL,'2026-01-07 12:55:19','2026-01-07 12:55:19'),
(175,135,209,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767810079_695ea41f1e73d.mp4','combined_video_1767810079_695ea41f1e73d.mp4','thumb_combined_video_1767810079_695ea41f1e73d.jpg','landscape',NULL,NULL,0,NULL,'2026-01-07 12:55:19','2026-01-07 12:55:19'),
(176,136,211,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767872426_695f97aa1f4b1.mp4','combined_video_1767872426_695f97aa1f4b1.mp4','thumb_combined_video_1767872426_695f97aa1f4b1.jpg','landscape',46,8518540,0,NULL,'2026-01-08 06:11:16','2026-01-08 06:11:16'),
(177,136,210,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767872426_695f97aa1db3b.mp4','combined_video_1767872426_695f97aa1db3b.mp4','thumb_combined_video_1767872426_695f97aa1db3b.jpg','landscape',46,8364986,0,NULL,'2026-01-08 06:11:16','2026-01-08 06:11:16'),
(178,136,210,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767872426_695f97aa1dc97.mp4','combined_video_1767872426_695f97aa1dc97.mp4','thumb_combined_video_1767872426_695f97aa1dc97.jpg','landscape',46,8507867,0,NULL,'2026-01-08 06:11:16','2026-01-08 06:11:16'),
(179,136,211,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767872426_695f97aa1f408.mp4','combined_video_1767872426_695f97aa1f408.mp4','thumb_combined_video_1767872426_695f97aa1f408.jpg','landscape',46,634810,0,NULL,'2026-01-08 06:11:16','2026-01-08 06:11:16'),
(180,150,227,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767983005_6961479d7a143.mp4','combined_video_1767983005_6961479d7a143.mp4','thumb_combined_video_1767983005_6961479d7a143.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 12:54:11','2026-01-09 12:54:11'),
(181,150,227,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767983005_6961479d7a1d6.mp4','combined_video_1767983005_6961479d7a1d6.mp4','thumb_combined_video_1767983005_6961479d7a1d6.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 12:54:11','2026-01-09 12:54:11'),
(182,151,228,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767983213_6961486dbcebb.mp4','combined_video_1767983213_6961486dbcebb.mp4','thumb_combined_video_1767983213_6961486dbcebb.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 12:57:49','2026-01-09 12:57:49'),
(183,151,228,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767983213_6961486dbcfc8.mp4','combined_video_1767983213_6961486dbcfc8.mp4','thumb_combined_video_1767983213_6961486dbcfc8.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 12:57:49','2026-01-09 12:57:49'),
(184,152,229,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767983560_696149c830292.mp4','combined_video_1767983560_696149c830292.mp4','thumb_combined_video_1767983560_696149c830292.jpg','landscape',46,8364986,0,NULL,'2026-01-09 13:02:48','2026-01-09 13:02:48'),
(185,152,229,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767983560_696149c830330.mp4','combined_video_1767983560_696149c830330.mp4','thumb_combined_video_1767983560_696149c830330.jpg','landscape',46,8507867,0,NULL,'2026-01-09 13:02:48','2026-01-09 13:02:48'),
(186,153,230,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767983683_69614a43e2547.mp4','combined_video_1767983683_69614a43e2547.mp4','thumb_combined_video_1767983683_69614a43e2547.jpg','landscape',46,8364986,0,NULL,'2026-01-09 13:04:49','2026-01-09 13:04:49'),
(187,153,230,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767983683_69614a43e25ea.mp4','combined_video_1767983683_69614a43e25ea.mp4','thumb_combined_video_1767983683_69614a43e25ea.jpg','landscape',46,8507867,0,NULL,'2026-01-09 13:04:50','2026-01-09 13:04:50'),
(188,154,231,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767983773_69614a9d21868.mp4','combined_video_1767983773_69614a9d21868.mp4','thumb_combined_video_1767983773_69614a9d21868.jpg','landscape',46,8364986,0,NULL,'2026-01-09 13:06:18','2026-01-09 13:06:18'),
(189,154,231,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767983773_69614a9d2190d.mp4','combined_video_1767983773_69614a9d2190d.mp4','thumb_combined_video_1767983773_69614a9d2190d.jpg','landscape',46,8507867,0,NULL,'2026-01-09 13:06:21','2026-01-09 13:06:21'),
(190,155,232,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767983816_69614ac8a4ce6.mp4','combined_video_1767983816_69614ac8a4ce6.mp4','thumb_combined_video_1767983816_69614ac8a4ce6.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:07:47','2026-01-09 13:07:47'),
(191,155,232,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767983816_69614ac8a4ddf.mp4','combined_video_1767983816_69614ac8a4ddf.mp4','thumb_combined_video_1767983816_69614ac8a4ddf.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:07:47','2026-01-09 13:07:47'),
(192,157,239,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767985005_69614f6dd6652.mp4','combined_video_1767985005_69614f6dd6652.mp4','thumb_combined_video_1767985005_69614f6dd6652.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:28:11','2026-01-09 13:28:11'),
(193,157,239,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767985005_69614f6dd66bc.mp4','combined_video_1767985005_69614f6dd66bc.mp4','thumb_combined_video_1767985005_69614f6dd66bc.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:28:11','2026-01-09 13:28:11'),
(194,157,240,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767985005_69614f6dd6ac6.mp4','combined_video_1767985005_69614f6dd6ac6.mp4','thumb_combined_video_1767985005_69614f6dd6ac6.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:28:11','2026-01-09 13:28:11'),
(195,157,240,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767985005_69614f6dd6b02.mp4','combined_video_1767985005_69614f6dd6b02.mp4','thumb_combined_video_1767985005_69614f6dd6b02.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:28:11','2026-01-09 13:28:11'),
(196,157,241,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767985005_69614f6dd6f26.mp4','combined_video_1767985005_69614f6dd6f26.mp4','thumb_combined_video_1767985005_69614f6dd6f26.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:28:11','2026-01-09 13:28:11'),
(197,157,241,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767985005_69614f6dd6f7f.mp4','combined_video_1767985005_69614f6dd6f7f.mp4','thumb_combined_video_1767985005_69614f6dd6f7f.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:28:11','2026-01-09 13:28:11'),
(198,160,256,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767985974_69615336e623c.mp4','combined_video_1767985974_69615336e623c.mp4','thumb_combined_video_1767985974_69615336e623c.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:43:25','2026-01-09 13:43:25'),
(199,160,256,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767985974_69615336e62e0.mp4','combined_video_1767985974_69615336e62e0.mp4','thumb_combined_video_1767985974_69615336e62e0.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:43:25','2026-01-09 13:43:25'),
(200,140,216,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767959024_6960e9f0b10bb.mp4','combined_video_1767959024_6960e9f0b10bb.mp4','thumb_combined_video_1767959024_6960e9f0b10bb.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:57:05','2026-01-09 13:57:05'),
(201,140,216,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767959024_6960e9f0b11e3.mp4','combined_video_1767959024_6960e9f0b11e3.mp4','thumb_combined_video_1767959024_6960e9f0b11e3.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 13:57:05','2026-01-09 13:57:05'),
(202,162,265,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767987579_6961597b06fcc.mp4','combined_video_1767987579_6961597b06fcc.mp4','thumb_combined_video_1767987579_6961597b06fcc.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:11:19','2026-01-09 14:11:19'),
(203,162,265,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767987579_6961597b07063.mp4','combined_video_1767987579_6961597b07063.mp4','thumb_combined_video_1767987579_6961597b07063.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:11:19','2026-01-09 14:11:19'),
(204,162,266,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767987579_6961597b0746d.mp4','combined_video_1767987579_6961597b0746d.mp4','thumb_combined_video_1767987579_6961597b0746d.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:11:19','2026-01-09 14:11:19'),
(205,162,266,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767987579_6961597b074a3.mp4','combined_video_1767987579_6961597b074a3.mp4','thumb_combined_video_1767987579_6961597b074a3.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:11:19','2026-01-09 14:11:19'),
(206,162,267,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767987579_6961597b077c7.mp4','combined_video_1767987579_6961597b077c7.mp4','thumb_combined_video_1767987579_6961597b077c7.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:11:19','2026-01-09 14:11:19'),
(207,162,267,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767987579_6961597b077fb.mp4','combined_video_1767987579_6961597b077fb.mp4','thumb_combined_video_1767987579_6961597b077fb.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:11:19','2026-01-09 14:11:19'),
(208,162,268,7,6,18,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767987579_6961597b07af0.mp4','combined_video_1767987579_6961597b07af0.mp4','thumb_combined_video_1767987579_6961597b07af0.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:11:20','2026-01-09 14:11:20'),
(209,162,268,6,6,20,'D:\\\\xamp\\\\htdocs\\\\imgen\\\\public_html\\\\public_html\\\\public\\\\videos\\/generated_video\\/combined_video_1767987579_6961597b07b21.mp4','combined_video_1767987579_6961597b07b21.mp4','thumb_combined_video_1767987579_6961597b07b21.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:11:20','2026-01-09 14:11:20'),
(210,165,282,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8ceba.mp4','combined_video_1767988650_69615daa8ceba.mp4','thumb_combined_video_1767988650_69615daa8ceba.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(211,165,282,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8d084.mp4','combined_video_1767988650_69615daa8d084.mp4','thumb_combined_video_1767988650_69615daa8d084.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(212,165,283,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8d9d3.mp4','combined_video_1767988650_69615daa8d9d3.mp4','thumb_combined_video_1767988650_69615daa8d9d3.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(213,165,283,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8da72.mp4','combined_video_1767988650_69615daa8da72.mp4','thumb_combined_video_1767988650_69615daa8da72.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(214,165,284,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8e538.mp4','combined_video_1767988650_69615daa8e538.mp4','thumb_combined_video_1767988650_69615daa8e538.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(215,165,284,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8e658.mp4','combined_video_1767988650_69615daa8e658.mp4','thumb_combined_video_1767988650_69615daa8e658.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(216,165,285,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8ed86.mp4','combined_video_1767988650_69615daa8ed86.mp4','thumb_combined_video_1767988650_69615daa8ed86.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(217,165,285,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8ede8.mp4','combined_video_1767988650_69615daa8ede8.mp4','thumb_combined_video_1767988650_69615daa8ede8.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(218,165,286,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8f6f1.mp4','combined_video_1767988650_69615daa8f6f1.mp4','thumb_combined_video_1767988650_69615daa8f6f1.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(219,165,286,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8f757.mp4','combined_video_1767988650_69615daa8f757.mp4','thumb_combined_video_1767988650_69615daa8f757.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(220,165,287,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8fee1.mp4','combined_video_1767988650_69615daa8fee1.mp4','thumb_combined_video_1767988650_69615daa8fee1.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(221,165,287,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767988650_69615daa8ff76.mp4','combined_video_1767988650_69615daa8ff76.mp4','thumb_combined_video_1767988650_69615daa8ff76.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:29:47','2026-01-09 14:29:47'),
(222,166,288,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b38b2.mp4','combined_video_1767990281_69616409b38b2.mp4','thumb_combined_video_1767990281_69616409b38b2.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(223,166,288,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b39b1.mp4','combined_video_1767990281_69616409b39b1.mp4','thumb_combined_video_1767990281_69616409b39b1.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(224,166,289,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b3e6e.mp4','combined_video_1767990281_69616409b3e6e.mp4','thumb_combined_video_1767990281_69616409b3e6e.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(225,166,289,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b3ec3.mp4','combined_video_1767990281_69616409b3ec3.mp4','thumb_combined_video_1767990281_69616409b3ec3.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(226,166,290,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b4227.mp4','combined_video_1767990281_69616409b4227.mp4','thumb_combined_video_1767990281_69616409b4227.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(227,166,290,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b4275.mp4','combined_video_1767990281_69616409b4275.mp4','thumb_combined_video_1767990281_69616409b4275.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(228,166,291,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b45a9.mp4','combined_video_1767990281_69616409b45a9.mp4','thumb_combined_video_1767990281_69616409b45a9.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(229,166,291,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b45eb.mp4','combined_video_1767990281_69616409b45eb.mp4','thumb_combined_video_1767990281_69616409b45eb.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(230,166,292,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b48f0.mp4','combined_video_1767990281_69616409b48f0.mp4','thumb_combined_video_1767990281_69616409b48f0.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(231,166,292,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b491f.mp4','combined_video_1767990281_69616409b491f.mp4','thumb_combined_video_1767990281_69616409b491f.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(232,166,293,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b4c2e.mp4','combined_video_1767990281_69616409b4c2e.mp4','thumb_combined_video_1767990281_69616409b4c2e.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(233,166,293,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b4c61.mp4','combined_video_1767990281_69616409b4c61.mp4','thumb_combined_video_1767990281_69616409b4c61.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(234,166,294,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b4fc0.mp4','combined_video_1767990281_69616409b4fc0.mp4','thumb_combined_video_1767990281_69616409b4fc0.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(235,166,294,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b501c.mp4','combined_video_1767990281_69616409b501c.mp4','thumb_combined_video_1767990281_69616409b501c.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(236,166,295,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b5981.mp4','combined_video_1767990281_69616409b5981.mp4','thumb_combined_video_1767990281_69616409b5981.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(237,166,295,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b59bc.mp4','combined_video_1767990281_69616409b59bc.mp4','thumb_combined_video_1767990281_69616409b59bc.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(238,166,296,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b5e27.mp4','combined_video_1767990281_69616409b5e27.mp4','thumb_combined_video_1767990281_69616409b5e27.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(239,166,296,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990281_69616409b5e71.mp4','combined_video_1767990281_69616409b5e71.mp4','thumb_combined_video_1767990281_69616409b5e71.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 14:57:38','2026-01-09 14:57:38'),
(240,167,298,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc34e9.mp4','combined_video_1767990779_696165fbc34e9.mp4','thumb_combined_video_1767990779_696165fbc34e9.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(241,167,298,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc35cb.mp4','combined_video_1767990779_696165fbc35cb.mp4','thumb_combined_video_1767990779_696165fbc35cb.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(242,167,299,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc3b41.mp4','combined_video_1767990779_696165fbc3b41.mp4','thumb_combined_video_1767990779_696165fbc3b41.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(243,167,299,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc3b77.mp4','combined_video_1767990779_696165fbc3b77.mp4','thumb_combined_video_1767990779_696165fbc3b77.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(244,167,300,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc3f38.mp4','combined_video_1767990779_696165fbc3f38.mp4','thumb_combined_video_1767990779_696165fbc3f38.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(245,167,300,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc3f8b.mp4','combined_video_1767990779_696165fbc3f8b.mp4','thumb_combined_video_1767990779_696165fbc3f8b.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(246,167,301,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc43ce.mp4','combined_video_1767990779_696165fbc43ce.mp4','thumb_combined_video_1767990779_696165fbc43ce.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(247,167,301,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc441a.mp4','combined_video_1767990779_696165fbc441a.mp4','thumb_combined_video_1767990779_696165fbc441a.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(248,167,302,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc4b01.mp4','combined_video_1767990779_696165fbc4b01.mp4','thumb_combined_video_1767990779_696165fbc4b01.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(249,167,302,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc4b5b.mp4','combined_video_1767990779_696165fbc4b5b.mp4','thumb_combined_video_1767990779_696165fbc4b5b.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(250,167,303,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc4f66.mp4','combined_video_1767990779_696165fbc4f66.mp4','thumb_combined_video_1767990779_696165fbc4f66.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(251,167,303,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc4fb3.mp4','combined_video_1767990779_696165fbc4fb3.mp4','thumb_combined_video_1767990779_696165fbc4fb3.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(252,167,304,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc533e.mp4','combined_video_1767990779_696165fbc533e.mp4','thumb_combined_video_1767990779_696165fbc533e.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(253,167,304,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767990779_696165fbc536c.mp4','combined_video_1767990779_696165fbc536c.mp4','thumb_combined_video_1767990779_696165fbc536c.jpg','landscape',NULL,NULL,0,NULL,'2026-01-09 15:05:51','2026-01-09 15:05:51'),
(254,146,223,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767981770_696142ca7b669.mp4','combined_video_1767981770_696142ca7b669.mp4','thumb_combined_video_1767981770_696142ca7b669.jpg','landscape',0,0,0,NULL,'2026-01-09 15:21:34','2026-01-09 15:21:34'),
(255,146,223,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767981770_696142ca7b58a.mp4','combined_video_1767981770_696142ca7b58a.mp4','thumb_combined_video_1767981770_696142ca7b58a.jpg','landscape',0,0,0,NULL,'2026-01-09 15:21:34','2026-01-09 15:21:34'),
(256,171,309,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768047288_696242b81a984.mp4','combined_video_1768047288_696242b81a984.mp4','thumb_combined_video_1768047288_696242b81a984.jpg','landscape',0,0,0,NULL,'2026-01-10 06:46:07','2026-01-10 06:46:07'),
(257,171,309,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768047288_696242b81aa5c.mp4','combined_video_1768047288_696242b81aa5c.mp4','thumb_combined_video_1768047288_696242b81aa5c.jpg','landscape',0,0,0,NULL,'2026-01-10 06:46:07','2026-01-10 06:46:07'),
(258,171,310,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768047288_696242b81af38.mp4','combined_video_1768047288_696242b81af38.mp4','thumb_combined_video_1768047288_696242b81af38.jpg','landscape',0,0,0,NULL,'2026-01-10 06:46:07','2026-01-10 06:46:07'),
(259,171,310,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768047288_696242b81aefd.mp4','combined_video_1768047288_696242b81aefd.mp4','thumb_combined_video_1768047288_696242b81aefd.jpg','landscape',0,0,0,NULL,'2026-01-10 06:46:07','2026-01-10 06:46:07'),
(260,172,313,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768047833_696244d9da559.mp4','combined_video_1768047833_696244d9da559.mp4','thumb_combined_video_1768047833_696244d9da559.jpg','landscape',0,0,0,NULL,'2026-01-10 06:55:53','2026-01-10 06:55:53'),
(261,172,313,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768047833_696244d9da4e6.mp4','combined_video_1768047833_696244d9da4e6.mp4','thumb_combined_video_1768047833_696244d9da4e6.jpg','landscape',0,0,0,NULL,'2026-01-10 06:55:53','2026-01-10 06:55:53'),
(262,172,312,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768047833_696244d9d9e20.mp4','combined_video_1768047833_696244d9d9e20.mp4','thumb_combined_video_1768047833_696244d9d9e20.jpg','landscape',0,0,0,NULL,'2026-01-10 06:55:53','2026-01-10 06:55:53'),
(263,172,312,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768047833_696244d9d9dd3.mp4','combined_video_1768047833_696244d9d9dd3.mp4','thumb_combined_video_1768047833_696244d9d9dd3.jpg','landscape',0,0,0,NULL,'2026-01-10 06:55:53','2026-01-10 06:55:53'),
(264,172,311,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768047833_696244d9d945f.mp4','combined_video_1768047833_696244d9d945f.mp4','thumb_combined_video_1768047833_696244d9d945f.jpg','landscape',0,0,0,NULL,'2026-01-10 06:55:54','2026-01-10 06:55:54'),
(265,173,315,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768048588_696247ccf2d8e.mp4','combined_video_1768048588_696247ccf2d8e.mp4','thumb_combined_video_1768048588_696247ccf2d8e.jpg','landscape',0,0,0,NULL,'2026-01-10 07:07:50','2026-01-10 07:07:50'),
(266,173,315,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768048588_696247ccf2c8e.mp4','combined_video_1768048588_696247ccf2c8e.mp4','thumb_combined_video_1768048588_696247ccf2c8e.jpg','landscape',0,0,0,NULL,'2026-01-10 07:07:50','2026-01-10 07:07:50'),
(267,173,314,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768048588_696247ccf2455.mp4','combined_video_1768048588_696247ccf2455.mp4','thumb_combined_video_1768048588_696247ccf2455.jpg','landscape',0,0,0,NULL,'2026-01-10 07:07:50','2026-01-10 07:07:50'),
(268,173,314,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768048588_696247ccf2366.mp4','combined_video_1768048588_696247ccf2366.mp4','thumb_combined_video_1768048588_696247ccf2366.jpg','landscape',0,0,0,NULL,'2026-01-10 07:07:50','2026-01-10 07:07:50'),
(269,174,317,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768049514_69624b6a2a34f.mp4','combined_video_1768049514_69624b6a2a34f.mp4','thumb_combined_video_1768049514_69624b6a2a34f.jpg','landscape',0,0,0,NULL,'2026-01-10 07:23:25','2026-01-10 07:23:25'),
(270,174,317,7,6,18,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768049514_69624b6a2a310.mp4','combined_video_1768049514_69624b6a2a310.mp4','thumb_combined_video_1768049514_69624b6a2a310.jpg','landscape',0,0,0,NULL,'2026-01-10 07:23:25','2026-01-10 07:23:25'),
(271,174,316,6,6,20,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1768049514_69624b6a29db4.mp4','combined_video_1768049514_69624b6a29db4.mp4','thumb_combined_video_1768049514_69624b6a29db4.jpg','landscape',0,0,0,NULL,'2026-01-10 07:23:25','2026-01-10 07:23:25');
/*!40000 ALTER TABLE `generated_videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instagram_credentials`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instagram_credentials` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `customer_id` bigint(20) unsigned DEFAULT NULL,
  `credential_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ig_user_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `facebook_page_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `instagram_credentials_user_id_is_active_index` (`user_id`,`is_active`),
  KEY `instagram_credentials_customer_id_foreign` (`customer_id`),
  CONSTRAINT `instagram_credentials_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instagram_credentials_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instagram_credentials`
--

LOCK TABLES `instagram_credentials` WRITE;
/*!40000 ALTER TABLE `instagram_credentials` DISABLE KEYS */;
INSERT  IGNORE INTO `instagram_credentials` VALUES
(2,NULL,6,'yuvraj','eyJpdiI6IndXVGhMM3dUR3FwdW9JY0U2VlpaTGc9PSIsInZhbHVlIjoiQkJLYnFDSGY2cUt0R2FoSmhHeG1Pbzdvd0VDVUJSbEx5TUJaeTQ1dWR3c3BqaGlrWmpwUzlVWHhKY3dxd2x6eUg0c0U3dGhXaDV2YXM3bFpIWTlmMU83QXhnMTJlLzFOa0RjajdrNytwMDAxeTN3YmFJODdNb3VtMVZ0YVc3Q2Q0NTYzMDZ0UDNMcFQzaEI1bHM2eVNVczBML3kzeUtxQjMzSHUrOHg1bUtleEZqV3BzWHB0VDlVYStpalZQenNIU1R5bTFRdHgvQVcyS0E5N2kwd2ZPMDJBQkVvUDcvM3NWcmVQNTUzellxUGxCTXc3SGQvUHVlQmt5SFFVWjJveWJpVW00SnE0dnZjbnQ5c0wvaXJvc1E9PSIsIm1hYyI6IjZiYjBlNjExMDA2NGRkYTEyM2E0ZDNjOGE0OTEwNzE4ZmJjZWNjODRiMmU4YzA3ZWMzODY3NmU0Zjc0YjlmM2YiLCJ0YWciOiIifQ==','17841478123611469','921733587691767',1,'2026-01-02 10:44:01','2026-01-29 18:30:00','2025-12-29 11:09:04','2026-01-02 10:44:01'),
(3,NULL,7,'YA2','eyJpdiI6IlJrYzAwVFJrRGNsZXVrbS9WZ25MUGc9PSIsInZhbHVlIjoibE5KR0dGSGVqa1ZNZmgxaVRvOFpWT2EybmFVcFRROUxiSHB2VkZRS014R3oxcW5xSlN5VTB4ekc3V3VveUN6SVFBWTczYm42bW9zWm1PZVNZTllnZ1hldElBRno5dTl1TDFwLzJtb1lVd21IZEVnQUM2ZHBGdUJ3OGM0OVVPNzdUcWxMSmdPemVjdyt6NUN6RU1uZHB0ZTF0T2EvT1VOekxIWVU3K2dXZ0VUbytNOGkxWEpDOG1NSTY1bHNhak44SEkwY2VYbVhIbDdJQlNBVlRLdEhQQUpoMUUxUE1EcGp2Z2o1ZUlJbWo2NmNrMVZvUnNuSzZXdjRCVmpEeFlyZGRUVHNRMDQ4ZDZCaFdnWDlMeWJHa2c9PSIsIm1hYyI6ImYxNzg0OTU2M2Q5YjMxZmRiOWJhMTc5ZDI2ODQ5OGE1NjVkYWE3M2YwNjBjMDFmMWU5N2JhMTIxZDY3ZjJlNDMiLCJ0YWciOiIifQ==','17841478123611469','963944953466373',1,'2026-01-02 10:43:29','2026-01-22 18:30:00','2026-01-01 09:54:05','2026-01-02 10:43:29'),
(4,NULL,8,'TESTTEST','eyJpdiI6Ing3V0NGeDRHZ3Jvb0sxSjFrS00zSkE9PSIsInZhbHVlIjoiRllqUnZ3WmcxUzJCdTNZZ2huVURvMXAvQTFOTVFQSEx1LzVzRWNEUjNFTTZrMVRHZ2dxcVlUQ1hXNCtqYUgwZ0VweVFBcUJveXIyNkowd2FqWCtSQ0UvWG1tRE1VNkRaMHlFcjRwOFlqbmZFM3gyeFFFbGJNWUc0T0l1QnZXSUxnUzgvZGFWeXI0RUlxSjY1MnQxUmtPcFIxbEx0akJUQkR2WWcxM1A3S0J1b2dJOUs2c0JaTXlXWFpNdDFjZzlkRGJtTXVLNjFhOElkV3V4Ui8wRzdkSVdWRXk0cDZ5ZXB2NmltQnAzd3k4Y1YrSG16R0NMV0dlQi93ZzhaTXFhelhaN0pPbnY3amwvQ1JPbW9pSWVZVmc9PSIsIm1hYyI6IjQ2MjJiNjNhYTMxNmFmOTM2ZmI1NmYwOGQ3NjgwZTQwMTk4ZmZjNWE2ZGEzMTg1ZTllODQ0Y2MzNmFjYTJlZjIiLCJ0YWciOiIifQ==','17841466387680752','940608162468225',1,'2026-01-02 10:47:20','2026-01-30 18:30:00','2026-01-02 07:25:50','2026-01-02 10:47:20');
/*!40000 ALTER TABLE `instagram_credentials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instagram_upload_logs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instagram_upload_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `platform` enum('instagram','facebook') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'instagram',
  `credential_id` bigint(20) unsigned NOT NULL,
  `video_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `media_container_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `instagram_post_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','processing','published','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `error_message` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `instagram_upload_logs_credential_id_foreign` (`credential_id`),
  KEY `instagram_upload_logs_user_id_status_index` (`user_id`,`status`),
  KEY `instagram_upload_logs_created_at_index` (`created_at`),
  CONSTRAINT `instagram_upload_logs_credential_id_foreign` FOREIGN KEY (`credential_id`) REFERENCES `instagram_credentials` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instagram_upload_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=143 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instagram_upload_logs`
--

LOCK TABLES `instagram_upload_logs` WRITE;
/*!40000 ALTER TABLE `instagram_upload_logs` DISABLE KEYS */;
INSERT  IGNORE INTO `instagram_upload_logs` VALUES
(1,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc0c2.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','',NULL,NULL,'failed','Unknown error occurred','2025-12-29 11:47:59','2025-12-29 11:48:12'),
(2,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc0c2.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','yaspik',NULL,NULL,'failed','Unknown error occurred','2025-12-29 11:51:53','2025-12-29 11:52:06'),
(3,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc0c2.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','lets test yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-29 11:54:42','2026-01-02 10:27:09'),
(4,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc769.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc769.mp4','lets test yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-29 11:54:43','2026-01-02 10:27:09'),
(5,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbcca1.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbcca1.mp4','lets test yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-29 11:54:43','2026-01-02 10:27:09'),
(6,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbcfa7.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbcfa7.mp4','lets test yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-29 11:54:43','2026-01-02 10:27:09'),
(7,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1766047611_6943bf7bd33b1.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1766047611_6943bf7bd33b1.mp4','lets test yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-29 11:54:43','2026-01-02 10:27:09'),
(8,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1766047611_6943bf7bd37c8.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1766047611_6943bf7bd37c8.mp4','lets test yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-29 11:54:44','2026-01-02 10:27:09'),
(9,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1766047611_6943bf7bd3ade.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1766047611_6943bf7bd3ade.mp4','lets test yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-29 11:54:44','2026-01-02 10:27:09'),
(10,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1767024110_6952a5ee6bad7.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767024110_6952a5ee6bad7.mp4','lets test yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-29 11:54:44','2026-01-02 10:27:09'),
(11,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1767024110_6952a5ee6bb8e.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767024110_6952a5ee6bb8e.mp4','lets test yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-29 11:54:44','2026-01-02 10:27:09'),
(12,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1767026250_6952ae4a98f3b.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767026250_6952ae4a98f3b.mp4','lets test yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-29 11:54:44','2026-01-02 10:27:09'),
(13,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc0c2.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 00:42:55','2026-01-02 10:27:09'),
(14,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc769.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc769.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 00:42:55','2026-01-02 10:27:09'),
(15,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbcca1.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbcca1.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 00:42:55','2026-01-02 10:27:09'),
(16,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbcfa7.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbcfa7.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 00:42:55','2026-01-02 10:27:09'),
(17,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1766047611_6943bf7bd33b1.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1766047611_6943bf7bd33b1.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 00:42:56','2026-01-02 10:27:09'),
(18,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1766047611_6943bf7bd37c8.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1766047611_6943bf7bd37c8.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 00:42:56','2026-01-02 10:27:09'),
(19,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1766047611_6943bf7bd3ade.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1766047611_6943bf7bd3ade.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 00:42:56','2026-01-02 10:27:09'),
(20,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1767024110_6952a5ee6bad7.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767024110_6952a5ee6bad7.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 00:42:56','2026-01-02 10:27:09'),
(21,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1767024110_6952a5ee6bb8e.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767024110_6952a5ee6bb8e.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 00:42:56','2026-01-02 10:27:09'),
(22,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1767026250_6952ae4a98f3b.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767026250_6952ae4a98f3b.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 00:42:56','2026-01-02 10:27:09'),
(23,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc0c2.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 01:41:44','2026-01-02 10:27:09'),
(24,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc0c2.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','new update video',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 01:43:08','2026-01-02 10:27:09'),
(25,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc0c2.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','finsal update',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 01:45:32','2026-01-02 10:27:09'),
(26,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc0c2.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','new video',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 01:58:19','2026-01-02 10:27:09'),
(27,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc0c2.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','lets test the video uploarder',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 02:06:57','2026-01-02 10:27:09'),
(28,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1765823292_6940533cbc0c2.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1765823292_6940533cbc0c2.mp4','new update video',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 02:11:41','2026-01-02 10:27:09'),
(29,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','new post video',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 10:28:41','2026-01-02 10:27:09'),
(30,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video\\combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','new post video',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 10:28:41','2026-01-02 10:27:09'),
(31,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:04:49','2026-01-02 10:27:09'),
(32,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4',NULL,NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:04:49','2026-01-02 10:27:09'),
(33,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lests rte',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:16:26','2026-01-02 10:27:09'),
(34,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lests rte',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:16:26','2026-01-02 10:27:09'),
(35,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','finaly uploarding',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:30:45','2026-01-02 10:27:09'),
(36,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','finaly uploarding',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:30:46','2026-01-02 10:27:09'),
(37,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','klajdsfkljsad',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:39:27','2026-01-02 10:27:09'),
(38,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','klajdsfkljsad',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:39:27','2026-01-02 10:27:09'),
(39,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','asdgasdgadgsdag',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:44:35','2026-01-02 10:27:09'),
(40,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','asdgasdgadgsdag',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:44:35','2026-01-02 10:27:09'),
(41,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','kljslkdjlfkas',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:47:52','2026-01-02 10:27:09'),
(42,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','kljslkdjlfkas',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:47:52','2026-01-02 10:27:09'),
(43,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','kjsdljaldjfjklasjkljlksa',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:56:44','2026-01-02 10:27:09'),
(44,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','kjsdljaldjfjklasjkljlksa',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:56:44','2026-01-02 10:27:09'),
(45,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','kjldajslkf',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:59:39','2026-01-02 10:27:09'),
(46,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','kjldajslkf',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 12:59:39','2026-01-02 10:27:09'),
(47,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','kljasdjlfjaklsj',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 13:05:57','2026-01-02 10:27:09'),
(48,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','kljasdjlfjaklsj',NULL,NULL,'failed','Facebook Upload Failed: {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AMB47i5shuda84UuoX96Kq-\"}}','2025-12-30 13:05:57','2025-12-30 13:09:20'),
(49,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','sdfasdsafasdfdsf',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 13:12:06','2026-01-02 10:27:09'),
(50,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','sdfasdsafasdfdsf',NULL,NULL,'failed','Video file not found (deleted)','2025-12-30 13:12:06','2026-01-02 10:27:09'),
(51,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets teste the video uploard',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:17:56','2026-01-02 10:27:09'),
(52,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets teste the video uploard',NULL,NULL,'failed','Facebook Upload Failed: {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AcJjuXiD49pyYpmmChebEgU\"}}','2025-12-31 08:17:56','2025-12-31 08:24:45'),
(53,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets get started by yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:29:11','2026-01-02 10:27:09'),
(54,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets get started by yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:29:11','2026-01-02 10:27:09'),
(55,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets upload the video by yaspik',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:32:40','2026-01-02 10:27:09'),
(56,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets upload the video by yaspik',NULL,NULL,'failed','Facebook Upload Failed: {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"ApQaqA-U1PA06QasSJMCWz3\"}}','2025-12-31 08:32:40','2025-12-31 08:35:00'),
(57,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','djkahdjfhjkahdkj yaspik tech',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:39:17','2026-01-02 10:27:09'),
(58,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','djkahdjfhjkahdkj yaspik tech',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:39:17','2026-01-02 10:27:09'),
(59,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','dsfadsdfasdfdvvdfafddsfaf',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:47:31','2026-01-02 10:27:09'),
(60,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','dsfadsdfasdfdvvdfafddsfaf',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:47:31','2026-01-02 10:27:09'),
(61,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','finsla upload',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:52:22','2026-01-02 10:27:09'),
(62,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','finsla upload',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:52:22','2026-01-02 10:27:09'),
(63,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','jhjkfahkshdkhadfds',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:54:46','2026-01-02 10:27:09'),
(64,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','jhjkfahkshdkhadfds',NULL,NULL,'failed','Video file not found (deleted)','2025-12-31 08:54:46','2026-01-02 10:27:09'),
(65,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','hjghjgj',NULL,NULL,'failed','Video file not found (deleted)','2026-01-01 01:05:06','2026-01-02 10:27:09'),
(66,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','hjghjgj','17850419619604121','17976076649798076','failed','Video file not found (deleted)','2026-01-01 01:05:06','2026-01-02 10:27:09'),
(68,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','finaly uploarding','17850420927604121','18172798321338506','published',NULL,'2026-01-01 01:30:39','2026-01-01 01:31:18'),
(69,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','finaly uploarding',NULL,NULL,'failed','Video file not found (deleted)','2026-01-01 01:30:39','2026-01-02 10:27:09'),
(70,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://unantagonizing-bertram-nonstrategically.ngrok-free.app/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets upload and finaly uploarding',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AX7W5Ift-OJQwk6bVo236_n\"}}','2026-01-01 01:36:14','2026-01-01 01:36:16'),
(71,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','finaly getting uploarded','17850467703604121','18102512554757351','published',NULL,'2026-01-01 06:10:45','2026-01-01 06:11:20'),
(72,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','finaly getting uploarded',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"A0y-lAXgRNd-CVXWR6MrLx7\"}}','2026-01-01 06:10:45','2026-01-01 06:10:47'),
(73,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','findslay getting uplaord',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AfsGvzUw0L7gYlEJ_k_nSTx\"}}','2026-01-01 06:21:09','2026-01-01 06:21:10'),
(74,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets get started',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"A7923l-q5WoXmeMATumdmli\"}}','2026-01-01 06:28:00','2026-01-01 06:28:01'),
(75,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets test the facebook','17850471159604121','17894481516240004','published',NULL,'2026-01-01 06:34:00','2026-01-01 06:34:43'),
(76,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets test the facebook',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AzsbgFGUilH47bDayu3s-oR\"}}','2026-01-01 06:34:00','2026-01-01 06:34:02'),
(77,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets thet thest the video',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AasiN55GuO8xzJwDufzKrfd\"}}','2026-01-01 06:34:46','2026-01-01 06:34:47'),
(78,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','letslwte test the hface bookt',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"Ah-ZSTE9TDrXnNk283YmPey\"}}','2026-01-01 06:39:56','2026-01-01 06:39:57'),
(79,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','finaly both working','17850473145604121','17943313736965855','published',NULL,'2026-01-01 06:44:16','2026-01-01 06:44:58'),
(80,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','finaly both working','3927401770883226','3927401770883226','published',NULL,'2026-01-01 06:44:16','2026-01-01 06:44:25'),
(81,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','letst upload the video yaspik','17850510171604121','17871626454496613','published',NULL,'2026-01-01 10:06:18','2026-01-01 10:07:00'),
(82,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','letst upload the video yaspik','1488094946652339','1488094946652339','published',NULL,'2026-01-01 10:06:18','2026-01-01 10:06:27'),
(83,1,'instagram',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','',NULL,NULL,'failed','HTTP Error 400: {\"error\":{\"message\":\"(#10) Application does not have permission for this action\",\"type\":\"OAuthException\",\"code\":10,\"fbtrace_id\":\"Ao6fz1zudULPGQ28Ui8G1bY\"}}','2026-01-01 12:54:35','2026-01-01 12:54:36'),
(84,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4',NULL,NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"ATvxtANgMu9g58dAfUrCpVC\"}}','2026-01-01 12:54:35','2026-01-01 12:54:36'),
(85,1,'instagram',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','',NULL,NULL,'failed','Video file not found (deleted)','2026-01-01 12:54:35','2026-01-02 10:27:09'),
(86,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4',NULL,NULL,NULL,'failed','Video file not found (deleted)','2026-01-01 12:54:35','2026-01-02 10:27:09'),
(87,1,'instagram',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','',NULL,NULL,'failed','Video file not found (deleted)','2026-01-01 12:54:36','2026-01-02 10:27:09'),
(88,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4',NULL,NULL,NULL,'failed','Video file not found (deleted)','2026-01-01 12:54:36','2026-01-02 10:27:09'),
(89,1,'instagram',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767277254_695682c659012.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767277254_695682c659012.mp4','',NULL,NULL,'failed','HTTP Error 400: {\"error\":{\"message\":\"(#10) Application does not have permission for this action\",\"type\":\"OAuthException\",\"code\":10,\"fbtrace_id\":\"AfYm9h2tGrqwrBWEVLjhtE4\"}}','2026-01-01 12:54:36','2026-01-01 12:54:38'),
(90,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767277254_695682c659012.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767277254_695682c659012.mp4',NULL,NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AQhguQ6vDZWPWGfXJqE817V\"}}','2026-01-01 12:54:36','2026-01-01 12:54:38'),
(91,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d777e.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d777e.mp4','lets test','1933461474247510','1933461474247510','published',NULL,'2026-01-01 12:55:05','2026-01-01 12:55:17'),
(92,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9a999.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9a999.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2026-01-01 12:55:06','2026-01-02 10:27:09'),
(93,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','lets test',NULL,NULL,'failed','Video file not found (deleted)','2026-01-01 12:55:06','2026-01-02 10:27:09'),
(94,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','lets send multi',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AzqdmACTA1wH4ZGKeD8vLRD\"}}','2026-01-01 13:01:43','2026-01-01 13:01:44'),
(95,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','lets send multi',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AWYieaFBuwABKpbS9LcXISZ\"}}','2026-01-01 13:01:43','2026-01-01 13:01:44'),
(96,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','lets send multi',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AVujTuD2rLa9vyJCTXnWRVC\"}}','2026-01-01 13:01:43','2026-01-01 13:01:44'),
(97,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767277254_695682c659012.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767277254_695682c659012.mp4','lets send multi',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AhSc0p29fe18b0yNgCrDBo_\"}}','2026-01-01 13:01:44','2026-01-01 13:01:45'),
(98,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d777e.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d777e.mp4','dsfdssss','1949990455875763','1949990455875763','published',NULL,'2026-01-01 13:02:34','2026-01-01 13:02:44'),
(99,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','dsfdssss','1802318750423970','1802318750423970','published',NULL,'2026-01-01 13:02:34','2026-01-01 13:02:44'),
(100,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9a999.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9a999.mp4','dsfdssss','1027847799549554','1027847799549554','published',NULL,'2026-01-01 13:02:34','2026-01-01 13:02:44'),
(101,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','dsfasf dgdg vd',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"A89zkPTAJMhFL5vLQpA_zsL\"}}','2026-01-01 13:04:23','2026-01-01 13:04:24'),
(102,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','dsfasf dgdg vd',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AHQjL559WEqQw6RUq-35RZc\"}}','2026-01-01 13:04:23','2026-01-01 13:04:24'),
(103,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','dsfasf dgdg vd',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"AFKO9YLSrtxO9BY-PJ56-X9\"}}','2026-01-01 13:04:23','2026-01-01 13:04:24'),
(104,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','final uploard',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"A3nmb6QKR6XWY2rjJd5v6jG\"}}','2026-01-01 13:36:43','2026-01-01 13:36:44'),
(105,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','final uploard',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"ALjN-sTRmV2tEYKv9DzGdZe\"}}','2026-01-01 13:36:43','2026-01-01 13:36:44'),
(106,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','final uploard',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"(#100) No permission to publish the video\",\"type\":\"OAuthException\",\"code\":100,\"fbtrace_id\":\"APWlEa1G_uQcfNJ4phMbWv8\"}}','2026-01-01 13:36:43','2026-01-01 13:36:45'),
(107,1,'instagram',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','dfsdfsdf',NULL,NULL,'failed','HTTP Error 400: {\"error\":{\"message\":\"(#10) Application does not have permission for this action\",\"type\":\"OAuthException\",\"code\":10,\"fbtrace_id\":\"AIHKXPt5TVU4aFbAawPJaXz\"}}','2026-01-01 14:22:02','2026-01-01 14:22:04'),
(108,1,'instagram',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','dfsdfsdf',NULL,NULL,'failed','HTTP Error 400: {\"error\":{\"message\":\"(#10) Application does not have permission for this action\",\"type\":\"OAuthException\",\"code\":10,\"fbtrace_id\":\"AfQj1_gspa1gfdezB-7JoGE\"}}','2026-01-01 14:22:02','2026-01-01 14:22:04'),
(109,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','lets go uploard','1954004432660615','1954004432660615','published',NULL,'2026-01-01 14:34:58','2026-01-01 14:35:08'),
(110,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','lets go uploard','922254380361972','922254380361972','published',NULL,'2026-01-01 14:34:58','2026-01-01 14:35:05'),
(111,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','finaly uploading','4137651536503137','4137651536503137','published',NULL,'2026-01-02 03:01:41','2026-01-02 03:02:12'),
(112,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','lets send','890309966715765','890309966715765','published',NULL,'2026-01-02 03:02:50','2026-01-02 03:03:34'),
(113,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d7803.mp4','lets sebf','1727906758663845','1727906758663845','published',NULL,'2026-01-02 03:07:37','2026-01-02 03:07:47'),
(114,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9aa18.mp4','lets sebf','2043576429545339','2043576429545339','published',NULL,'2026-01-02 03:07:37','2026-01-02 03:08:07'),
(115,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767277254_695682c659012.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767277254_695682c659012.mp4','HELLO',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"Unable to fetch video file from URL.\",\"type\":\"OAuthException\",\"code\":389,\"error_subcode\":1363057,\"is_transient\":false,\"error_user_title\":\"Unable to fetch video file from URL\",\"error_user_msg\":\"Unable to fetch video file from URL.\",\"fbtrace_id\":\"A-KxQRa_Osx6Nr-QI-bV5z1\"}}','2026-01-02 06:00:24','2026-01-02 06:00:27'),
(116,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','Hellow hi 2','17850684189604121',NULL,'failed','Instagram failed to process the video','2026-01-02 06:00:24','2026-01-02 06:00:38'),
(117,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767110157_6953f60d8a531.mp4','Hellow hi 2',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"Unable to fetch video file from URL.\",\"type\":\"OAuthException\",\"code\":389,\"error_subcode\":1363057,\"is_transient\":false,\"error_user_title\":\"Unable to fetch video file from URL\",\"error_user_msg\":\"Unable to fetch video file from URL.\",\"fbtrace_id\":\"Aq7ijOoh_TM--_qAUKSWxkn\"}}','2026-01-02 06:00:24','2026-01-02 06:00:46'),
(118,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','hekllloe',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"Unable to fetch video file from URL.\",\"type\":\"OAuthException\",\"code\":389,\"error_subcode\":1363057,\"is_transient\":false,\"error_user_title\":\"Unable to fetch video file from URL\",\"error_user_msg\":\"Unable to fetch video file from URL.\",\"fbtrace_id\":\"ApMzm9sjfEZEfFS2Sr12llc\"}}','2026-01-02 06:02:07','2026-01-02 06:02:29'),
(119,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767277254_695682c659012.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767277254_695682c659012.mp4','hekllloe',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"Unable to fetch video file from URL.\",\"type\":\"OAuthException\",\"code\":389,\"error_subcode\":1363057,\"is_transient\":false,\"error_user_title\":\"Unable to fetch video file from URL\",\"error_user_msg\":\"Unable to fetch video file from URL.\",\"fbtrace_id\":\"AeU-1kYuqFmbmSlS7ykJHh7\"}}','2026-01-02 06:02:07','2026-01-02 06:02:31'),
(120,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767353042_6957aad241c72.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767353042_6957aad241c72.mp4','','17850684528604121','18064727525219993','published',NULL,'2026-01-02 06:02:20','2026-01-02 06:03:05'),
(121,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767353042_6957aad241c72.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767353042_6957aad241c72.mp4',NULL,'850427951080896','850427951080896','published',NULL,'2026-01-02 06:02:20','2026-01-02 06:02:51'),
(122,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"Unable to fetch video file from URL.\",\"type\":\"OAuthException\",\"code\":389,\"error_subcode\":1363057,\"is_transient\":false,\"error_user_title\":\"Unable to fetch video file from URL\",\"error_user_msg\":\"Unable to fetch video file from URL.\",\"fbtrace_id\":\"AMTd1_-kfFwteLGX6r0mXeN\"}}','2026-01-02 06:06:15','2026-01-02 06:06:17'),
(123,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767290913_6956b8211aed8.mp4','kljajdsklfjklsjalkj kjklhdsklfj',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"Unable to fetch video file from URL.\",\"type\":\"OAuthException\",\"code\":389,\"error_subcode\":1363057,\"is_transient\":false,\"error_user_title\":\"Unable to fetch video file from URL\",\"error_user_msg\":\"Unable to fetch video file from URL.\",\"fbtrace_id\":\"AVXecWigsXTxIjVOGdPPxrq\"}}','2026-01-02 06:06:43','2026-01-02 06:07:04'),
(124,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d777e.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d777e.mp4','helo yaspik yuvraj','17850685248604121',NULL,'failed','Instagram failed to process the video','2026-01-02 06:07:52','2026-01-02 06:08:05'),
(125,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291719_6956bb47d777e.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291719_6956bb47d777e.mp4','helo yaspik yuvraj',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"Unable to fetch video file from URL.\",\"type\":\"OAuthException\",\"code\":389,\"error_subcode\":1363057,\"is_transient\":false,\"error_user_title\":\"Unable to fetch video file from URL\",\"error_user_msg\":\"Unable to fetch video file from URL.\",\"fbtrace_id\":\"Aw_mQj8aeLXBIJaJUIQGzwk\"}}','2026-01-02 06:07:52','2026-01-02 06:08:14'),
(126,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9a999.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9a999.mp4','helo yaspik yuvraj','17850685251604121',NULL,'failed','Instagram failed to process the video','2026-01-02 06:07:52','2026-01-02 06:08:05'),
(127,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767291565_6956baad9a999.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767291565_6956baad9a999.mp4','helo yaspik yuvraj',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"Unable to fetch video file from URL.\",\"type\":\"OAuthException\",\"code\":389,\"error_subcode\":1363057,\"is_transient\":false,\"error_user_title\":\"Unable to fetch video file from URL\",\"error_user_msg\":\"Unable to fetch video file from URL.\",\"fbtrace_id\":\"AG2eK6A6RkSbXDoMh-rKmiF\"}}','2026-01-02 06:07:52','2026-01-02 06:07:55'),
(128,1,'facebook',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767358345_6957bf8923366.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767358345_6957bf8923366.mp4','helow now uploarding','1365628991407191','1365628991407191','published',NULL,'2026-01-02 07:26:24','2026-01-02 07:26:34'),
(129,1,'instagram',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','xfdgfhfgh','17921725152212923',NULL,'failed','Instagram failed to process the video','2026-01-02 09:36:29','2026-01-02 09:36:42'),
(130,1,'facebook',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','xfdgfhfgh',NULL,NULL,'failed','HTTP Error: 400 - {\"error\":{\"message\":\"There was a problem uploading your video file. Please try again with another file.\",\"type\":\"OAuthException\",\"code\":6000,\"error_subcode\":1363042,\"is_transient\":false,\"error_user_title\":\"No permission to upload video\",\"error_user_msg\":\"You don\'t have permission to upload a video here.\",\"fbtrace_id\":\"ARkOg8P0zeCoykZOSOh6R9O\"}}','2026-01-02 09:36:29','2026-01-02 09:36:38'),
(131,1,'instagram',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767354779_6957b19b051a2.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767354779_6957b19b051a2.mp4','',NULL,NULL,'failed','HTTP Error 400: {\"error\":{\"message\":\"(#10) Application does not have permission for this action\",\"type\":\"OAuthException\",\"code\":10,\"fbtrace_id\":\"A8BcouFCN0ABYwC0h042HF0\"}}','2026-01-02 09:44:43','2026-01-02 09:44:44'),
(132,1,'instagram',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','xfdgfhfgh',NULL,NULL,'failed','Upload timed out - stuck in pending status','2026-01-02 10:14:04','2026-01-02 10:40:06'),
(133,1,'facebook',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','xfdgfhfgh',NULL,NULL,'failed','Upload timed out - stuck in pending status','2026-01-02 10:14:04','2026-01-02 10:40:06'),
(134,1,'instagram',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','xfdgfhfgh',NULL,NULL,'failed','Upload timed out - stuck in pending status','2026-01-02 10:21:18','2026-01-02 10:40:06'),
(135,1,'facebook',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','xfdgfhfgh',NULL,NULL,'failed','Upload timed out - stuck in pending status','2026-01-02 10:21:18','2026-01-02 10:40:06'),
(136,1,'instagram',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','UVa creation test',NULL,NULL,'pending',NULL,'2026-01-02 10:41:28','2026-01-02 10:41:28'),
(137,1,'facebook',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','UVa creation test',NULL,NULL,'pending',NULL,'2026-01-02 10:41:28','2026-01-02 10:41:28'),
(138,1,'facebook',3,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767353042_6957aad241d79.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767353042_6957aad241d79.mp4','lets uploard','1192953279642794','1192953279642794','published',NULL,'2026-01-02 10:43:18','2026-01-02 10:43:29'),
(139,1,'instagram',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767354779_6957b19b05122.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767354779_6957b19b05122.mp4','lets test uploard','17850735165604121','17905771683316030','published',NULL,'2026-01-02 10:43:19','2026-01-02 10:44:01'),
(140,1,'facebook',2,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767354779_6957b19b05122.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767354779_6957b19b05122.mp4','lets test uploard','1934757987399572','1934757987399572','published',NULL,'2026-01-02 10:43:19','2026-01-02 10:43:28'),
(141,1,'instagram',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','UVa creation test','17921732796212923','18314415838301952','published',NULL,'2026-01-02 10:46:38','2026-01-02 10:47:20'),
(142,1,'facebook',4,'D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','https://ya.yaspik.tech/imgen/public_html/public_html/public/videos/generated_video/combined_video_1767366254_6957de6e558b1.mp4','UVa creation test','1580650089607797','1580650089607797','published',NULL,'2026-01-02 10:46:38','2026-01-02 10:47:09');
/*!40000 ALTER TABLE `instagram_upload_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT  IGNORE INTO `logs` VALUES
(1,1,'success','Customer created successfully','2025-12-10 12:34:46','2025-12-10 12:34:46'),
(2,1,'success','Customer Template created successfully','2025-12-10 12:36:31','2025-12-10 12:36:31'),
(7,4,'success','Task created successfully','2025-12-10 14:00:28','2025-12-10 14:00:28'),
(8,5,'success','Task created successfully','2025-12-10 14:01:33','2025-12-10 14:01:33'),
(9,5,'success','Images generated successfully. Ready to send.','2025-12-10 14:02:11','2025-12-10 14:02:11'),
(10,6,'success','Task created successfully','2025-12-10 14:17:11','2025-12-10 14:17:11'),
(11,6,'success','Images generated successfully. Ready to send.','2025-12-10 14:17:29','2025-12-10 14:17:29'),
(12,7,'success','Task created successfully','2025-12-10 14:20:34','2025-12-10 14:20:34'),
(13,7,'success','Images generated successfully. Ready to send.','2025-12-10 14:20:45','2025-12-10 14:20:45'),
(14,1,'success','Customer Template updated successfully','2025-12-10 14:21:52','2025-12-10 14:21:52'),
(15,1,'success','Customer Template updated successfully','2025-12-10 14:22:23','2025-12-10 14:22:23'),
(16,1,'success','Customer Template updated successfully','2025-12-10 14:24:04','2025-12-10 14:24:04'),
(20,9,'success','Task created successfully','2025-12-10 14:28:38','2025-12-10 14:28:38'),
(21,9,'success','Images generated successfully. Ready to send.','2025-12-10 14:30:07','2025-12-10 14:30:07'),
(22,10,'success','Task created successfully','2025-12-10 14:31:22','2025-12-10 14:31:22'),
(23,10,'success','Images generated successfully. Ready to send.','2025-12-10 14:31:35','2025-12-10 14:31:35'),
(24,11,'success','Task created successfully','2025-12-10 14:44:37','2025-12-10 14:44:37'),
(25,11,'success','Images generated successfully. Ready to send.','2025-12-10 14:44:47','2025-12-10 14:44:47'),
(26,11,'success','Images generated successfully. Ready to send.','2025-12-10 14:49:31','2025-12-10 14:49:31'),
(33,10,'success','Images generated successfully. Ready to send.','2025-12-10 15:15:13','2025-12-10 15:15:13'),
(34,14,'success','Task created successfully','2025-12-10 15:15:43','2025-12-10 15:15:43'),
(35,14,'success','Images generated successfully. Ready to send.','2025-12-10 15:17:07','2025-12-10 15:17:07'),
(36,15,'success','Task created successfully','2025-12-11 04:11:16','2025-12-11 04:11:16'),
(37,15,'success','Images generated successfully. Ready to send.','2025-12-11 04:11:29','2025-12-11 04:11:29'),
(38,16,'success','Task created successfully','2025-12-11 04:13:17','2025-12-11 04:13:17'),
(39,16,'success','Images generated successfully. Ready to send.','2025-12-11 04:13:27','2025-12-11 04:13:27'),
(40,3,'success','Template created successfully','2025-12-11 06:16:49','2025-12-11 06:16:49'),
(41,3,'success','Customer created successfully','2025-12-11 06:17:24','2025-12-11 06:17:24'),
(42,4,'success','Customer Template created successfully','2025-12-11 06:17:58','2025-12-11 06:17:58'),
(43,5,'success','Customer Template created successfully','2025-12-11 06:18:25','2025-12-11 06:18:25'),
(44,17,'success','Task created successfully','2025-12-11 06:19:09','2025-12-11 06:19:09'),
(45,18,'success','Task created successfully','2025-12-11 06:19:16','2025-12-11 06:19:16'),
(46,18,'success','Images generated successfully. Ready to send.','2025-12-11 06:19:30','2025-12-11 06:19:30'),
(47,17,'success','Images generated successfully. Ready to send.','2025-12-11 06:19:36','2025-12-11 06:19:36'),
(48,6,'success','Customer Template created successfully','2025-12-11 13:25:11','2025-12-11 13:25:11'),
(49,7,'success','Customer Template created successfully','2025-12-11 14:58:28','2025-12-11 14:58:28'),
(50,7,'success','Customer Template updated successfully','2025-12-11 15:26:21','2025-12-11 15:26:21'),
(51,19,'success','Task created successfully','2025-12-13 08:05:15','2025-12-13 08:05:15'),
(52,19,'success','Images generated successfully. Ready to send.','2025-12-13 08:06:25','2025-12-13 08:06:25'),
(53,8,'success','Customer Template created successfully','2025-12-14 14:54:48','2025-12-14 14:54:48'),
(54,9,'success','Customer Template created successfully','2025-12-14 14:55:12','2025-12-14 14:55:12'),
(55,20,'success','Video task created successfully','2025-12-14 15:01:48','2025-12-14 15:01:48'),
(56,20,'success','Videos generated successfully. Ready to send.','2025-12-14 15:01:59','2025-12-14 15:01:59'),
(57,21,'success','Video task created successfully','2025-12-14 15:37:46','2025-12-14 15:37:46'),
(58,21,'success','Videos generated successfully. Ready to send.','2025-12-14 15:37:54','2025-12-14 15:37:54'),
(59,20,'success','Videos generated successfully. Ready to send.','2025-12-14 15:43:05','2025-12-14 15:43:05'),
(60,22,'success','Video task created successfully','2025-12-14 15:56:49','2025-12-14 15:56:49'),
(61,22,'success','Videos generated successfully. Ready to send.','2025-12-14 15:57:06','2025-12-14 15:57:06'),
(62,20,'success','Images generated successfully. Ready to send.','2025-12-14 16:12:19','2025-12-14 16:12:19'),
(63,23,'success','Video task created successfully','2025-12-14 16:13:04','2025-12-14 16:13:04'),
(64,23,'success','Videos generated successfully. Ready to send.','2025-12-14 16:13:24','2025-12-14 16:13:24'),
(65,22,'success','Videos generated successfully. Ready to send.','2025-12-14 16:25:48','2025-12-14 16:25:48'),
(66,24,'success','Video task created successfully','2025-12-14 16:26:49','2025-12-14 16:26:49'),
(67,24,'success','Videos generated successfully. Ready to send.','2025-12-14 16:27:07','2025-12-14 16:27:07'),
(68,2,'success','Video template created successfully','2025-12-14 16:37:56','2025-12-14 16:37:56'),
(69,10,'success','Customer Template created successfully','2025-12-14 16:38:40','2025-12-14 16:38:40'),
(70,10,'success','Customer Template updated successfully','2025-12-14 16:39:19','2025-12-14 16:39:19'),
(71,25,'success','Video task created successfully','2025-12-14 16:39:54','2025-12-14 16:39:54'),
(72,26,'success','Video task created successfully','2025-12-14 16:41:37','2025-12-14 16:41:37'),
(73,27,'success','Video task created successfully','2025-12-14 16:43:32','2025-12-14 16:43:32'),
(74,28,'success','Video task created successfully','2025-12-14 16:44:25','2025-12-14 16:44:25'),
(75,25,'success','Videos generated successfully. Ready to send.','2025-12-14 16:47:38','2025-12-14 16:47:38'),
(76,26,'success','Videos generated successfully. Ready to send.','2025-12-14 16:47:48','2025-12-14 16:47:48'),
(77,27,'success','Videos generated successfully. Ready to send.','2025-12-14 16:47:57','2025-12-14 16:47:57'),
(78,28,'success','Videos generated successfully. Ready to send.','2025-12-14 16:48:16','2025-12-14 16:48:16'),
(79,29,'success','Video task created successfully','2025-12-14 17:17:37','2025-12-14 17:17:37'),
(80,30,'success','Video task created successfully','2025-12-14 17:20:12','2025-12-14 17:20:12'),
(81,29,'success','Videos generated successfully. Ready to send.','2025-12-14 17:27:07','2025-12-14 17:27:07'),
(82,30,'success','Videos generated successfully. Ready to send.','2025-12-14 17:27:18','2025-12-14 17:27:18'),
(83,31,'success','Video task created successfully','2025-12-14 17:30:37','2025-12-14 17:30:37'),
(84,32,'success','Video task created successfully','2025-12-14 17:32:09','2025-12-14 17:32:09'),
(85,32,'success','Videos generated successfully. Ready to send.','2025-12-14 17:37:34','2025-12-14 17:37:34'),
(86,31,'success','Videos generated successfully. Ready to send.','2025-12-14 17:42:58','2025-12-14 17:42:58'),
(87,33,'success','Video task created successfully','2025-12-14 17:44:03','2025-12-14 17:44:03'),
(88,34,'success','Video task created successfully','2025-12-14 17:44:50','2025-12-14 17:44:50'),
(89,34,'success','Videos generated successfully. Ready to send.','2025-12-14 17:45:49','2025-12-14 17:45:49'),
(90,35,'success','Video task created successfully','2025-12-14 17:49:09','2025-12-14 17:49:09'),
(91,35,'success','Videos generated successfully. Ready to send.','2025-12-14 17:49:56','2025-12-14 17:49:56'),
(92,10,'success','Customer Template updated successfully','2025-12-14 17:51:12','2025-12-14 17:51:12'),
(93,10,'success','Customer Template updated successfully','2025-12-14 17:51:47','2025-12-14 17:51:47'),
(94,10,'success','Customer Template updated successfully','2025-12-14 17:52:19','2025-12-14 17:52:19'),
(95,11,'success','Customer Template created successfully','2025-12-14 17:53:38','2025-12-14 17:53:38'),
(96,36,'success','Video task created successfully','2025-12-14 17:54:13','2025-12-14 17:54:13'),
(97,36,'success','Videos generated successfully. Ready to send.','2025-12-14 17:55:32','2025-12-14 17:55:32'),
(98,33,'success','Videos generated successfully. Ready to send.','2025-12-14 17:56:42','2025-12-14 17:56:42'),
(99,12,'success','Customer Template created successfully','2025-12-14 18:00:49','2025-12-14 18:00:49'),
(100,37,'success','Video task created successfully','2025-12-14 18:01:26','2025-12-14 18:01:26'),
(101,3,'success','Video template created successfully','2025-12-15 02:45:50','2025-12-15 02:45:50'),
(102,13,'success','Customer Template created successfully','2025-12-15 02:48:55','2025-12-15 02:48:55'),
(103,38,'success','Video task created successfully','2025-12-15 02:49:19','2025-12-15 02:49:19'),
(104,38,'success','Videos generated successfully. Ready to send.','2025-12-15 02:51:22','2025-12-15 02:51:22'),
(105,37,'success','Images generated successfully. Ready to send.','2025-12-15 03:33:43','2025-12-15 03:33:43'),
(106,39,'success','Video task created successfully','2025-12-15 03:34:06','2025-12-15 03:34:06'),
(107,39,'success','Videos generated successfully. Ready to send.','2025-12-15 03:34:39','2025-12-15 03:34:39'),
(108,40,'success','Video task created successfully','2025-12-15 03:34:54','2025-12-15 03:34:54'),
(109,40,'success','Videos generated successfully. Ready to send.','2025-12-15 03:35:24','2025-12-15 03:35:24'),
(110,41,'success','Video task created successfully','2025-12-15 03:37:26','2025-12-15 03:37:26'),
(111,41,'success','Videos generated successfully. Ready to send.','2025-12-15 03:38:29','2025-12-15 03:38:29'),
(112,42,'success','Video task created successfully','2025-12-15 03:40:22','2025-12-15 03:40:22'),
(113,43,'success','Video task created successfully','2025-12-15 04:20:28','2025-12-15 04:20:28'),
(114,44,'success','Video task created successfully','2025-12-15 04:20:55','2025-12-15 04:20:55'),
(115,44,'success','Videos generated successfully. Ready to send.','2025-12-15 04:21:28','2025-12-15 04:21:28'),
(116,43,'success','Images generated successfully. Ready to send.','2025-12-15 04:21:59','2025-12-15 04:21:59'),
(117,45,'success','Video task created successfully','2025-12-15 04:23:48','2025-12-15 04:23:48'),
(118,45,'success','Videos generated successfully. Ready to send.','2025-12-15 04:25:17','2025-12-15 04:25:17'),
(119,46,'success','Video task created successfully','2025-12-15 04:30:04','2025-12-15 04:30:04'),
(120,46,'success','Videos generated successfully. Ready to send.','2025-12-15 04:31:01','2025-12-15 04:31:01'),
(121,47,'success','Video task created successfully','2025-12-15 04:34:52','2025-12-15 04:34:52'),
(122,47,'success','Videos generated successfully. Ready to send.','2025-12-15 04:35:23','2025-12-15 04:35:23'),
(123,48,'success','Video task created successfully','2025-12-15 04:37:24','2025-12-15 04:37:24'),
(124,48,'success','Videos generated successfully. Ready to send.','2025-12-15 04:38:26','2025-12-15 04:38:26'),
(125,49,'success','Video task created successfully','2025-12-15 04:38:48','2025-12-15 04:38:48'),
(126,49,'success','Videos generated successfully. Ready to send.','2025-12-15 04:39:25','2025-12-15 04:39:25'),
(127,4,'success','Template created successfully','2025-12-15 04:42:47','2025-12-15 04:42:47'),
(128,14,'success','Customer Template created successfully','2025-12-15 04:43:39','2025-12-15 04:43:39'),
(129,50,'success','Task created successfully','2025-12-15 04:44:55','2025-12-15 04:44:55'),
(130,50,'success','Images generated successfully. Ready to send.','2025-12-15 04:45:00','2025-12-15 04:45:00'),
(131,51,'success','Task created successfully','2025-12-15 04:45:48','2025-12-15 04:45:48'),
(132,51,'success','Images generated successfully. Ready to send.','2025-12-15 04:45:54','2025-12-15 04:45:54'),
(133,42,'success','Videos generated successfully. Ready to send.','2025-12-15 04:52:43','2025-12-15 04:52:43'),
(134,52,'success','Video task created successfully','2025-12-15 05:01:32','2025-12-15 05:01:32'),
(135,52,'success','Videos generated successfully. Ready to send.','2025-12-15 05:03:29','2025-12-15 05:03:29'),
(136,53,'success','Video task created successfully','2025-12-15 05:06:55','2025-12-15 05:06:55'),
(137,53,'success','Videos generated successfully. Ready to send.','2025-12-15 05:09:22','2025-12-15 05:09:22'),
(138,54,'success','Video task created successfully','2025-12-15 05:11:37','2025-12-15 05:11:37'),
(139,55,'success','Video task created successfully','2025-12-15 05:12:54','2025-12-15 05:12:54'),
(140,55,'success','Videos generated successfully. Ready to send.','2025-12-15 05:17:53','2025-12-15 05:17:53'),
(141,54,'success','Videos generated successfully. Ready to send.','2025-12-15 05:20:41','2025-12-15 05:20:41'),
(142,56,'success','Video task created successfully','2025-12-15 07:02:45','2025-12-15 07:02:45'),
(143,56,'success','Videos generated successfully. Ready to send.','2025-12-15 07:30:14','2025-12-15 07:30:14'),
(144,57,'success','Video task created successfully','2025-12-15 09:52:44','2025-12-15 09:52:44'),
(145,57,'success','Videos generated successfully. Ready to send.','2025-12-15 09:54:10','2025-12-15 09:54:10'),
(146,58,'success','Video task created successfully','2025-12-15 10:01:13','2025-12-15 10:01:13'),
(147,58,'success','Videos generated successfully. Ready to send.','2025-12-15 10:01:53','2025-12-15 10:01:53'),
(148,59,'success','Video task created successfully','2025-12-15 10:03:28','2025-12-15 10:03:28'),
(149,60,'success','Video task created successfully','2025-12-15 12:13:19','2025-12-15 12:13:19'),
(150,60,'success','Videos generated successfully. Ready to send.','2025-12-15 12:14:14','2025-12-15 12:14:14'),
(151,59,'success','Videos generated successfully. Ready to send.','2025-12-15 12:20:43','2025-12-15 12:20:43'),
(152,61,'success','Video task created successfully','2025-12-15 12:25:48','2025-12-15 12:25:48'),
(153,61,'success','Videos generated successfully. Ready to send.','2025-12-15 12:26:48','2025-12-15 12:26:48'),
(154,62,'success','Video task created successfully','2025-12-15 12:29:52','2025-12-15 12:29:52'),
(155,62,'success','Videos generated successfully. Ready to send.','2025-12-15 12:30:31','2025-12-15 12:30:31'),
(156,63,'success','Video task created successfully','2025-12-15 12:41:23','2025-12-15 12:41:23'),
(157,63,'success','Videos generated successfully. Ready to send.','2025-12-15 12:42:05','2025-12-15 12:42:05'),
(158,64,'success','Video task created successfully','2025-12-15 12:42:43','2025-12-15 12:42:43'),
(159,64,'success','Videos generated successfully. Ready to send.','2025-12-15 12:42:54','2025-12-15 12:42:54'),
(160,65,'success','Video task created successfully','2025-12-15 12:45:01','2025-12-15 12:45:01'),
(161,65,'success','Videos generated successfully. Ready to send.','2025-12-15 12:45:40','2025-12-15 12:45:40'),
(162,66,'success','Video task created successfully','2025-12-15 12:57:59','2025-12-15 12:57:59'),
(163,66,'success','Videos generated successfully. Ready to send.','2025-12-15 12:59:05','2025-12-15 12:59:05'),
(164,4,'success','Video template created successfully','2025-12-18 03:12:07','2025-12-18 03:12:07'),
(165,4,'success','Customer created successfully','2025-12-18 03:13:14','2025-12-18 03:13:14'),
(166,15,'success','Customer Template created successfully','2025-12-18 03:14:37','2025-12-18 03:14:37'),
(167,67,'success','Video task created successfully','2025-12-18 03:16:38','2025-12-18 03:16:38'),
(168,67,'success','Videos generated successfully. Ready to send.','2025-12-18 03:17:06','2025-12-18 03:17:06'),
(169,5,'success','Customer created successfully','2025-12-29 10:16:45','2025-12-29 10:16:45'),
(170,16,'success','Customer Template created successfully','2025-12-29 10:30:51','2025-12-29 10:30:51'),
(171,68,'success','Video task created successfully','2025-12-29 10:31:39','2025-12-29 10:31:39'),
(172,68,'success','Videos generated successfully. Ready to send.','2025-12-29 10:32:27','2025-12-29 10:32:27'),
(173,5,'success','Template created successfully','2025-12-29 11:01:08','2025-12-29 11:01:08'),
(174,6,'success','Customer created successfully','2025-12-29 11:02:05','2025-12-29 11:02:05'),
(175,5,'success','Video template created successfully','2025-12-29 11:02:54','2025-12-29 11:02:54'),
(176,6,'success','Video template created successfully','2025-12-29 11:06:08','2025-12-29 11:06:08'),
(177,17,'success','Customer Template created successfully','2025-12-29 11:06:55','2025-12-29 11:06:55'),
(178,69,'success','Video task created successfully','2025-12-29 11:07:21','2025-12-29 11:07:21'),
(179,69,'success','Videos generated successfully. Ready to send.','2025-12-29 11:07:56','2025-12-29 11:07:56'),
(180,70,'success','Video task created successfully','2025-12-30 07:52:28','2025-12-30 07:52:28'),
(181,70,'success','Videos generated successfully. Ready to send.','2025-12-30 07:57:10','2025-12-30 07:57:10'),
(182,71,'success','Video task created successfully','2025-12-30 08:12:05','2025-12-30 08:12:05'),
(183,72,'success','Video task created successfully','2025-12-30 08:13:57','2025-12-30 08:13:57'),
(184,72,'success','Videos generated successfully. Ready to send.','2025-12-30 08:14:20','2025-12-30 08:14:20'),
(185,73,'success','Video task created successfully','2025-12-30 08:15:23','2025-12-30 08:15:23'),
(186,73,'success','Videos generated successfully. Ready to send.','2025-12-30 08:15:29','2025-12-30 08:15:29'),
(187,74,'success','Video task created successfully','2025-12-30 09:10:46','2025-12-30 09:10:46'),
(188,74,'success','Videos generated successfully. Ready to send.','2025-12-30 09:10:59','2025-12-30 09:10:59'),
(189,71,'success','Videos generated successfully. Ready to send.','2025-12-30 10:26:37','2025-12-30 10:26:37'),
(190,75,'success','Video task created successfully','2025-12-30 10:46:11','2025-12-30 10:46:11'),
(191,75,'success','Videos generated successfully. Ready to send.','2025-12-30 10:47:01','2025-12-30 10:47:01'),
(192,7,'success','Customer created successfully','2026-01-01 08:37:46','2026-01-01 08:37:46'),
(193,18,'success','Customer Template created successfully','2026-01-01 08:39:05','2026-01-01 08:39:05'),
(194,76,'success','Video task created successfully','2026-01-01 08:50:44','2026-01-01 08:50:44'),
(195,76,'success','Videos generated successfully. Ready to send.','2026-01-01 08:51:51','2026-01-01 08:51:51'),
(196,77,'success','Video task created successfully','2026-01-01 12:38:25','2026-01-01 12:38:25'),
(197,77,'success','Videos generated successfully. Ready to send.','2026-01-01 12:39:30','2026-01-01 12:39:30'),
(198,78,'success','Video task created successfully','2026-01-01 12:49:20','2026-01-01 12:49:20'),
(199,78,'success','Videos generated successfully. Ready to send.','2026-01-01 12:50:19','2026-01-01 12:50:19'),
(200,79,'success','Video task created successfully','2026-01-01 12:51:33','2026-01-01 12:51:33'),
(201,79,'success','Videos generated successfully. Ready to send.','2026-01-01 12:52:54','2026-01-01 12:52:54'),
(202,80,'success','Video task created successfully','2026-01-02 05:53:38','2026-01-02 05:53:38'),
(203,80,'success','Videos generated successfully. Ready to send.','2026-01-02 05:55:27','2026-01-02 05:55:27'),
(204,81,'success','Video task created successfully','2026-01-02 06:19:13','2026-01-02 06:19:13'),
(205,81,'success','Videos generated successfully. Ready to send.','2026-01-02 06:23:57','2026-01-02 06:23:57'),
(206,8,'success','Customer created successfully','2026-01-02 07:19:43','2026-01-02 07:19:43'),
(207,7,'success','Video template created successfully','2026-01-02 07:20:59','2026-01-02 07:20:59'),
(208,19,'success','Customer Template created successfully','2026-01-02 07:21:35','2026-01-02 07:21:35'),
(209,82,'success','Video task created successfully','2026-01-02 07:22:15','2026-01-02 07:22:15'),
(210,82,'success','Videos generated successfully. Ready to send.','2026-01-02 07:23:10','2026-01-02 07:23:10'),
(211,83,'success','Video task created successfully','2026-01-02 09:34:02','2026-01-02 09:34:02'),
(212,83,'success','Videos generated successfully. Ready to send.','2026-01-02 09:35:09','2026-01-02 09:35:09'),
(213,84,'success','Video task created successfully','2026-01-02 11:14:50','2026-01-02 11:14:50'),
(214,85,'success','Video task created successfully','2026-01-02 12:01:13','2026-01-02 12:01:13'),
(215,85,'success','Videos generated successfully. Ready to send.','2026-01-02 12:02:20','2026-01-02 12:02:20'),
(216,84,'success','Videos generated successfully. Ready to send.','2026-01-02 12:02:21','2026-01-02 12:02:21'),
(217,86,'success','Video task created successfully','2026-01-02 12:03:42','2026-01-02 12:03:42'),
(218,86,'success','Videos generated successfully. Ready to send.','2026-01-02 12:05:20','2026-01-02 12:05:20'),
(219,87,'success','Video task created successfully','2026-01-02 12:07:50','2026-01-02 12:07:50'),
(220,87,'success','Videos generated successfully. Ready to send.','2026-01-02 12:09:37','2026-01-02 12:09:37'),
(221,88,'success','Video task created successfully','2026-01-02 12:13:22','2026-01-02 12:13:22'),
(222,88,'success','Videos generated successfully. Ready to send.','2026-01-02 12:13:37','2026-01-02 12:13:37'),
(223,89,'success','Video task created successfully','2026-01-02 12:18:35','2026-01-02 12:18:35'),
(224,89,'success','Videos generated successfully. Ready to send.','2026-01-02 12:18:46','2026-01-02 12:18:46'),
(225,90,'success','Video task created successfully','2026-01-02 12:35:32','2026-01-02 12:35:32'),
(226,90,'success','Videos generated successfully. Ready to send.','2026-01-02 12:37:23','2026-01-02 12:37:23'),
(227,91,'success','Video task created successfully','2026-01-02 12:40:31','2026-01-02 12:40:31'),
(228,91,'success','Videos generated successfully. Ready to send.','2026-01-02 12:40:41','2026-01-02 12:40:41'),
(229,92,'success','Video task created successfully','2026-01-02 12:43:07','2026-01-02 12:43:07'),
(230,92,'success','Videos generated successfully. Ready to send.','2026-01-02 12:43:14','2026-01-02 12:43:14'),
(231,93,'success','Video task created successfully','2026-01-02 12:56:40','2026-01-02 12:56:40'),
(232,93,'success','Videos generated successfully. Ready to send.','2026-01-02 13:30:06','2026-01-02 13:30:06'),
(233,94,'success','Video task created successfully','2026-01-02 13:36:37','2026-01-02 13:36:37'),
(234,94,'success','Videos generated successfully. Ready to send.','2026-01-02 13:36:44','2026-01-02 13:36:44'),
(235,95,'success','Video task created successfully','2026-01-02 13:41:10','2026-01-02 13:41:10'),
(236,95,'success','Videos generated successfully. Ready to send.','2026-01-02 13:41:16','2026-01-02 13:41:16'),
(237,96,'success','Video task created successfully','2026-01-02 13:48:29','2026-01-02 13:48:29'),
(238,96,'success','Videos generated successfully. Ready to send.','2026-01-02 13:48:37','2026-01-02 13:48:37'),
(239,97,'success','Video task created successfully','2026-01-02 13:52:25','2026-01-02 13:52:25'),
(240,97,'success','Videos generated successfully. Ready to send.','2026-01-02 13:52:31','2026-01-02 13:52:31'),
(241,98,'success','Video task created successfully','2026-01-02 14:04:09','2026-01-02 14:04:09'),
(242,98,'success','Videos generated successfully. Ready to send.','2026-01-02 14:04:20','2026-01-02 14:04:20'),
(243,99,'success','Video task created successfully','2026-01-02 15:19:38','2026-01-02 15:19:38'),
(244,99,'success','Videos generated successfully. Ready to send.','2026-01-02 15:19:55','2026-01-02 15:19:55'),
(245,100,'success','Video task created successfully','2026-01-02 15:24:00','2026-01-02 15:24:00'),
(246,100,'success','Videos generated successfully. Ready to send.','2026-01-02 15:24:09','2026-01-02 15:24:09'),
(247,101,'success','Video task created successfully','2026-01-02 15:35:02','2026-01-02 15:35:02'),
(248,101,'success','Videos generated successfully. Ready to send.','2026-01-02 15:35:09','2026-01-02 15:35:09'),
(249,102,'success','Video task created successfully','2026-01-02 15:36:37','2026-01-02 15:36:37'),
(250,102,'success','Videos generated successfully. Ready to send.','2026-01-02 15:40:09','2026-01-02 15:40:09'),
(251,103,'success','Video task created successfully','2026-01-02 15:42:50','2026-01-02 15:42:50'),
(252,103,'success','Videos generated successfully. Ready to send.','2026-01-02 15:42:58','2026-01-02 15:42:58'),
(253,104,'success','Video task created successfully','2026-01-02 15:46:31','2026-01-02 15:46:31'),
(254,104,'success','Videos generated successfully. Ready to send.','2026-01-02 15:46:37','2026-01-02 15:46:37'),
(255,105,'success','Video task created successfully','2026-01-02 15:50:52','2026-01-02 15:50:52'),
(256,105,'success','Videos generated successfully. Ready to send.','2026-01-02 15:50:58','2026-01-02 15:50:58'),
(257,106,'success','Video task created successfully','2026-01-02 15:53:52','2026-01-02 15:53:52'),
(258,106,'success','Videos generated successfully. Ready to send.','2026-01-02 15:54:00','2026-01-02 15:54:00'),
(259,107,'success','Video task created successfully','2026-01-02 15:59:04','2026-01-02 15:59:04'),
(260,107,'success','Videos generated successfully. Ready to send.','2026-01-02 15:59:08','2026-01-02 15:59:08'),
(261,108,'success','Video task created successfully','2026-01-02 16:00:43','2026-01-02 16:00:43'),
(262,108,'success','Videos generated successfully. Ready to send.','2026-01-02 16:00:50','2026-01-02 16:00:50'),
(263,109,'success','Video task created successfully','2026-01-02 16:04:46','2026-01-02 16:04:46'),
(264,109,'success','Videos generated successfully. Ready to send.','2026-01-02 16:04:55','2026-01-02 16:04:55'),
(265,110,'success','Video task created successfully','2026-01-02 16:15:19','2026-01-02 16:15:19'),
(266,110,'success','Videos generated successfully. Ready to send.','2026-01-02 16:16:07','2026-01-02 16:16:07'),
(267,111,'success','Video task created successfully','2026-01-02 16:27:51','2026-01-02 16:27:51'),
(268,111,'success','Videos generated successfully. Ready to send.','2026-01-02 16:27:58','2026-01-02 16:27:58'),
(269,112,'success','Video task created successfully','2026-01-03 00:28:05','2026-01-03 00:28:05'),
(270,112,'success','Videos generated successfully. Ready to send.','2026-01-03 00:39:16','2026-01-03 00:39:16'),
(271,89,'success','Videos generated successfully. Ready to send.','2026-01-03 00:53:09','2026-01-03 00:53:09'),
(272,88,'success','Videos generated successfully. Ready to send.','2026-01-03 00:54:25','2026-01-03 00:54:25'),
(273,113,'success','Video task created successfully','2026-01-03 00:55:52','2026-01-03 00:55:52'),
(274,113,'success','Videos generated successfully. Ready to send.','2026-01-03 00:56:04','2026-01-03 00:56:04'),
(275,89,'success','Videos generated successfully. Ready to send.','2026-01-03 00:58:49','2026-01-03 00:58:49'),
(276,88,'success','Videos generated successfully. Ready to send.','2026-01-03 00:58:52','2026-01-03 00:58:52'),
(277,114,'success','Video task created successfully','2026-01-03 01:02:05','2026-01-03 01:02:05'),
(278,114,'success','Videos generated successfully. Ready to send.','2026-01-03 01:02:18','2026-01-03 01:02:18'),
(279,115,'success','Video task created successfully','2026-01-03 11:45:39','2026-01-03 11:45:39'),
(280,115,'success','Videos generated successfully. Ready to send.','2026-01-03 11:45:48','2026-01-03 11:45:48'),
(281,116,'success','Video task created successfully','2026-01-03 11:52:32','2026-01-03 11:52:32'),
(282,116,'success','Videos generated successfully. Ready to send.','2026-01-03 11:52:39','2026-01-03 11:52:39'),
(283,117,'success','Video task created successfully','2026-01-03 11:53:34','2026-01-03 11:53:34'),
(284,117,'success','Videos generated successfully. Ready to send.','2026-01-03 11:53:40','2026-01-03 11:53:40'),
(285,118,'success','Video task created successfully','2026-01-03 11:55:57','2026-01-03 11:55:57'),
(286,118,'success','Videos generated successfully. Ready to send.','2026-01-03 11:56:03','2026-01-03 11:56:03'),
(287,119,'success','Video task created successfully','2026-01-03 12:16:22','2026-01-03 12:16:22'),
(288,119,'success','Videos generated successfully. Ready to send.','2026-01-03 12:16:29','2026-01-03 12:16:29'),
(289,120,'success','Video task created successfully','2026-01-03 12:19:28','2026-01-03 12:19:28'),
(290,120,'success','Videos generated successfully. Ready to send.','2026-01-03 12:19:34','2026-01-03 12:19:34'),
(291,121,'success','Video task created successfully','2026-01-03 12:30:39','2026-01-03 12:30:39'),
(292,121,'success','Videos generated successfully. Ready to send.','2026-01-03 12:30:45','2026-01-03 12:30:45'),
(293,122,'success','Video task created successfully','2026-01-03 12:36:29','2026-01-03 12:36:29'),
(294,122,'success','Videos generated successfully. Ready to send.','2026-01-03 12:36:37','2026-01-03 12:36:37'),
(295,123,'success','Video task created successfully','2026-01-03 13:05:50','2026-01-03 13:05:50'),
(296,123,'success','Videos generated successfully. Ready to send.','2026-01-03 13:05:56','2026-01-03 13:05:56'),
(297,124,'success','Video task created successfully','2026-01-03 13:07:39','2026-01-03 13:07:39'),
(298,124,'success','Videos generated successfully. Ready to send.','2026-01-03 13:07:46','2026-01-03 13:07:46'),
(299,125,'success','Video task created successfully','2026-01-03 13:09:58','2026-01-03 13:09:58'),
(300,125,'success','Videos generated successfully. Ready to send.','2026-01-03 13:10:06','2026-01-03 13:10:06'),
(301,126,'success','Video task created successfully','2026-01-03 13:15:48','2026-01-03 13:15:48'),
(302,126,'success','Videos generated successfully. Ready to send.','2026-01-03 13:16:42','2026-01-03 13:16:42'),
(303,127,'success','Video task created successfully','2026-01-03 13:19:44','2026-01-03 13:19:44'),
(304,127,'success','Videos generated successfully. Ready to send.','2026-01-03 13:19:51','2026-01-03 13:19:51'),
(305,128,'success','Video task created successfully','2026-01-03 13:21:35','2026-01-03 13:21:35'),
(306,128,'success','Videos generated successfully. Ready to send.','2026-01-03 13:21:46','2026-01-03 13:21:46'),
(307,129,'success','Video task created successfully','2026-01-07 11:58:03','2026-01-07 11:58:03'),
(308,129,'success','Videos generated successfully. Ready to send.','2026-01-07 11:58:25','2026-01-07 11:58:25'),
(309,130,'success','Video task created successfully','2026-01-07 12:02:27','2026-01-07 12:02:27'),
(310,130,'success','Videos generated successfully. Ready to send.','2026-01-07 12:02:32','2026-01-07 12:02:32'),
(311,131,'success','Video task created successfully','2026-01-07 12:12:02','2026-01-07 12:12:02'),
(312,131,'success','Videos generated successfully. Ready to send.','2026-01-07 12:12:17','2026-01-07 12:12:17'),
(313,132,'success','Video task created successfully','2026-01-07 12:17:09','2026-01-07 12:17:09'),
(314,132,'success','Videos generated successfully. Ready to send.','2026-01-07 12:17:14','2026-01-07 12:17:14'),
(315,133,'success','Video task created successfully','2026-01-07 12:28:01','2026-01-07 12:28:01'),
(316,133,'success','Videos generated successfully. Ready to send.','2026-01-07 12:28:09','2026-01-07 12:28:09'),
(317,134,'success','Video task created successfully','2026-01-07 12:29:16','2026-01-07 12:29:16'),
(318,134,'success','Videos generated successfully. Ready to send.','2026-01-07 12:29:22','2026-01-07 12:29:22'),
(319,20,'success','Customer Template created successfully','2026-01-07 12:50:21','2026-01-07 12:50:21'),
(320,135,'success','Video task created successfully','2026-01-07 12:51:13','2026-01-07 12:51:13'),
(321,135,'success','Videos generated successfully. Ready to send.','2026-01-07 12:51:19','2026-01-07 12:51:19'),
(322,136,'success','Video task created successfully','2026-01-08 06:10:20','2026-01-08 06:10:20'),
(323,136,'success','Videos generated successfully. Ready to send.','2026-01-08 06:10:29','2026-01-08 06:10:29'),
(324,137,'success','Video task created successfully','2026-01-08 06:23:31','2026-01-08 06:23:31'),
(325,137,'success','Videos generated successfully. Ready to send.','2026-01-08 06:24:05','2026-01-08 06:24:05'),
(326,138,'success','Video task created successfully','2026-01-09 05:46:25','2026-01-09 05:46:25'),
(327,138,'success','Videos generated successfully. Ready to send.','2026-01-09 05:47:06','2026-01-09 05:47:06'),
(328,139,'success','Video task created successfully','2026-01-09 05:58:51','2026-01-09 05:58:51'),
(329,140,'success','Video task created successfully','2026-01-09 06:07:00','2026-01-09 06:07:00'),
(330,141,'success','Video task created successfully','2026-01-09 06:12:03','2026-01-09 06:12:03'),
(331,140,'success','Videos queued for generation','2026-01-09 06:13:44','2026-01-09 06:13:44'),
(332,141,'success','Videos queued for generation','2026-01-09 06:13:44','2026-01-09 06:13:44'),
(333,139,'success','Videos queued for generation','2026-01-09 06:13:44','2026-01-09 06:13:44'),
(334,142,'success','Video task created successfully','2026-01-09 11:49:06','2026-01-09 11:49:06'),
(335,143,'success','Video task created successfully','2026-01-09 11:56:13','2026-01-09 11:56:13'),
(336,143,'success','Videos queued for generation','2026-01-09 11:56:18','2026-01-09 11:56:18'),
(337,144,'success','Video task created successfully','2026-01-09 12:01:15','2026-01-09 12:01:15'),
(338,144,'success','Videos queued for generation','2026-01-09 12:01:23','2026-01-09 12:01:23'),
(339,145,'success','Video task created successfully','2026-01-09 12:10:06','2026-01-09 12:10:06'),
(340,145,'success','Videos queued for generation','2026-01-09 12:10:13','2026-01-09 12:10:13'),
(341,146,'success','Video task created successfully','2026-01-09 12:32:37','2026-01-09 12:32:37'),
(342,146,'success','Videos queued for generation','2026-01-09 12:32:50','2026-01-09 12:32:50'),
(343,147,'success','Video task created successfully','2026-01-09 12:34:44','2026-01-09 12:34:44'),
(344,147,'success','Videos queued for generation','2026-01-09 12:34:51','2026-01-09 12:34:51'),
(345,148,'success','Video task created successfully','2026-01-09 12:36:43','2026-01-09 12:36:43'),
(346,149,'success','Video task created successfully','2026-01-09 12:38:59','2026-01-09 12:38:59'),
(347,149,'success','Videos queued for generation','2026-01-09 12:44:59','2026-01-09 12:44:59'),
(348,148,'success','Videos queued for generation','2026-01-09 12:45:36','2026-01-09 12:45:36'),
(349,150,'success','Video task created successfully','2026-01-09 12:53:20','2026-01-09 12:53:20'),
(350,150,'success','Videos queued for generation','2026-01-09 12:53:25','2026-01-09 12:53:25'),
(351,151,'success','Video task created successfully','2026-01-09 12:56:45','2026-01-09 12:56:45'),
(352,151,'success','Videos queued for generation','2026-01-09 12:56:53','2026-01-09 12:56:53'),
(353,152,'success','Video task created successfully','2026-01-09 13:02:34','2026-01-09 13:02:34'),
(354,152,'success','Videos queued for generation','2026-01-09 13:02:40','2026-01-09 13:02:40'),
(355,153,'success','Video task created successfully','2026-01-09 13:04:07','2026-01-09 13:04:07'),
(356,153,'success','Videos queued for generation','2026-01-09 13:04:43','2026-01-09 13:04:43'),
(357,154,'success','Video task created successfully','2026-01-09 13:06:05','2026-01-09 13:06:05'),
(358,154,'success','Videos queued for generation','2026-01-09 13:06:13','2026-01-09 13:06:13'),
(359,155,'success','Video task created successfully','2026-01-09 13:06:51','2026-01-09 13:06:51'),
(360,155,'success','Videos queued for generation','2026-01-09 13:06:56','2026-01-09 13:06:56'),
(361,156,'success','Video task created successfully','2026-01-09 13:13:18','2026-01-09 13:13:18'),
(362,156,'success','Videos queued for generation','2026-01-09 13:13:23','2026-01-09 13:13:23'),
(363,157,'success','Video task created successfully','2026-01-09 13:25:07','2026-01-09 13:25:07'),
(364,157,'success','Videos queued for generation','2026-01-09 13:26:45','2026-01-09 13:26:45'),
(365,158,'success','Video task created successfully','2026-01-09 13:31:51','2026-01-09 13:31:51'),
(366,158,'success','Videos queued for generation','2026-01-09 13:31:55','2026-01-09 13:31:55'),
(367,159,'success','Video task created successfully','2026-01-09 13:42:09','2026-01-09 13:42:09'),
(368,159,'success','Videos queued for generation','2026-01-09 13:42:17','2026-01-09 13:42:17'),
(369,160,'success','Video task created successfully','2026-01-09 13:42:49','2026-01-09 13:42:49'),
(370,160,'success','Videos queued for generation','2026-01-09 13:42:55','2026-01-09 13:42:55'),
(371,161,'success','Video task created successfully','2026-01-09 13:48:55','2026-01-09 13:48:55'),
(372,161,'success','Videos queued for generation','2026-01-09 13:49:00','2026-01-09 13:49:00'),
(373,162,'success','Video task created successfully','2026-01-09 14:09:27','2026-01-09 14:09:27'),
(374,162,'success','Videos queued for generation','2026-01-09 14:09:39','2026-01-09 14:09:39'),
(375,163,'success','Video task created successfully','2026-01-09 14:14:03','2026-01-09 14:14:03'),
(376,163,'success','Videos queued for generation','2026-01-09 14:14:09','2026-01-09 14:14:09'),
(377,164,'success','Video task created successfully','2026-01-09 14:21:35','2026-01-09 14:21:35'),
(378,164,'success','Videos queued for generation','2026-01-09 14:21:40','2026-01-09 14:21:40'),
(379,165,'success','Video task created successfully','2026-01-09 14:27:24','2026-01-09 14:27:24'),
(380,165,'success','Videos queued for generation','2026-01-09 14:27:30','2026-01-09 14:27:30'),
(381,166,'success','Video task created successfully','2026-01-09 14:54:35','2026-01-09 14:54:35'),
(382,166,'success','Videos queued for generation','2026-01-09 14:54:41','2026-01-09 14:54:41'),
(383,167,'success','Video task created successfully','2026-01-09 15:02:54','2026-01-09 15:02:54'),
(384,167,'success','Videos queued for generation','2026-01-09 15:02:59','2026-01-09 15:02:59'),
(385,168,'success','Video task created successfully','2026-01-09 15:56:21','2026-01-09 15:56:21'),
(386,168,'success','Videos queued for generation','2026-01-09 15:56:26','2026-01-09 15:56:26'),
(387,169,'success','Video task created successfully','2026-01-09 16:12:01','2026-01-09 16:12:01'),
(388,169,'success','Videos queued for generation','2026-01-09 16:12:09','2026-01-09 16:12:09'),
(389,170,'success','Video task created successfully','2026-01-10 06:41:41','2026-01-10 06:41:41'),
(390,171,'success','Video task created successfully','2026-01-10 06:44:37','2026-01-10 06:44:37'),
(391,171,'success','Videos queued for generation','2026-01-10 06:44:48','2026-01-10 06:44:48'),
(392,172,'success','Video task created successfully','2026-01-10 06:53:46','2026-01-10 06:53:46'),
(393,172,'success','Videos queued for generation','2026-01-10 06:53:53','2026-01-10 06:53:53'),
(394,170,'success','Videos queued for generation','2026-01-10 07:04:55','2026-01-10 07:04:55'),
(395,173,'success','Video task created successfully','2026-01-10 07:06:21','2026-01-10 07:06:21'),
(396,173,'success','Videos queued for generation','2026-01-10 07:06:29','2026-01-10 07:06:29'),
(397,174,'success','Video task created successfully','2026-01-10 07:20:57','2026-01-10 07:20:57'),
(398,174,'success','Videos queued for generation','2026-01-10 07:21:54','2026-01-10 07:21:54'),
(399,175,'success','Task created successfully','2026-01-10 07:27:40','2026-01-10 07:27:40'),
(400,175,'success','Images generated successfully. Ready to send.','2026-01-10 07:27:55','2026-01-10 07:27:55');
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT  IGNORE INTO `migrations` VALUES
(1,'2014_10_12_000000_create_users_table',1),
(2,'2014_10_12_100000_create_password_reset_tokens_table',1),
(3,'2019_08_19_000000_create_failed_jobs_table',1),
(4,'2019_12_14_000001_create_personal_access_tokens_table',1),
(5,'2024_05_15_165659_customer',1),
(6,'2024_05_16_045432_templates',1),
(7,'2024_05_16_051028_generated_image',1),
(8,'2024_05_16_090410_template_by_user',1),
(9,'2024_05_16_091248_add_user_template_id_to_generated_image_table',2),
(10,'2024_05_16_094830_upload_images',2),
(11,'2025_12_10_155003_create_task_table',2),
(12,'2024_12_15_000001_add_video_support_to_tables',3),
(13,'2024_12_15_000002_add_content_type_to_templates_by_user',4),
(14,'2025_12_14_202837_create_tempstore_table',5),
(16,'2025_12_15_093737_add_animation_effect_to_tables',6),
(17,'2025_12_29_000001_create_instagram_credentials_table',7),
(18,'2025_12_29_000002_create_instagram_upload_logs_table',7),
(19,'2025_12_29_000003_add_customer_id_to_instagram_credentials',8),
(20,'2025_12_30_075006_add_facebook_page_id_to_instagram_credentials_table',9),
(21,'2025_12_30_180559_add_platform_to_instagram_upload_logs_table',10),
(22,'2026_01_02_000001_add_default_upload_platform_to_users_table',11),
(23,'2026_01_02_180828_create_jobs_table',12),
(24,'2026_01_03_061800_create_sessions_table',13),
(25,'2026_01_07_add_rendering_engine_column',14);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
-- Table structure for table `projects`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projects` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT  IGNORE INTO `sessions` VALUES
('manu59nxPULq1QCh7q6SHUNVXOOaEGcep07xxKxi',NULL,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoicWR4TURDb2szWG1wUzVJRUl3Q2lCbXZRWm1wSHlydFRsRHBZNkFFSSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo3MzoiaHR0cDovL3lhLnlhc3Bpay50ZWNoL2ltZ2VuL3B1YmxpY19odG1sL3B1YmxpY19odG1sL3B1YmxpYy9hcGkvZ3B1LXN0YXR1cyI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjczOiJodHRwOi8veWEueWFzcGlrLnRlY2gvaW1nZW4vcHVibGljX2h0bWwvcHVibGljX2h0bWwvcHVibGljL2FwaS9ncHUtc3RhdHVzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1767984950);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `taskname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('image','video') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image',
  `task_type` enum('image','video') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image',
  `remark` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `sent_status` tinyint(1) DEFAULT 0,
  `finished_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT  IGNORE INTO `task` VALUES
(10,'Task09','image','image','Success - All Images Sent',1,'2025-12-10 14:31:22','2025-12-10 15:15:13',1,'2025-12-10 15:15:13',1),
(11,'Task10','image','image','Generated - Ready to Send',1,'2025-12-10 14:44:37','2025-12-10 14:49:31',0,'2025-12-10 14:49:31',1),
(14,'Task13','image','image','Generated - Ready to Send',1,'2025-12-10 15:15:43','2025-12-10 15:17:07',0,'2025-12-10 15:17:07',1),
(15,'Task04','image','image','Generated - Ready to Send',1,'2025-12-11 04:11:16','2025-12-11 04:11:29',0,'2025-12-11 04:11:29',1),
(16,'Task05','image','image','Generated - Ready to Send',1,'2025-12-11 04:13:17','2025-12-11 04:13:27',0,'2025-12-11 04:13:27',1),
(17,'Task06','image','image','Success - All Images Sent',1,'2025-12-11 06:19:09','2025-12-11 06:20:40',1,'2025-12-11 06:19:36',1),
(18,'Task07','image','image','Success - All Images Sent',1,'2025-12-11 06:19:16','2025-12-11 06:20:38',1,'2025-12-11 06:19:30',1),
(19,'Task08','image','image','Generated - Ready to Send',1,'2025-12-13 08:05:15','2025-12-13 08:06:25',0,'2025-12-13 08:06:25',1),
(20,'VideoTask01','image','video','Generated - Ready to Send',1,'2025-12-14 15:01:48','2025-12-14 16:12:19',0,'2025-12-14 16:12:19',1),
(21,'VideoTask02','image','video','Generated - Ready to Send',1,'2025-12-14 15:37:46','2025-12-14 15:37:54',0,'2025-12-14 15:37:54',1),
(22,'VideoTask03','image','video','Generated - Ready to Send',1,'2025-12-14 15:56:49','2025-12-14 16:25:48',0,'2025-12-14 16:25:48',1),
(23,'VideoTask04','image','video','Generated - Ready to Send',1,'2025-12-14 16:13:04','2025-12-14 16:13:24',0,'2025-12-14 16:13:24',1),
(24,'VideoTask05','image','video','Success - All Videos Sent',1,'2025-12-14 16:26:49','2025-12-14 16:34:28',1,'2025-12-14 16:27:07',1),
(25,'VideoTask06','image','video','Generated - Ready to Send',1,'2025-12-14 16:39:54','2025-12-14 16:47:38',0,'2025-12-14 16:47:38',1),
(26,'VideoTask07','image','video','Generated - Ready to Send',1,'2025-12-14 16:41:37','2025-12-14 16:47:48',0,'2025-12-14 16:47:48',1),
(27,'VideoTask08','image','video','Generated - Ready to Send',1,'2025-12-14 16:43:32','2025-12-14 16:47:57',0,'2025-12-14 16:47:57',1),
(28,'VideoTask09','image','video','Generated - Ready to Send',1,'2025-12-14 16:44:25','2025-12-14 16:48:16',0,'2025-12-14 16:48:16',1),
(29,'VideoTask10','image','video','Generated - Ready to Send',1,'2025-12-14 17:17:37','2025-12-14 17:27:07',0,'2025-12-14 17:27:07',1),
(30,'VideoTask11','image','video','Generated - Ready to Send',1,'2025-12-14 17:20:12','2025-12-14 17:27:18',0,'2025-12-14 17:27:18',1),
(31,'VideoTask12','image','video','Generated - Ready to Send',1,'2025-12-14 17:30:37','2025-12-14 17:42:58',0,'2025-12-14 17:42:58',1),
(32,'VideoTask13','image','video','Generated - Ready to Send',1,'2025-12-14 17:32:09','2025-12-14 17:37:34',0,'2025-12-14 17:37:34',1),
(33,'VideoTask14','image','video','Generated - Ready to Send',1,'2025-12-14 17:44:03','2025-12-14 17:56:42',0,'2025-12-14 17:56:42',1),
(34,'VideoTask15','image','video','Generated - Ready to Send',1,'2025-12-14 17:44:50','2025-12-14 17:45:49',0,'2025-12-14 17:45:49',1),
(35,'VideoTask16','image','video','Generated - Ready to Send',1,'2025-12-14 17:49:09','2025-12-14 17:49:56',0,'2025-12-14 17:49:56',1),
(36,'VideoTask17','image','video','Success - All Videos Sent',1,'2025-12-14 17:54:13','2025-12-14 17:57:41',1,'2025-12-14 17:55:32',1),
(37,'VideoTask18','image','video','Generated - Ready to Send',1,'2025-12-14 18:01:26','2025-12-15 03:33:43',0,'2025-12-15 03:33:43',1),
(38,'VideoTask19','image','video','Generated - Ready to Send',1,'2025-12-15 02:49:19','2025-12-15 02:51:22',0,'2025-12-15 02:51:22',1),
(39,'VideoTask20','image','video','Generated - Ready to Send',1,'2025-12-15 03:34:06','2025-12-15 03:34:39',0,'2025-12-15 03:34:39',1),
(40,'VideoTask21','image','video','Generated - Ready to Send',1,'2025-12-15 03:34:54','2025-12-15 03:35:24',0,'2025-12-15 03:35:24',1),
(41,'VideoTask22','image','video','Generated - Ready to Send',1,'2025-12-15 03:37:26','2025-12-15 03:38:29',0,'2025-12-15 03:38:29',1),
(42,'VideoTask23','image','video','Generated - Ready to Send',1,'2025-12-15 03:40:22','2025-12-15 04:52:43',0,'2025-12-15 04:52:43',1),
(43,'VideoTask24','image','video','Generated - Ready to Send',1,'2025-12-15 04:20:28','2025-12-15 04:21:59',0,'2025-12-15 04:21:59',1),
(44,'VideoTask25','image','video','Generated - Ready to Send',1,'2025-12-15 04:20:55','2025-12-15 04:21:28',0,'2025-12-15 04:21:28',1),
(45,'VideoTask26','image','video','Generated - Ready to Send',1,'2025-12-15 04:23:48','2025-12-15 04:25:17',0,'2025-12-15 04:25:17',1),
(46,'VideoTask27','image','video','Generated - Ready to Send',1,'2025-12-15 04:30:04','2025-12-15 04:31:01',0,'2025-12-15 04:31:01',1),
(47,'VideoTask28','image','video','Success - All Videos Sent',1,'2025-12-15 04:34:52','2025-12-15 04:39:37',1,'2025-12-15 04:35:23',1),
(48,'VideoTask29','image','video','Success - All Videos Sent',1,'2025-12-15 04:37:24','2025-12-15 04:39:36',1,'2025-12-15 04:38:26',1),
(49,'VideoTask30','image','video','Success - All Videos Sent',1,'2025-12-15 04:38:48','2025-12-15 04:39:34',1,'2025-12-15 04:39:25',1),
(50,'Task39','image','image','Generated - Ready to Send',1,'2025-12-15 04:44:55','2025-12-15 04:45:00',0,'2025-12-15 04:45:00',1),
(51,'Task40','image','image','Generated - Ready to Send',1,'2025-12-15 04:45:48','2025-12-15 04:45:54',0,'2025-12-15 04:45:54',1),
(52,'VideoTask31','image','video','Generated - Ready to Send',1,'2025-12-15 05:01:32','2025-12-15 05:03:29',0,'2025-12-15 05:03:29',1),
(53,'VideoTask32','image','video','Generated - Ready to Send',1,'2025-12-15 05:06:55','2025-12-15 05:09:22',0,'2025-12-15 05:09:22',1),
(54,'VideoTask33','image','video','Generated - Ready to Send',1,'2025-12-15 05:11:37','2025-12-15 05:20:41',0,'2025-12-15 05:20:41',1),
(55,'VideoTask34','image','video','Generated - Ready to Send',1,'2025-12-15 05:12:54','2025-12-15 05:17:53',0,'2025-12-15 05:17:53',1),
(56,'VideoTask35','image','video','Generated - Ready to Send',1,'2025-12-15 07:02:44','2025-12-15 07:30:14',0,'2025-12-15 07:30:14',1),
(57,'VideoTask36','image','video','Generated - Ready to Send',1,'2025-12-15 09:52:44','2025-12-15 09:54:10',0,'2025-12-15 09:54:10',1),
(58,'VideoTask37','image','video','Generated - Ready to Send',1,'2025-12-15 10:01:13','2025-12-15 10:01:53',0,'2025-12-15 10:01:53',1),
(59,'VideoTask38','image','video','Generated - Ready to Send',1,'2025-12-15 10:03:28','2025-12-15 12:20:43',0,'2025-12-15 12:20:43',1),
(60,'VideoTask39','image','video','Generated - Ready to Send',1,'2025-12-15 12:13:19','2025-12-15 12:14:14',0,'2025-12-15 12:14:14',1),
(61,'VideoTask40','image','video','Generated - Ready to Send',1,'2025-12-15 12:25:48','2025-12-15 12:26:48',0,'2025-12-15 12:26:48',1),
(62,'VideoTask41','image','video','Generated - Ready to Send',1,'2025-12-15 12:29:52','2025-12-15 12:30:31',0,'2025-12-15 12:30:31',1),
(63,'VideoTask42','image','video','Generated - Ready to Send',1,'2025-12-15 12:41:23','2025-12-15 12:42:05',0,'2025-12-15 12:42:05',1),
(64,'VideoTask43','image','video','Generated - Ready to Send',1,'2025-12-15 12:42:43','2025-12-15 12:42:54',0,'2025-12-15 12:42:54',1),
(65,'VideoTask44','image','video','Generated - Ready to Send',1,'2025-12-15 12:45:01','2025-12-15 12:45:40',0,'2025-12-15 12:45:40',1),
(66,'VideoTask45','image','video','Generated - Ready to Send',1,'2025-12-15 12:57:59','2025-12-15 12:59:05',0,'2025-12-15 12:59:05',1),
(67,'VideoTask46','image','video','Success - All Videos Sent',1,'2025-12-18 03:16:38','2025-12-29 07:14:18',1,'2025-12-18 03:17:06',1),
(68,'VideoTask47','image','video','Generated - Ready to Send',1,'2025-12-29 10:31:39','2025-12-29 10:32:27',0,'2025-12-29 10:32:27',1),
(69,'VideoTask48','image','video','Success - All Videos Sent',1,'2025-12-29 11:07:21','2025-12-29 11:37:42',1,'2025-12-29 11:07:56',1),
(70,'VideoTask49','image','video','Generated - Ready to Send',1,'2025-12-30 07:52:28','2025-12-30 07:57:10',0,'2025-12-30 07:57:10',1),
(71,'VideoTask50','image','video','Generated - Ready to Send',1,'2025-12-30 08:12:05','2025-12-30 10:26:37',0,'2025-12-30 10:26:37',1),
(72,'VideoTask51','image','video','Generated - Ready to Send',1,'2025-12-30 08:13:57','2025-12-30 08:14:20',0,'2025-12-30 08:14:20',1),
(73,'VideoTask52','image','video','Generated - Ready to Send',1,'2025-12-30 08:15:23','2025-12-30 08:15:29',0,'2025-12-30 08:15:29',1),
(74,'VideoTask53','image','video','Generated - Ready to Send',1,'2025-12-30 09:10:46','2025-12-30 09:10:59',0,'2025-12-30 09:10:59',1),
(75,'VideoTask54','image','video','Success - All Videos Sent',1,'2025-12-30 10:46:11','2025-12-30 10:51:48',1,'2025-12-30 10:47:01',1),
(76,'VideoTask55','image','video','Success - All Videos Sent',1,'2026-01-01 08:50:44','2026-01-01 09:34:52',1,'2026-01-01 08:51:51',1),
(77,'VideoTask56','image','video','Success - All Videos Sent',1,'2026-01-01 12:38:25','2026-01-01 12:41:29',1,'2026-01-01 12:39:30',1),
(78,'VideoTask57','image','video','Generated - Ready to Send',1,'2026-01-01 12:49:20','2026-01-01 12:50:18',0,'2026-01-01 12:50:18',1),
(79,'VideoTask58','image','video','Generated - Ready to Send',1,'2026-01-01 12:51:33','2026-01-01 12:52:54',0,'2026-01-01 12:52:54',1),
(80,'VideoTask59','image','video','Generated - Ready to Send',1,'2026-01-02 05:53:38','2026-01-02 05:55:27',0,'2026-01-02 05:55:27',1),
(81,'VideoTask60','image','video','Generated - Ready to Send',1,'2026-01-02 06:19:13','2026-01-02 06:23:57',0,'2026-01-02 06:23:57',1),
(82,'VideoTask61','image','video','Generated - Ready to Send',1,'2026-01-02 07:22:15','2026-01-02 07:23:10',0,'2026-01-02 07:23:10',1),
(83,'VideoTask62','image','video','Generated - Ready to Send',1,'2026-01-02 09:34:02','2026-01-02 09:35:09',0,'2026-01-02 09:35:09',1),
(84,'VideoTask63','image','video','Generated - Ready to Send',1,'2026-01-02 11:14:50','2026-01-02 12:02:21',0,'2026-01-02 12:02:21',1),
(85,'VideoTask64','image','video','Generated - Ready to Send',1,'2026-01-02 12:01:13','2026-01-02 12:02:20',0,'2026-01-02 12:02:20',1),
(86,'VideoTask65','image','video','Generated - Ready to Send',1,'2026-01-02 12:03:42','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(87,'VideoTask66','image','video','Generated - Ready to Send',1,'2026-01-02 12:07:50','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(88,'VideoTask67','image','video','Generated - Ready to Send',1,'2026-01-02 12:13:22','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(89,'VideoTask68','image','video','Generated - Ready to Send',1,'2026-01-02 12:18:35','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(90,'VideoTask69','image','video','Generated - Ready to Send',1,'2026-01-02 12:35:32','2026-01-09 13:38:57',0,'2026-01-02 12:37:23',1),
(91,'VideoTask70','image','video','Generated - Ready to Send',1,'2026-01-02 12:40:31','2026-01-09 13:38:57',0,'2026-01-02 12:40:41',1),
(92,'VideoTask71','image','video','Generated - Ready to Send',1,'2026-01-02 12:43:07','2026-01-09 13:38:57',0,'2026-01-02 12:43:14',1),
(93,'VideoTask72','image','video','Generated - Ready to Send',1,'2026-01-02 12:56:39','2026-01-02 13:32:01',0,'2026-01-02 13:32:01',1),
(94,'VideoTask73','image','video','Generated - Ready to Send',1,'2026-01-02 13:36:37','2026-01-02 13:42:41',0,'2026-01-02 13:42:41',1),
(95,'VideoTask74','image','video','Generated - Ready to Send',1,'2026-01-02 13:41:10','2026-01-02 13:43:51',0,'2026-01-02 13:43:51',1),
(96,'VideoTask75','image','video','Generated - Ready to Send',1,'2026-01-02 13:48:29','2026-01-02 13:51:07',0,'2026-01-02 13:51:07',1),
(97,'VideoTask76','image','video','Generated - Ready to Send',1,'2026-01-02 13:52:25','2026-01-02 13:53:48',0,'2026-01-02 13:53:48',1),
(98,'VideoTask77','image','video','Generated - Ready to Send',1,'2026-01-02 14:04:09','2026-01-02 14:06:15',0,'2026-01-02 14:06:15',1),
(99,'VideoTask78','image','video','Generated - Ready to Send',1,'2026-01-02 15:19:38','2026-01-02 15:21:22',0,'2026-01-02 15:21:22',1),
(100,'VideoTask79','image','video','Generated - Ready to Send',1,'2026-01-02 15:24:00','2026-01-02 15:26:30',0,'2026-01-02 15:26:30',1),
(101,'VideoTask80','image','video','Generated - Ready to Send',1,'2026-01-02 15:35:02','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(102,'VideoTask81','image','video','Generated - Ready to Send',1,'2026-01-02 15:36:37','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(103,'VideoTask82','image','video','Generated - Ready to Send',1,'2026-01-02 15:42:50','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(104,'VideoTask83','image','video','Generated - Ready to Send',1,'2026-01-02 15:46:31','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(105,'VideoTask84','image','video','Generated - Ready to Send',1,'2026-01-02 15:50:52','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(106,'VideoTask85','image','video','Generated - Ready to Send',1,'2026-01-02 15:53:52','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(107,'VideoTask86','image','video','Generated - Ready to Send',1,'2026-01-02 15:59:04','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(108,'VideoTask87','image','video','Generated - Ready to Send',1,'2026-01-02 16:00:43','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(109,'VideoTask88','image','video','Generated - Ready to Send',1,'2026-01-02 16:04:46','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(110,'VideoTask89','image','video','Generated - Ready to Send',1,'2026-01-02 16:15:19','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(111,'VideoTask90','image','video','Generated - Ready to Send',1,'2026-01-02 16:27:51','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(112,'VideoTask91','image','video','Generated - Ready to Send',1,'2026-01-03 00:28:05','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(113,'VideoTask92','image','video','Generated - Ready to Send',1,'2026-01-03 00:55:52','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(114,'VideoTask93','image','video','Generated - Ready to Send',1,'2026-01-03 01:02:05','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(115,'VideoTask94','image','video','Generated - Ready to Send',1,'2026-01-03 11:45:39','2026-01-03 11:46:13',0,'2026-01-03 11:46:13',1),
(116,'VideoTask95','image','video','Generated - Ready to Send',1,'2026-01-03 11:52:32','2026-01-03 11:52:44',0,'2026-01-03 11:52:44',1),
(117,'VideoTask96','image','video','Generated - Ready to Send',1,'2026-01-03 11:53:34','2026-01-03 11:54:35',0,'2026-01-03 11:54:35',1),
(118,'VideoTask97','image','video','Generated - Ready to Send',1,'2026-01-03 11:55:57','2026-01-03 11:56:19',0,'2026-01-03 11:56:19',1),
(119,'VideoTask98','image','video','Generated - Ready to Send',1,'2026-01-03 12:16:22','2026-01-03 12:16:50',0,'2026-01-03 12:16:50',1),
(120,'VideoTask99','image','video','Generated - Ready to Send',1,'2026-01-03 12:19:28','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(121,'VideoTask100','image','video','Generated - Ready to Send',1,'2026-01-03 12:30:39','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(122,'VideoTask101','image','video','Generated - Ready to Send',1,'2026-01-03 12:36:29','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(123,'VideoTask102','image','video','Generated - Ready to Send',1,'2026-01-03 13:05:50','2026-01-03 13:06:19',0,'2026-01-03 13:06:19',1),
(124,'VideoTask103','image','video','Generated - Ready to Send',1,'2026-01-03 13:07:39','2026-01-03 13:08:32',0,'2026-01-03 13:08:32',1),
(125,'VideoTask104','image','video','Generated - Ready to Send',1,'2026-01-03 13:09:58','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(126,'VideoTask105','image','video','Generated - Ready to Send',1,'2026-01-03 13:15:48','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(127,'VideoTask106','image','video','Generated - Ready to Send',1,'2026-01-03 13:19:44','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(128,'VideoTask107','image','video','Generated - Ready to Send',1,'2026-01-03 13:21:35','2026-01-03 13:22:40',0,'2026-01-03 13:22:40',1),
(129,'VideoTask108','image','video','Generated - Ready to Send',1,'2026-01-07 11:58:03','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(130,'VideoTask109','image','video','Generated - Ready to Send',1,'2026-01-07 12:02:27','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(131,'VideoTask110','image','video','Generated - Ready to Send',1,'2026-01-07 12:12:02','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(132,'VideoTask111','image','video','Generated - Ready to Send',1,'2026-01-07 12:17:09','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(133,'VideoTask112','image','video','Generated - Ready to Send',1,'2026-01-07 12:28:01','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(134,'VideoTask113','image','video','Generated - Ready to Send',1,'2026-01-07 12:29:16','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(135,'VideoTask114','image','video','Generated - Ready to Send',1,'2026-01-07 12:51:13','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(136,'VideoTask115','image','video','Generated - Ready to Send',1,'2026-01-08 06:10:20','2026-01-08 06:11:16',0,'2026-01-08 06:11:16',1),
(137,'VideoTask116','image','video','Generated - Ready to Send',1,'2026-01-08 06:23:31','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(138,'VideoTask117','image','video','Generated - Ready to Send',1,'2026-01-09 05:46:25','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(139,'VideoTask118','image','video','Generated - Ready to Send',1,'2026-01-09 05:58:51','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(140,'VideoTask119','image','video','Task Executed Successfully',1,'2026-01-09 06:07:00','2026-01-09 14:06:45',0,'2026-01-09 14:06:45',1),
(141,'VideoTask120','image','video','Generated - Ready to Send',1,'2026-01-09 06:12:03','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(142,'VideoTask121','image','video','Generated - Ready to Send',1,'2026-01-09 11:49:06','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(143,'VideoTask122','image','video','Generated - Ready to Send',1,'2026-01-09 11:56:13','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(144,'VideoTask123','image','video','Generated - Ready to Send',1,'2026-01-09 12:01:15','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(145,'VideoTask124','image','video','Generated - Ready to Send',1,'2026-01-09 12:10:06','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(146,'VideoTask125','image','video','Generated - Ready to Send',1,'2026-01-09 12:32:37','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(147,'VideoTask126','image','video','Generated - Ready to Send',1,'2026-01-09 12:34:44','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(148,'VideoTask127','image','video','Generated - Ready to Send',1,'2026-01-09 12:36:43','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(149,'VideoTask128','image','video','Generated - Ready to Send',1,'2026-01-09 12:38:59','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(150,'VideoTask129','image','video','Task Executed Successfully',1,'2026-01-09 12:53:20','2026-01-09 12:54:11',0,'2026-01-09 12:54:11',1),
(151,'VideoTask130','image','video','Task Executed Successfully',1,'2026-01-09 12:56:45','2026-01-09 12:57:49',0,'2026-01-09 12:57:49',1),
(152,'VideoTask131','image','video','Generated - Ready to Send',1,'2026-01-09 13:02:34','2026-01-09 13:02:48',0,'2026-01-09 13:02:48',1),
(153,'VideoTask132','image','video','Generated - Ready to Send',1,'2026-01-09 13:04:07','2026-01-09 13:04:50',0,'2026-01-09 13:04:50',1),
(154,'VideoTask133','image','video','Generated - Ready to Send',1,'2026-01-09 13:06:05','2026-01-09 13:06:21',0,'2026-01-09 13:06:21',1),
(155,'VideoTask134','image','video','Task Executed Successfully',1,'2026-01-09 13:06:51','2026-01-09 13:07:47',0,'2026-01-09 13:07:47',1),
(156,'VideoTask135','image','video','Generated - Ready to Send',1,'2026-01-09 13:13:18','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(157,'VideoTask136','image','video','Task Executed Successfully',1,'2026-01-09 13:25:07','2026-01-09 13:28:11',0,'2026-01-09 13:28:11',1),
(158,'VideoTask137','image','video','Generated - Ready to Send',1,'2026-01-09 13:31:51','2026-01-09 13:38:57',0,'2026-01-09 13:38:57',1),
(159,'VideoTask138','image','video','Pending',2,'2026-01-09 13:42:09','2026-01-09 13:42:16',0,NULL,1),
(160,'VideoTask139','image','video','Task Executed Successfully',1,'2026-01-09 13:42:49','2026-01-09 13:43:25',0,'2026-01-09 13:43:25',1),
(161,'VideoTask140','image','video','Pending',2,'2026-01-09 13:48:55','2026-01-09 13:49:00',0,NULL,1),
(162,'VideoTask141','image','video','Task Executed Successfully',1,'2026-01-09 14:09:27','2026-01-09 14:11:20',0,'2026-01-09 14:11:20',1),
(163,'VideoTask142','image','video','Pending',2,'2026-01-09 14:14:03','2026-01-09 14:14:09',0,NULL,1),
(164,'VideoTask143','image','video','Pending',2,'2026-01-09 14:21:35','2026-01-09 14:21:39',0,NULL,1),
(165,'VideoTask144','image','video','Task Executed Successfully',1,'2026-01-09 14:27:24','2026-01-09 14:29:47',0,'2026-01-09 14:29:47',1),
(166,'VideoTask145','image','video','Task Executed Successfully',1,'2026-01-09 14:54:35','2026-01-09 14:57:38',0,'2026-01-09 14:57:38',1),
(167,'VideoTask146','image','video','Task Executed Successfully',1,'2026-01-09 15:02:54','2026-01-10 06:50:37',0,'2026-01-10 06:50:37',1),
(168,'VideoTask147','image','video','Pending',2,'2026-01-09 15:56:21','2026-01-09 15:56:26',0,NULL,1),
(169,'VideoTask148','image','video','Pending',2,'2026-01-09 16:12:01','2026-01-09 16:12:09',0,NULL,1),
(170,'VideoTask149','image','video','Pending',2,'2026-01-10 06:41:41','2026-01-10 07:04:55',0,NULL,1),
(171,'VideoTask150','image','video','Task Executed Successfully',1,'2026-01-10 06:44:37','2026-01-10 06:50:37',0,'2026-01-10 06:50:37',1),
(172,'VideoTask151','image','video','Pending',2,'2026-01-10 06:53:46','2026-01-10 06:53:52',0,NULL,1),
(173,'VideoTask152','image','video','Task Executed Successfully (4 videos generated)',1,'2026-01-10 07:06:21','2026-01-10 07:06:28',0,NULL,1),
(174,'VideoTask153','image','video','Task Executed Successfully (3 videos generated)',1,'2026-01-10 07:20:57','2026-01-10 07:23:25',0,NULL,1),
(175,'Task164','image','image','Generated - Ready to Send',1,'2026-01-10 07:27:40','2026-01-10 07:27:55',0,'2026-01-10 07:27:55',1);
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tempgeneration`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tempgeneration` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mastertemplateid` int(11) NOT NULL,
  `backgroundimage` varchar(255) DEFAULT NULL,
  `backgroundpath` varchar(500) DEFAULT NULL,
  `content_type` enum('image','video') NOT NULL DEFAULT 'image',
  `video_type` enum('portrait','landscape') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `animation_effect` varchar(50) DEFAULT 'wipe-in',
  `rendering_engine` varchar(20) DEFAULT 'moviepy',
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

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templates`
--

LOCK TABLES `templates` WRITE;
/*!40000 ALTER TABLE `templates` DISABLE KEYS */;
INSERT  IGNORE INTO `templates` VALUES
(1,'1','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/master_template/template_1765382482_6939995297ca1.png','template_1765382482_6939995297ca1.png','png',NULL,'2025-12-10 10:31:22','2025-12-10 10:31:22'),
(4,'new temp','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/master_template/template_1765793567_693fdf1fc93aa.png','template_1765793567_693fdf1fc93aa.png','png',NULL,'2025-12-15 04:42:47','2025-12-15 04:42:47'),
(5,'newya','D:\\xamp\\htdocs\\imgen\\public_html\\public_html\\public\\img/master_template/template_1767025868_6952accc6e6e8.png','template_1767025868_6952accc6e6e8.png','png',NULL,'2025-12-29 11:01:08','2025-12-29 11:01:08');
/*!40000 ALTER TABLE `templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `templates_by_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `templates_by_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `master_template_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer_template` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `template_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `memtype` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type` enum('image','video') COLLATE utf8mb4_unicode_ci DEFAULT 'image',
  `created_by` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templates_by_user`
--

LOCK TABLES `templates_by_user` WRITE;
/*!40000 ALTER TABLE `templates_by_user` DISABLE KEYS */;
INSERT  IGNORE INTO `templates_by_user` VALUES
(14,4,2,'user_template_1765793619_693fdf5358561.png','img/user_template/user_template_1765793619_693fdf5358561.png','png','image',NULL,'2025-12-15 04:43:39','2025-12-15 04:43:39'),
(18,6,7,'user_template_1767276545_6956800113766.png','img/user_template/user_template_1767276545_6956800113766.png','png','video',NULL,'2026-01-01 08:39:05','2026-01-01 08:39:05'),
(19,7,8,'user_template_1767358295_6957bf5793769.png','img/user_template/user_template_1767358295_6957bf5793769.png','png','video',NULL,'2026-01-02 07:21:35','2026-01-02 07:21:35'),
(20,6,6,'user_template_1767810021_695ea3e5d0f77.png','img/user_template/user_template_1767810021_695ea3e5d0f77.png','png','video',NULL,'2026-01-07 12:50:21','2026-01-07 12:50:21');
/*!40000 ALTER TABLE `templates_by_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `upload_images`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_upload_platform` enum('instagram','facebook','both') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'instagram',
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
INSERT  IGNORE INTO `users` VALUES
(1,'UVA Creations','uvacreation@gmail.com',NULL,'$2y$12$gdfI6p0s2FOS797lQ1hlPev1uue5nu7iSNqyxPie.Z2TqsPbnj9.W',NULL,'instagram','2025-12-10 10:16:41','2026-01-02 04:30:47');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video_templates`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `video_templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_type` enum('portrait','landscape') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'portrait',
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_file` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL COMMENT 'Duration in seconds',
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video_templates`
--

LOCK TABLES `video_templates` WRITE;
/*!40000 ALTER TABLE `video_templates` DISABLE KEYS */;
INSERT  IGNORE INTO `video_templates` VALUES
(2,'new temp','landscape','video_template_1765750076_693f353c2bf4c.png','img/master_template/video_template_1765750076_693f353c2bf4c.png','video_template_1765750076_693f353c2bf4c.png',NULL,NULL,NULL,NULL,1,'2025-12-14 16:37:56','2025-12-14 16:37:56'),
(3,'potraittest','portrait','video_template_1765786550_693fc3b67c005.png','img/master_template/video_template_1765786550_693fc3b67c005.png','video_template_1765786550_693fc3b67c005.png',NULL,NULL,NULL,NULL,1,'2025-12-15 02:45:50','2025-12-15 02:45:50'),
(4,'ALL BJP','landscape','video_template_1766047327_6943be5f6ff8d.png','img/master_template/video_template_1766047327_6943be5f6ff8d.png','video_template_1766047327_6943be5f6ff8d.png',NULL,NULL,NULL,NULL,1,'2025-12-18 03:12:07','2025-12-18 03:12:07'),
(6,'yanew','landscape','video_template_1767026168_6952adf8557c5.png','img/master_template/video_template_1767026168_6952adf8557c5.png','video_template_1767026168_6952adf8557c5.png',NULL,NULL,NULL,NULL,1,'2025-12-29 11:06:08','2025-12-29 11:06:08'),
(7,'UVA','landscape','video_template_1767358259_6957bf333146c.png','img/master_template/video_template_1767358259_6957bf333146c.png','video_template_1767358259_6957bf333146c.png',NULL,NULL,NULL,NULL,1,'2026-01-02 07:20:59','2026-01-02 07:20:59');
/*!40000 ALTER TABLE `video_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos_by_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videos_by_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) unsigned NOT NULL,
  `master_video_id` bigint(20) unsigned NOT NULL,
  `customer_video` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `master_video_id` (`master_video_id`),
  CONSTRAINT `videos_by_user_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `videos_by_user_master_video_id_foreign` FOREIGN KEY (`master_video_id`) REFERENCES `video_templates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos_by_user`
--

LOCK TABLES `videos_by_user` WRITE;
/*!40000 ALTER TABLE `videos_by_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `videos_by_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-10 19:03:22
