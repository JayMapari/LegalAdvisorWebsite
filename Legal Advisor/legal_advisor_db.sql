-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: legal_advisor_db
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `ai_knowledge_base`
--

DROP TABLE IF EXISTS `ai_knowledge_base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_knowledge_base` (
  `kb_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `keywords` text,
  `response` text,
  PRIMARY KEY (`kb_id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_knowledge_base`
--

LOCK TABLES `ai_knowledge_base` WRITE;
/*!40000 ALTER TABLE `ai_knowledge_base` DISABLE KEYS */;
INSERT INTO `ai_knowledge_base` VALUES (1,1,'fraud,online,otp,hacking,identity,cyber','This appears to be a cyber crime. Report at National Cyber Crime Portal and call 1930.'),(2,2,'refund,consumer,product,service,complaint,bill','This appears to be a consumer dispute. Contact helpline 1915 or file complaint in Consumer Commission.'),(3,3,'theft,assault,threat,crime,violence,attack','This appears to be a criminal offence under IPC. File FIR at nearest police station or call 112.'),(4,4,'domestic,violence,harassment,abuse,women','This falls under Women Protection laws. Contact Women Helpline 181.'),(5,7,'instagram hacked, facebook hacked, whatsapp hacked','This is a cyber crime. Report immediately on cybercrime.gov.in and save all screenshots as evidence.'),(6,7,'online fraud, upi fraud, otp fraud, net banking fraud','This is an online financial fraud. Contact your bank immediately and file complaint on cyber crime portal.'),(7,7,'email hacked, password stolen, account hacked','Change your passwords immediately and report the cyber crime to police.'),(8,7,'cyber bullying, online harassment, fake profile','You can file a cyber complaint for online harassment and fake profile.'),(9,7,'data leak, data theft, privacy breach','Data theft is punishable under IT Act. File complaint in cyber crime portal.'),(10,8,'mobile theft, bike theft, चोरी','File FIR in nearest police station for theft. Provide bill and proof of ownership.'),(11,8,'physical assault, मारपीट, fight','This is assault case. File FIR and get medical report.'),(12,8,'cheating case, fraud case, 420 case','File FIR for cheating under IPC section 420.'),(13,8,'threatening, death threat, intimidation','File police complaint for criminal intimidation.'),(14,8,'someone hit me, violence case','You should go to police station and file FIR for assault.'),(15,9,'divorce case, separation','You should file divorce case in family court with help of lawyer.'),(16,9,'child custody case','File child custody case in family court.'),(17,9,'maintenance case, wife maintenance','You can file maintenance case under family law.'),(18,9,'domestic violence by husband','File domestic violence complaint and contact women helpline.'),(19,9,'adoption process','You need to follow legal adoption procedure through court.'),(20,10,'product not working, defective product','You can file complaint in consumer court.'),(21,10,'online shopping fraud','File complaint on consumerhelpline.gov.in'),(22,10,'refund not received','You can take legal action in consumer court for refund.'),(23,10,'duplicate product received','File complaint against seller in consumer court.'),(24,10,'poor service complaint','Consumer court handles service related complaints.'),(25,11,'land dispute case','This is property dispute. File civil case.'),(26,11,'property कब्जा, illegal possession','You should file property case in civil court.'),(27,11,'property fraud case','Consult property lawyer and file case.'),(28,11,'tenant not leaving house','You can file eviction case.'),(29,11,'property registration problem','Contact property lawyer and registrar office.'),(30,12,'molestation case','Call 1091 women helpline and file FIR.'),(31,12,'rape case','Immediately go to police and hospital for medical test.'),(32,12,'dowry harassment','File complaint under Dowry Prohibition Act.'),(33,12,'domestic violence','File complaint under Domestic Violence Act.'),(34,12,'office harassment','File complaint in police or women cell.'),(35,13,'salary not paid','File complaint in labour office.'),(36,13,'pf not given','You can complain to PF office.'),(37,13,'esi not given','File complaint to ESI office.'),(38,13,'salary delay','Labour law protects salary payment.'),(39,13,'office harassment','You can file complaint in labour court.'),(40,14,'cheque bounce case','File case under NI Act for cheque bounce.'),(41,14,'atm fraud','Block card and file bank complaint.'),(42,14,'loan recovery harassment','Complain to RBI if bank harassing.'),(43,14,'credit card fraud','Report bank and cyber crime portal.'),(44,14,'bank not returning money','File complaint to banking ombudsman.'),(45,15,'no helmet fine','You must pay traffic fine.'),(46,15,'drunk driving case','This is punishable offence and may lead to jail.'),(47,15,'no driving license','Driving without license is illegal.'),(48,15,'over speed challan','Pay challan online or attend court.'),(49,15,'no insurance fine','Vehicle insurance is compulsory.'),(50,16,'children not taking care','File maintenance case in tribunal.'),(51,16,'son took property','Senior citizen property law protects you.'),(52,16,'pension problem','Contact pension office.'),(53,16,'senior citizen abuse','File complaint to police.'),(54,16,'medical support issue','Government provides senior citizen protection.'),(55,17,'ragging complaint','Ragging is punishable offence.'),(56,17,'college not giving certificate','File complaint to university.'),(57,17,'school fees problem','File complaint to education board.'),(58,17,'fake university','Report to UGC.'),(59,17,'college harassment','File complaint to college authority.'),(60,18,'factory pollution','File complaint to pollution control board.'),(61,18,'water pollution complaint','Contact municipal authority.'),(62,18,'air pollution complaint','Report to pollution control board.'),(63,18,'tree cutting complaint','Inform forest department.'),(64,18,'noise pollution','File complaint to police.'),(65,19,'how to file rti','Submit RTI application to government office.'),(66,19,'rti not replied','File RTI appeal.'),(67,19,'government information needed','Use RTI Act to get information.'),(68,19,'rti appeal process','File appeal to RTI officer.'),(69,19,'rti penalty','Officer can be penalized for not replying.'),(70,20,'income tax notice','Contact CA and reply to notice.'),(71,20,'gst problem','File GST complaint or correction.'),(72,20,'tax penalty notice','Respond to tax notice properly.'),(73,20,'gst registration problem','Contact GST office.'),(74,20,'tax saving','Use legal tax saving options.'),(75,21,'someone posted wrong about me','You can file defamation case.'),(76,21,'social media defamation','Take screenshot and send legal notice.'),(77,21,'false news','File defamation case in court.'),(78,21,'reputation damage','You can claim compensation.'),(79,21,'youtube defamation','File legal case.'),(80,22,'copyright issue','File copyright complaint.'),(81,22,'trademark copy','File trademark violation case.'),(82,22,'patent copy','Patent law protects invention.'),(83,22,'software piracy','Piracy is illegal.'),(84,22,'design copy','Design Act protects product design.');
/*!40000 ALTER TABLE `ai_knowledge_base` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `case_documents`
--

DROP TABLE IF EXISTS `case_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `case_documents` (
  `document_id` int NOT NULL AUTO_INCREMENT,
  `case_id` int DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`document_id`),
  KEY `case_id` (`case_id`),
  CONSTRAINT `case_documents_ibfk_1` FOREIGN KEY (`case_id`) REFERENCES `cases` (`case_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `case_documents`
--

LOCK TABLES `case_documents` WRITE;
/*!40000 ALTER TABLE `case_documents` DISABLE KEYS */;
INSERT INTO `case_documents` VALUES (1,2,'Screenshot_2026-02-02_132429.png','static/uploads\\Screenshot_2026-02-02_132429.png','2026-02-28 20:15:43'),(8,10,'cloud_practical_5.docx','static/uploads\\cloud_practical_5.docx','2026-03-21 20:38:58'),(9,11,'Screenshot_2026-03-11_023013.png','static/uploads\\Screenshot_2026-03-11_023013.png','2026-03-21 20:46:39'),(10,3,'Screenshot_2026-03-11_025532.png','static/uploads\\Screenshot_2026-03-11_025532.png','2026-03-21 21:07:57'),(11,12,'Screenshot_2026-03-11_022949.png','static/uploads\\Screenshot_2026-03-11_022949.png','2026-03-21 21:08:34'),(13,11,'bubble sort.pdf',NULL,'2026-03-21 21:44:33'),(14,22,'25f01a1e-7781-4555-87ac-22946cc17159.jpg',NULL,'2026-03-26 06:55:11'),(15,23,'Screenshot 2026-03-25 214132.png',NULL,'2026-03-26 07:41:25');
/*!40000 ALTER TABLE `case_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `case_lawyer`
--

DROP TABLE IF EXISTS `case_lawyer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `case_lawyer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `case_id` int DEFAULT NULL,
  `lawyer_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `case_lawyer`
--

LOCK TABLES `case_lawyer` WRITE;
/*!40000 ALTER TABLE `case_lawyer` DISABLE KEYS */;
INSERT INTO `case_lawyer` VALUES (1,7,1),(2,8,1),(3,9,1),(4,10,1),(5,11,1),(6,12,1),(7,13,1),(8,14,1),(9,15,1),(10,16,1),(11,17,1),(12,18,1),(13,19,1),(14,20,1),(15,21,1),(16,22,2),(17,23,18);
/*!40000 ALTER TABLE `case_lawyer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `case_timeline`
--

DROP TABLE IF EXISTS `case_timeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `case_timeline` (
  `timeline_id` int NOT NULL AUTO_INCREMENT,
  `case_id` int DEFAULT NULL,
  `event_date` date DEFAULT NULL,
  `event_title` varchar(200) DEFAULT NULL,
  `event_description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`timeline_id`),
  KEY `case_id` (`case_id`),
  CONSTRAINT `case_timeline_ibfk_1` FOREIGN KEY (`case_id`) REFERENCES `cases` (`case_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `case_timeline`
--

LOCK TABLES `case_timeline` WRITE;
/*!40000 ALTER TABLE `case_timeline` DISABLE KEYS */;
INSERT INTO `case_timeline` VALUES (1,2,'2026-03-09','submiting document','4wtfe','2026-02-28 20:15:26'),(5,22,'2026-03-20','  m mn','nmb ','2026-03-26 06:55:05');
/*!40000 ALTER TABLE `case_timeline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cases`
--

DROP TABLE IF EXISTS `cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cases` (
  `case_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `case_type` varchar(150) DEFAULT NULL,
  `court_name` varchar(200) DEFAULT NULL,
  `next_hearing` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int DEFAULT NULL,
  `lawyer_idl` int DEFAULT NULL,
  `lawyer_id` int DEFAULT NULL,
  `reminder_sent` int DEFAULT '0',
  PRIMARY KEY (`case_id`),
  KEY `user_id` (`user_id`),
  KEY `fk_case_lawyer` (`lawyer_id`),
  CONSTRAINT `cases_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_case_lawyer` FOREIGN KEY (`lawyer_id`) REFERENCES `lawyers` (`lawyer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases`
--

LOCK TABLES `cases` WRITE;
/*!40000 ALTER TABLE `cases` DISABLE KEYS */;
INSERT INTO `cases` VALUES (1,'fraud','cyber crime','high court','2026-03-18','Ongoing','adasac','2026-02-28 19:44:22',NULL,NULL,NULL,0),(2,'DAAD','ADADS','gwegwef','2026-03-03','Open','fasswf','2026-02-28 19:49:57',NULL,NULL,NULL,0),(3,'robbery','crime','pune high court','2026-03-04','Ongoing','czsasfasf','2026-03-02 11:10:50',7,NULL,NULL,0),(10,'smuggling','drugs','high court','2026-04-24','Ongoing','jail','2026-03-21 20:38:38',7,NULL,NULL,0),(11,'sample','sample','high court','2026-03-26','Open','ajhbjhbau','2026-03-21 20:46:28',7,NULL,NULL,0),(12,'a','a','a','2026-04-01','Open','gyug','2026-03-21 21:08:23',7,NULL,NULL,0),(14,'ewfw','crime','high court','2026-03-24','Open','fsfcaf','2026-03-23 13:16:44',11,NULL,NULL,0),(19,'Student Rights Voilance','Rights Voilance','high court','2026-03-24','Open','collage charging extra fees on industrial visit','2026-03-23 14:09:35',1,NULL,NULL,0),(20,'online fraud','crime','pune high court','2026-03-23','Open','hgygj','2026-03-23 14:14:43',20,NULL,NULL,0),(21,'fvhgf','sdvsdmncn','vsvdvmnsvm','2026-03-24','Open','bjhgerb','2026-03-23 14:21:20',20,NULL,NULL,0),(22,'vhvh','vhgvh','hgvhv','2026-03-27','Ongoing','  jb','2026-03-26 06:54:45',1,NULL,NULL,0),(23,'dfs','scsscd','cssc','2026-03-27','Open','bhjggv','2026-03-26 07:41:13',35,NULL,NULL,0);
/*!40000 ALTER TABLE `cases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cases_backup`
--

DROP TABLE IF EXISTS `cases_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cases_backup` (
  `case_id` int NOT NULL DEFAULT '0',
  `title` varchar(200) DEFAULT NULL,
  `case_type` varchar(150) DEFAULT NULL,
  `court_name` varchar(200) DEFAULT NULL,
  `next_hearing` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int DEFAULT NULL,
  `lawyer_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases_backup`
--

LOCK TABLES `cases_backup` WRITE;
/*!40000 ALTER TABLE `cases_backup` DISABLE KEYS */;
INSERT INTO `cases_backup` VALUES (1,'fraud','cyber crime','high court','2026-03-18','Ongoing','adasac','2026-02-28 19:44:22',NULL,NULL),(2,'DAAD','ADADS','gwegwef','2026-03-03','Open','fasswf','2026-02-28 19:49:57',NULL,NULL),(3,'robbery','crime','pune high court','2026-03-04','Ongoing','czsasfasf','2026-03-02 11:10:50',7,NULL),(5,'cyber','cyber crime','high court','2026-03-14','Ongoing','ecedc','2026-03-12 06:49:23',1,NULL),(6,'hfbfdfdd','crime','dggfd','2026-03-18','Ongoing','egfedrg','2026-03-17 18:19:34',1,NULL);
/*!40000 ALTER TABLE `cases_backup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cases_new`
--

DROP TABLE IF EXISTS `cases_new`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cases_new` (
  `case_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `case_type` varchar(150) DEFAULT NULL,
  `court_name` varchar(200) DEFAULT NULL,
  `next_hearing` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int DEFAULT NULL,
  `lawyer_id` int DEFAULT NULL,
  PRIMARY KEY (`case_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases_new`
--

LOCK TABLES `cases_new` WRITE;
/*!40000 ALTER TABLE `cases_new` DISABLE KEYS */;
INSERT INTO `cases_new` VALUES (1,'fraud','cyber crime','high court','2026-03-18','Ongoing','adasac','2026-02-28 19:44:22',NULL,NULL),(2,'DAAD','ADADS','gwegwef','2026-03-03','Open','fasswf','2026-02-28 19:49:57',NULL,NULL),(3,'robbery','crime','pune high court','2026-03-04','Ongoing','czsasfasf','2026-03-02 11:10:50',7,NULL),(5,'cyber','cyber crime','high court','2026-03-14','Ongoing','ecedc','2026-03-12 06:49:23',1,NULL),(6,'hfbfdfdd','crime','dggfd','2026-03-18','Ongoing','egfedrg','2026-03-17 18:19:34',1,NULL);
/*!40000 ALTER TABLE `cases_new` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consultations`
--

DROP TABLE IF EXISTS `consultations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consultations` (
  `consultation_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `lawyer_id` int DEFAULT NULL,
  `consultation_type` varchar(50) DEFAULT NULL,
  `consultation_date` date DEFAULT NULL,
  `issue` text,
  `status` varchar(50) DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_status` varchar(20) DEFAULT 'Pending',
  `payment_method` varchar(50) DEFAULT NULL,
  `document` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`consultation_id`),
  KEY `user_id` (`user_id`),
  KEY `lawyer_id` (`lawyer_id`),
  CONSTRAINT `consultations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `consultations_ibfk_2` FOREIGN KEY (`lawyer_id`) REFERENCES `lawyers` (`lawyer_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultations`
--

LOCK TABLES `consultations` WRITE;
/*!40000 ALTER TABLE `consultations` DISABLE KEYS */;
INSERT INTO `consultations` VALUES (27,10,1,'Chat','2026-03-19','dad','Rejected','2026-03-17 20:06:10','Pending',NULL,NULL),(32,10,1,'Chat','2026-03-19','43tt','Pending','2026-03-17 20:48:45','Pending','Cash',NULL);
/*!40000 ALTER TABLE `consultations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_templates`
--

DROP TABLE IF EXISTS `document_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_templates` (
  `template_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`template_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_templates`
--

LOCK TABLES `document_templates` WRITE;
/*!40000 ALTER TABLE `document_templates` DISABLE KEYS */;
INSERT INTO `document_templates` VALUES (1,'Consumer Complaint Letter','Complaint against defective product or refund issue'),(2,'FIR Draft','Draft format for filing FIR'),(3,'Legal Notice','Formal legal notice format'),(4,'FIR Application','Template for filing FIR in police station.'),(5,'RTI Application','Template for filing RTI application.'),(6,'Consumer Complaint','Template for filing consumer court complaint.'),(7,'Legal Notice','Template for sending legal notice.'),(8,'Rent Agreement','House rent agreement format.'),(9,'Affidavit Format','General affidavit format.'),(10,'Divorce Petition','Divorce petition format.'),(11,'Maintenance Application','Maintenance application format.'),(12,'Cheque Bounce Notice','Legal notice for cheque bounce case.'),(13,'Property Agreement','Property sale agreement format.'),(14,'Employment Agreement','Employee employment agreement format.'),(15,'Non-Disclosure Agreement','NDA agreement format.'),(16,'Power of Attorney','Power of attorney format.'),(17,'Partnership Deed','Business partnership deed format.'),(18,'Will (Property)','Property will format.'),(19,'Consumer Complaint','Consumer complaint document'),(20,'FIR Application','FIR application document'),(21,'Legal Notice','Legal notice document');
/*!40000 ALTER TABLE `document_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forwarded_documents`
--

DROP TABLE IF EXISTS `forwarded_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forwarded_documents` (
  `forward_id` int NOT NULL AUTO_INCREMENT,
  `case_id` int DEFAULT NULL,
  `lawyer_id` int DEFAULT NULL,
  `document_id` int DEFAULT NULL,
  `forwarded_by` int DEFAULT NULL,
  `forwarded_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `forwarded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`forward_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forwarded_documents`
--

LOCK TABLES `forwarded_documents` WRITE;
/*!40000 ALTER TABLE `forwarded_documents` DISABLE KEYS */;
INSERT INTO `forwarded_documents` VALUES (3,10,1,8,NULL,'2026-03-21 20:39:00','2026-03-21 20:39:00'),(4,11,1,9,NULL,'2026-03-21 20:46:41','2026-03-21 20:46:41'),(5,12,1,11,NULL,'2026-03-21 21:08:36','2026-03-21 21:08:36'),(7,11,1,13,NULL,'2026-03-21 21:44:36','2026-03-21 21:44:36'),(9,22,2,14,NULL,'2026-03-26 06:55:15','2026-03-26 06:55:15'),(10,23,18,15,NULL,'2026-03-26 07:41:28','2026-03-26 07:41:28');
/*!40000 ALTER TABLE `forwarded_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `government_schemes`
--

DROP TABLE IF EXISTS `government_schemes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `government_schemes` (
  `scheme_id` int NOT NULL AUTO_INCREMENT,
  `scheme_name` varchar(200) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `description` text,
  `eligibility` text,
  `official_link` varchar(300) DEFAULT NULL,
  `min_income` int DEFAULT NULL,
  `max_income` int DEFAULT NULL,
  `caste` varchar(20) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`scheme_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `government_schemes`
--

LOCK TABLES `government_schemes` WRITE;
/*!40000 ALTER TABLE `government_schemes` DISABLE KEYS */;
INSERT INTO `government_schemes` VALUES (1,'National Scholarship Scheme','Student','Financial support for students from economically weaker sections.','Students with family income below 2.5 lakh per year.','https://scholarships.gov.in',NULL,NULL,NULL,NULL),(2,'Beti Bachao Beti Padhao','Women','Government scheme for welfare and education of girl child.','Families with girl children.','https://wcd.nic.in',NULL,NULL,NULL,NULL),(3,'PM Kisan Samman Nidhi','Farmer','Income support scheme for farmers.','Small and marginal farmers.','https://pmkisan.gov.in',NULL,NULL,NULL,NULL),(4,'Indira Gandhi National Old Age Pension','Senior Citizen','Monthly pension for elderly citizens.','Age above 60 with low income.','https://nsap.nic.in',NULL,NULL,NULL,NULL),(5,'National Scholarship Scheme','Student','Financial support for students','Income below 2.5 lakh','https://scholarships.gov.in',0,250000,'SC','Any'),(6,'Girls Education Scheme','Student','Support for girls education','Only for female students','https://example.com',0,300000,'Any','Female'),(7,'Farmer Subsidy Scheme','Farmer','Subsidy for farmers','Small farmers','https://example.com',0,500000,'Any','Any'),(8,'Pradhan Mantri Awas Yojana','Housing','Housing scheme for poor families to build or buy a house.','Economically weaker section and low income group families without permanent house.','https://pmaymis.gov.in',0,300000,'All','All'),(9,'Ayushman Bharat Yojana','Health','Health insurance scheme providing free treatment.','Poor families listed in SECC database.','https://pmjay.gov.in',0,300000,'All','All'),(10,'Pradhan Mantri Jan Dhan Yojana','Banking','Zero balance bank account for every citizen.','Any Indian citizen above age 10.','https://pmjdy.gov.in',0,500000,'All','All'),(11,'Beti Bachao Beti Padhao','Women','Scheme for education and protection of girl child.','Girl child and families with girl child.','https://wcd.nic.in',0,400000,'All','Female'),(12,'Stand Up India Scheme','Business','Loan scheme for SC/ST and women entrepreneurs.','SC/ST and Women entrepreneurs above 18 years.','https://standupmitra.in',0,1000000,'SC/ST','Female'),(13,'PM Kisan Samman Nidhi','Agriculture','Financial support scheme for farmers.','Small and marginal farmers.','https://pmkisan.gov.in',0,500000,'All','All'),(14,'Skill India Mission','Education','Skill training program for youth.','Any Indian youth who wants skill training.','https://skillindia.gov.in',0,500000,'All','All'),(15,'Atal Pension Yojana','Pension','Pension scheme for unorganized sector workers.','Age 18 to 40 years.','https://npscra.nsdl.co.in',0,500000,'All','All'),(16,'Ujjwala Yojana','Women','Free LPG gas connection for poor women.','Women from BPL families.','https://pmuy.gov.in',0,300000,'All','Female'),(17,'National Scholarship Scheme','Education','Scholarship for students.','Students from low income families.','https://scholarships.gov.in',0,300000,'All','All'),(18,'National Scholarship Scheme','Student','Scholarship for students from low income families.','Students with family income below 3 lakh.','https://scholarships.gov.in',0,300000,'All','All'),(19,'PM Kisan Samman Nidhi','Farmer','Financial support for farmers.','Small and marginal farmers.','https://pmkisan.gov.in',0,500000,'All','All'),(20,'Beti Bachao Beti Padhao','Women','Scheme for girl child education.','Families with girl child.','https://wcd.nic.in',0,400000,'All','Female'),(21,'Atal Pension Yojana','Senior Citizen','Pension scheme.','Age 18–40 can apply.','https://npscra.nsdl.co.in',0,500000,'All','All'),(22,'Startup India Scheme','Business','Loan and support for startups.','Entrepreneurs.','https://startupindia.gov.in',0,1000000,'All','All'),(23,'National Scholarship Scheme','Student','Scholarship for students from low income families.','Students with family income below 3 lakh.','https://scholarships.gov.in',0,300000,'All','All'),(24,'Beti Bachao Beti Padhao','Women','Scheme for girl child education.','Families with girl child.','https://wcd.nic.in',0,400000,'All','Female'),(25,'PM Kisan Samman Nidhi','Farmer','Financial support for farmers.','Small and marginal farmers.','https://pmkisan.gov.in',0,500000,'All','All'),(26,'Atal Pension Yojana','Senior Citizen','Pension scheme.','Age 18–40 can apply.','https://npscra.nsdl.co.in',0,500000,'All','All'),(27,'Startup India Scheme','Business','Loan and support for startups.','Entrepreneurs.','https://startupindia.gov.in',0,1000000,'All','All'),(28,'Ayushman Bharat Yojana','Health','Health insurance scheme.','Low income families.','https://pmjay.gov.in',0,300000,'All','All'),(29,'Pradhan Mantri Awas Yojana','Housing','Housing scheme.','Low income families.','https://pmaymis.gov.in',0,300000,'All','All'),(30,'Pradhan Mantri Jan Dhan Yojana','Banking','Zero balance bank account.','All citizens.','https://pmjdy.gov.in',0,500000,'All','All');
/*!40000 ALTER TABLE `government_schemes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `helplines`
--

DROP TABLE IF EXISTS `helplines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `helplines` (
  `helpline_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `helpline_name` varchar(150) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`helpline_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `helplines_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `law_categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `helplines`
--

LOCK TABLES `helplines` WRITE;
/*!40000 ALTER TABLE `helplines` DISABLE KEYS */;
INSERT INTO `helplines` VALUES (1,1,'National Cyber Crime Helpline','1930','Report online fraud, identity theft and cyber crimes'),(2,2,'National Consumer Helpline','1915','Consumer complaints and guidance'),(3,3,'Police Emergency','112','Emergency police assistance'),(4,4,'vedant','235033','don\'t call by mistakely'),(5,1,'abc','6554fa','fafa'),(6,7,'Cyber Crime Helpline','1930','Report online fraud and cyber crime'),(7,8,'Police Helpline','100','Emergency police help'),(8,9,'Women Helpline','1091','Women safety and domestic violence help'),(9,10,'Consumer Helpline','1800-11-4000','Consumer complaint helpline'),(10,11,'Property Dispute Helpline','1070','Land and property dispute help'),(11,12,'Women Helpline','1091','Women harassment help'),(12,13,'Labour Helpline','155214','Salary and job complaint'),(13,14,'Banking Helpline','14440','Bank fraud help'),(14,15,'Traffic Helpline','103','Traffic complaint'),(15,16,'Senior Citizen Helpline','14567','Senior citizen help'),(16,17,'Education Helpline','1800-11-8002','Education complaint'),(17,18,'Environment Helpline','1073','Pollution complaint'),(18,19,'RTI Helpline','1800-11-1111','RTI help'),(19,20,'Tax Helpline','1800-180-1961','Income tax help'),(20,21,'Police Helpline','100','Defamation complaint'),(21,22,'IPR Helpline','1800-425-1961','Copyright and trademark help'),(22,23,'vedant','0000','dont call');
/*!40000 ALTER TABLE `helplines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `law_categories`
--

DROP TABLE IF EXISTS `law_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `law_categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `law_categories`
--

LOCK TABLES `law_categories` WRITE;
/*!40000 ALTER TABLE `law_categories` DISABLE KEYS */;
INSERT INTO `law_categories` VALUES (7,'Cyber Law','Laws related to online fraud, hacking, cyber bullying, data theft.'),(8,'Criminal Law','Laws related to crimes like theft, assault, murder, cheating.'),(9,'Family Law','Laws related to divorce, child custody, domestic violence.'),(10,'Consumer Law','Laws for defective products, online shopping fraud, services complaint.'),(11,'Property Law','Land disputes, property ownership, illegal possession.'),(12,'Women Protection Law','Laws for women safety, harassment, domestic violence.'),(13,'Labour Law','Employee rights, salary issues, workplace harassment.'),(14,'Banking Law','Bank fraud, loan disputes, credit card issues.'),(15,'Traffic Law','Traffic rules, accidents, drunk driving cases.'),(16,'Senior Citizen Law','Laws for protection of senior citizens.'),(17,'Education Law','School/college complaints, ragging, fees issues.'),(18,'Environmental Law','Pollution, environmental protection laws.'),(19,'RTI Law','Right to Information Act related matters.'),(20,'Tax Law','Income tax, GST related issues.'),(21,'Defamation Law','Social media defamation and reputation damage.'),(22,'Intellectual Property Law','Copyright, trademark, patent issues.'),(23,'vedant laws','abc');
/*!40000 ALTER TABLE `law_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laws`
--

DROP TABLE IF EXISTS `laws`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laws` (
  `law_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `act_name` varchar(150) DEFAULT NULL,
  `section_number` varchar(50) DEFAULT NULL,
  `law_title` varchar(200) DEFAULT NULL,
  `simple_explanation` text,
  `example` text,
  `legal_consequence` text,
  PRIMARY KEY (`law_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `laws_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `law_categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laws`
--

LOCK TABLES `laws` WRITE;
/*!40000 ALTER TABLE `laws` DISABLE KEYS */;
INSERT INTO `laws` VALUES (34,13,'Minimum Wages Act','1948','Minimum Wage','Minimum salary rule.','Low salary.','Fine.'),(35,13,'Payment of Wages Act','1936','Salary Payment','Salary on time.','Salary delay.','Penalty.'),(36,13,'Equal Remuneration Act','1976','Equal Pay','Equal pay for men and women.','Less salary to women.','Penalty.'),(37,13,'Factories Act','1948','Factory Safety','Worker safety.','Unsafe factory.','Fine.'),(38,13,'Industrial Disputes Act','1947','Worker Dispute','Employee dispute.','Wrong termination.','Legal action.'),(39,14,'RBI Act','1934','Bank Regulation','Bank rules.','Bank fraud.','Penalty.'),(40,14,'NI Act','Sec 138','Cheque Bounce','Cheque bounce.','Cheque bounce case.','2 years jail.'),(41,14,'Banking Regulation Act','1949','Bank Control','Bank operations.','Bank issue.','Penalty.'),(42,14,'SARFAESI Act','2002','Loan Recovery','Loan recovery law.','Loan not paid.','Property seizure.'),(43,14,'IT Act','66C','Card Fraud','Debit/Credit fraud.','Card cloning.','3 years jail.'),(49,15,'Motor Vehicle Act','Sec 184','Dangerous Driving','Rash driving.','Overspeed driving.','Fine.'),(50,15,'Motor Vehicle Act','Sec 185','Drunk Driving','Drink and drive.','Alcohol driving.','Fine + jail.'),(51,15,'Motor Vehicle Act','Sec 130','Driving License','Must carry license.','No license.','Fine.'),(52,15,'Motor Vehicle Act','Sec 129','Helmet Rule','Helmet required.','No helmet.','Fine.'),(53,15,'Motor Vehicle Act','Sec 194','No Insurance','Vehicle insurance required.','No insurance.','Fine.'),(54,16,'Senior Citizens Act 2007','Sec 4','Maintenance of Parents','Children must take care of parents.','Children not giving money.','Monthly maintenance ordered by court.'),(55,16,'Senior Citizens Act 2007','Sec 5','Maintenance Tribunal','Senior citizens can file complaint.','Parents abandoned.','Legal action.'),(56,11,'IPC','Sec 406','Property Misuse','Children taking property illegally.','Son takes house.','Legal punishment.'),(57,11,'Senior Citizens Act 2007','Sec 23','Property Transfer Fraud','If children take property and not care.','Property fraud.','Transfer cancelled.'),(58,9,'CrPC','Sec 125','Maintenance','Parents can claim maintenance.','No money support.','Court order.'),(59,18,'Environment Protection Act','1986','Pollution Control','Protect environment.','Factory pollution.','Fine/jail.'),(60,18,'Air Pollution Act','1981','Air Pollution','Control air pollution.','Smoke factory.','Fine.'),(61,18,'Water Pollution Act','1974','Water Pollution','Stop water pollution.','Dirty water release.','Fine.'),(62,18,'Wildlife Protection Act','1972','Animal Protection','Protect wildlife.','Hunting animals.','Jail.'),(63,18,'Forest Act','1927','Forest Protection','Protect forest.','Cutting trees.','Fine/jail.'),(64,7,'IT Act 2000','Sec 43','Data Theft','Stealing someone data without permission','Hacking email account','Fine up to 5 lakh'),(65,7,'IT Act 2000','Sec 66','Computer Hacking','Unauthorized system access','Hack bank server','3 years jail'),(66,7,'IT Act 2000','Sec 66C','Identity Theft','Using someone OTP/password','OTP fraud','3 years jail'),(67,7,'IT Act 2000','Sec 66D','Online Fraud','Online cheating','UPI scam','3 years jail'),(68,7,'IT Act 2000','Sec 67','Obscene Content','Posting illegal content online','Posting obscene video','5 years jail'),(69,8,'IPC','Sec 378','Theft','Taking property without permission','Mobile theft','Jail or fine'),(70,8,'IPC','Sec 420','Cheating','Fraud and cheating','Online fraud','7 years jail'),(71,8,'IPC','Sec 351','Assault','Attacking someone','Physical attack','Jail'),(72,21,'IPC','Sec 499','Defamation','Harming reputation','False post','Fine'),(73,8,'IPC','Sec 506','Criminal Intimidation','Threatening someone','Threat call','Jail'),(74,9,'Hindu Marriage Act','Sec 13','Divorce','Legal separation','Husband wife divorce','Court decision'),(75,12,'DV Act','2005','Domestic Violence','Abuse at home','Husband beating wife','Jail'),(76,9,'Hindu Adoption Act','1956','Adoption Law','Legal adoption','Adopt child','Legal process'),(78,9,'Child Marriage Act','2006','Child Marriage','Marriage under 18 illegal','Minor marriage','Jail'),(79,10,'Consumer Protection Act','2019','Consumer Rights','Defective product complaint','Broken mobile','Refund'),(80,10,'Consumer Protection Act','2019','Service Deficiency','Bad service','Bad internet service','Compensation'),(81,10,'Legal Metrology Act','2009','Wrong Weight','Wrong product weight','Petrol pump fraud','Fine'),(82,10,'Food Safety Act','2006','Food Safety','Bad food quality','Expired food','Fine'),(83,10,'E-Commerce Rules','2020','Online Shopping Fraud','Fake product online','Fake Amazon product','Refund'),(84,11,'Transfer of Property Act','1882','Property Transfer','Legal property transfer','Land sale','Legal document'),(85,11,'Registration Act','1908','Property Registration','Property registration required','Unregistered land','Illegal'),(86,11,'Land Revenue Act','1966','Land Dispute','Land ownership dispute','Farm land dispute','Court decision'),(87,11,'Rent Control Act','1948','Tenant Rights','Tenant protection','Owner force eviction','Illegal'),(88,11,'Property Law','Illegal Possession','Land कब्जा',' कब्जा on land','Police complaint','Jail'),(89,12,'IPC','Sec 354','Molestation','Touching without consent','Molestation case','Jail'),(90,12,'IPC','Sec 376','Rape','Forced sexual act','Rape case','Jail 7+ years'),(92,12,'Dowry Act','1961','Dowry','Dowry demand','Dowry case','Jail'),(93,12,'POSH Act','2013','Workplace Harassment','Office harassment','Office harassment case','Penalty'),(94,13,'Minimum Wages Act','1948','Minimum Salary','Minimum wage law','Low salary','Penalty'),(95,13,'Payment of Wages Act','1936','Salary Delay','Late salary','Company delay salary','Penalty'),(96,13,'EPF Act','1952','PF Rights','PF money rights','Company not giving PF','Legal action'),(97,13,'ESI Act','1948','Medical Benefits','Employee medical','Company deny ESI','Penalty'),(99,14,'Banking Regulation Act','1949','Bank Rules','Bank regulations','Bank fraud','Penalty'),(100,14,'RBI Act','1934','RBI Rules','RBI regulations','Bank violation','Penalty'),(102,14,'IT Act','Sec 66','Online Banking Fraud','Net banking fraud','OTP fraud','Jail'),(103,14,'Loan Law','Sec 138','Loan Default','Loan not paid','Loan case','Legal action'),(104,15,'Motor Vehicle Act','1988','No License','Driving without license','No license','Fine'),(105,15,'Motor Vehicle Act','Sec 129','No Helmet','Riding without helmet','No helmet','Fine'),(107,15,'Motor Vehicle Act','Sec 183','Over Speed','Over speed driving','Speeding','Fine'),(109,16,'Senior Citizen Act','2007','Parent Maintenance','Children must care parents','Son not caring','Legal action'),(110,16,'Senior Citizen Act','Sec 23','Property Protection','Illegal property grab','Property कब्जा','Jail'),(111,16,'Senior Citizen Act','Sec 24','Abuse Protection','Abuse against senior','Harassment','Jail'),(112,16,'Pension Act','1871','Pension Rights','Pension issues','Pension stopped','Legal action'),(113,16,'Medical Law','Sec 15','Senior Medical Rights','Hospital deny treatment','Treatment denied','Action'),(114,17,'Right to Education Act','2009','Free Education','Free education 6-14','School deny admission','Action'),(115,17,'UGC Act','1956','University Rules','University regulations','Fake university','Penalty'),(116,17,'Anti Ragging Act','2009','Ragging Crime','Ragging illegal','College ragging','Suspension'),(117,17,'Education Act','Sec 5','Capitation Fee','Illegal donation fee','College donation','Penalty'),(118,17,'IT Act','Sec 66','Online Harassment','Online bullying','Student cyber bullying','Legal action'),(124,19,'RTI Act','2005','Right to Information','Ask govt info','RTI application','Info provided'),(125,19,'RTI Act','Sec 6','Apply RTI','RTI apply process','Apply RTI','Response'),(126,19,'RTI Act','Sec 7','RTI Reply','Reply in 30 days','No reply','Penalty'),(127,19,'RTI Act','Sec 19','RTI Appeal','Appeal if no reply','RTI appeal','Action'),(128,19,'RTI Act','Sec 20','Penalty on Officer','Late reply','Fine on officer','Fine'),(129,20,'Income Tax Act','1961','Income Tax','Tax on income','Not paying tax','Penalty'),(130,20,'GST Act','2017','GST Tax','GST rules','GST fraud','Penalty'),(131,20,'Income Tax Act','Sec 80C','Tax Saving','Tax deduction','LIC investment','Tax benefit'),(132,20,'GST Act','Sec 22','GST Registration','GST registration required','No GST','Penalty'),(133,20,'Tax Law','Sec 276','Tax Evasion','Hiding income','Black money','Penalty'),(135,21,'IPC','Sec 500','Defamation Punishment','Punishment for defamation','Social media post','Jail/Fine'),(136,21,'IT Act','Sec 66A','Online Defamation','Online insult','Facebook post','Legal action'),(137,21,'Civil Law','Sec 19','Defamation Suit','File case','Reputation damage','Compensation'),(138,21,'Media Law','Sec 3','False News','Fake news spread','False news','Penalty'),(139,22,'Copyright Act','1957','Copyright Protection','Protect content','Copy book','Penalty'),(140,22,'Trademark Act','1999','Trademark Protection','Protect brand','Fake brand','Penalty'),(141,22,'Patent Act','1970','Patent Protection','Protect invention','Copy invention','Penalty'),(142,22,'IT Act','Sec 65','Software Piracy','Illegal software copy','Pirated software','Fine'),(143,22,'Design Act','2000','Design Protection','Protect design','Copy design','Penalty'),(144,23,'vedant act,259','33B','not working','if not following orders','abc','fine and jail');
/*!40000 ALTER TABLE `laws` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lawyers`
--

DROP TABLE IF EXISTS `lawyers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lawyers` (
  `lawyer_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `specialization` varchar(150) DEFAULT NULL,
  `experience` int DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `description` text,
  `consultation_fee` int DEFAULT '500',
  `profile_image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`lawyer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lawyers`
--

LOCK TABLES `lawyers` WRITE;
/*!40000 ALTER TABLE `lawyers` DISABLE KEYS */;
INSERT INTO `lawyers` VALUES (1,'Adv. Rahul Sharma','Mumbai','Cyber Law',8,'9876543210','rahul@email.com','Specialist in cyber crime and digital fraud cases.',1000,NULL),(3,'Adv. Arjun Singh','Delhi','Criminal Law',12,'9988776655','arjun@email.com','Expert in IPC criminal cases and defence.',500,NULL),(14,'Adv. Rahul Sharma','Pune','Criminal Law',8,'9876543210','rahul@gmail.com','Expert in criminal and cyber crime cases.',1000,NULL),(15,'Adv. Priya Mehta','Mumbai','Family Law',6,'9876543211','priya@gmail.com','Handles divorce, domestic violence and family disputes.',1200,NULL),(16,'Adv. Anil Deshmukh','Nanded','Cyber Law',5,'9876543212','anil@gmail.com','Specialist in cyber fraud and online scam cases.',900,NULL),(17,'Adv. Snehal Patil','Pune','Property Law',10,'9876543213','snehal@gmail.com','Property disputes and land related cases.',1500,NULL),(18,'Adv. Kiran Joshi','Mumbai','Consumer Law',7,'9876543214','kiran@gmail.com','Consumer court and product complaint cases.',800,NULL);
/*!40000 ALTER TABLE `lawyers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qa_module`
--

DROP TABLE IF EXISTS `qa_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qa_module` (
  `qa_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `question` text,
  `answer` text,
  PRIMARY KEY (`qa_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `qa_module_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `law_categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qa_module`
--

LOCK TABLES `qa_module` WRITE;
/*!40000 ALTER TABLE `qa_module` DISABLE KEYS */;
INSERT INTO `qa_module` VALUES (1,1,'What should I do if someone commits online fraud against me?','You should immediately report the fraud on the National Cyber Crime Reporting Portal and call helpline 1930. Collect all evidence like screenshots and transaction details.'),(2,2,'How can I file a consumer complaint?','You can file a complaint through the Consumer Commission or use the National Consumer Helpline 1915. Keep purchase bills and product details ready.'),(3,3,'What should I do in case of theft?','You should file an FIR at the nearest police station and provide details of the stolen property.'),(4,7,'What should I do if my social media account is hacked?','Immediately change your password and report the incident on cybercrime.gov.in.'),(5,7,'Is online fraud punishable?','Yes, online fraud is punishable under IT Act.'),(6,7,'Where can I report cyber crime?','You can report cyber crime on the National Cyber Crime Portal.'),(7,7,'What is cyber bullying?','Cyber bullying is harassment using online platforms.'),(8,7,'Is hacking illegal in India?','Yes, hacking is illegal under IT Act.'),(9,8,'What is FIR?','FIR is First Information Report filed in police station.'),(10,8,'What should I do if someone assaults me?','File FIR and get medical report.'),(11,8,'What is cheating case?','Cheating is punishable under IPC Section 420.'),(12,8,'Can police arrest without warrant?','Yes, in cognizable offences police can arrest without warrant.'),(13,8,'What is criminal intimidation?','Threatening someone is criminal intimidation.'),(14,9,'How to file divorce?','You need to file divorce petition in family court.'),(15,9,'Who gets child custody after divorce?','Court decides based on child welfare.'),(16,9,'What is maintenance?','Maintenance is financial support given to spouse or parents.'),(17,9,'What is domestic violence?','Violence by spouse or family member is domestic violence.'),(18,9,'Is court marriage legal?','Yes, court marriage is legal.'),(19,10,'What to do if I receive defective product?','You can file complaint in consumer court.'),(20,10,'Can I get refund for online fraud?','Yes, you can file consumer complaint.'),(21,10,'What is consumer court?','Consumer court handles consumer complaints.'),(22,10,'Is bill necessary for complaint?','Yes, bill is important proof.'),(23,10,'How to file consumer complaint?','You can file complaint online.'),(24,11,'What to do in land dispute?','File civil case in court.'),(25,11,'What is property registration?','It is legal ownership registration.'),(26,11,'Can someone कब्जा my land?','Illegal possession is punishable.'),(27,11,'What is property fraud?','Selling property illegally is fraud.'),(28,11,'Do I need lawyer for property case?','Yes, property lawyer is required.'),(29,12,'What is women helpline number?','Women helpline number is 1091.'),(30,12,'What to do in molestation case?','File FIR immediately.'),(31,12,'What is domestic violence law?','It protects women from abuse.'),(32,12,'Is dowry illegal?','Yes, dowry is illegal.'),(33,12,'What is workplace harassment?','Harassment at workplace is punishable.'),(34,13,'What if salary not paid?','File complaint in labour office.'),(35,13,'What is PF?','PF is provident fund for employees.'),(36,13,'What is ESI?','ESI is employee medical benefit.'),(37,13,'Can company delay salary?','No, salary delay is illegal.'),(38,13,'Where to complain against company?','Labour court.'),(39,14,'What is cheque bounce?','Cheque bounce is punishable offence.'),(40,14,'What to do in ATM fraud?','Block card and inform bank.'),(41,14,'What is RBI Ombudsman?','It handles bank complaints.'),(42,14,'Can bank harass for loan?','No, harassment is illegal.'),(43,14,'What is loan default?','Not paying loan is default.'),(44,15,'Is helmet compulsory?','Yes, helmet is compulsory.'),(45,15,'Penalty for drunk driving?','Fine and jail possible.'),(46,15,'Driving without license?','Illegal and punishable.'),(47,15,'How to pay challan?','You can pay online.'),(48,15,'Is insurance compulsory?','Yes, vehicle insurance compulsory.'),(49,16,'What if children not taking care?','File maintenance case.'),(50,16,'Senior citizen property rights?','Law protects senior property.'),(51,16,'What is maintenance tribunal?','It handles senior citizen cases.'),(52,16,'Is senior abuse crime?','Yes, it is crime.'),(53,16,'What is pension right?','Senior citizens have pension rights.'),(54,17,'What is ragging law?','Ragging is punishable offence.'),(55,17,'College not giving certificate?','File complaint to university.'),(56,17,'Fake university complaint?','Report to UGC.'),(57,17,'School fees issue?','Complain to education board.'),(58,17,'Is ragging illegal?','Yes.'),(59,18,'Where to complain about pollution?','Pollution Control Board.'),(60,18,'Is tree cutting illegal?','Yes without permission.'),(61,18,'Noise pollution complaint?','File police complaint.'),(62,18,'Water pollution complaint?','Municipal authority.'),(63,18,'Air pollution complaint?','Pollution board.'),(64,19,'What is RTI?','Right to Information law.'),(65,19,'How to file RTI?','Submit RTI application.'),(66,19,'RTI reply time?','30 days.'),(67,19,'What if no RTI reply?','File RTI appeal.'),(68,19,'RTI penalty?','Officer can be fined.'),(69,20,'What is GST?','Goods and Services Tax.'),(70,20,'Income tax notice?','Reply with CA help.'),(71,20,'Tax penalty?','Penalty for tax violation.'),(72,20,'Tax saving?','Use legal deductions.'),(73,20,'GST registration?','Required for business.'),(74,21,'What is defamation?','Damage to reputation.'),(75,21,'Social media defamation?','Punishable offence.'),(76,21,'Defamation punishment?','Fine or jail.'),(77,21,'False news case?','File defamation case.'),(78,21,'Can I claim compensation?','Yes.'),(79,22,'What is copyright?','Protects original work.'),(80,22,'What is trademark?','Protects brand name.'),(81,22,'What is patent?','Protects invention.'),(82,22,'Is piracy illegal?','Yes.'),(83,22,'Design copy law?','Protected by Design Act.');
/*!40000 ALTER TABLE `qa_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rights_awareness`
--

DROP TABLE IF EXISTS `rights_awareness`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rights_awareness` (
  `right_id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(100) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`right_id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rights_awareness`
--

LOCK TABLES `rights_awareness` WRITE;
/*!40000 ALTER TABLE `rights_awareness` DISABLE KEYS */;
INSERT INTO `rights_awareness` VALUES (5,'Cyber Law','Right to File Cyber Complaint','You can file cyber crime complaint at cybercrime.gov.in'),(6,'Cyber Law','Right to Data Privacy','Your personal data cannot be used without permission'),(7,'Cyber Law','Right to Report Online Fraud','You can report UPI/online fraud to cyber police'),(8,'Cyber Law','Right to Block Bank Account','You can request bank to block account after fraud'),(9,'Cyber Law','Right to Legal Action','You can take legal action against cyber criminal'),(10,'Criminal Law','Right to FIR','You can file FIR at any police station'),(11,'Criminal Law','Right to Lawyer','You have right to hire a lawyer'),(12,'Criminal Law','Right to Bail','You can apply for bail'),(13,'Criminal Law','Right to Fair Trial','You have right to fair trial'),(14,'Criminal Law','Right to Appeal','You can appeal in higher court'),(15,'Family Law','Right to Divorce','You can legally apply for divorce'),(16,'Family Law','Right to Child Custody','You can apply for child custody'),(17,'Family Law','Right to Maintenance','You can claim maintenance'),(18,'Family Law','Right against Domestic Violence','You can file domestic violence complaint'),(19,'Family Law','Right to Property Share','You can claim share in family property'),(20,'Consumer Law','Right to Refund','You can get refund for defective product'),(21,'Consumer Law','Right to Replacement','You can replace defective product'),(22,'Consumer Law','Right to Consumer Court','You can file case in consumer court'),(23,'Consumer Law','Right to Complaint','You can file complaint online'),(24,'Consumer Law','Right to Compensation','You can claim compensation'),(25,'Property Law','Right to Property Ownership','Your property cannot be taken illegally'),(26,'Property Law','Right to Legal Notice','You can send legal notice'),(27,'Property Law','Right to File Case','You can file property case'),(28,'Property Law','Right against Illegal Possession','You can complain against illegal कब्जा'),(29,'Property Law','Right to Property Documents','You have right to property documents'),(30,'Women Protection Law','Right against Harassment','Women can file complaint against harassment'),(31,'Women Protection Law','Right to Police Help','Women can call 1091'),(32,'Women Protection Law','Right against Domestic Violence','You can file DV case'),(33,'Women Protection Law','Right to Work Safety','Women have workplace safety rights'),(34,'Women Protection Law','Right to Legal Protection','Women have legal protection'),(35,'Labour Law','Right to Minimum Wage','Employee must get minimum salary'),(36,'Labour Law','Right against Harassment','You can complain against workplace harassment'),(37,'Labour Law','Right to PF','You have PF rights'),(38,'Labour Law','Right to ESI','You have ESI medical rights'),(39,'Labour Law','Right to Salary on Time','You must get salary on time'),(40,'Banking Law','Right to Bank Complaint','You can complain to RBI'),(41,'Banking Law','Right against Fraud','You can report bank fraud'),(42,'Banking Law','Right to Refund Fraud Money','You can request refund'),(43,'Banking Law','Right to Account Safety','Bank must protect account'),(44,'Banking Law','Right to Loan Information','Bank must provide loan details'),(45,'Traffic Law','Right to Insurance Claim','You can claim accident insurance'),(46,'Traffic Law','Right to Safety','You have right to safe roads'),(47,'Traffic Law','Right to Traffic Complaint','You can complain traffic violation'),(48,'Traffic Law','Right to Compensation','You can claim accident compensation'),(49,'Traffic Law','Right to Legal Help','You can take legal help'),(50,'Senior Citizen Law','Right to Maintenance','Parents can claim maintenance'),(51,'Senior Citizen Law','Right to Protection','Senior citizens have protection'),(52,'Senior Citizen Law','Right to Property Protection','Property cannot be taken'),(53,'Senior Citizen Law','Right to Medical Care','Senior citizens have medical rights'),(54,'Senior Citizen Law','Right to Legal Help','Senior citizens can get legal help'),(55,'Education Law','Right to Education','Children have right to free education'),(56,'Education Law','Right against Ragging','Ragging is illegal'),(57,'Education Law','Right to Scholarship','Students can apply for scholarship'),(58,'Education Law','Right to Complaint','You can complain against school'),(59,'Education Law','Right to Certificates','You must get certificates'),(60,'Environmental Law','Right to Clean Environment','You can complain against pollution'),(61,'Environmental Law','Right to Information','You can report environmental issues'),(62,'Environmental Law','Right against Pollution','You can file pollution complaint'),(63,'Environmental Law','Right to Safe Water','You have right to clean water'),(64,'Environmental Law','Right to Legal Action','You can take legal action'),(65,'RTI Law','Right to Information','You can ask information'),(66,'RTI Law','Right to Appeal','You can appeal if RTI rejected'),(67,'RTI Law','Right to Reply','You must get reply in 30 days'),(68,'RTI Law','Right to File RTI','You can file RTI application'),(69,'RTI Law','Right to Complaint','You can complain RTI officer'),(70,'Tax Law','Right to Tax Refund','You can claim tax refund'),(71,'Tax Law','Right to Tax Appeal','You can appeal tax penalty'),(72,'Tax Law','Right to Tax Information','You can ask tax info'),(73,'Tax Law','Right to Correct Tax','You can correct tax details'),(74,'Tax Law','Right to Legal Help','You can take legal help'),(75,'Defamation Law','Right to File Case','You can file defamation case'),(76,'Defamation Law','Right to Compensation','You can claim compensation'),(77,'Defamation Law','Right to Remove Content','You can request removal of false content'),(78,'Defamation Law','Right to Legal Notice','You can send legal notice'),(79,'Defamation Law','Right to Court Case','You can file court case'),(80,'Intellectual Property Law','Right to Copyright','Your content is protected'),(81,'Intellectual Property Law','Right to Trademark','Your brand name is protected'),(82,'Intellectual Property Law','Right to Patent','Your invention is protected'),(83,'Intellectual Property Law','Right to Legal Action','You can take action'),(84,'Intellectual Property Law','Right to Ownership','You own your creation');
/*!40000 ALTER TABLE `rights_awareness` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `steps_to_follow`
--

DROP TABLE IF EXISTS `steps_to_follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `steps_to_follow` (
  `step_id` int NOT NULL AUTO_INCREMENT,
  `law_id` int DEFAULT NULL,
  `step_number` int DEFAULT NULL,
  `step_description` text,
  PRIMARY KEY (`step_id`),
  KEY `law_id` (`law_id`),
  CONSTRAINT `steps_to_follow_ibfk_1` FOREIGN KEY (`law_id`) REFERENCES `laws` (`law_id`)
) ENGINE=InnoDB AUTO_INCREMENT=766 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `steps_to_follow`
--

LOCK TABLES `steps_to_follow` WRITE;
/*!40000 ALTER TABLE `steps_to_follow` DISABLE KEYS */;
INSERT INTO `steps_to_follow` VALUES (5,34,1,'Take screenshots and save all digital evidence'),(6,35,1,'Take screenshots and save all digital evidence'),(7,36,1,'Take screenshots and save all digital evidence'),(8,37,1,'Take screenshots and save all digital evidence'),(9,38,1,'Take screenshots and save all digital evidence'),(10,64,1,'Take screenshots and save all digital evidence'),(11,65,1,'Take screenshots and save all digital evidence'),(12,66,1,'Take screenshots and save all digital evidence'),(13,67,1,'Take screenshots and save all digital evidence'),(14,68,1,'Take screenshots and save all digital evidence'),(20,34,2,'Report the cyber crime on cybercrime.gov.in'),(21,35,2,'Report the cyber crime on cybercrime.gov.in'),(22,36,2,'Report the cyber crime on cybercrime.gov.in'),(23,37,2,'Report the cyber crime on cybercrime.gov.in'),(24,38,2,'Report the cyber crime on cybercrime.gov.in'),(25,64,2,'Report the cyber crime on cybercrime.gov.in'),(26,65,2,'Report the cyber crime on cybercrime.gov.in'),(27,66,2,'Report the cyber crime on cybercrime.gov.in'),(28,67,2,'Report the cyber crime on cybercrime.gov.in'),(29,68,2,'Report the cyber crime on cybercrime.gov.in'),(35,34,3,'Visit nearest cyber crime police station'),(36,35,3,'Visit nearest cyber crime police station'),(37,36,3,'Visit nearest cyber crime police station'),(38,37,3,'Visit nearest cyber crime police station'),(39,38,3,'Visit nearest cyber crime police station'),(40,64,3,'Visit nearest cyber crime police station'),(41,65,3,'Visit nearest cyber crime police station'),(42,66,3,'Visit nearest cyber crime police station'),(43,67,3,'Visit nearest cyber crime police station'),(44,68,3,'Visit nearest cyber crime police station'),(50,34,4,'Submit digital evidence and complaint copy'),(51,35,4,'Submit digital evidence and complaint copy'),(52,36,4,'Submit digital evidence and complaint copy'),(53,37,4,'Submit digital evidence and complaint copy'),(54,38,4,'Submit digital evidence and complaint copy'),(55,64,4,'Submit digital evidence and complaint copy'),(56,65,4,'Submit digital evidence and complaint copy'),(57,66,4,'Submit digital evidence and complaint copy'),(58,67,4,'Submit digital evidence and complaint copy'),(59,68,4,'Submit digital evidence and complaint copy'),(65,34,5,'Follow investigation and court process'),(66,35,5,'Follow investigation and court process'),(67,36,5,'Follow investigation and court process'),(68,37,5,'Follow investigation and court process'),(69,38,5,'Follow investigation and court process'),(70,64,5,'Follow investigation and court process'),(71,65,5,'Follow investigation and court process'),(72,66,5,'Follow investigation and court process'),(73,67,5,'Follow investigation and court process'),(74,68,5,'Follow investigation and court process'),(80,39,1,'File FIR at nearest police station'),(81,40,1,'File FIR at nearest police station'),(82,41,1,'File FIR at nearest police station'),(83,42,1,'File FIR at nearest police station'),(84,43,1,'File FIR at nearest police station'),(90,69,1,'File FIR at nearest police station'),(91,70,1,'File FIR at nearest police station'),(92,71,1,'File FIR at nearest police station'),(93,72,1,'File FIR at nearest police station'),(94,73,1,'File FIR at nearest police station'),(95,39,2,'Provide all evidence and witness details'),(96,40,2,'Provide all evidence and witness details'),(97,41,2,'Provide all evidence and witness details'),(98,42,2,'Provide all evidence and witness details'),(99,43,2,'Provide all evidence and witness details'),(105,69,2,'Provide all evidence and witness details'),(106,70,2,'Provide all evidence and witness details'),(107,71,2,'Provide all evidence and witness details'),(108,72,2,'Provide all evidence and witness details'),(109,73,2,'Provide all evidence and witness details'),(110,39,3,'Hire a criminal lawyer'),(111,40,3,'Hire a criminal lawyer'),(112,41,3,'Hire a criminal lawyer'),(113,42,3,'Hire a criminal lawyer'),(114,43,3,'Hire a criminal lawyer'),(120,69,3,'Hire a criminal lawyer'),(121,70,3,'Hire a criminal lawyer'),(122,71,3,'Hire a criminal lawyer'),(123,72,3,'Hire a criminal lawyer'),(124,73,3,'Hire a criminal lawyer'),(125,39,4,'Attend court hearings'),(126,40,4,'Attend court hearings'),(127,41,4,'Attend court hearings'),(128,42,4,'Attend court hearings'),(129,43,4,'Attend court hearings'),(135,69,4,'Attend court hearings'),(136,70,4,'Attend court hearings'),(137,71,4,'Attend court hearings'),(138,72,4,'Attend court hearings'),(139,73,4,'Attend court hearings'),(140,39,5,'Follow court judgment and legal procedure'),(141,40,5,'Follow court judgment and legal procedure'),(142,41,5,'Follow court judgment and legal procedure'),(143,42,5,'Follow court judgment and legal procedure'),(144,43,5,'Follow court judgment and legal procedure'),(150,69,5,'Follow court judgment and legal procedure'),(151,70,5,'Follow court judgment and legal procedure'),(152,71,5,'Follow court judgment and legal procedure'),(153,72,5,'Follow court judgment and legal procedure'),(154,73,5,'Follow court judgment and legal procedure'),(155,49,1,'Try family mediation or counseling first'),(156,50,1,'Try family mediation or counseling first'),(157,51,1,'Try family mediation or counseling first'),(158,52,1,'Try family mediation or counseling first'),(159,53,1,'Try family mediation or counseling first'),(160,74,1,'Try family mediation or counseling first'),(161,75,1,'Try family mediation or counseling first'),(162,76,1,'Try family mediation or counseling first'),(164,78,1,'Try family mediation or counseling first'),(170,49,2,'Collect marriage and identity documents'),(171,50,2,'Collect marriage and identity documents'),(172,51,2,'Collect marriage and identity documents'),(173,52,2,'Collect marriage and identity documents'),(174,53,2,'Collect marriage and identity documents'),(175,74,2,'Collect marriage and identity documents'),(176,75,2,'Collect marriage and identity documents'),(177,76,2,'Collect marriage and identity documents'),(179,78,2,'Collect marriage and identity documents'),(185,49,3,'Consult family lawyer'),(186,50,3,'Consult family lawyer'),(187,51,3,'Consult family lawyer'),(188,52,3,'Consult family lawyer'),(189,53,3,'Consult family lawyer'),(190,74,3,'Consult family lawyer'),(191,75,3,'Consult family lawyer'),(192,76,3,'Consult family lawyer'),(194,78,3,'Consult family lawyer'),(200,49,4,'File case in family court'),(201,50,4,'File case in family court'),(202,51,4,'File case in family court'),(203,52,4,'File case in family court'),(204,53,4,'File case in family court'),(205,74,4,'File case in family court'),(206,75,4,'File case in family court'),(207,76,4,'File case in family court'),(209,78,4,'File case in family court'),(215,49,5,'Attend court hearings and mediation sessions'),(216,50,5,'Attend court hearings and mediation sessions'),(217,51,5,'Attend court hearings and mediation sessions'),(218,52,5,'Attend court hearings and mediation sessions'),(219,53,5,'Attend court hearings and mediation sessions'),(220,74,5,'Attend court hearings and mediation sessions'),(221,75,5,'Attend court hearings and mediation sessions'),(222,76,5,'Attend court hearings and mediation sessions'),(224,78,5,'Attend court hearings and mediation sessions'),(230,54,1,'Keep bill, receipt and product proof'),(231,55,1,'Keep bill, receipt and product proof'),(232,56,1,'Keep bill, receipt and product proof'),(233,57,1,'Keep bill, receipt and product proof'),(234,58,1,'Keep bill, receipt and product proof'),(235,79,1,'Keep bill, receipt and product proof'),(236,80,1,'Keep bill, receipt and product proof'),(237,81,1,'Keep bill, receipt and product proof'),(238,82,1,'Keep bill, receipt and product proof'),(239,83,1,'Keep bill, receipt and product proof'),(245,54,2,'Contact seller or company customer care'),(246,55,2,'Contact seller or company customer care'),(247,56,2,'Contact seller or company customer care'),(248,57,2,'Contact seller or company customer care'),(249,58,2,'Contact seller or company customer care'),(250,79,2,'Contact seller or company customer care'),(251,80,2,'Contact seller or company customer care'),(252,81,2,'Contact seller or company customer care'),(253,82,2,'Contact seller or company customer care'),(254,83,2,'Contact seller or company customer care'),(260,54,3,'File complaint on consumerhelpline.gov.in'),(261,55,3,'File complaint on consumerhelpline.gov.in'),(262,56,3,'File complaint on consumerhelpline.gov.in'),(263,57,3,'File complaint on consumerhelpline.gov.in'),(264,58,3,'File complaint on consumerhelpline.gov.in'),(265,79,3,'File complaint on consumerhelpline.gov.in'),(266,80,3,'File complaint on consumerhelpline.gov.in'),(267,81,3,'File complaint on consumerhelpline.gov.in'),(268,82,3,'File complaint on consumerhelpline.gov.in'),(269,83,3,'File complaint on consumerhelpline.gov.in'),(275,54,4,'File case in consumer court'),(276,55,4,'File case in consumer court'),(277,56,4,'File case in consumer court'),(278,57,4,'File case in consumer court'),(279,58,4,'File case in consumer court'),(280,79,4,'File case in consumer court'),(281,80,4,'File case in consumer court'),(282,81,4,'File case in consumer court'),(283,82,4,'File case in consumer court'),(284,83,4,'File case in consumer court'),(290,54,5,'Attend hearing and submit evidence'),(291,55,5,'Attend hearing and submit evidence'),(292,56,5,'Attend hearing and submit evidence'),(293,57,5,'Attend hearing and submit evidence'),(294,58,5,'Attend hearing and submit evidence'),(295,79,5,'Attend hearing and submit evidence'),(296,80,5,'Attend hearing and submit evidence'),(297,81,5,'Attend hearing and submit evidence'),(298,82,5,'Attend hearing and submit evidence'),(299,83,5,'Attend hearing and submit evidence'),(305,84,1,'Collect property documents and ownership proof'),(306,85,1,'Collect property documents and ownership proof'),(307,86,1,'Collect property documents and ownership proof'),(308,87,1,'Collect property documents and ownership proof'),(309,88,1,'Collect property documents and ownership proof'),(312,84,2,'Verify property documents legally'),(313,85,2,'Verify property documents legally'),(314,86,2,'Verify property documents legally'),(315,87,2,'Verify property documents legally'),(316,88,2,'Verify property documents legally'),(319,84,3,'Consult property lawyer'),(320,85,3,'Consult property lawyer'),(321,86,3,'Consult property lawyer'),(322,87,3,'Consult property lawyer'),(323,88,3,'Consult property lawyer'),(326,84,4,'File case in civil court'),(327,85,4,'File case in civil court'),(328,86,4,'File case in civil court'),(329,87,4,'File case in civil court'),(330,88,4,'File case in civil court'),(333,84,5,'Attend court and resolve dispute legally'),(334,85,5,'Attend court and resolve dispute legally'),(335,86,5,'Attend court and resolve dispute legally'),(336,87,5,'Attend court and resolve dispute legally'),(337,88,5,'Attend court and resolve dispute legally'),(340,59,1,'Call women helpline 1091 or 181'),(341,60,1,'Call women helpline 1091 or 181'),(342,61,1,'Call women helpline 1091 or 181'),(343,62,1,'Call women helpline 1091 or 181'),(344,63,1,'Call women helpline 1091 or 181'),(345,89,1,'Call women helpline 1091 or 181'),(346,90,1,'Call women helpline 1091 or 181'),(348,92,1,'Call women helpline 1091 or 181'),(349,93,1,'Call women helpline 1091 or 181'),(355,59,2,'File complaint in nearest police station'),(356,60,2,'File complaint in nearest police station'),(357,61,2,'File complaint in nearest police station'),(358,62,2,'File complaint in nearest police station'),(359,63,2,'File complaint in nearest police station'),(360,89,2,'File complaint in nearest police station'),(361,90,2,'File complaint in nearest police station'),(363,92,2,'File complaint in nearest police station'),(364,93,2,'File complaint in nearest police station'),(370,59,3,'Collect medical report and evidence'),(371,60,3,'Collect medical report and evidence'),(372,61,3,'Collect medical report and evidence'),(373,62,3,'Collect medical report and evidence'),(374,63,3,'Collect medical report and evidence'),(375,89,3,'Collect medical report and evidence'),(376,90,3,'Collect medical report and evidence'),(378,92,3,'Collect medical report and evidence'),(379,93,3,'Collect medical report and evidence'),(385,59,4,'Consult a lawyer or women protection cell'),(386,60,4,'Consult a lawyer or women protection cell'),(387,61,4,'Consult a lawyer or women protection cell'),(388,62,4,'Consult a lawyer or women protection cell'),(389,63,4,'Consult a lawyer or women protection cell'),(390,89,4,'Consult a lawyer or women protection cell'),(391,90,4,'Consult a lawyer or women protection cell'),(393,92,4,'Consult a lawyer or women protection cell'),(394,93,4,'Consult a lawyer or women protection cell'),(400,59,5,'Attend court and follow legal process'),(401,60,5,'Attend court and follow legal process'),(402,61,5,'Attend court and follow legal process'),(403,62,5,'Attend court and follow legal process'),(404,63,5,'Attend court and follow legal process'),(405,89,5,'Attend court and follow legal process'),(406,90,5,'Attend court and follow legal process'),(408,92,5,'Attend court and follow legal process'),(409,93,5,'Attend court and follow legal process'),(415,94,1,'Talk to employer or HR department first'),(416,95,1,'Talk to employer or HR department first'),(417,96,1,'Talk to employer or HR department first'),(418,97,1,'Talk to employer or HR department first'),(422,94,2,'Collect salary slips and work proof'),(423,95,2,'Collect salary slips and work proof'),(424,96,2,'Collect salary slips and work proof'),(425,97,2,'Collect salary slips and work proof'),(429,94,3,'File complaint in labour office'),(430,95,3,'File complaint in labour office'),(431,96,3,'File complaint in labour office'),(432,97,3,'File complaint in labour office'),(436,94,4,'Consult labour lawyer'),(437,95,4,'Consult labour lawyer'),(438,96,4,'Consult labour lawyer'),(439,97,4,'Consult labour lawyer'),(443,94,5,'Attend labour court hearing'),(444,95,5,'Attend labour court hearing'),(445,96,5,'Attend labour court hearing'),(446,97,5,'Attend labour court hearing'),(450,99,1,'Contact bank customer care immediately'),(451,100,1,'Contact bank customer care immediately'),(453,102,1,'Contact bank customer care immediately'),(454,103,1,'Contact bank customer care immediately'),(457,99,2,'Block card or account if fraud'),(458,100,2,'Block card or account if fraud'),(460,102,2,'Block card or account if fraud'),(461,103,2,'Block card or account if fraud'),(464,99,3,'File written complaint to bank manager'),(465,100,3,'File written complaint to bank manager'),(467,102,3,'File written complaint to bank manager'),(468,103,3,'File written complaint to bank manager'),(471,99,4,'File complaint on RBI website'),(472,100,4,'File complaint on RBI website'),(474,102,4,'File complaint on RBI website'),(475,103,4,'File complaint on RBI website'),(478,99,5,'Go to banking ombudsman if not resolved'),(479,100,5,'Go to banking ombudsman if not resolved'),(481,102,5,'Go to banking ombudsman if not resolved'),(482,103,5,'Go to banking ombudsman if not resolved'),(485,104,1,'Check traffic challan details online'),(486,105,1,'Check traffic challan details online'),(488,107,1,'Check traffic challan details online'),(492,104,2,'Pay fine online or visit traffic police office'),(493,105,2,'Pay fine online or visit traffic police office'),(495,107,2,'Pay fine online or visit traffic police office'),(499,104,3,'If accident, inform police immediately'),(500,105,3,'If accident, inform police immediately'),(502,107,3,'If accident, inform police immediately'),(506,104,4,'Submit driving license and vehicle documents'),(507,105,4,'Submit driving license and vehicle documents'),(509,107,4,'Submit driving license and vehicle documents'),(513,104,5,'Attend traffic court if required'),(514,105,5,'Attend traffic court if required'),(516,107,5,'Attend traffic court if required'),(520,109,1,'Contact senior citizen helpline'),(521,110,1,'Contact senior citizen helpline'),(522,111,1,'Contact senior citizen helpline'),(523,112,1,'Contact senior citizen helpline'),(524,113,1,'Contact senior citizen helpline'),(527,109,2,'File complaint against children or relatives if harassment'),(528,110,2,'File complaint against children or relatives if harassment'),(529,111,2,'File complaint against children or relatives if harassment'),(530,112,2,'File complaint against children or relatives if harassment'),(531,113,2,'File complaint against children or relatives if harassment'),(534,109,3,'Apply for maintenance tribunal'),(535,110,3,'Apply for maintenance tribunal'),(536,111,3,'Apply for maintenance tribunal'),(537,112,3,'Apply for maintenance tribunal'),(538,113,3,'Apply for maintenance tribunal'),(541,109,4,'Submit property and ID proof'),(542,110,4,'Submit property and ID proof'),(543,111,4,'Submit property and ID proof'),(544,112,4,'Submit property and ID proof'),(545,113,4,'Submit property and ID proof'),(548,109,5,'Attend tribunal hearing'),(549,110,5,'Attend tribunal hearing'),(550,111,5,'Attend tribunal hearing'),(551,112,5,'Attend tribunal hearing'),(552,113,5,'Attend tribunal hearing'),(555,114,1,'Write complaint to school/college authority'),(556,115,1,'Write complaint to school/college authority'),(557,116,1,'Write complaint to school/college authority'),(558,117,1,'Write complaint to school/college authority'),(559,118,1,'Write complaint to school/college authority'),(562,114,2,'Contact education board or university'),(563,115,2,'Contact education board or university'),(564,116,2,'Contact education board or university'),(565,117,2,'Contact education board or university'),(566,118,2,'Contact education board or university'),(569,114,3,'File complaint against ragging if required'),(570,115,3,'File complaint against ragging if required'),(571,116,3,'File complaint against ragging if required'),(572,117,3,'File complaint against ragging if required'),(573,118,3,'File complaint against ragging if required'),(576,114,4,'Submit documents and written complaint'),(577,115,4,'Submit documents and written complaint'),(578,116,4,'Submit documents and written complaint'),(579,117,4,'Submit documents and written complaint'),(580,118,4,'Submit documents and written complaint'),(583,114,5,'Take legal action if issue not resolved'),(584,115,5,'Take legal action if issue not resolved'),(585,116,5,'Take legal action if issue not resolved'),(586,117,5,'Take legal action if issue not resolved'),(587,118,5,'Take legal action if issue not resolved'),(625,124,1,'Write RTI application'),(626,125,1,'Write RTI application'),(627,126,1,'Write RTI application'),(628,127,1,'Write RTI application'),(629,128,1,'Write RTI application'),(632,124,2,'Submit RTI application to government office'),(633,125,2,'Submit RTI application to government office'),(634,126,2,'Submit RTI application to government office'),(635,127,2,'Submit RTI application to government office'),(636,128,2,'Submit RTI application to government office'),(639,124,3,'Wait for reply within 30 days'),(640,125,3,'Wait for reply within 30 days'),(641,126,3,'Wait for reply within 30 days'),(642,127,3,'Wait for reply within 30 days'),(643,128,3,'Wait for reply within 30 days'),(646,124,4,'If no reply, file RTI appeal'),(647,125,4,'If no reply, file RTI appeal'),(648,126,4,'If no reply, file RTI appeal'),(649,127,4,'If no reply, file RTI appeal'),(650,128,4,'If no reply, file RTI appeal'),(653,124,5,'Go to RTI commission if required'),(654,125,5,'Go to RTI commission if required'),(655,126,5,'Go to RTI commission if required'),(656,127,5,'Go to RTI commission if required'),(657,128,5,'Go to RTI commission if required'),(660,129,1,'Collect income and tax documents'),(661,130,1,'Collect income and tax documents'),(662,131,1,'Collect income and tax documents'),(663,132,1,'Collect income and tax documents'),(664,133,1,'Collect income and tax documents'),(667,129,2,'Contact CA or tax consultant'),(668,130,2,'Contact CA or tax consultant'),(669,131,2,'Contact CA or tax consultant'),(670,132,2,'Contact CA or tax consultant'),(671,133,2,'Contact CA or tax consultant'),(674,129,3,'File tax return or correction'),(675,130,3,'File tax return or correction'),(676,131,3,'File tax return or correction'),(677,132,3,'File tax return or correction'),(678,133,3,'File tax return or correction'),(681,129,4,'Respond to tax notice if received'),(682,130,4,'Respond to tax notice if received'),(683,131,4,'Respond to tax notice if received'),(684,132,4,'Respond to tax notice if received'),(685,133,4,'Respond to tax notice if received'),(688,129,5,'Attend tax hearing if required'),(689,130,5,'Attend tax hearing if required'),(690,131,5,'Attend tax hearing if required'),(691,132,5,'Attend tax hearing if required'),(692,133,5,'Attend tax hearing if required'),(696,135,1,'Collect proof of defamation (posts, messages, video)'),(697,136,1,'Collect proof of defamation (posts, messages, video)'),(698,137,1,'Collect proof of defamation (posts, messages, video)'),(699,138,1,'Collect proof of defamation (posts, messages, video)'),(703,135,2,'Send legal notice to the person'),(704,136,2,'Send legal notice to the person'),(705,137,2,'Send legal notice to the person'),(706,138,2,'Send legal notice to the person'),(710,135,3,'File defamation case in court'),(711,136,3,'File defamation case in court'),(712,137,3,'File defamation case in court'),(713,138,3,'File defamation case in court'),(717,135,4,'Submit evidence and witnesses'),(718,136,4,'Submit evidence and witnesses'),(719,137,4,'Submit evidence and witnesses'),(720,138,4,'Submit evidence and witnesses'),(724,135,5,'Attend court hearings'),(725,136,5,'Attend court hearings'),(726,137,5,'Attend court hearings'),(727,138,5,'Attend court hearings'),(730,139,1,'Collect proof of ownership (copyright, trademark, patent)'),(731,140,1,'Collect proof of ownership (copyright, trademark, patent)'),(732,141,1,'Collect proof of ownership (copyright, trademark, patent)'),(733,142,1,'Collect proof of ownership (copyright, trademark, patent)'),(734,143,1,'Collect proof of ownership (copyright, trademark, patent)'),(737,139,2,'Send legal notice to offender'),(738,140,2,'Send legal notice to offender'),(739,141,2,'Send legal notice to offender'),(740,142,2,'Send legal notice to offender'),(741,143,2,'Send legal notice to offender'),(744,139,3,'File complaint in IP office or court'),(745,140,3,'File complaint in IP office or court'),(746,141,3,'File complaint in IP office or court'),(747,142,3,'File complaint in IP office or court'),(748,143,3,'File complaint in IP office or court'),(751,139,4,'Submit ownership proof and evidence'),(752,140,4,'Submit ownership proof and evidence'),(753,141,4,'Submit ownership proof and evidence'),(754,142,4,'Submit ownership proof and evidence'),(755,143,4,'Submit ownership proof and evidence'),(758,139,5,'Attend court hearing'),(759,140,5,'Attend court hearing'),(760,141,5,'Attend court hearing'),(761,142,5,'Attend court hearing'),(762,143,5,'Attend court hearing');
/*!40000 ALTER TABLE `steps_to_follow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `role` varchar(20) DEFAULT 'user',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Vedant','vedantgjawadwar26@gmail.com','$2b$12$SIha5m8/cLj5cThVhhyPFuWslCbWNktIJgpnuODnjOKReN.ZxU85.','2026-03-02 10:35:26','admin'),(7,'user-a','a@g.com','$2b$12$aeigC16N3uSNR2P75Lmnsu4dtAPD4xtYLDYayYd7eIPsCYNnBnf96','2026-03-02 11:09:21','user'),(10,'admin','admin@gmail.com','$2b$12$usiprrCOWs04lPQD.gpvFOvaZfEndJfy4c4Q8hUx4gZgWhzX2/XrK','2026-03-07 20:08:28','admin'),(11,'rahul','rahul@email.com','$2b$12$m3p/B3ZQt14j/hymqI6Kn.a2LsXLlBfq6y/K02qLJWDlBEo2I65/K','2026-03-08 14:26:52','lawyer'),(20,'Vedant','ved12816@gmail.com','$2b$12$cGQuYw5iKGoYmw3iJJYIXOHaoue2Aav87k6RNEPvqcXcStrPbRT.y','2026-03-23 14:14:05','user'),(28,'Rahul Sharma','rahul@gmail.com','$2b$12$J8h1tFqF9nZ8HjG7QXQ7UeK7rH2rQeZyJ0J9Z8mQeK9jH1X8Y7Z6G','2026-03-25 16:16:12','lawyer'),(29,'Anil Deshmukh','anil@gmail.com','$2b$12$J8h1tFqF9nZ8HjG7QXQ7UeK7rH2rQeZyJ0J9Z8mQeK9jH1X8Y7Z6G','2026-03-25 16:16:12','lawyer'),(30,'Amit Patil','amit@gmail.com','123','2026-03-25 16:16:12','user'),(31,'Sneha Joshi','sneha@gmail.com','123','2026-03-25 16:16:12','user'),(32,'Rohit Kulkarni','rohit@gmail.com','123','2026-03-25 16:16:12','user'),(33,'Pooja Shah','pooja@gmail.com','123','2026-03-25 16:16:12','user'),(34,'kiran','kiran@gmail.com','$2b$12$HORV2eAlHGHLEecXXegkXeGhwUsa7goFmg9AvlNc.EnQrWHJxtwBG','2026-03-26 07:10:20','lawyer'),(35,'c','c@gmail.com','$2b$12$CHzbmKwwOfNvpmdas394merdM9TVdyqEy9IAXPPph.AVJ7z2mjnT2','2026-03-26 07:16:58','user'),(36,'Priya Mehta','priya@gmail.com','$2b$12$AzObGeYs5ych2J9TCaz6uOxos9ny1h/KxyQlBHhAclhsg5O1jJIIy','2026-03-26 07:36:44','lawyer');
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

-- Dump completed on 2026-03-28  1:14:42
