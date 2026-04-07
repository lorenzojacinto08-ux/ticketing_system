-- MySQL dump 10.13  Distrib 8.0.43, for macos15 (x86_64)
--
-- Host: localhost    Database: ticketing_db
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `activity_summary`
--

DROP TABLE IF EXISTS `activity_summary`;
/*!50001 DROP VIEW IF EXISTS `activity_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `activity_summary` AS SELECT 
 1 AS `activity_id`,
 1 AS `user_id`,
 1 AS `user_email`,
 1 AS `activity_type`,
 1 AS `activity_description`,
 1 AS `target_type`,
 1 AS `target_id`,
 1 AS `timestamp`,
 1 AS `success`,
 1 AS `ip_address`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `role`,
 1 AS `session_login_time`,
 1 AS `session_logout_time`,
 1 AS `time_category`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `entries`
--

DROP TABLE IF EXISTS `entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entries` (
  `ticket_no` int NOT NULL AUTO_INCREMENT,
  `store_name` varchar(45) DEFAULT NULL,
  `contact_number` varchar(45) DEFAULT NULL,
  `subject` varchar(45) DEFAULT NULL,
  `assigned_it` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `concern` varchar(255) DEFAULT NULL,
  `service_fee` decimal(10,2) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `remedy` varchar(255) DEFAULT NULL,
  `job_order` varchar(10) DEFAULT NULL,
  `service_done` text,
  `date_completed` datetime DEFAULT NULL,
  PRIMARY KEY (`ticket_no`),
  UNIQUE KEY `job_order_UNIQUE` (`job_order`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entries`
--

LOCK TABLES `entries` WRITE;
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;
INSERT INTO `entries` VALUES (42,'Llao llao','09673679257','Hardware','Jake','2026-03-30 14:54:38','admin@gmail.com','Not working',2000.00,'completed',NULL,'jo-0001','Changed battery',NULL),(43,'gbbbu','788787','hardware failure',NULL,'2026-03-30 15:05:16',NULL,'awdadadawd',5000.00,'pending',NULL,'jo-0002','changed pos screen',NULL),(44,'swsws','9090909090','hello','Jake','2026-03-30 15:31:27',NULL,'swswswsw',5000.00,'ongoing',NULL,'jo-0003',NULL,NULL);
/*!40000 ALTER TABLE `entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `transaction_summary`
--

DROP TABLE IF EXISTS `transaction_summary`;
/*!50001 DROP VIEW IF EXISTS `transaction_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `transaction_summary` AS SELECT 
 1 AS `transaction_id`,
 1 AS `ticket_no`,
 1 AS `job_order`,
 1 AS `store_name`,
 1 AS `service_fee`,
 1 AS `labor_fee`,
 1 AS `total_amount`,
 1 AS `transaction_date`,
 1 AS `status`,
 1 AS `payment_status`,
 1 AS `assigned_it`,
 1 AS `ticket_date`,
 1 AS `subject`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `ticket_no` int NOT NULL,
  `job_order` varchar(10) DEFAULT NULL,
  `store_name` varchar(45) DEFAULT NULL,
  `service_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `labor_fee` decimal(10,2) DEFAULT '0.00',
  `total_amount` decimal(10,2) GENERATED ALWAYS AS ((`service_fee` + `labor_fee`)) STORED,
  `transaction_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `payment_status` varchar(20) NOT NULL DEFAULT 'unpaid',
  `created_by` varchar(255) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`transaction_id`),
  UNIQUE KEY `unique_ticket_transaction` (`ticket_no`),
  KEY `idx_transaction_date` (`transaction_date`),
  KEY `idx_payment_status` (`payment_status`),
  CONSTRAINT `fk_transaction_ticket` FOREIGN KEY (`ticket_no`) REFERENCES `entries` (`ticket_no`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` (`transaction_id`, `ticket_no`, `job_order`, `store_name`, `service_fee`, `labor_fee`, `transaction_date`, `status`, `payment_status`, `created_by`, `notes`) VALUES (1,44,'jo-0003','swsws',5000.00,0.00,'2026-03-30 15:34:06','pending','paid',NULL,'');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_activities`
--

DROP TABLE IF EXISTS `user_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_activities` (
  `activity_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `activity_type` varchar(50) NOT NULL,
  `activity_description` text,
  `target_type` varchar(50) DEFAULT NULL,
  `target_id` int DEFAULT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `success` tinyint(1) DEFAULT '1',
  `error_message` text,
  PRIMARY KEY (`activity_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_activity_type` (`activity_type`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_target` (`target_type`,`target_id`),
  CONSTRAINT `fk_activity_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idusers`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_activities`
--

LOCK TABLES `user_activities` WRITE;
/*!40000 ALTER TABLE `user_activities` DISABLE KEYS */;
INSERT INTO `user_activities` VALUES (1,3,'super_admin@gmail.com','318288b2-014a-4080-86d3-4d8e64b21b5b','LOGIN','User super_admin@gmail.com logged in successfully','user',3,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-30 08:04:07',1,NULL),(2,3,'super_admin@gmail.com','318288b2-014a-4080-86d3-4d8e64b21b5b','LOGOUT','User super_admin@gmail.com logged out','user',3,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-30 08:11:05',1,NULL),(3,3,'super_admin@gmail.com','09dbce6a-31b5-477a-a293-90003f52edb4','LOGIN','User super_admin@gmail.com logged in successfully','user',3,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-30 08:11:14',1,NULL),(4,3,'super_admin@gmail.com','57186153-bb80-4d64-acb4-98d366230596','LOGIN','User super_admin@gmail.com logged in successfully','user',3,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:20:44',1,NULL),(5,3,'super_admin@gmail.com','57186153-bb80-4d64-acb4-98d366230596','TICKET_UPDATED','Updated ticket #44 for swsws','ticket',44,'{\"name\": \"\", \"email\": null, \"status\": \"pending\", \"subject\": \"hello\", \"job_order\": \"jo-0003\", \"contact_number\": \"9090909090\"}','{\"name\": \"swsws\", \"email\": \"\", \"status\": \"completed\", \"subject\": \"hello\", \"job_order\": \"jo-0003\", \"contact_number\": \"9090909090\"}','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:23:40',1,NULL),(6,3,'super_admin@gmail.com','57186153-bb80-4d64-acb4-98d366230596','LOGOUT','User super_admin@gmail.com logged out','user',3,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:23:54',1,NULL),(7,3,'super_admin@gmail.com','305f47e1-2da6-425d-b674-a67b80dc814d','LOGIN','User super_admin@gmail.com logged in successfully','user',3,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:24:07',1,NULL),(8,3,'super_admin@gmail.com','305f47e1-2da6-425d-b674-a67b80dc814d','TRANSACTION_UPDATED','Updated transaction #1','transaction',1,NULL,'{\"notes\": \"\", \"service_fee\": \"5000.00\", \"payment_status\": \"unpaid\"}','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:26:21',1,NULL),(9,3,'super_admin@gmail.com','305f47e1-2da6-425d-b674-a67b80dc814d','TRANSACTION_UPDATED','Updated transaction #1','transaction',1,NULL,'{\"notes\": \"\", \"service_fee\": \"5000.00\", \"payment_status\": \"paid\"}','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:26:28',1,NULL),(10,3,'super_admin@gmail.com','305f47e1-2da6-425d-b674-a67b80dc814d','TICKET_UPDATED','Updated ticket #44 for swsws','ticket',44,'{\"name\": \"\", \"email\": null, \"status\": \"completed\", \"subject\": \"hello\", \"job_order\": \"jo-0003\", \"contact_number\": \"9090909090\"}','{\"name\": \"swsws\", \"email\": \"\", \"status\": \"pending\", \"subject\": \"hello\", \"job_order\": \"jo-0003\", \"contact_number\": \"9090909090\"}','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:30:04',1,NULL),(11,3,'super_admin@gmail.com','305f47e1-2da6-425d-b674-a67b80dc814d','LOGOUT','User super_admin@gmail.com logged out','user',3,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:50:05',1,NULL),(12,3,'super_admin@gmail.com','82ec2ab7-a36f-4a59-b709-aa5d209a2da0','LOGIN','User super_admin@gmail.com logged in successfully','user',3,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:50:19',1,NULL),(13,3,'super_admin@gmail.com','82ec2ab7-a36f-4a59-b709-aa5d209a2da0','TICKET_UPDATED','Updated ticket #44 for swsws','ticket',44,'{\"name\": \"\", \"email\": null, \"status\": \"pending\", \"subject\": \"hello\", \"job_order\": \"jo-0003\", \"contact_number\": \"9090909090\"}','{\"name\": \"swsws\", \"email\": \"\", \"status\": \"completed\", \"subject\": \"hello\", \"job_order\": \"jo-0003\", \"contact_number\": \"9090909090\"}','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 06:09:46',1,NULL),(14,3,'super_admin@gmail.com','82ec2ab7-a36f-4a59-b709-aa5d209a2da0','TICKET_UPDATED','Updated ticket #44 for swsws','ticket',44,'{\"name\": \"swsws\", \"email\": null, \"status\": \"completed\", \"subject\": \"hello\", \"job_order\": \"jo-0003\", \"contact_number\": \"9090909090\"}','{\"name\": \"swsws\", \"email\": \"\", \"status\": \"ongoing\", \"subject\": \"hello\", \"job_order\": \"jo-0003\", \"contact_number\": \"9090909090\"}','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 06:14:57',1,NULL),(15,3,'super_admin@gmail.com','82ec2ab7-a36f-4a59-b709-aa5d209a2da0','TRANSACTIONS_EXPORT','Exported all transactions to Excel',NULL,NULL,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 06:24:30',1,NULL),(16,3,'super_admin@gmail.com','82ec2ab7-a36f-4a59-b709-aa5d209a2da0','LOGOUT','User super_admin@gmail.com logged out','user',3,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 06:28:46',1,NULL),(17,3,'super_admin@gmail.com','c0f11cec-a950-46ef-b955-8d7026f32856','LOGIN','User super_admin@gmail.com logged in successfully','user',3,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 06:28:55',1,NULL),(18,3,'super_admin@gmail.com','c0f11cec-a950-46ef-b955-8d7026f32856','TRANSACTIONS_EXPORT','Exported all transactions to Excel',NULL,NULL,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 06:30:23',1,NULL),(19,3,'super_admin@gmail.com','c0f11cec-a950-46ef-b955-8d7026f32856','TRANSACTIONS_EXPORT','Exported all transactions to Excel',NULL,NULL,NULL,NULL,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 06:30:43',1,NULL);
/*!40000 ALTER TABLE `user_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_activity_logs`
--

DROP TABLE IF EXISTS `user_activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_activity_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `description` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `ticket_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_action` (`action`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_log_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idusers`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_activity_logs`
--

LOCK TABLES `user_activity_logs` WRITE;
/*!40000 ALTER TABLE `user_activity_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `user_activity_summary`
--

DROP TABLE IF EXISTS `user_activity_summary`;
/*!50001 DROP VIEW IF EXISTS `user_activity_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `user_activity_summary` AS SELECT 
 1 AS `log_id`,
 1 AS `user_id`,
 1 AS `user_email`,
 1 AS `action`,
 1 AS `description`,
 1 AS `ip_address`,
 1 AS `created_at`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `role`,
 1 AS `time_category`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sessions` (
  `session_id` varchar(255) NOT NULL,
  `user_id` int DEFAULT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `login_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_activity` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `logout_time` timestamp NULL DEFAULT NULL,
  `session_duration` int DEFAULT NULL,
  `activities_count` int DEFAULT '0',
  PRIMARY KEY (`session_id`),
  KEY `fk_session_user` (`user_id`),
  CONSTRAINT `fk_session_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`idusers`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sessions`
--

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
INSERT INTO `user_sessions` VALUES ('09dbce6a-31b5-477a-a293-90003f52edb4',3,'super_admin@gmail.com','2026-03-30 08:11:14','2026-03-30 08:11:14','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15',NULL,NULL,1),('305f47e1-2da6-425d-b674-a67b80dc814d',3,'super_admin@gmail.com','2026-03-31 05:24:07','2026-03-31 05:50:05','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:50:05',1558,5),('318288b2-014a-4080-86d3-4d8e64b21b5b',3,'super_admin@gmail.com','2026-03-30 08:04:07','2026-03-30 08:11:05','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-30 08:11:05',418,2),('57186153-bb80-4d64-acb4-98d366230596',3,'super_admin@gmail.com','2026-03-31 05:20:44','2026-03-31 05:23:54','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 05:23:54',190,3),('82ec2ab7-a36f-4a59-b709-aa5d209a2da0',3,'super_admin@gmail.com','2026-03-31 05:50:19','2026-03-31 06:28:46','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15','2026-03-31 06:28:46',2307,5),('c0f11cec-a950-46ef-b955-8d7026f32856',3,'super_admin@gmail.com','2026-03-31 06:28:55','2026-03-31 06:30:43','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3.1 Safari/605.1.15',NULL,NULL,3);
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `idusers` int NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `role` varchar(45) NOT NULL,
  `is_active` varchar(45) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idusers`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `unique_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'test2@gmail.com','scrypt:32768:8:1$PM7gZHr7j9Zx1H7l$5833eda655240a9f2c6346de53c29309233b4d61d84eb73dde4e9469c0524808beb811d7c8e721ee76a613a99ebc2ef826ae676329e92d72c1322bcb24c9018e','Test1','User','end_user','1','2026-02-25 01:59:57','2026-02-27 13:34:58'),(2,'lorenzojacinto08@gmail.com','scrypt:32768:8:1$MO3dN7fOVHoP418f$5fc5d88251a2efd878edd46144455d6af65808363f0011d62dd25234d18d73adf870688920f88ed29fe7e42fa86192b65e4aa3a51712943e57127d0828e52fdd','Test2','User','end_user','1','2026-02-27 01:50:07','2026-02-27 10:27:57'),(3,'super_admin@gmail.com','scrypt:32768:8:1$WF0JlgZWceviOlJL$c2a62706bdbb2e08ffe2aa519e64850236d65d8fbc2b657261979e759d1bd9a03d0e97aee8e17e673ec7ed11e748b331a73b33096282c4e51f154162fb27be31','Super','Admin','super_admin','1','2026-02-27 02:13:38','2026-03-02 11:19:17'),(4,'user1@gmail.com','scrypt:32768:8:1$HGlTLdpSRZWCVtBh$bd7fce6c42678416e040342a93cc7c6206972a19ac219aefb17f447e086a83c51528425f0388e3413144ae177c13da0b0e580388a47f5a7fd11260752791a10c','User1','Test','admin','1','2026-02-27 03:56:12','2026-02-27 14:17:45'),(5,'umayamshairamae.s@gmail.com','scrypt:32768:8:1$VusOLsl7uiMcG03c$350d48caee89a25262cde129955184a0ac250ce40f40be53da64ceb7a2a601e9823f7b6c85817d50c73a3393b506b69b8fe949772e88ce1836cbfbc63cbfe746','Shaira','Umayam','end_user','1','2026-03-02 03:53:10','2026-03-02 11:53:10'),(6,'jdmtadm12@gmail.com','scrypt:32768:8:1$plCoxAPOCZV3bCmO$2cab7bc31173ea88136c83933807432c8335595c80148fd04cb57a673fc810df7046d3f1e07e5a454d14b568aaf7dcdcfe14b806214d8b60d390e2a1bb7af790','Rona','Cano','end_user','1','2026-03-02 05:09:01','2026-03-02 13:09:01'),(7,'ljferrer@donbosco.edu.ph','scrypt:32768:8:1$Vzcjc4hhG6jzVjTy$71a67f28c11b004cd8b66d3b3f76ae5ae278c706ab8695aea0c0ad9e40d44fe6d33f7ed72fef0db59eac576e66ce680b9fead816f814cd12ced5d2bb233548ab','Lorenzo','Ferrer','end_user','1','2026-03-03 03:11:16','2026-03-03 11:11:16'),(8,'franciscoseana04@gmail.com','scrypt:32768:8:1$9TQk45rH8ylA5IbA$7a07208f576f367c396627ebb1e0dc03917bcfe5d579d429ea16d2da7985f2350ef6d00cc56b0ba57946353bf9a14bb5c99d2ce1b286fa28df6b251c79ddf87c','Seana Louiesa','Francisco','admin','1','2026-03-03 03:45:19','2026-03-03 11:46:04'),(9,'taniegrarj@gmail.com','scrypt:32768:8:1$8fTRg1TwzYfNjQ1K$49160c19a8e4397dd184986b35e7e9d6cd67eff2dd9225889bdffd6125e770dd5897fa07bfa1e9f7cfbd32f8c2c18136e40147d3c5707a2b223491f90e99309e','ROMMEL JOHN','TANIEGRA','super_admin','1','2026-03-03 07:13:35','2026-03-03 16:22:05');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `activity_summary`
--

/*!50001 DROP VIEW IF EXISTS `activity_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `activity_summary` AS select `ua`.`activity_id` AS `activity_id`,`ua`.`user_id` AS `user_id`,`ua`.`user_email` AS `user_email`,`ua`.`activity_type` AS `activity_type`,`ua`.`activity_description` AS `activity_description`,`ua`.`target_type` AS `target_type`,`ua`.`target_id` AS `target_id`,`ua`.`timestamp` AS `timestamp`,`ua`.`success` AS `success`,`ua`.`ip_address` AS `ip_address`,`u`.`first_name` AS `first_name`,`u`.`last_name` AS `last_name`,`u`.`role` AS `role`,`us`.`login_time` AS `session_login_time`,`us`.`logout_time` AS `session_logout_time`,(case when (`ua`.`timestamp` >= (now() - interval 1 hour)) then 'Recent' when (`ua`.`timestamp` >= (now() - interval 24 hour)) then 'Today' when (`ua`.`timestamp` >= (now() - interval 7 day)) then 'This Week' else 'Older' end) AS `time_category` from ((`user_activities` `ua` left join `users` `u` on((`ua`.`user_id` = `u`.`idusers`))) left join `user_sessions` `us` on((`ua`.`session_id` = `us`.`session_id`))) order by `ua`.`timestamp` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `transaction_summary`
--

/*!50001 DROP VIEW IF EXISTS `transaction_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `transaction_summary` AS select `t`.`transaction_id` AS `transaction_id`,`t`.`ticket_no` AS `ticket_no`,`t`.`job_order` AS `job_order`,`t`.`store_name` AS `store_name`,`t`.`service_fee` AS `service_fee`,`t`.`labor_fee` AS `labor_fee`,`t`.`total_amount` AS `total_amount`,`t`.`transaction_date` AS `transaction_date`,`t`.`status` AS `status`,`t`.`payment_status` AS `payment_status`,`e`.`assigned_it` AS `assigned_it`,`e`.`date` AS `ticket_date`,`e`.`subject` AS `subject` from (`transactions` `t` left join `entries` `e` on((`t`.`ticket_no` = `e`.`ticket_no`))) order by `t`.`transaction_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_activity_summary`
--

/*!50001 DROP VIEW IF EXISTS `user_activity_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_activity_summary` AS select `ual`.`log_id` AS `log_id`,`ual`.`user_id` AS `user_id`,`ual`.`user_email` AS `user_email`,`ual`.`action` AS `action`,`ual`.`description` AS `description`,`ual`.`ip_address` AS `ip_address`,`ual`.`created_at` AS `created_at`,`u`.`first_name` AS `first_name`,`u`.`last_name` AS `last_name`,`u`.`role` AS `role`,(case when (`ual`.`created_at` >= (now() - interval 1 hour)) then 'Recent' when (`ual`.`created_at` >= (now() - interval 24 hour)) then 'Today' when (`ual`.`created_at` >= (now() - interval 7 day)) then 'This Week' else 'Older' end) AS `time_category` from (`user_activity_logs` `ual` left join `users` `u` on((`ual`.`user_id` = `u`.`idusers`))) order by `ual`.`created_at` desc */;
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

-- Dump completed on 2026-03-31 14:47:02
