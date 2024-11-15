-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (2,'Shop Confirmation'),(1,'Vendors');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (1,1,50),(2,1,52),(3,1,57),(4,1,58),(5,1,59),(6,1,60),(7,1,61),(8,1,62),(9,1,63),(10,1,64),(11,1,65),(12,1,66),(13,1,67),(14,1,68),(15,1,69),(16,1,70),(17,1,71),(18,1,72),(19,1,73),(20,1,74),(21,1,75),(22,1,76),(23,1,78),(24,1,80),(30,1,129),(31,1,130),(32,1,131),(33,1,132),(34,1,133),(35,1,134),(36,1,135),(37,1,136),(25,2,40),(27,2,50),(29,2,52),(26,2,82),(28,2,84);
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add Category',6,'add_category'),(22,'Can change Category',6,'change_category'),(23,'Can delete Category',6,'delete_category'),(24,'Can view Category',6,'view_category'),(25,'Can add order status',7,'add_orderstatus'),(26,'Can change order status',7,'change_orderstatus'),(27,'Can delete order status',7,'delete_orderstatus'),(28,'Can view order status',7,'view_orderstatus'),(29,'Can add payment method',8,'add_paymentmethod'),(30,'Can change payment method',8,'change_paymentmethod'),(31,'Can delete payment method',8,'delete_paymentmethod'),(32,'Can view payment method',8,'view_paymentmethod'),(33,'Can add shipping',9,'add_shipping'),(34,'Can change shipping',9,'change_shipping'),(35,'Can delete shipping',9,'delete_shipping'),(36,'Can view shipping',9,'view_shipping'),(37,'Can add shop confirmation status',10,'add_shopconfirmationstatus'),(38,'Can change shop confirmation status',10,'change_shopconfirmationstatus'),(39,'Can delete shop confirmation status',10,'delete_shopconfirmationstatus'),(40,'Can view shop confirmation status',10,'view_shopconfirmationstatus'),(41,'Can add voucher',11,'add_voucher'),(42,'Can change voucher',11,'change_voucher'),(43,'Can delete voucher',11,'delete_voucher'),(44,'Can view voucher',11,'view_voucher'),(45,'Can add voucher type',12,'add_vouchertype'),(46,'Can change voucher type',12,'change_vouchertype'),(47,'Can delete voucher type',12,'delete_vouchertype'),(48,'Can view voucher type',12,'view_vouchertype'),(49,'Can add user',13,'add_user'),(50,'Can change user',13,'change_user'),(51,'Can delete user',13,'delete_user'),(52,'Can view user',13,'view_user'),(53,'Can add order',14,'add_order'),(54,'Can change order',14,'change_order'),(55,'Can delete order',14,'delete_order'),(56,'Can view order',14,'view_order'),(57,'Can add product',15,'add_product'),(58,'Can change product',15,'change_product'),(59,'Can delete product',15,'delete_product'),(60,'Can view product',15,'view_product'),(61,'Can add product color',16,'add_productcolor'),(62,'Can change product color',16,'change_productcolor'),(63,'Can delete product color',16,'delete_productcolor'),(64,'Can view product color',16,'view_productcolor'),(65,'Can add product detail',17,'add_productdetail'),(66,'Can change product detail',17,'change_productdetail'),(67,'Can delete product detail',17,'delete_productdetail'),(68,'Can view product detail',17,'view_productdetail'),(69,'Can add product image',18,'add_productimage'),(70,'Can change product image',18,'change_productimage'),(71,'Can delete product image',18,'delete_productimage'),(72,'Can view product image',18,'view_productimage'),(73,'Can add product video',19,'add_productvideo'),(74,'Can change product video',19,'change_productvideo'),(75,'Can delete product video',19,'delete_productvideo'),(76,'Can view product video',19,'view_productvideo'),(77,'Can add shop',20,'add_shop'),(78,'Can change shop',20,'change_shop'),(79,'Can delete shop',20,'delete_shop'),(80,'Can view shop',20,'view_shop'),(81,'Can add shop confirmation',21,'add_shopconfirmation'),(82,'Can change shop confirmation',21,'change_shopconfirmation'),(83,'Can delete shop confirmation',21,'delete_shopconfirmation'),(84,'Can view shop confirmation',21,'view_shopconfirmation'),(85,'Can add user address',22,'add_useraddress'),(86,'Can change user address',22,'change_useraddress'),(87,'Can delete user address',22,'delete_useraddress'),(88,'Can view user address',22,'view_useraddress'),(89,'Can add user phone',23,'add_userphone'),(90,'Can change user phone',23,'change_userphone'),(91,'Can delete user phone',23,'delete_userphone'),(92,'Can view user phone',23,'view_userphone'),(93,'Can add order detail',24,'add_orderdetail'),(94,'Can change order detail',24,'change_orderdetail'),(95,'Can delete order detail',24,'delete_orderdetail'),(96,'Can view order detail',24,'view_orderdetail'),(97,'Can add user voucher',25,'add_uservoucher'),(98,'Can change user voucher',25,'change_uservoucher'),(99,'Can delete user voucher',25,'delete_uservoucher'),(100,'Can view user voucher',25,'view_uservoucher'),(101,'Can add order voucher',26,'add_ordervoucher'),(102,'Can change order voucher',26,'change_ordervoucher'),(103,'Can delete order voucher',26,'delete_ordervoucher'),(104,'Can view order voucher',26,'view_ordervoucher'),(105,'Can add voucher condition',27,'add_vouchercondition'),(106,'Can change voucher condition',27,'change_vouchercondition'),(107,'Can delete voucher condition',27,'delete_vouchercondition'),(108,'Can view voucher condition',27,'view_vouchercondition'),(109,'Can add application',28,'add_application'),(110,'Can change application',28,'change_application'),(111,'Can delete application',28,'delete_application'),(112,'Can view application',28,'view_application'),(113,'Can add access token',29,'add_accesstoken'),(114,'Can change access token',29,'change_accesstoken'),(115,'Can delete access token',29,'delete_accesstoken'),(116,'Can view access token',29,'view_accesstoken'),(117,'Can add grant',30,'add_grant'),(118,'Can change grant',30,'change_grant'),(119,'Can delete grant',30,'delete_grant'),(120,'Can view grant',30,'view_grant'),(121,'Can add refresh token',31,'add_refreshtoken'),(122,'Can change refresh token',31,'change_refreshtoken'),(123,'Can delete refresh token',31,'delete_refreshtoken'),(124,'Can view refresh token',31,'view_refreshtoken'),(125,'Can add id token',32,'add_idtoken'),(126,'Can change id token',32,'change_idtoken'),(127,'Can delete id token',32,'delete_idtoken'),(128,'Can view id token',32,'view_idtoken'),(129,'Can add storage product',33,'add_storageproduct'),(130,'Can change storage product',33,'change_storageproduct'),(131,'Can delete storage product',33,'delete_storageproduct'),(132,'Can view storage product',33,'view_storageproduct'),(133,'Can add storage',34,'add_storage'),(134,'Can change storage',34,'change_storage'),(135,'Can delete storage',34,'delete_storage'),(136,'Can view storage',34,'view_storage'),(137,'Can add payment vnpay detail',35,'add_paymentvnpaydetail'),(138,'Can change payment vnpay detail',35,'change_paymentvnpaydetail'),(139,'Can delete payment vnpay detail',35,'delete_paymentvnpaydetail'),(140,'Can view payment vnpay detail',35,'view_paymentvnpaydetail'),(141,'Can add comment',36,'add_comment'),(142,'Can change comment',36,'change_comment'),(143,'Can delete comment',36,'delete_comment'),(144,'Can view comment',36,'view_comment'),(145,'Can add rating',37,'add_rating'),(146,'Can change rating',37,'change_rating'),(147,'Can delete rating',37,'delete_rating'),(148,'Can view rating',37,'view_rating'),(149,'Can add product rating',38,'add_productrating'),(150,'Can change product rating',38,'change_productrating'),(151,'Can delete product rating',38,'delete_productrating'),(152,'Can view product rating',38,'view_productrating'),(153,'Can add shop rating',39,'add_shoprating'),(154,'Can change shop rating',39,'change_shoprating'),(155,'Can delete shop rating',39,'delete_shoprating'),(156,'Can view shop rating',39,'view_shoprating'),(157,'Can add product review',38,'add_productreview'),(158,'Can change product review',38,'change_productreview'),(159,'Can delete product review',38,'delete_productreview'),(160,'Can view product review',38,'view_productreview'),(161,'Can add shop review',39,'add_shopreview'),(162,'Can change shop review',39,'change_shopreview'),(163,'Can delete shop review',39,'delete_shopreview'),(164,'Can view shop review',39,'view_shopreview'),(165,'Can add user address phone',40,'add_useraddressphone'),(166,'Can change user address phone',40,'change_useraddressphone'),(167,'Can delete user address phone',40,'delete_useraddressphone'),(168,'Can view user address phone',40,'view_useraddressphone');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_eCommerce_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_eCommerce_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=359 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2024-06-27 04:19:39.979152','1','Vendors',1,'[{\"added\": {}}]',3,1),(2,'2024-06-27 04:21:00.064521','2','Shop Confirmation',1,'[{\"added\": {}}]',3,1),(3,'2024-06-27 04:21:48.946716','2','user2',1,'[{\"added\": {}}]',13,1),(4,'2024-06-27 04:22:15.742088','3','user3',1,'[{\"added\": {}}]',13,1),(5,'2024-06-27 04:22:41.169579','4','staff',1,'[{\"added\": {}}]',13,1),(6,'2024-06-27 04:23:32.589618','1','Approving',1,'[{\"added\": {}}]',10,1),(7,'2024-06-27 04:23:36.258832','2','Successful',1,'[{\"added\": {}}]',10,1),(8,'2024-06-27 04:23:44.897139','3','Providing Additional Information',1,'[{\"added\": {}}]',10,1),(9,'2024-06-27 04:24:39.710519','4','Failed',1,'[{\"added\": {}}]',10,1),(10,'2024-06-27 04:30:18.998204','1','eCommerceApp',1,'[{\"added\": {}}]',28,1),(11,'2024-06-27 04:32:23.976601','1','ShopConfirmation object (1)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(12,'2024-06-27 04:34:30.152926','1','ShopConfirmation object (1)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(13,'2024-06-27 04:39:23.514204','1','ShopConfirmation object (1)',2,'[]',21,4),(14,'2024-06-27 04:40:33.304183','1','ShopConfirmation object (1)',2,'[]',21,4),(15,'2024-06-27 04:41:20.326514','1','ShopConfirmation object (1)',2,'[]',21,4),(16,'2024-06-27 04:46:35.260932','1','ShopConfirmation object (1)',2,'[]',21,4),(17,'2024-06-27 04:46:47.786722','1','ShopConfirmation object (1)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(18,'2024-06-27 04:47:21.736501','1','ShopConfirmation object (1)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(19,'2024-06-27 04:49:12.542990','1','Toys',1,'[{\"added\": {}}]',6,1),(20,'2024-06-27 04:49:18.971322','2','Laptop',1,'[{\"added\": {}}]',6,1),(21,'2024-06-27 04:49:21.578924','3','Clothes',1,'[{\"added\": {}}]',6,1),(22,'2024-06-27 04:49:29.153676','4','Cooker',1,'[{\"added\": {}}]',6,1),(23,'2024-06-27 04:50:54.905207','1','Klutz Lego Gear Bots Science/STEM Activity Kit for 8-12 years',1,'[{\"added\": {}}, {\"added\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (1)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (1)\"}}, {\"added\": {\"name\": \"product color\", \"object\": \"ProductColor object (1)\"}}, {\"added\": {\"name\": \"product video\", \"object\": \"ProductVideo object (1)\"}}]',15,3),(24,'2024-06-27 04:51:40.286857','2','Nồi cơm điện Philips HD4518/62 1.8L',1,'[{\"added\": {}}, {\"added\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (2)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (2)\"}}]',15,3),(25,'2024-06-27 04:53:02.110701','3','Essentials Women\'s Classic',1,'[{\"added\": {}}, {\"added\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (3)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (3)\"}}, {\"added\": {\"name\": \"product video\", \"object\": \"ProductVideo object (2)\"}}]',15,3),(26,'2024-06-27 06:44:39.327278','1','Cash',1,'[{\"added\": {}}]',8,1),(27,'2024-06-27 06:44:43.636612','2','VNPay',1,'[{\"added\": {}}]',8,1),(28,'2024-06-27 06:44:51.273193','3','Momo',1,'[{\"added\": {}}]',8,1),(29,'2024-06-27 06:45:01.842930','4','Zalo Pay',1,'[{\"added\": {}}]',8,1),(30,'2024-06-27 06:45:43.823019','1','VN Express',1,'[{\"added\": {}}]',9,1),(31,'2024-06-27 06:45:53.691674','2','GKTK',1,'[{\"added\": {}}]',9,1),(32,'2024-06-27 06:46:24.069932','3','Ninja',1,'[{\"added\": {}}]',9,1),(33,'2024-06-27 06:53:28.164307','1','Voucher object (1)',1,'[{\"added\": {}}]',11,1),(34,'2024-06-27 07:24:44.098443','5','customer',1,'[{\"added\": {}}]',13,1),(35,'2024-06-27 07:31:54.514613','1','UserAddress object (1)',1,'[{\"added\": {}}]',22,1),(36,'2024-06-27 07:32:03.897249','1','UserPhone object (1)',1,'[{\"added\": {}}]',23,1),(37,'2024-06-27 07:56:38.204972','1','Klutz Lego Gear Bots Science/STEM Activity Kit for 8-12 years',2,'[{\"added\": {\"name\": \"product color\", \"object\": \"ProductColor object (2)\"}}]',15,1),(38,'2024-06-27 07:58:46.999960','2','ProductColor object (2)',2,'[{\"changed\": {\"fields\": [\"Product\"]}}]',16,1),(39,'2024-06-27 08:00:38.430128','2','ProductColor object (2)',2,'[{\"changed\": {\"fields\": [\"Product\"]}}]',16,1),(40,'2024-06-27 08:00:53.302165','1','Klutz Lego Gear Bots Science/STEM Activity Kit for 8-12 years',2,'[]',15,1),(41,'2024-06-27 08:01:04.713312','1','Klutz Lego Gear Bots Science/STEM Activity Kit for 8-12 years',2,'[{\"changed\": {\"name\": \"product color\", \"object\": \"ProductColor object (2)\", \"fields\": [\"Name\"]}}]',15,1),(42,'2024-06-27 08:01:30.912345','1','Klutz Lego Gear Bots Science/STEM Activity Kit for 8-12 years',2,'[{\"added\": {\"name\": \"product color\", \"object\": \"ProductColor object (3)\"}}]',15,1),(43,'2024-06-27 08:01:48.761632','2','ProductColor object (2)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(44,'2024-06-27 08:02:24.770736','1','Klutz Lego Gear Bots Science/STEM Activity Kit for 8-12 years',2,'[{\"changed\": {\"name\": \"product color\", \"object\": \"ProductColor object (2)\", \"fields\": [\"Name\"]}}, {\"changed\": {\"name\": \"product color\", \"object\": \"ProductColor object (3)\", \"fields\": [\"Name\"]}}]',15,3),(45,'2024-06-27 08:07:52.102140','4','Essentials Men\'s Classic',1,'[{\"added\": {}}, {\"added\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (4)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (4)\"}}]',15,3),(46,'2024-06-27 08:09:21.894080','5','Chia sẻ: Dell Precision 5680',1,'[{\"added\": {}}, {\"added\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (5)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (5)\"}}]',15,1),(47,'2024-06-27 08:10:32.672398','5','Chia sẻ: Dell Precision 5680',2,'[]',15,1),(48,'2024-06-27 08:11:07.893750','4','Essentials Men\'s Classic',2,'[{\"changed\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (4)\", \"fields\": [\"Description\"]}}]',15,3),(49,'2024-06-27 08:15:25.415067','6','Panasonic Toughbook FZ-55 MK1',1,'[{\"added\": {}}, {\"added\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (6)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (6)\"}}]',15,3),(50,'2024-06-27 08:16:01.073134','5','Chia sẻ: Dell Precision 5680',2,'[{\"changed\": {\"fields\": [\"Category\"]}}]',15,3),(51,'2024-06-27 08:24:40.262467','1','Klutz Lego Gear Bots Science/STEM Activity Kit for 8-12 years',2,'[{\"changed\": {\"fields\": [\"Price\"]}}]',15,1),(52,'2024-06-27 08:56:43.802681','1','Paying',1,'[{\"added\": {}}]',7,1),(53,'2024-06-28 06:15:04.398560','2','ShopConfirmation object (2)',2,'[{\"changed\": {\"fields\": [\"Shop description\"]}}]',21,4),(54,'2024-06-28 06:15:35.233654','2','ShopConfirmation object (2)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(55,'2024-06-28 07:03:55.316189','1','Vendors',2,'[{\"changed\": {\"fields\": [\"Permissions\"]}}]',3,1),(56,'2024-06-28 07:08:31.774718','2','ShopConfirmation object (2)',2,'[{\"changed\": {\"fields\": [\"Shop description\", \"Status\"]}}]',21,4),(57,'2024-06-28 07:09:07.754708','2','ShopConfirmation object (2)',2,'[{\"changed\": {\"fields\": [\"Shop description\"]}}]',21,4),(58,'2024-06-28 07:09:29.359157','2','ShopConfirmation object (2)',2,'[{\"changed\": {\"fields\": [\"Shop description\"]}}]',21,4),(59,'2024-06-28 07:22:07.937875','2','ShopConfirmation object (2)',2,'[{\"changed\": {\"fields\": [\"Shop description\"]}}]',21,4),(60,'2024-06-28 07:22:16.860693','2','ShopConfirmation object (2)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(61,'2024-06-28 07:23:08.530513','2','ShopConfirmation object (2)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(62,'2024-06-28 07:23:52.660156','2','Channel Official',2,'[{\"changed\": {\"fields\": [\"description\"]}}]',20,2),(63,'2024-06-28 07:25:35.148743','7','Skytech Gaming Nebula Gaming PC Desktop – AMD Ryzen 5 3600 3.6 GHz, NVIDIA GTX 1650, 500GB NVME SSD, 16GB DDR4 RAM 3200, 600W Gold PSU, 11AC Wi-Fi, Wi',1,'[{\"added\": {}}, {\"added\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (7)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (7)\"}}]',15,2),(64,'2024-06-28 07:39:10.464231','1','Storage object (1)',1,'[{\"added\": {}}]',34,2),(65,'2024-06-28 08:04:49.423916','1','77 Ngô Đức Kế',1,'[{\"added\": {}}]',34,2),(66,'2024-06-28 08:19:43.707126','1','StorageProduct object (1)',1,'[{\"added\": {}}]',33,2),(67,'2024-06-30 05:54:26.014547','2','Paid',1,'[{\"added\": {}}]',7,1),(68,'2024-06-30 15:10:58.779567','1','77 Ngô Đức Kế',1,'[{\"added\": {}}]',34,3),(69,'2024-06-30 15:40:55.626400','1','StorageProduct object (1)',1,'[{\"added\": {}}]',33,3),(70,'2024-07-01 03:04:51.195090','1','StorageProduct object (1)',2,'[{\"changed\": {\"fields\": [\"Product color\"]}}]',33,3),(71,'2024-07-01 03:45:43.564435','7','Skytech Gaming Nebula Gaming PC Desktop – AMD Ryzen 5 3600 3.6 GHz, NVIDIA GTX 1650, 500GB NVME SSD, 16GB DDR4 RAM 3200, 600W Gold PSU, 11AC Wi-Fi, Wi',2,'[{\"added\": {\"name\": \"product color\", \"object\": \"Skytech Gaming Nebula Gaming PC Desktop \\u2013 AMD Ryzen 5 3600 3.6 GHz, NVIDIA GTX 1650, 500GB NVME SSD, 16GB DDR4 RAM 3200, 600W Gold PSU, 11AC Wi-Fi, Wi_Blue\"}}, {\"added\": {\"name\": \"product video\", \"object\": \"ProductVideo object (3)\"}}]',15,2),(72,'2024-07-01 03:51:46.541399','5','Panasonic Toughbook FZ-55 MK1_Black',1,'[{\"added\": {}}]',16,3),(73,'2024-07-01 09:03:44.160121','1','StorageProduct object (1)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,3),(74,'2024-07-01 09:03:57.813052','2','516 Phan Văn Trị',1,'[{\"added\": {}}]',34,3),(75,'2024-07-01 09:05:34.177025','2','StorageProduct object (2)',1,'[{\"added\": {}}]',33,3),(76,'2024-07-01 09:05:48.533912','3','StorageProduct object (3)',1,'[{\"added\": {}}]',33,3),(77,'2024-07-01 09:25:27.524997','3','3',3,'',14,1),(78,'2024-07-01 09:25:27.527997','2','2',3,'',14,1),(79,'2024-07-03 04:55:17.245754','1','StorageProduct object (1)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(80,'2024-07-11 09:03:25.570983','11','TMxsPJuz3v7xYeQYY8dXmBmUEtqhZ4',2,'[{\"changed\": {\"fields\": [\"User\"]}}]',29,1),(81,'2024-07-11 09:03:44.831437','11','VF4n9YCyk6xcWft9UsclIbr4GzSkAJ',2,'[{\"changed\": {\"fields\": [\"User\", \"Revoked\"]}}]',31,1),(82,'2024-07-20 07:19:41.086683','1','Klutz Lego Gear Bots Science/STEM Activity Kit for 8-12 years',2,'[{\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (8)\"}}]',15,1),(83,'2024-07-22 01:09:49.911020','5','customer234235435',2,'[{\"changed\": {\"fields\": [\"Username\"]}}]',13,1),(84,'2024-07-22 01:13:17.591971','5','customer',2,'[{\"changed\": {\"fields\": [\"Username\"]}}]',13,1),(85,'2024-08-01 07:03:19.429307','30','hBKlGs1irX66a9Sipj0jzJDE2uVsgf',3,'',29,1),(86,'2024-08-01 07:03:31.857720','30','b5ACXnrHMLfJpgCtXHeA7ohoBMfDop',3,'',31,1),(87,'2024-08-01 07:03:51.774563','24','91830e7a61bd9fda',3,'',13,1),(88,'2024-08-01 10:43:11.175954','5','Chia sẻ: Dell Precision 5680',2,'[{\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (9)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (10)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (11)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (12)\"}}]',15,1),(89,'2024-08-02 07:54:33.868625','8','ProductImage object (8)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(90,'2024-08-02 10:10:28.603419','1','product_id:1 / Blue',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(91,'2024-08-02 10:10:51.909281','2','product_id:1 / Green',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(92,'2024-08-02 10:15:00.265132','4','product_id:7 / Blue',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(93,'2024-08-02 10:15:23.796087','3','product_id:1 / Gray',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(94,'2024-08-02 10:16:04.594671','5','product_id:6 / Black',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(95,'2024-08-04 03:34:07.050935','1','admin',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',13,1),(96,'2024-08-04 03:37:24.984586','1','product_id:1 / Blue',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(97,'2024-08-04 03:40:54.180929','9','ProductImage object (9)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(98,'2024-08-04 03:41:22.869881','10','ProductImage object (10)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(99,'2024-08-04 03:41:30.534551','11','ProductImage object (11)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(100,'2024-08-04 03:41:50.988419','1','ProductImage object (1)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(101,'2024-08-04 03:44:16.626821','1','ProductVideo object (1)',2,'[{\"changed\": {\"fields\": [\"Video\"]}}]',19,1),(102,'2024-08-04 03:48:39.596411','1','ProductImage object (1)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(103,'2024-08-04 03:51:01.323164','1','ProductImage object (1)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(104,'2024-08-04 03:54:14.304728','9','ProductImage object (9)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(105,'2024-08-04 03:54:25.388888','10','ProductImage object (10)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(106,'2024-08-04 03:54:45.455522','11','ProductImage object (11)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(107,'2024-08-04 03:54:46.237107','1','ProductVideo object (1)',2,'[{\"changed\": {\"fields\": [\"Video\"]}}]',19,1),(108,'2024-08-04 03:57:33.008256','1','product_id:1 / Blue',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(109,'2024-08-04 03:57:46.806858','2','product_id:1 / Green',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(110,'2024-08-04 03:57:59.474962','3','product_id:1 / Gray',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(111,'2024-08-04 03:58:07.563482','5','product_id:6 / Black',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',16,1),(112,'2024-08-04 07:57:40.572392','8','Chanel Black Leather Quilted Shoulder Bag',1,'[{\"added\": {}}, {\"added\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (8)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (13)\"}}]',15,1),(113,'2024-08-04 07:59:44.059647','9','Christian Dior White Silk Lace Paneled Cocktail Dress',1,'[{\"added\": {}}, {\"added\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (9)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (14)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (15)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (16)\"}}]',15,1),(114,'2024-08-04 08:04:15.607836','1','Teelab Official',2,'[{\"changed\": {\"fields\": [\"description\"]}}]',20,1),(115,'2024-08-04 08:04:28.906293','2','Channel Official',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',20,1),(116,'2024-08-04 08:04:39.850460','1','Teelab Official',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',20,1),(117,'2024-08-04 09:54:36.855418','1','Order Handling',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',7,1),(118,'2024-08-04 09:55:59.180117','3','Order Packing',1,'[{\"added\": {}}]',7,1),(119,'2024-08-04 09:56:19.095370','4','Order Delivering',1,'[{\"added\": {}}]',7,1),(120,'2024-08-04 09:56:34.705696','5','Order Delivered',1,'[{\"added\": {}}]',7,1),(121,'2024-08-04 09:56:58.613544','6','Order Canceled',1,'[{\"added\": {}}]',7,1),(122,'2024-08-04 09:57:24.342674','7','Order Returned',1,'[{\"added\": {}}]',7,1),(123,'2024-08-04 10:19:31.665849','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(124,'2024-08-04 10:25:44.924327','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(125,'2024-08-04 10:46:47.073199','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(126,'2024-08-04 10:50:14.299263','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(127,'2024-08-04 10:50:19.059167','2','StorageProduct object (2)',2,'[]',33,1),(128,'2024-08-04 10:50:23.110545','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(129,'2024-08-04 10:59:43.841041','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(130,'2024-08-04 10:59:48.218391','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(131,'2024-08-04 11:14:26.961600','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(132,'2024-08-04 11:14:30.725604','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(133,'2024-08-05 00:47:33.067217','7','7',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(134,'2024-08-05 01:14:17.919917','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(135,'2024-08-05 01:15:06.810781','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(136,'2024-08-05 01:15:25.415126','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(137,'2024-08-05 01:23:08.406415','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(138,'2024-08-05 01:23:17.002131','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(139,'2024-08-05 01:54:16.624663','1','StorageProduct object (1)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(140,'2024-08-05 01:54:26.703702','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(141,'2024-08-05 01:54:33.305187','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(142,'2024-08-05 01:56:49.083051','22','22',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(143,'2024-08-06 02:13:28.383835','21','21',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(144,'2024-08-06 04:25:30.194076','13','13',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(145,'2024-08-06 11:18:28.546926','12','12',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(146,'2024-08-06 15:04:02.364842','3','398 Phan Van Tri, Ward 7, Go Vap District,',1,'[{\"added\": {}}]',34,1),(147,'2024-08-06 15:04:26.988788','4','StorageProduct object (4)',1,'[{\"added\": {}}]',33,1),(148,'2024-08-06 15:12:31.891759','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(149,'2024-08-06 15:36:06.061406','25','25',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(150,'2024-08-17 15:50:33.402903','4','Aloha',1,'[{\"added\": {}}]',9,1),(151,'2024-08-17 15:52:13.306265','5','Faster',1,'[{\"added\": {}}]',9,1),(152,'2024-08-18 04:10:51.849211','1','VoucherType object (1)',1,'[{\"added\": {}}]',12,1),(153,'2024-08-18 04:11:00.306175','2','VoucherType object (2)',1,'[{\"added\": {}}]',12,1),(154,'2024-08-18 04:11:04.827907','3','VoucherType object (3)',1,'[{\"added\": {}}]',12,1),(155,'2024-08-18 04:11:08.707034','4','VoucherType object (4)',1,'[{\"added\": {}}]',12,1),(156,'2024-08-18 04:11:37.270802','5','VoucherType object (5)',1,'[{\"added\": {}}]',12,1),(157,'2024-08-18 04:11:39.805808','6','VoucherType object (6)',1,'[{\"added\": {}}]',12,1),(158,'2024-08-18 04:11:42.567795','7','VoucherType object (7)',1,'[{\"added\": {}}]',12,1),(159,'2024-08-18 04:27:32.361922','3','shipping:eCommerce.Shipping.None / payment_method:eCommerce.PaymentMethod.None categories:eCommerce.Category.None / product:eCommerce.Product.Nonemin_order_amount:0.0 / 0.0min_order_amount:10000.0 / 1',1,'[{\"added\": {}}]',27,1),(160,'2024-08-18 04:41:42.852785','4','4',1,'[{\"added\": {}}]',27,1),(161,'2024-08-18 04:42:17.345035','5','5',1,'[{\"added\": {}}]',27,1),(162,'2024-08-18 04:43:14.827145','6','6',1,'[{\"added\": {}}]',27,1),(163,'2024-08-18 04:44:43.260188','6','6',2,'[{\"changed\": {\"fields\": [\"Min order amount\"]}}]',27,1),(164,'2024-08-18 04:50:52.465850','1','Voucher object (1)',1,'[{\"added\": {}}]',11,1),(165,'2024-08-18 11:28:17.100151','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Start date\"]}}]',11,1),(166,'2024-08-18 11:30:14.726678','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(167,'2024-08-18 18:34:19.154765','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(168,'2024-08-18 19:23:13.415783','2','Voucher object (2)',1,'[{\"added\": {}}]',11,1),(169,'2024-08-18 19:29:40.526496','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Active\"]}}]',11,1),(170,'2024-08-19 14:45:17.102795','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Active\"]}}]',11,1),(171,'2024-08-19 16:42:30.760899','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(172,'2024-08-19 17:50:56.928753','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Active\"]}}]',11,1),(173,'2024-08-19 17:52:20.972232','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Active\"]}}]',11,1),(174,'2024-08-19 18:23:06.309896','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(175,'2024-08-19 18:23:39.230225','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(176,'2024-08-19 18:23:53.465708','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(177,'2024-08-19 18:24:34.077530','2','Voucher object (2)',2,'[]',11,1),(178,'2024-08-19 18:25:11.866700','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(179,'2024-08-19 18:25:53.641917','2','Voucher object (2)',2,'[]',11,1),(180,'2024-08-19 18:26:31.260144','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(181,'2024-08-19 18:27:07.029989','2','Voucher object (2)',2,'[]',11,1),(182,'2024-08-19 18:27:38.405913','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Active\"]}}]',11,1),(183,'2024-08-19 18:27:45.090537','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(184,'2024-08-19 18:28:24.617964','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(185,'2024-08-19 18:28:33.252077','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(186,'2024-08-19 18:28:38.723942','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(187,'2024-08-19 18:29:54.600916','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(188,'2024-08-20 13:51:31.002683','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(189,'2024-08-21 22:20:17.629612','5','StorageProduct object (5)',1,'[{\"added\": {}}]',33,1),(190,'2024-08-21 22:25:31.313172','6','StorageProduct object (6)',1,'[{\"added\": {}}]',33,1),(191,'2024-08-21 22:55:56.689639','6','StorageProduct object (6)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(192,'2024-08-29 20:23:15.325006','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Active\"]}}]',11,1),(193,'2024-08-29 20:24:43.617532','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Active\", \"Start date\", \"End date\"]}}]',11,1),(194,'2024-08-30 09:35:41.644669','3','3',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',27,1),(195,'2024-08-30 13:56:32.833399','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(196,'2024-08-30 18:45:27.225998','6','6',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',27,1),(197,'2024-09-04 10:47:09.284385','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(198,'2024-09-04 10:50:41.954210','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(199,'2024-09-04 10:56:54.264486','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(200,'2024-09-04 21:57:01.326221','4','4',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',27,1),(201,'2024-09-04 21:57:10.230433','5','5',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',27,1),(202,'2024-09-04 21:57:15.141256','6','6',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',27,1),(203,'2024-09-05 07:58:59.884856','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(204,'2024-09-05 10:32:11.993088','4','4',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',27,1),(205,'2024-09-05 10:41:40.377841','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(206,'2024-09-05 11:06:52.977614','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Active\"]}}]',11,1),(207,'2024-09-05 11:07:02.857702','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(208,'2024-09-05 13:11:44.701653','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(209,'2024-09-05 18:03:15.790033','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Active\", \"End date\", \"Is multiple\"]}}]',11,1),(210,'2024-09-05 18:03:48.909267','3','3',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',27,1),(211,'2024-09-05 18:51:55.016800','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(212,'2024-09-05 18:56:46.312556','3','3',2,'[{\"changed\": {\"fields\": [\"Categories\"]}}]',27,1),(213,'2024-09-05 18:56:58.014026','3','3',2,'[{\"changed\": {\"fields\": [\"Min order amount\"]}}]',27,1),(214,'2024-09-05 18:57:39.440117','3','3',2,'[{\"changed\": {\"fields\": [\"Min order amount\", \"Remain\"]}}]',27,1),(215,'2024-09-06 09:04:26.315797','6','6',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',27,1),(216,'2024-09-06 09:04:33.539316','3','3',2,'[{\"changed\": {\"fields\": [\"Min order amount\"]}}]',27,1),(217,'2024-09-06 09:04:53.117674','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(218,'2024-09-06 09:06:10.928083','3','3',2,'[{\"changed\": {\"fields\": [\"Min order amount\", \"Remain\"]}}]',27,1),(219,'2024-09-06 09:21:11.511388','3','3',2,'[{\"changed\": {\"fields\": [\"Remain\", \"Categories\"]}}]',27,1),(220,'2024-09-06 09:21:22.813963','3','3',2,'[{\"changed\": {\"fields\": [\"Min order amount\"]}}]',27,1),(221,'2024-09-06 09:33:09.894472','3','3',2,'[{\"changed\": {\"fields\": [\"Min order amount\", \"Categories\"]}}]',27,1),(222,'2024-09-06 09:37:45.700798','3','3',2,'[{\"changed\": {\"fields\": [\"Categories\", \"Products\"]}}]',27,1),(223,'2024-09-06 09:40:20.701211','3','3',2,'[{\"changed\": {\"fields\": [\"Products\", \"Payment methods\", \"Shippings\"]}}]',27,1),(224,'2024-09-06 09:47:56.588622','4','4',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',27,1),(225,'2024-09-06 15:20:49.469187','3','3',2,'[{\"changed\": {\"fields\": [\"Payment methods\", \"Shippings\"]}}]',27,1),(226,'2024-09-08 14:35:54.172282','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(227,'2024-09-08 14:36:06.666593','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(228,'2024-09-08 14:37:55.766241','5','StorageProduct object (5)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(229,'2024-09-08 15:03:00.830801','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(230,'2024-09-08 15:03:05.131571','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(231,'2024-09-08 15:03:27.810244','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(232,'2024-09-08 15:04:28.999218','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(233,'2024-09-08 15:04:40.632101','5','StorageProduct object (5)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(234,'2024-09-08 15:05:13.778807','5','StorageProduct object (5)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(235,'2024-09-08 15:11:41.059880','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(236,'2024-09-08 15:11:46.897671','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(237,'2024-09-08 15:53:40.933149','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(238,'2024-09-08 21:28:21.429216','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(239,'2024-09-09 10:42:12.862696','4','StorageProduct object (4)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(240,'2024-09-09 13:20:27.147424','4','StorageProduct object (4)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(241,'2024-09-09 15:55:31.117748','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(242,'2024-09-09 17:14:45.485830','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(243,'2024-09-10 09:52:15.509140','50','50',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(244,'2024-09-10 21:59:30.218796','3','StorageProduct object (3)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(245,'2024-09-11 09:09:49.978883','79','79',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(246,'2024-09-11 10:47:42.669526','85','85',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(247,'2024-09-11 11:32:25.373360','31','05GcaPRaRSZijok4BfJdIB703IWmv3',2,'[{\"changed\": {\"fields\": [\"Expires\"]}}]',29,1),(248,'2024-09-11 11:56:29.714759','79','79',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(249,'2024-09-11 18:42:58.168849','86','86',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(250,'2024-09-12 14:16:02.511407','5','StorageProduct object (5)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(251,'2024-09-12 14:16:12.765141','1','StorageProduct object (1)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(252,'2024-09-12 14:31:48.182521','6','StorageProduct object (6)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(253,'2024-09-12 14:31:54.958830','2','StorageProduct object (2)',2,'[{\"changed\": {\"fields\": [\"Remain\"]}}]',33,1),(254,'2024-09-13 18:05:54.912833','7','StorageProduct object (7)',1,'[{\"added\": {}}]',33,1),(255,'2024-09-13 18:06:03.072724','8','StorageProduct object (8)',1,'[{\"added\": {}}]',33,1),(256,'2024-09-13 18:11:34.913207','5','Dell Precision 5680',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',15,1),(257,'2024-09-13 18:12:57.154657','7','StorageProduct object (7)',2,'[{\"changed\": {\"fields\": [\"Product\"]}}]',33,1),(258,'2024-09-13 18:16:35.566814','9','StorageProduct object (9)',1,'[{\"added\": {}}]',33,1),(259,'2024-09-13 18:36:50.243082','5','Book',1,'[{\"added\": {}}]',6,1),(260,'2024-09-13 18:37:20.757707','6','Pillow',1,'[{\"added\": {}}]',6,1),(261,'2024-09-13 18:38:00.193723','7','Household Items',1,'[{\"added\": {}}]',6,1),(262,'2024-09-13 18:38:18.661707','8','Car',1,'[{\"added\": {}}]',6,1),(263,'2024-09-13 18:38:23.515947','9','Phone',1,'[{\"added\": {}}]',6,1),(264,'2024-09-13 18:38:41.461589','10','Headphone',1,'[{\"added\": {}}]',6,1),(265,'2024-09-13 18:38:45.635970','11','Earphone',1,'[{\"added\": {}}]',6,1),(266,'2024-09-13 18:39:58.077292','12','Bleach',1,'[{\"added\": {}}]',6,1),(267,'2024-09-13 18:40:06.645965','13','Glass',1,'[{\"added\": {}}]',6,1),(268,'2024-09-17 20:07:00.168248','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"End date\"]}}]',11,1),(269,'2024-09-21 11:31:10.474218','17','ShopConfirmation object (17)',2,'[{\"changed\": {\"fields\": [\"Shop description\"]}}]',21,4),(270,'2024-09-21 13:53:36.429834','3','user3',2,'[{\"changed\": {\"fields\": [\"Password\"]}}]',13,3),(271,'2024-09-21 13:54:09.286324','3','user3',2,'[{\"changed\": {\"fields\": [\"Password\"]}}]',13,3),(272,'2024-09-21 15:10:55.959775','17','ShopConfirmation object (17)',2,'[{\"changed\": {\"fields\": [\"Shop description\", \"Status\"]}}]',21,1),(273,'2024-09-21 17:47:01.569578','111','111',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(274,'2024-09-28 10:12:42.038342','2','ProductImage object (2)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(275,'2024-09-28 10:13:29.246237','2','Rice cooker Philips HD4518/62 1.8L',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',15,1),(276,'2024-09-28 10:14:26.266713','6','Panasonic Toughbook FZ-55 MK1',2,'[{\"changed\": {\"name\": \"product color\", \"object\": \"product_id:6 / Black\", \"fields\": [\"Image\"]}}]',15,1),(277,'2024-09-28 10:15:06.298006','6','ProductImage object (6)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(278,'2024-09-28 10:17:05.450149','7','Skytech Gaming Nebula Gaming PC Desktop – AMD Ryzen 5 3600 3.6 GHz, NVIDIA GTX 1650, 500GB NVME SSD, 16GB DDR4 RAM 3200, 600W Gold PSU, 11AC Wi-Fi, Wi',2,'[{\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (17)\"}}]',15,1),(279,'2024-09-28 10:18:39.811739','7','ProductImage object (7)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(280,'2024-09-28 10:21:34.591877','4','ProductImage object (4)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',18,1),(281,'2024-09-28 10:22:50.910364','4','Men\'s Polo T-shirt',2,'[{\"changed\": {\"fields\": [\"Name\"]}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (18)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (19)\"}}]',15,1),(282,'2024-09-28 10:26:29.847377','3','Women\'s Shirt',2,'[{\"changed\": {\"fields\": [\"Name\"]}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (20)\"}}, {\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (21)\"}}, {\"changed\": {\"name\": \"product image\", \"object\": \"ProductImage object (3)\", \"fields\": [\"Image\"]}}]',15,1),(283,'2024-09-28 10:29:09.033012','1','Klutz Lego Gear Bots Science/STEM Activity Kit for 8-12 years',2,'[{\"changed\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (1)\", \"fields\": [\"Description\"]}}, {\"changed\": {\"name\": \"product image\", \"object\": \"ProductImage object (1)\", \"fields\": [\"Image\"]}}, {\"changed\": {\"name\": \"product image\", \"object\": \"ProductImage object (8)\", \"fields\": [\"Image\"]}}]',15,1),(284,'2024-09-28 10:30:24.077138','5','Dell Precision 5680',2,'[{\"changed\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (5)\", \"fields\": [\"Description\"]}}]',15,1),(285,'2024-09-28 10:31:00.890784','4','Men\'s Polo T-shirt',2,'[{\"changed\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (4)\", \"fields\": [\"Description\"]}}]',15,1),(286,'2024-09-28 10:32:02.818352','2','Rice cooker Philips HD4518/62 1.8L',2,'[{\"changed\": {\"name\": \"product detail\", \"object\": \"ProductDetail object (2)\", \"fields\": [\"Description\"]}}]',15,1),(287,'2024-10-05 21:22:03.224603','112','112',2,'[{\"changed\": {\"fields\": [\"Payment method\"]}}]',14,1),(288,'2024-10-05 21:36:35.895882','112','112',2,'[{\"changed\": {\"fields\": [\"Status\", \"Payment method\"]}}]',14,1),(289,'2024-10-05 22:01:58.453996','112','112',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(290,'2024-10-05 22:02:06.360332','106','106',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(291,'2024-10-05 22:02:12.697588','101','101',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(292,'2024-10-06 13:27:09.615166','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(293,'2024-10-06 13:28:08.778719','2','Voucher object (2)',2,'[]',11,1),(294,'2024-10-06 13:39:54.135079','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(295,'2024-10-06 13:41:03.147363','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Is multiple\"]}}]',11,1),(296,'2024-10-08 18:58:01.318918','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(297,'2024-10-08 18:58:06.403862','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(298,'2024-10-08 20:25:37.559177','115','115',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(299,'2024-10-11 15:40:45.389702','2','ShopConfirmation object (2)',2,'[{\"changed\": {\"fields\": [\"Shop image\"]}}]',21,1),(300,'2024-10-11 15:41:07.976218','1','ShopConfirmation object (1)',2,'[{\"changed\": {\"fields\": [\"Shop image\"]}}]',21,1),(301,'2024-10-14 15:18:50.006293','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(302,'2024-10-14 15:18:54.537294','1','Voucher object (1)',2,'[{\"changed\": {\"fields\": [\"Start date\", \"End date\"]}}]',11,1),(303,'2024-10-14 15:19:33.097518','2','Voucher object (2)',2,'[{\"changed\": {\"fields\": [\"Is multiple\"]}}]',11,1),(304,'2024-10-14 22:27:47.227108','116','116',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(305,'2024-10-14 22:30:41.359171','18','ShopConfirmation object (18)',2,'[{\"changed\": {\"fields\": [\"Shop description\", \"Status\"]}}]',21,4),(306,'2024-10-14 22:56:51.807518','30','usertest14102024',3,'',13,1),(307,'2024-10-14 22:56:58.958060','29','Luiz',3,'',13,1),(308,'2024-10-14 22:57:15.432338','27','testuser',3,'',13,1),(309,'2024-10-14 23:00:56.974404','28','Johnson',3,'',13,1),(310,'2024-10-14 23:07:28.422204','21','ShopConfirmation object (21)',2,'[{\"changed\": {\"fields\": [\"Shop description\", \"Status\"]}}]',21,4),(311,'2024-10-14 23:13:14.957116','31','usertest',3,'',13,1),(312,'2024-10-14 23:13:20.959432','32','usertest14102024',3,'',13,1),(313,'2024-10-14 23:13:54.994385','25','1af6de63b78ec236gf',2,'[{\"changed\": {\"fields\": [\"Password\"]}}]',13,1),(314,'2024-10-14 23:14:19.484837','17','ShopConfirmation object (17)',3,'',21,1),(315,'2024-10-14 23:16:05.094872','3','My new shop',3,'',20,1),(316,'2024-10-14 23:18:11.564579','25','1af6de63b78ec236gf',2,'[{\"changed\": {\"fields\": [\"Groups\", \"Staff status\", \"Is vendor\"]}}]',13,1),(317,'2024-10-14 23:19:32.181876','25','1af6de63b78ec236gf',2,'[{\"changed\": {\"fields\": [\"Groups\", \"Is vendor\"]}}]',13,1),(318,'2024-10-14 23:26:18.691166','22','ShopConfirmation object (22)',2,'[{\"changed\": {\"fields\": [\"Shop description\", \"Status\"]}}]',21,4),(319,'2024-10-14 23:26:53.747248','22','ShopConfirmation object (22)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(321,'2024-10-14 23:29:54.368858','14','Cake',1,'[{\"added\": {}}]',6,1),(322,'2024-10-14 23:30:06.950110','33','usertest14102024',3,'',13,1),(323,'2024-10-14 23:38:27.395051','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Shop description\", \"Status\"]}}]',21,4),(324,'2024-10-14 23:40:08.381071','117','117',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',14,1),(325,'2024-11-10 11:17:03.898291','3','user3',2,'[{\"changed\": {\"fields\": [\"Password\"]}}]',13,3),(326,'2024-11-10 11:17:41.370149','3','user3',2,'[{\"changed\": {\"fields\": [\"Password\"]}}]',13,3),(327,'2024-11-10 15:09:09.487718','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,1),(328,'2024-11-10 15:10:31.609493','23','ShopConfirmation object (23)',2,'[]',21,1),(329,'2024-11-10 15:35:10.954652','23','ShopConfirmation object (23)',2,'[]',21,1),(330,'2024-11-10 15:36:16.646987','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"User\"]}}]',21,1),(331,'2024-11-10 15:39:21.512353','34','usertest14102024',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',13,1),(332,'2024-11-10 15:39:46.669780','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(333,'2024-11-10 15:42:25.139365','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(334,'2024-11-10 15:43:28.260662','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(335,'2024-11-10 15:43:35.969617','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(336,'2024-11-10 15:44:36.357302','34','usertest14102024',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',13,1),(337,'2024-11-10 15:45:26.833268','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(338,'2024-11-10 15:50:04.541084','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(339,'2024-11-10 15:50:26.113650','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(340,'2024-11-10 15:50:48.800523','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(341,'2024-11-10 15:50:59.171579','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(342,'2024-11-10 15:56:47.514611','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(343,'2024-11-10 16:01:19.050021','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(344,'2024-11-10 16:01:51.608493','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(345,'2024-11-10 16:10:56.310856','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(346,'2024-11-10 16:16:11.538274','23','ShopConfirmation object (23)',2,'[]',21,4),(347,'2024-11-10 17:52:54.459136','34','usertest14102024',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',13,1),(348,'2024-11-10 19:19:41.611385','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,1),(349,'2024-11-11 21:13:24.732720','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(350,'2024-11-11 21:13:57.022280','34','usertest14102024',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',13,1),(351,'2024-11-11 21:14:16.407152','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(352,'2024-11-11 21:18:41.906527','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(353,'2024-11-11 21:19:13.618193','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(354,'2024-11-11 21:19:21.408265','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(355,'2024-11-11 21:21:34.512346','23','ShopConfirmation object (23)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',21,4),(356,'2024-11-12 15:36:52.036601','22','tester66',2,'[{\"changed\": {\"fields\": [\"Username\"]}}]',13,1),(357,'2024-11-12 15:40:43.917187','9','Christian Dior White Silk Lace Paneled Cocktail Dress',2,'[{\"added\": {\"name\": \"product image\", \"object\": \"ProductImage object (22)\"}}]',15,1),(358,'2024-11-13 09:42:37.921602','34','usertest14102024',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',13,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'contenttypes','contenttype'),(6,'eCommerce','category'),(36,'eCommerce','comment'),(14,'eCommerce','order'),(24,'eCommerce','orderdetail'),(7,'eCommerce','orderstatus'),(26,'eCommerce','ordervoucher'),(8,'eCommerce','paymentmethod'),(35,'eCommerce','paymentvnpaydetail'),(15,'eCommerce','product'),(16,'eCommerce','productcolor'),(17,'eCommerce','productdetail'),(18,'eCommerce','productimage'),(38,'eCommerce','productreview'),(19,'eCommerce','productvideo'),(37,'eCommerce','rating'),(9,'eCommerce','shipping'),(20,'eCommerce','shop'),(21,'eCommerce','shopconfirmation'),(10,'eCommerce','shopconfirmationstatus'),(39,'eCommerce','shopreview'),(34,'eCommerce','storage'),(33,'eCommerce','storageproduct'),(13,'eCommerce','user'),(22,'eCommerce','useraddress'),(40,'eCommerce','useraddressphone'),(23,'eCommerce','userphone'),(25,'eCommerce','uservoucher'),(11,'eCommerce','voucher'),(27,'eCommerce','vouchercondition'),(12,'eCommerce','vouchertype'),(29,'oauth2_provider','accesstoken'),(28,'oauth2_provider','application'),(30,'oauth2_provider','grant'),(32,'oauth2_provider','idtoken'),(31,'oauth2_provider','refreshtoken'),(5,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-06-27 04:17:04.312759'),(2,'contenttypes','0002_remove_content_type_name','2024-06-27 04:17:04.380786'),(3,'auth','0001_initial','2024-06-27 04:17:04.649517'),(4,'auth','0002_alter_permission_name_max_length','2024-06-27 04:17:04.710522'),(5,'auth','0003_alter_user_email_max_length','2024-06-27 04:17:04.717226'),(6,'auth','0004_alter_user_username_opts','2024-06-27 04:17:04.722037'),(7,'auth','0005_alter_user_last_login_null','2024-06-27 04:17:04.728417'),(8,'auth','0006_require_contenttypes_0002','2024-06-27 04:17:04.730481'),(9,'auth','0007_alter_validators_add_error_messages','2024-06-27 04:17:04.737823'),(10,'auth','0008_alter_user_username_max_length','2024-06-27 04:17:04.744214'),(11,'auth','0009_alter_user_last_name_max_length','2024-06-27 04:17:04.750558'),(12,'auth','0010_alter_group_name_max_length','2024-06-27 04:17:04.766485'),(13,'auth','0011_update_proxy_permissions','2024-06-27 04:17:04.773245'),(14,'auth','0012_alter_user_first_name_max_length','2024-06-27 04:17:04.779258'),(15,'eCommerce','0001_initial','2024-06-27 04:17:07.484547'),(16,'admin','0001_initial','2024-06-27 04:17:07.620121'),(17,'admin','0002_logentry_remove_auto_add','2024-06-27 04:17:07.664835'),(18,'admin','0003_logentry_add_action_flag_choices','2024-06-27 04:17:07.675011'),(19,'oauth2_provider','0001_initial','2024-06-27 04:17:08.406377'),(20,'oauth2_provider','0002_auto_20190406_1805','2024-06-27 04:17:08.463405'),(21,'oauth2_provider','0003_auto_20201211_1314','2024-06-27 04:17:08.531506'),(22,'oauth2_provider','0004_auto_20200902_2022','2024-06-27 04:17:09.014277'),(23,'oauth2_provider','0005_auto_20211222_2352','2024-06-27 04:17:09.102436'),(24,'oauth2_provider','0006_alter_application_client_secret','2024-06-27 04:17:09.135206'),(25,'oauth2_provider','0007_application_post_logout_redirect_uris','2024-06-27 04:17:09.257351'),(26,'oauth2_provider','0008_alter_accesstoken_token','2024-06-27 04:17:09.270817'),(27,'oauth2_provider','0009_add_hash_client_secret','2024-06-27 04:17:09.323511'),(28,'oauth2_provider','0010_application_allowed_origins','2024-06-27 04:17:09.402344'),(29,'sessions','0001_initial','2024-06-27 04:17:09.440664'),(30,'eCommerce','0002_remove_vouchercondition_categories_and_more','2024-06-27 06:38:17.888908'),(31,'eCommerce','0003_alter_voucher_voucher_condition_and_more','2024-06-27 06:50:09.785896'),(32,'eCommerce','0004_userphone_default','2024-06-27 07:31:20.960018'),(33,'eCommerce','0005_storage_storageproduct','2024-06-28 06:55:43.726181'),(34,'eCommerce','0002_paymentvnpaydetail','2024-06-30 08:32:36.346039'),(35,'eCommerce','0002_alter_storageproduct_product_color','2024-07-01 03:04:31.996263'),(36,'eCommerce','0002_alter_order_status','2024-07-01 09:37:33.395859'),(37,'eCommerce','0002_rename_rating_product_product_rating_and_more','2024-07-01 15:01:00.413133'),(38,'eCommerce','0003_rename_productrating_productreview_and_more','2024-07-01 15:06:56.790885'),(39,'eCommerce','0004_alter_shop_shop_rating','2024-07-01 15:19:55.297662'),(40,'eCommerce','0002_alter_comment_is_parent','2024-07-04 03:21:35.767581'),(41,'eCommerce','0003_alter_comment_product_alter_rating_product','2024-08-06 03:57:52.787241'),(42,'eCommerce','0003_alter_category_created_date_and_more','2024-08-06 15:07:39.920086'),(43,'eCommerce','0002_remove_vouchercondition_payment_method_and_more','2024-08-18 04:18:57.651023'),(44,'eCommerce','0003_voucher_is_multiple','2024-08-30 08:12:18.271004'),(45,'eCommerce','0004_alter_useraddress_user','2024-08-31 10:03:54.101461'),(46,'eCommerce','0005_alter_userphone_user','2024-08-31 14:11:18.478785'),(47,'eCommerce','0002_alter_useraddressphone_default','2024-09-01 22:34:22.167156'),(48,'eCommerce','0002_user_phone','2024-09-11 06:34:04.847321'),(49,'oauth2_provider','0011_refreshtoken_token_family','2024-10-09 20:26:45.645022'),(50,'oauth2_provider','0012_add_token_checksum','2024-10-09 20:26:46.010678'),(51,'eCommerce','0003_alter_user_avatar','2024-11-14 14:42:55.732785');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('1b3itbrhbqb4liin7tbpk6lgvp0w9u95','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sp4xD:j60t_oBgfnGJdgkFT0ROvz1QbeC9wMmQFG8i1q2X1-c','2024-09-27 18:59:11.051943'),('29vl99jhpnhprstj016pcy1q5gvy1k7u','e30:1sxLJC:gLGZ6CWK2lIIMzZWuMScMtMbFtYMMF2Bg_OUacyM4xU','2024-10-20 14:04:02.605623'),('3803fo81h7ypaqqtyjw71gatx1swopos','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sOUWd:aD8hGtfAxytACLs-qZUOKo08wkl1pQxL5Dn_dRPAoL4','2024-07-16 03:49:51.808425'),('3t9pa5jis1k9o5m1g8cl5om6j00lktx0','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sRpgu:qpwmgMotqY0EPD_EkEYHjkb6lahfo6DDGI1oHVaue8A','2024-07-25 09:02:16.508477'),('434pzty998jsrlyp9d896lv8g0e5tv5k','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sMq8d:-rVPOhuIq6Am9Iadxi1nHFO3LRLN-MUlGDdVu-pSZwg','2024-07-11 14:30:15.975228'),('49646ospbi0j5a311xrdkbz1thgnwn46','eyJwaG9uZSI6IjA5MDg4MDQ0NDQifQ:1t0Gvy:bDfgbONjdSk22Muz0-TiD8rDc4I6LMpymnxtwY2J82Y','2024-10-28 16:00:10.184152'),('6feokxuu9uqpnqjijx3odczcwcdoit9i','e30:1sRpXi:CcRbIlzheMXRL2k7SigsWBhlAbbFHu2ILKRCOF9eUas','2024-07-25 08:52:46.526255'),('8jkbkt2yet9n9b164fwdq2vxprpf507z','e30:1sZ5pW:pRcaCP7OLEypnWzk8xNbzl6smLWrBGNjliGUxxBEh78','2024-08-14 09:41:10.508924'),('8w1ru72s37azya20qz1j8ycnwohlfw3r','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sOInl:eDoQVXyK9h1Lzp4HAQ_lbz1uw0TANzp8Q4vPTdUz9aI','2024-07-15 15:18:45.798846'),('agrztirfn7y4dcqrnkng0013u633g20q','e30:1sZ591:oSiLwOmEGSK-6EirZM7qEEldPu0BEzG_24FYmBn6dv4','2024-08-14 08:57:15.460325'),('avfquy0tp1ax7sysnp1bu0fjjq3l3vw8','.eJxVjMsOgjAUBf-la9NQ6OPWpXu_obkvBDWQUFgZ_11JWOj2zMx5mYLbOpSt6lJGMWfjzel3I-SHTjuQO0632fI8rctIdlfsQau9zqLPy-H-HQxYh2-dGk9ZKKaU26wBCFSZA0BUdM4H7sl1Cl1upSeOSSCwTy6AJIdNbM37A-dZN8Q:1srrht:A5RR6ADLkw6YTgVktKDBlLINvJ4A5oAzeRwQkbgqjSU','2024-10-05 11:26:53.528592'),('bb2pkqvpewh6m1pjm2szrrg509eryjwh','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sRVYR:YZ49v8Ka3kUV6s0Zq7OQfZn9D2nNmn4Uxi_qdJjZPYY','2024-07-24 11:32:11.479009'),('daecl5msbkyhg5rchwmluqgsz1n73hkz','.eJxVjMsOwiAQAP-FsyHy6rIevfsNBHapVA0kpT0Z_92Q9KDXmcm8RYj7VsLe8xoWFhehxOmXpUjPXIfgR6z3JqnVbV2SHIk8bJe3xvl1Pdq_QYm9jO3kiRENOW1pBqcZgJ2L4HEmnZgUKzYAPmdrDaDxkQgZic8OdJrE5wvh7Tf3:1tB3Ko:qXETOt6qC28Mi5AwlLGplalbKVSrOuZEltxjxefgdgk','2024-11-27 09:42:22.908466'),('e8y4ze6v1a1zutyvuvvupp6ls71ra6v2','.eJxVjMsOwiAQAP-FsyHy6rIevfsNBHapVA0kpT0Z_92Q9KDXmcm8RYj7VsLe8xoWFhehxOmXpUjPXIfgR6z3JqnVbV2SHIk8bJe3xvl1Pdq_QYm9jO3kiRENOW1pBqcZgJ2L4HEmnZgUKzYAPmdrDaDxkQgZic8OdJrE5wvh7Tf3:1t0O6o:c7Ca6KRtTegUkwomGcxKnBHvYiZAe4kGXTWnRz0x2ok','2024-10-28 23:39:50.906710'),('egcqgmtcw02k8s8q9m2xgnh4z31y1iat','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sN6aZ:fYNTlk7TxlTi3wSCycEihMOqytPVOvbBgxRqzMauesk','2024-07-12 08:04:11.705423'),('etv6587wy7spjvp66bew8xrq29n1iohr','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sRUmV:LrBWaEqhAAG2CQDKJ0SnBMOxeC8mNOF4B_J5K3yAqLU','2024-07-24 10:42:39.142939'),('j96rotz4juxaflnbuyunu81tcr659kup','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sqXE8:pmpsKzHNRCgC0pF4nnNV86geyV6_wMDJw_Fx4SUeqDE','2024-10-01 19:22:40.999934'),('jblrols29sqdsiz5invi2t6qoge8aq8a','.eJxVjMEOwiAQRP-FsyFboGXx6N1vICwLUjU0Ke3J-O9K0oPeJvPezEv4sG_F7y2tfmZxFlqcfjsK8ZFqB3wP9bbIuNRtnUl2RR60yevC6Xk53L-DElrpa62ASDkbDRiVeXIJtBkwM0dAdIAmwTdZRMijG-2kCLRjJAhDZBbvD8mFN0c:1t9zOZ:RqltdCEmXGbGTULrfGHz_Wx-rok6031sE92yzfytEnI','2024-11-24 11:17:51.620055'),('jnvsr7a6vfi4o3d68l156u5zk42s0gd9','.eJxVjDsOwjAQBe_iGlnROv6Ekp4zWOvdNQ4gW4qTCnF3iJQC2jcz76UibmuJW5clzqzOalSn3y0hPaTugO9Yb01Tq-syJ70r-qBdXxvL83K4fwcFe_nWxgnZ5C3DiJiNEc8CxAE9kAHn0Q4Op5AHzuAkoEtTAHAWMvnRSFbvD_kwOEE:1t0N1P:wFdz1b3DPYi3nQeqfXgXeC9dXjxAMi0e8oep1NkdgYg','2024-10-28 22:30:11.666340'),('klq9n8tk8nckl3zm0kpuczec65r7z9ee','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1saXTQ:WKYyP7J_yIwDEyDLTI527ipSP02-ssFfOucXoetmXpc','2024-08-18 09:24:20.614565'),('lza8i7glcq68iz10ewdg4nnloluvfpu5','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sxKZ0:dUdqq0QakTKExB8iyHvYpQssQhZF9XxzsEaDg6G2ZHM','2024-10-20 13:16:18.355497'),('q7isdeo8stt6je19m9ogdp8othk2k7ne','e30:1sy8q2:Gct1OkPcC2W6kBYwVVBf8VJXRBTv6UZQcgOynDcPvq8','2024-10-22 18:57:14.925101'),('qtwnq7c6kt1uzcusbg6tzmu0yhhnsisy','.eJxVjEEOwiAQRe_C2hBmCgIu3fcMhCmDVA0kpV0Z765NutDtf-_9lwhxW0vYOi9hTuIiUJx-N4rTg-sO0j3WW5NTq-syk9wVedAux5b4eT3cv4MSe_nWERkUGzIAhlgpk7wDbdGBHZQGtjkxEg5gvI5n6zEjOaW1p2wzGiveH7srNqw:1t0GJB:ZvaAzU4Yrxc6KLaZqG7CIrAbFr1JXVtEfGAobalE-1M','2024-10-28 15:20:05.192351'),('qy2oq2k0ppy358nquloudnkdyirsu18s','.eJxVjMsOwiAQAP-FsyHy6rIevfsNBHapVA0kpT0Z_92Q9KDXmcm8RYj7VsLe8xoWFhehxOmXpUjPXIfgR6z3JqnVbV2SHIk8bJe3xvl1Pdq_QYm9jO3kiRENOW1pBqcZgJ2L4HEmnZgUKzYAPmdrDaDxkQgZic8OdJrE5wvh7Tf3:1szB4F:XgwKq7N0vOpzk4D1T5-Y0h3nzEODPFKoEgUxLBijZD0','2024-10-25 15:32:11.896354'),('r70790ul3azwvzayjjkqqugucp9e81cv','e30:1soAOS:0wBR7bKSlkOn9leIQtKN5D8mp-tIOTa1XtMUK1eH-SI','2024-09-25 06:35:32.335653'),('sl2k499z1r5ape6ceio3jqf24bwz7tdj','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sfdng:YVs4Zu5j3Rqj6Rz6j6jopmc9Atw8iQSveDRkOZIBG1M','2024-09-01 11:10:20.555788'),('u19t2p74uw1a7ordcertsqkzpn7lyy3f','e30:1sZABe:xMQfQ72kYWay6cc0eZivAro_vZOhK79bwlJuo8X6iBs','2024-08-14 14:20:18.172298'),('w043vnvhwjr9rdlw4idssu3gg5obqfgo','.eJxVjEEOwiAQRe_C2hDGASou3XuGBpgZqRpISrsy3l2bdKHb_977LzXGdSnj2nkeJ1JnBerwu6WYH1w3QPdYb03nVpd5SnpT9E67vjbi52V3_w5K7OVbs81CJ7HZDoHAM-echMiDd4ROMAh6YHYI1h4FxJjBgk8h-oAGE6v3BwyQODs:1sOBRV:SisKpTOoeo6k4Yjv-qFX971pqAwQ-XYe6iOjICNIsME','2024-07-15 07:27:17.521210');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_category`
--

DROP TABLE IF EXISTS `ecommerce_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_category`
--

LOCK TABLES `ecommerce_category` WRITE;
/*!40000 ALTER TABLE `ecommerce_category` DISABLE KEYS */;
INSERT INTO `ecommerce_category` VALUES (1,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'Toys'),(2,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'Laptop'),(3,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'Clothes'),(4,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'Cooker'),(5,'2024-09-13 18:36:50.240052','2024-09-13 18:36:50.240052',1,'Book'),(6,'2024-09-13 18:37:20.756441','2024-09-13 18:37:20.756441',1,'Pillow'),(7,'2024-09-13 18:38:00.191216','2024-09-13 18:38:00.191216',1,'Household Items'),(8,'2024-09-13 18:38:18.660683','2024-09-13 18:38:18.660683',1,'Car'),(9,'2024-09-13 18:38:23.514939','2024-09-13 18:38:23.514939',1,'Phone'),(10,'2024-09-13 18:38:41.460091','2024-09-13 18:38:41.460091',1,'Headphone'),(11,'2024-09-13 18:38:45.634737','2024-09-13 18:38:45.634737',1,'Earphone'),(12,'2024-09-13 18:39:58.075785','2024-09-13 18:39:58.075785',1,'Bleach'),(13,'2024-09-13 18:40:06.644857','2024-09-13 18:40:06.644857',1,'Glass'),(14,'2024-10-14 23:29:54.367921','2024-10-14 23:29:54.367921',1,'Cake');
/*!40000 ALTER TABLE `ecommerce_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_comment`
--

DROP TABLE IF EXISTS `ecommerce_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `content` longtext NOT NULL,
  `is_shop` tinyint(1) NOT NULL,
  `is_parent` tinyint(1) NOT NULL,
  `parent_comment_id` bigint DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_comment_parent_comment_id_1b549e3b_fk_eCommerce` (`parent_comment_id`),
  KEY `eCommerce_comment_user_id_7f78eb64_fk_eCommerce_user_id` (`user_id`),
  KEY `eCommerce_comment_order_id_32c0fffd_fk_eCommerce_order_id` (`order_id`),
  KEY `eCommerce_comment_product_id_bdacec1f_fk_eCommerce_product_id` (`product_id`),
  CONSTRAINT `eCommerce_comment_order_id_32c0fffd_fk_eCommerce_order_id` FOREIGN KEY (`order_id`) REFERENCES `ecommerce_order` (`id`),
  CONSTRAINT `eCommerce_comment_parent_comment_id_1b549e3b_fk_eCommerce` FOREIGN KEY (`parent_comment_id`) REFERENCES `ecommerce_comment` (`id`),
  CONSTRAINT `eCommerce_comment_product_id_bdacec1f_fk_eCommerce_product_id` FOREIGN KEY (`product_id`) REFERENCES `ecommerce_product` (`id`),
  CONSTRAINT `eCommerce_comment_user_id_7f78eb64_fk_eCommerce_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_comment`
--

LOCK TABLES `ecommerce_comment` WRITE;
/*!40000 ALTER TABLE `ecommerce_comment` DISABLE KEYS */;
INSERT INTO `ecommerce_comment` VALUES (4,'2024-09-12 00:20:32.109083','2024-09-12 00:20:32.110079',1,'Nice support',1,0,NULL,25,86,1),(5,'2024-09-12 00:20:38.506252','2024-09-12 00:20:38.506252',1,'Good package',0,0,NULL,25,86,1),(6,'2024-09-12 00:21:38.626288','2024-09-12 00:21:38.626288',1,'fafsdfsdf',0,0,NULL,25,86,5),(15,'2024-09-23 17:09:08.137048','2024-09-23 17:09:08.138556',1,'else if (order.product_review && !order.shop_review) {\n          return renderShopReview(ord',0,0,NULL,25,111,1),(17,'2024-10-05 21:58:53.557684','2024-10-05 21:58:53.557684',1,'NGUYEN VAN A',1,0,NULL,25,111,1),(18,'2024-10-05 22:00:47.996169','2024-10-05 22:00:47.996169',1,'NGUYEN VAN A',0,0,NULL,25,85,9),(19,'2024-10-05 22:00:48.364722','2024-10-05 22:00:48.364722',1,'NGUYEN VAN A',1,0,NULL,25,85,9),(20,'2024-10-05 22:01:06.430121','2024-10-05 22:01:06.430121',1,'NGUYEN VAN A',0,0,NULL,25,85,1),(21,'2024-10-05 22:01:06.781418','2024-10-05 22:01:06.781418',1,'NGUYEN VAN A',1,0,NULL,25,85,1),(22,'2024-10-06 13:34:01.606298','2024-10-06 13:34:55.794414',1,'San pham nay con khong shop',0,1,NULL,25,NULL,4),(23,'2024-10-06 13:34:55.798851','2024-10-06 13:34:55.798851',1,'Con nha ban',0,0,22,3,NULL,4),(24,'2024-10-08 19:03:33.720241','2024-10-08 19:04:08.501253',1,'San pham nay con khong shop?',0,1,NULL,26,NULL,9),(25,'2024-10-08 19:04:08.506721','2024-10-08 19:04:08.506721',1,'Mau nay con mau khac khong?',0,0,24,26,NULL,9),(26,'2024-10-08 20:27:46.392516','2024-10-08 20:27:46.392516',1,'good package, the product as description',0,0,NULL,26,115,9),(27,'2024-10-08 20:27:46.712182','2024-10-08 20:27:46.712182',1,'Friendly shop owner',1,0,NULL,26,115,9),(28,'2024-10-14 22:28:30.494907','2024-10-14 22:28:30.494907',1,'Chu shop 10 diem',0,0,NULL,26,116,9),(29,'2024-10-14 22:28:30.755712','2024-10-14 22:28:30.755712',1,'San pham nhu mo ta, ung ho shop nhung lan tiep theo',1,0,NULL,26,116,9),(30,'2024-10-14 22:28:51.426351','2024-10-14 22:28:51.426351',1,'Chu shop 10 diem',0,0,NULL,26,116,4),(31,'2024-10-14 22:28:51.676949','2024-10-14 22:28:51.676949',1,'San pham nhu mo ta, ung ho shop nhung lan tiep theo',1,0,NULL,26,116,4),(32,'2024-10-14 23:41:06.738232','2024-10-14 23:41:06.738232',1,'San pham nhu mo ta, ung ho shop nhung lan tiep theo',0,0,NULL,25,117,9),(33,'2024-10-14 23:41:07.007298','2024-10-14 23:41:07.007298',1,'Chu shop 10 diem',1,0,NULL,25,117,9);
/*!40000 ALTER TABLE `ecommerce_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_order`
--

DROP TABLE IF EXISTS `ecommerce_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `total_amount` double NOT NULL,
  `user_id` bigint NOT NULL,
  `status_id` bigint NOT NULL,
  `payment_method_id` bigint NOT NULL,
  `shipping_id` bigint NOT NULL,
  `user_address_phone_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_order_user_address_phone_i_10ff1ec5_fk_eCommerce` (`user_address_phone_id`),
  KEY `eCommerce_order_user_id_888c6224_fk_eCommerce_user_id` (`user_id`),
  KEY `eCommerce_order_status_id_6886d62c_fk_eCommerce_orderstatus_id` (`status_id`),
  KEY `eCommerce_order_payment_method_id_f886e1a4_fk_eCommerce` (`payment_method_id`),
  KEY `eCommerce_order_shipping_id_231b4255_fk_eCommerce_shipping_id` (`shipping_id`),
  CONSTRAINT `eCommerce_order_payment_method_id_f886e1a4_fk_eCommerce` FOREIGN KEY (`payment_method_id`) REFERENCES `ecommerce_paymentmethod` (`id`),
  CONSTRAINT `eCommerce_order_shipping_id_231b4255_fk_eCommerce_shipping_id` FOREIGN KEY (`shipping_id`) REFERENCES `ecommerce_shipping` (`id`),
  CONSTRAINT `eCommerce_order_status_id_6886d62c_fk_eCommerce_orderstatus_id` FOREIGN KEY (`status_id`) REFERENCES `ecommerce_orderstatus` (`id`),
  CONSTRAINT `eCommerce_order_user_address_phone_i_10ff1ec5_fk_eCommerce` FOREIGN KEY (`user_address_phone_id`) REFERENCES `ecommerce_useraddressphone` (`id`),
  CONSTRAINT `eCommerce_order_user_id_888c6224_fk_eCommerce_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_order`
--

LOCK TABLES `ecommerce_order` WRITE;
/*!40000 ALTER TABLE `ecommerce_order` DISABLE KEYS */;
INSERT INTO `ecommerce_order` VALUES (79,'2024-09-10 21:48:12.623469','2024-09-11 11:56:29.705046',1,4877000,25,2,2,1,11),(85,'2024-10-10 21:59:41.145576','2024-10-11 10:47:42.669526',1,5346000,25,5,2,4,11),(86,'2024-12-11 18:41:42.477839','2024-12-11 18:42:58.164849',1,17135600,25,5,2,5,11),(87,'2024-09-12 14:33:17.211674','2024-09-12 14:33:17.211674',1,15835600,25,1,1,5,11),(88,'2024-09-12 14:36:53.239219','2024-09-12 14:36:53.239219',1,20536000,25,1,1,4,11),(89,'2024-09-12 14:46:55.691829','2024-09-12 14:46:55.691829',1,4946000,25,1,1,4,11),(90,'2024-09-12 14:50:25.765701','2024-09-12 14:50:25.765701',1,417000,25,1,1,1,11),(91,'2024-09-12 14:57:57.102013','2024-09-12 14:57:57.102013',1,4877000,25,1,1,1,11),(92,'2024-09-12 15:00:41.646090','2024-09-12 15:00:41.646090',1,217000,25,1,1,1,11),(93,'2024-09-12 15:01:18.378068','2024-09-12 15:01:18.378068',1,4877000,25,1,1,1,11),(94,'2024-09-12 15:02:26.034906','2024-09-12 15:02:26.034906',1,226700,25,1,1,3,11),(95,'2024-09-12 15:03:43.239914','2024-09-12 15:03:43.239914',1,217000,25,1,1,1,11),(99,'2024-09-12 16:16:19.899195','2024-09-12 16:16:19.900725',1,217000,25,1,1,1,11),(100,'2024-09-12 16:16:27.662016','2024-09-12 16:16:27.662016',1,217000,25,1,1,1,11),(101,'2024-09-12 16:18:47.046379','2024-10-05 22:02:12.694584',1,217000,25,3,1,1,11),(102,'2024-09-12 16:19:11.682329','2024-09-12 16:19:11.682329',1,4877000,25,1,1,1,11),(103,'2024-09-12 16:20:05.236174','2024-09-12 16:20:05.236174',1,4877000,25,1,1,1,11),(104,'2024-09-12 20:27:30.044802','2024-09-12 20:27:30.044802',1,286000,25,1,1,4,11),(105,'2024-09-12 20:28:21.937892','2024-09-12 20:28:21.937892',1,4877000,25,1,1,1,11),(106,'2024-09-12 20:29:38.924327','2024-10-05 22:02:06.357970',1,15607000,25,4,1,1,11),(107,'2024-09-12 20:33:32.912268','2024-09-12 20:33:32.912268',1,15822000,25,1,1,2,11),(108,'2024-09-13 18:13:25.837203','2024-09-13 18:13:25.837203',1,10737000,25,1,1,1,5),(109,'2024-09-13 18:17:19.974779','2024-09-13 18:17:19.975785',1,7586000,25,1,1,4,5),(110,'2024-09-21 15:42:04.604770','2024-09-21 15:42:35.753488',1,795600,5,2,2,5,13),(111,'2024-09-21 17:46:31.888815','2024-09-21 17:47:01.565436',1,445600,25,5,1,5,5),(112,'2024-10-05 21:09:47.290819','2024-10-05 22:01:58.449989',1,4886700,25,4,1,3,5),(113,'2024-10-05 21:37:47.441399','2024-10-05 21:38:30.324851',1,4886700,25,2,2,3,11),(114,'2024-10-06 14:48:15.341056','2024-10-06 14:49:10.227644',1,4876700,25,2,2,3,12),(115,'2024-10-08 20:24:11.780269','2024-10-08 20:25:37.555659',1,4867000,26,5,2,1,14),(116,'2024-10-14 22:26:16.809896','2024-10-14 22:27:47.223590',1,10207000,26,5,2,1,14),(117,'2024-10-14 23:35:20.874565','2024-10-14 23:40:08.376986',1,4867000,25,5,2,1,5);
/*!40000 ALTER TABLE `ecommerce_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_order_order_voucher_condition`
--

DROP TABLE IF EXISTS `ecommerce_order_order_voucher_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_order_order_voucher_condition` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `vouchercondition_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eCommerce_order_order_vo_order_id_voucherconditio_3a5c944f_uniq` (`order_id`,`vouchercondition_id`),
  KEY `eCommerce_order_orde_vouchercondition_id_5a6d4f28_fk_eCommerce` (`vouchercondition_id`),
  CONSTRAINT `eCommerce_order_orde_order_id_f7ca31e3_fk_eCommerce` FOREIGN KEY (`order_id`) REFERENCES `ecommerce_order` (`id`),
  CONSTRAINT `eCommerce_order_orde_vouchercondition_id_5a6d4f28_fk_eCommerce` FOREIGN KEY (`vouchercondition_id`) REFERENCES `ecommerce_vouchercondition` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_order_order_voucher_condition`
--

LOCK TABLES `ecommerce_order_order_voucher_condition` WRITE;
/*!40000 ALTER TABLE `ecommerce_order_order_voucher_condition` DISABLE KEYS */;
INSERT INTO `ecommerce_order_order_voucher_condition` VALUES (9,114,3),(10,115,3),(11,116,3),(12,117,3);
/*!40000 ALTER TABLE `ecommerce_order_order_voucher_condition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_orderdetail`
--

DROP TABLE IF EXISTS `ecommerce_orderdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_orderdetail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int NOT NULL,
  `price` double NOT NULL,
  `order_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `color_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_orderdetail_order_id_e11e535c_fk_eCommerce_order_id` (`order_id`),
  KEY `eCommerce_orderdetai_product_id_e68fc300_fk_eCommerce` (`product_id`),
  KEY `eCommerce_orderdetai_color_id_53fd42c3_fk_eCommerce` (`color_id`),
  CONSTRAINT `eCommerce_orderdetai_color_id_53fd42c3_fk_eCommerce` FOREIGN KEY (`color_id`) REFERENCES `ecommerce_productcolor` (`id`),
  CONSTRAINT `eCommerce_orderdetai_product_id_e68fc300_fk_eCommerce` FOREIGN KEY (`product_id`) REFERENCES `ecommerce_product` (`id`),
  CONSTRAINT `eCommerce_orderdetail_order_id_e11e535c_fk_eCommerce_order_id` FOREIGN KEY (`order_id`) REFERENCES `ecommerce_order` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_orderdetail`
--

LOCK TABLES `ecommerce_orderdetail` WRITE;
/*!40000 ALTER TABLE `ecommerce_orderdetail` DISABLE KEYS */;
INSERT INTO `ecommerce_orderdetail` VALUES (86,1,4860000,79,9,NULL),(87,2,200000,85,1,3),(88,1,4860000,85,9,NULL),(89,1,200000,86,1,3),(90,1,16890000,86,5,NULL),(91,1,15590000,87,7,4),(92,1,200000,87,1,3),(93,1,4860000,88,9,NULL),(94,1,15590000,88,7,4),(95,1,4860000,89,9,NULL),(96,2,200000,90,1,3),(97,1,4860000,91,9,NULL),(98,1,200000,92,1,3),(99,1,4860000,93,9,NULL),(100,1,200000,94,1,3),(101,1,200000,95,1,3),(105,1,200000,99,1,3),(106,1,200000,100,1,3),(107,1,200000,101,1,3),(108,1,4860000,102,9,NULL),(109,1,4860000,103,9,NULL),(110,1,200000,104,1,3),(111,1,4860000,105,9,NULL),(112,1,15590000,106,7,4),(113,1,15590000,107,7,4),(114,1,200000,107,1,3),(115,3,1200000,108,3,NULL),(116,4,1780000,108,4,NULL),(117,10,750000,109,2,NULL),(118,1,750000,110,2,NULL),(119,1,200000,111,1,3),(120,1,200000,111,1,1),(121,1,4860000,112,9,NULL),(122,1,4860000,113,9,NULL),(123,1,4860000,114,9,NULL),(124,1,4860000,115,9,NULL),(125,1,4860000,116,9,NULL),(126,3,1780000,116,4,NULL),(127,1,4860000,117,9,NULL);
/*!40000 ALTER TABLE `ecommerce_orderdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_orderstatus`
--

DROP TABLE IF EXISTS `ecommerce_orderstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_orderstatus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_orderstatus`
--

LOCK TABLES `ecommerce_orderstatus` WRITE;
/*!40000 ALTER TABLE `ecommerce_orderstatus` DISABLE KEYS */;
INSERT INTO `ecommerce_orderstatus` VALUES (1,'Order Handling'),(2,'Paid'),(3,'Order Packing'),(4,'Order Delivering'),(5,'Order Delivered'),(6,'Order Canceled'),(7,'Order Returned');
/*!40000 ALTER TABLE `ecommerce_orderstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_paymentmethod`
--

DROP TABLE IF EXISTS `ecommerce_paymentmethod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_paymentmethod` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `name` varchar(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_paymentmethod`
--

LOCK TABLES `ecommerce_paymentmethod` WRITE;
/*!40000 ALTER TABLE `ecommerce_paymentmethod` DISABLE KEYS */;
INSERT INTO `ecommerce_paymentmethod` VALUES (1,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'Cash'),(2,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'VNPay'),(3,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'Momo'),(4,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'Zalo Pay');
/*!40000 ALTER TABLE `ecommerce_paymentmethod` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_paymentvnpaydetail`
--

DROP TABLE IF EXISTS `ecommerce_paymentvnpaydetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_paymentvnpaydetail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `amount` double NOT NULL,
  `order_desc` varchar(100) NOT NULL,
  `vnp_TransactionNo` varchar(20) NOT NULL,
  `vnp_ResponseCode` varchar(20) NOT NULL,
  `vnp_PayDate` varchar(20) NOT NULL,
  `order_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_paymentvnp_order_id_a20de7a9_fk_eCommerce` (`order_id`),
  CONSTRAINT `eCommerce_paymentvnp_order_id_a20de7a9_fk_eCommerce` FOREIGN KEY (`order_id`) REFERENCES `ecommerce_order` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_paymentvnpaydetail`
--

LOCK TABLES `ecommerce_paymentvnpaydetail` WRITE;
/*!40000 ALTER TABLE `ecommerce_paymentvnpaydetail` DISABLE KEYS */;
INSERT INTO `ecommerce_paymentvnpaydetail` VALUES (34,4877000,'Order payment for eCommerceApp','14578531','00','20240910214833',79),(35,4877000,'Order payment for eCommerceApp','14578531','00','20240910214833',79),(36,5346000,'Order payment for eCommerceApp','14578533','00','20240910220004',85),(37,5346000,'Order payment for eCommerceApp','14578533','00','20240910220004',85),(38,17135600,'Order payment for eCommerceApp','14579211','00','20240911184224',86),(39,17135600,'Order payment for eCommerceApp','14579211','00','20240911184224',86),(40,795600,'Order payment for eCommerceApp','14589562','00','20240921154312',110),(41,795600,'Order payment for eCommerceApp','14589562','00','20240921154312',110),(42,4886700,'Order payment for eCommerceApp','14603986','00','20241005213857',113),(43,4886700,'Order payment for eCommerceApp','14603986','00','20241005213857',113),(44,4876700,'Order payment for eCommerceApp','14604278','00','20241006144932',114),(45,4876700,'Order payment for eCommerceApp','14604278','00','20241006144932',114),(46,4867000,'Order payment for eCommerceApp','14606885','00','20241008202523',115),(47,4867000,'Order payment for eCommerceApp','14606885','00','20241008202523',115),(48,10207000,'Order payment for eCommerceApp','14614028','00','20241014222717',116),(49,4867000,'Order payment for eCommerceApp','14614124','00','20241014233622',117),(50,4867000,'Order payment for eCommerceApp','14614124','00','20241014233622',117);
/*!40000 ALTER TABLE `ecommerce_paymentvnpaydetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_product`
--

DROP TABLE IF EXISTS `ecommerce_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `name` varchar(150) NOT NULL,
  `price` double NOT NULL,
  `sold` int NOT NULL,
  `product_rating` double NOT NULL,
  `category_id` bigint NOT NULL,
  `shop_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_product_shop_id_910e65c7_fk_eCommerce_shop_id` (`shop_id`),
  KEY `eCommerce_product_category_id_eafc7935_fk_eCommerce_category_id` (`category_id`),
  CONSTRAINT `eCommerce_product_category_id_eafc7935_fk_eCommerce_category_id` FOREIGN KEY (`category_id`) REFERENCES `ecommerce_category` (`id`),
  CONSTRAINT `eCommerce_product_shop_id_910e65c7_fk_eCommerce_shop_id` FOREIGN KEY (`shop_id`) REFERENCES `ecommerce_shop` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_product`
--

LOCK TABLES `ecommerce_product` WRITE;
/*!40000 ALTER TABLE `ecommerce_product` DISABLE KEYS */;
INSERT INTO `ecommerce_product` VALUES (1,'2024-06-27 00:00:00.000000','2024-10-05 22:01:06.440231',1,'Klutz Lego Gear Bots Science/STEM Activity Kit for 8-12 years',200000,15,5,1,1),(2,'2024-06-27 00:00:00.000000','2024-09-28 10:32:02.815920',1,'Rice cooker Philips HD4518/62 1.8L',750000,0,0,4,1),(3,'2024-06-27 00:00:00.000000','2024-09-28 10:26:25.249334',1,'Women\'s Shirt',1200000,0,0,3,1),(4,'2024-06-27 00:00:00.000000','2024-10-14 22:28:51.440273',1,'Men\'s Polo T-shirt',1780000,1,3,3,1),(5,'2024-06-27 00:00:00.000000','2024-09-28 10:30:24.074137',1,'Dell Precision 5680',16890000,8,3,2,1),(6,'2024-06-27 00:00:00.000000','2024-09-28 10:14:24.379989',1,'Panasonic Toughbook FZ-55 MK1',20596000,0,0,2,1),(7,'2024-06-28 00:00:00.000000','2024-09-28 10:17:04.837800',1,'Skytech Gaming Nebula Gaming PC Desktop – AMD Ryzen 5 3600 3.6 GHz, NVIDIA GTX 1650, 500GB NVME SSD, 16GB DDR4 RAM 3200, 600W Gold PSU, 11AC Wi-Fi, Wi',15590000,0,0,2,2),(8,'2024-08-04 00:00:00.000000','2024-08-04 00:00:00.000000',1,'Chanel Black Leather Quilted Shoulder Bag',69865000,0,0,3,2),(9,'2024-08-04 00:00:00.000000','2024-11-12 15:40:34.080564',1,'Christian Dior White Silk Lace Paneled Cocktail Dress',4860000,4,5,3,2);
/*!40000 ALTER TABLE `ecommerce_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_productcolor`
--

DROP TABLE IF EXISTS `ecommerce_productcolor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_productcolor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `image` varchar(255) NOT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_productcol_product_id_3219abf4_fk_eCommerce` (`product_id`),
  CONSTRAINT `eCommerce_productcol_product_id_3219abf4_fk_eCommerce` FOREIGN KEY (`product_id`) REFERENCES `ecommerce_product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_productcolor`
--

LOCK TABLES `ecommerce_productcolor` WRITE;
/*!40000 ALTER TABLE `ecommerce_productcolor` DISABLE KEYS */;
INSERT INTO `ecommerce_productcolor` VALUES (1,'Blue','image/upload/v1722743852/t2snhrk1edc39y8wwvqd.jpg',1),(2,'Green','image/upload/v1722743866/mz3uxhnqo7hgckrd8ezw.png',1),(3,'Gray','image/upload/v1722743879/boxvn9uvthmfgqtlhcmm.jpg',1),(4,'Blue','image/upload/v1722743852/t2snhrk1edc39y8wwvqd.jpg',7),(5,'Black','image/upload/v1727493264/ff3vr1joibomejpvg7ni.png',6);
/*!40000 ALTER TABLE `ecommerce_productcolor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_productdetail`
--

DROP TABLE IF EXISTS `ecommerce_productdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_productdetail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `material` varchar(50) NOT NULL,
  `manufactory` varchar(50) NOT NULL,
  `description` longtext NOT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id` (`product_id`),
  CONSTRAINT `eCommerce_productdet_product_id_35e3711a_fk_eCommerce` FOREIGN KEY (`product_id`) REFERENCES `ecommerce_product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_productdetail`
--

LOCK TABLES `ecommerce_productdetail` WRITE;
/*!40000 ALTER TABLE `ecommerce_productdetail` DISABLE KEYS */;
INSERT INTO `ecommerce_productdetail` VALUES (1,'Plastic','Australia','<ul>\r\n	<li>Build 8 physics-driven kinetic creatures using LEGO Technic bricks and papercraft.</li>\r\n	<li>Includes every LEGO element you need!</li>\r\n	<li>STEM content about axles, cams, cranks, engineering in everyday machines is included in the 64-page book, alongside the step-by-step instructions.</li>\r\n	<li>Model number: 9781338603453</li>\r\n</ul>',1),(2,'Fabric, Cotton','Australia','<h3>18 chế độ được tối ưu h&oacute;a với giao diện người d&ugrave;ng th&ocirc;ng minh</h3>\r\n\r\n<p>Giao diện người d&ugrave;ng liền mạch của nồi cơm điện của ch&uacute;ng t&ocirc;i cho ph&eacute;p bạn chọn từ menu gồm 18 chương tr&igrave;nh nấu ăn dễ d&agrave;ng chỉ với một lần chạm.</p>\r\n\r\n<h3>Biểu đồ nhiệt độ nấu th&ocirc;ng minh để đảm bảo cơm ch&iacute;n đều, thơm ngon</h3>\r\n\r\n<p>Điều khiển th&ocirc;ng minh nhiệt độ v&agrave; thời gian của c&aacute;c giai đoạn nấu kh&aacute;c nhau dựa tr&ecirc;n loại v&agrave; cấu tạo hạt gạo bạn đ&atilde; chọn. H&atilde;y để c&aacute;c cảm biến nhiệt độ th&ocirc;ng minh gi&aacute;m s&aacute;t v&agrave; tối ưu h&oacute;a năng lượng nhiệt để mang lại m&ugrave;i thơm, hương vị v&agrave; cảm gi&aacute;c ngon miệng ho&agrave;n hảo.</p>\r\n\r\n<h3>Hệ thống đốt n&oacute;ng 3D th&ocirc;ng minh cho năng lượng nhiệt mạnh mẽ</h3>\r\n\r\n<p>Bộ gia nhiệt dạng tấm được lắp đặt ở ph&iacute;a tr&ecirc;n, mặt b&ecirc;n v&agrave; ph&iacute;a dưới tạo ra năng lượng nhiệt mạnh mẽ, đảm bảo hương vị thơm ngon trong từng hạt gạo.</p>\r\n\r\n<h3>Chức năng Giữ ấm cho nhiệt độ ho&agrave;n hảo mọi l&uacute;c</h3>\r\n\r\n<p>Chức năng Giữ ấm tiện dụng cho ph&eacute;p bạn d&ugrave;ng cơm bất cứ khi n&agrave;o bạn muốn. Khi chức năng được k&iacute;ch hoạt, c&aacute;c loại ngũ cốc đ&atilde; nấu ch&iacute;n của bạn sẽ lu&ocirc;n tươi, xốp v&agrave; ở nhiệt độ ho&agrave;n hảo trong tối đa 24 giờ.</p>\r\n\r\n<h3>L&ograve;ng nồi hợp kim 6 lớp với Lớp tr&aacute;ng Maifanshi</h3>\r\n\r\n<p>Lớp tr&aacute;ng Maifanshi tự h&agrave;o về t&iacute;nh kh&ocirc;ng độc hại v&agrave; khả năng chống trầy xước được cải thiện l&ecirc;n đến 6 lần*. Được t&iacute;ch hợp với c&aacute;c vật liệu tr&aacute;ng l&ograve;ng nồi kh&aacute;c như hợp kim v&agrave; gốm, l&ograve;ng nồi cho ph&eacute;p bạn nấu ăn dễ d&agrave;ng v&agrave; đảm bảo chất lượng m&oacute;n ăn.</p>\r\n\r\n<h3>Van chống tr&agrave;n</h3>\r\n\r\n<p>Van chống tr&agrave;n gi&uacute;p ngăn nước tr&agrave;n trong trường hợp cho qu&aacute; nhiều nước v&agrave;o, đảm bảo qu&aacute; tr&igrave;nh nấu ăn diễn ra su&ocirc;n sẻ.</p>',2),(3,'Fabric, Cotton','Australia','<p><code>obj.user, &#39;user_shop&#39;</code> l&agrave; một c&aacute;ch viết ngắn gọn để kiểm tra xem người d&ugrave;ng (<code>obj.user</code>) c&oacute; một cửa h&agrave;ng (<code>Shop</code>) n&agrave;o đ&oacute; li&ecirc;n kết với họ hay kh&ocirc;ng. Cụ thể, đ&acirc;y l&agrave; c&aacute;ch Django sử dụng để kiểm tra sự tồn tại của một mối quan hệ một-một (OneToOne) th&ocirc;ng qua việc truy cập thuộc t&iacute;nh động.</p>',3),(4,'Fabric, Cotton','Australia','<ul>\r\n	<li>Moisture wicking short sleeve polo with 35 UPF sun protection, ribbed cuff and knit collar</li>\r\n</ul>\r\n\r\n<ul>\r\n	<li>CB dry Tec cotton+ technology for ultimate softness and comfort</li>\r\n</ul>\r\n\r\n<ul>\r\n	<li>C and b pennant embroidery at back yoke,</li>\r\n</ul>\r\n\r\n<ul>\r\n	<li>Grosgrain neck tape and locker loop</li>\r\n</ul>',4),(5,'Carbon, Metal','China','<ul>\r\n	<li>\r\n	<p><img alt=\"processor\" src=\"https://www.dell.com/cdn/assets/csb/configux/bundles/1.0.6.45393/images/processor-blk.svg\" style=\"height:20px; width:20px\" /></p>\r\n\r\n	<p>Intel&reg; Core&trade; i7-13700H, vPro&reg; Essentials (24MB Cache, 14 Cores, 20 Threads, 2.4-5.0 GHz Turbo, 45W)</p>\r\n	</li>\r\n	<li>\r\n	<p><img alt=\"laptop\" src=\"https://www.dell.com/cdn/assets/csb/configux/bundles/1.0.6.45393/images/laptop-blk.svg\" style=\"height:20px; width:20px\" /></p>\r\n\r\n	<p>Windows 11 Pro, English, Brazilian Portuguese, French, Spanish<br />\r\n	(Dell Technologies recommends Windows 11 Pro for business)</p>\r\n	</li>\r\n	<li>\r\n	<p><img alt=\"videocard\" src=\"https://www.dell.com/cdn/assets/csb/configux/bundles/1.0.6.45393/images/videocard-blk.svg\" style=\"height:20px; width:20px\" /></p>\r\n\r\n	<p>NVIDIA&reg; RTX&trade; 3500 Ada, 12GB GDDR6</p>\r\n	</li>\r\n	<li>\r\n	<p><img alt=\"memory\" src=\"https://www.dell.com/cdn/assets/csb/configux/bundles/1.0.6.45393/images/memory-blk.svg\" style=\"height:20px; width:20px\" /></p>\r\n\r\n	<p>16 GB: 1 x 16 GB, LPDDR5, 6400 MT/s</p>\r\n	</li>\r\n	<li>\r\n	<p><img alt=\"harddrive\" src=\"https://www.dell.com/cdn/assets/csb/configux/bundles/1.0.6.45393/images/harddrive-blk.svg\" style=\"height:20px; width:20px\" /></p>\r\n\r\n	<p>256 GB, M.2 2230, Gen 4 PCIe NVMe SSD, Class 35</p>\r\n	</li>\r\n	<li>\r\n	<p><img alt=\"\" src=\"https://www.dell.com/cdn/assets/csb/configux/bundles/1.0.6.45393/images/ports-blk.svg\" style=\"height:20px; width:20px\" /></p>\r\n	</li>\r\n</ul>',5),(6,'Carbon, Metal','Australia','<h2>PANASONIC TOUGHBOOK FZ-55 MK1</h2>\r\n\r\n<p><strong>Thiết kế m&ocirc;-đun, thời lượng pin vượt trội, hiệu suất cao v&agrave; sự ch&uacute; &yacute; đến từng chi tiết đ&atilde; khiến chiếc m&aacute;y t&iacute;nh x&aacute;ch tay b&aacute;n chắc chắn mới nhất của Panasonic trở th&agrave;nh người chiến thắng</strong></p>\r\n\r\n<p>Panasonic đ&atilde; giới thiệu thế hệ tiếp theo của m&aacute;y t&iacute;nh x&aacute;ch tay d&agrave;nh cho doanh nh&acirc;n b&aacute;n chắc chắn d&agrave;nh cho c&aacute;c chuy&ecirc;n gia di động. Toughbook 55 mới nhấn mạnh v&agrave;o trọng lượng nhẹ, kiểu d&aacute;ng mỏng v&agrave; hiệu suất tuyệt vời nhưng cũng khẳng định thời lượng pin vượt trội v&agrave; thiết kế m&ocirc;-đun mang lại t&iacute;nh linh hoạt v&agrave; khả năng t&ugrave;y biến.</p>\r\n\r\n<p>Panasonic Toughbooks hầu như kh&ocirc;ng cần giới thiệu. Rất &iacute;t m&aacute;y t&iacute;nh c&oacute; lịch sử v&agrave; phả hệ của những chiếc Toughbook chắc chắn c&oacute; một vị tr&iacute; đặc biệt như c&oacute; lẽ l&agrave; những chiếc m&aacute;y t&iacute;nh x&aacute;ch tay chắc chắn phổ biến nhất từng được tạo ra. C&oacute; một d&ograve;ng sản phẩm Toughbook của Panasonic đ&atilde; c&oacute; từ thi&ecirc;n ni&ecirc;n kỷ trước, mỗi chiếc đều tương th&iacute;ch với những chiếc trước đ&oacute;, mỗi chiếc đều tốt hơn chiếc trước đ&oacute;.</p>',6),(7,'Carbon, Metal','Malaysia','<h1>Skytech Gaming Nebula Gaming PC Desktop &ndash; AMD Ryzen 5 3600 3.6 GHz, NVIDIA GTX 1650, 500GB NVME SSD, 16GB DDR4 RAM 3200, 600W Gold PSU, 11AC Wi-Fi, Windows 11 Home 64-bit,Black</h1>',7),(8,'Fabric, Cotton, Feather','America','<p>An authenticated vintage that dates back to 1987-1989, this Chanel full flap bag is an investment piece that will only become more beautiful and valuable with time. An iconic style from the legendary couturier, this black one features all the makings of a classic - gold-plated hardware, soft and supple quilted leather and a goldtone CC logo that accents the front flap.</p>',8),(9,'Fabric, Cotton','America','<ul>\r\n	<li>Christian Dior lace-panelled dress in white, black, coral, rose, and silk</li>\r\n	<li>Lace-Panelled</li>\r\n	<li>Round neck</li>\r\n	<li>Slleveless</li>\r\n	<li>Closes with hook and invisible zipper on the back</li>\r\n	<li>Lined in white silk</li>\r\n</ul>\r\n\r\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Mesurements taken flat</p>\r\n\r\n<ul>\r\n	<li>Tag Size 40</li>\r\n	<li>Bust 45.5cm (17,91&quot;)</li>\r\n	<li>Waist 50.5cm (19,88&quot;)</li>\r\n	<li>Hips 50cm (19,68&quot;)</li>\r\n	<li>Length 93cm (36,61&quot;)</li>\r\n	<li>Hemline&nbsp; 54.5cm (21,45&quot;)</li>\r\n</ul>\r\n\r\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Condition:</p>\r\n\r\n<ul>\r\n	<li>Good</li>\r\n	<li>This item has been professionally cleaned and is odor free. Thoroughly checked over before shipping, it will be ready to wear upon arrival.&nbsp;</li>\r\n	<li>Please note, pre-owned items may show signs of being stored even when unworn and unused. This is reflected within the significantly the reduced price. Pease refer to images, and use the zoom functionn for more detail.</li>\r\n</ul>\r\n\r\n<ul>\r\n	<li>This item has been authenticated by our in-house trained professionals. Dior does not endorse or participate in the La Doyenne Vintage&#39;s authentication process.&nbsp;</li>\r\n	<li>Dior is a registered trademark of Dior. La Doyenne Vintage is neither partnered nor affiliated with Dior.&nbsp;</li>\r\n	<li>Photos are of the actual item in our possession.&nbsp;</li>\r\n</ul>\r\n\r\n<ul>\r\n	<li>Purchasing this item continues its narrative and reduces the environmental impact of using new resources. You can be confident that you&rsquo;re making a better choice for the&nbsp;Planet.</li>\r\n</ul>',9);
/*!40000 ALTER TABLE `ecommerce_productdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_productimage`
--

DROP TABLE IF EXISTS `ecommerce_productimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_productimage` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image` varchar(255) NOT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_productima_product_id_22a19791_fk_eCommerce` (`product_id`),
  CONSTRAINT `eCommerce_productima_product_id_22a19791_fk_eCommerce` FOREIGN KEY (`product_id`) REFERENCES `ecommerce_product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_productimage`
--

LOCK TABLES `ecommerce_productimage` WRITE;
/*!40000 ALTER TABLE `ecommerce_productimage` DISABLE KEYS */;
INSERT INTO `ecommerce_productimage` VALUES (1,'image/upload/v1727494144/fsb0haqh1qcliippranx.png',1),(2,'image/upload/v1727493160/njl43kopyfyeuk6o8pis.png',2),(3,'image/upload/v1727493985/xzia6ktddl2dgqhowmhq.png',3),(4,'image/upload/v1727493692/ware0ynghltgkrp0yt6i.png',4),(5,'image/upload/xdmqyfikkoywmqhme8mo.jpg',5),(6,'image/upload/v1727493304/rpn0snnpkaxpsozb66hm.png',6),(7,'image/upload/v1727493518/dd66qy0kh6u3ftfyacuy.jpg',7),(8,'image/upload/v1727494147/ztqspnapiyiyfmlwcmge.png',1),(9,'image/upload/v1722743653/m5gzpjhhl8xq1agnlyf6.jpg',5),(10,'image/upload/v1722743665/t1rozg8jzipungtecsqx.jpg',5),(11,'image/upload/v1722743685/fvj3jwt9uizoyh0lfq2k.jpg',5),(12,'image/upload/v1722743653/m5gzpjhhl8xq1agnlyf6.jpg',5),(13,'image/upload/v1722758260/ebgo5zqjafj5h1z0668f.jpg',8),(14,'image/upload/v1722758381/ryixikypek7hvuftgnmt.jpg',9),(15,'image/upload/v1722758382/ayupn55ncm1enjn7hlu9.jpg',9),(16,'image/upload/v1722758383/ub1syc7xrvpesxu5xnki.jpg',9),(17,'image/upload/v1727493424/pfbd2xvvwi71yc4y5lly.jpg',7),(18,'image/upload/v1727493767/mwexwqtldgpkqbmqmnyw.png',4),(19,'image/upload/v1727493769/safoqesuhnbse6wcdl4i.png',4),(20,'image/upload/v1727493986/hspcuwztz6bfm2yaytpn.png',3),(21,'image/upload/v1727493988/qjurcgxojjauyfq5o2xa.png',3),(22,'image/upload/v1731400841/sgxfracseud8fl8a1lke.jpg',9);
/*!40000 ALTER TABLE `ecommerce_productimage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_productvideo`
--

DROP TABLE IF EXISTS `ecommerce_productvideo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_productvideo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `video` varchar(255) NOT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_productvid_product_id_f6f9419d_fk_eCommerce` (`product_id`),
  CONSTRAINT `eCommerce_productvid_product_id_f6f9419d_fk_eCommerce` FOREIGN KEY (`product_id`) REFERENCES `ecommerce_product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_productvideo`
--

LOCK TABLES `ecommerce_productvideo` WRITE;
/*!40000 ALTER TABLE `ecommerce_productvideo` DISABLE KEYS */;
INSERT INTO `ecommerce_productvideo` VALUES (1,'video/upload/v1722743684/v48koh4rdxkvdl0b1hid.mp4',1),(2,'video/upload/v1722743684/v48koh4rdxkvdl0b1hid.mp4',3),(3,'video/upload/v1722743684/v48koh4rdxkvdl0b1hid.mp4',7);
/*!40000 ALTER TABLE `ecommerce_productvideo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_rating`
--

DROP TABLE IF EXISTS `ecommerce_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_rating` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `star` int NOT NULL,
  `is_shop` tinyint(1) NOT NULL,
  `order_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_rating_order_id_449d48e1_fk_eCommerce_order_id` (`order_id`),
  KEY `eCommerce_rating_product_id_5a3d0b07_fk_eCommerce_product_id` (`product_id`),
  KEY `eCommerce_rating_user_id_8ecd389a_fk_eCommerce_user_id` (`user_id`),
  CONSTRAINT `eCommerce_rating_order_id_449d48e1_fk_eCommerce_order_id` FOREIGN KEY (`order_id`) REFERENCES `ecommerce_order` (`id`),
  CONSTRAINT `eCommerce_rating_product_id_5a3d0b07_fk_eCommerce_product_id` FOREIGN KEY (`product_id`) REFERENCES `ecommerce_product` (`id`),
  CONSTRAINT `eCommerce_rating_user_id_8ecd389a_fk_eCommerce_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_rating`
--

LOCK TABLES `ecommerce_rating` WRITE;
/*!40000 ALTER TABLE `ecommerce_rating` DISABLE KEYS */;
INSERT INTO `ecommerce_rating` VALUES (4,'2024-09-12 00:20:32.124689','2024-09-12 00:20:32.124689',1,5,1,86,1,25),(5,'2024-09-12 00:20:38.513339','2024-09-12 00:20:38.513339',1,5,0,86,1,25),(6,'2024-09-12 00:21:38.631644','2024-09-12 00:21:38.631644',1,3,0,86,5,25),(15,'2024-09-23 17:09:08.146084','2024-09-23 17:09:08.146084',1,5,0,111,1,25),(17,'2024-10-05 21:58:53.563138','2024-10-05 21:58:53.563138',1,5,1,111,1,25),(18,'2024-10-05 22:00:47.999828','2024-10-05 22:00:47.999828',1,5,0,85,9,25),(19,'2024-10-05 22:00:48.369627','2024-10-05 22:00:48.369627',1,5,1,85,9,25),(20,'2024-10-05 22:01:06.435856','2024-10-05 22:01:06.435856',1,5,0,85,1,25),(21,'2024-10-05 22:01:06.788804','2024-10-05 22:01:06.788804',1,5,1,85,1,25),(22,'2024-10-08 20:27:46.398045','2024-10-08 20:27:46.398045',1,5,0,115,9,26),(23,'2024-10-08 20:27:46.715249','2024-10-08 20:27:46.715249',1,5,1,115,9,26),(24,'2024-10-14 22:28:30.501210','2024-10-14 22:28:30.501210',1,5,0,116,9,26),(25,'2024-10-14 22:28:30.759937','2024-10-14 22:28:30.759937',1,5,1,116,9,26),(26,'2024-10-14 22:28:51.433230','2024-10-14 22:28:51.433230',1,3,0,116,4,26),(27,'2024-10-14 22:28:51.682988','2024-10-14 22:28:51.682988',1,5,1,116,4,26),(28,'2024-10-14 23:41:06.743174','2024-10-14 23:41:06.743174',1,5,0,117,9,25),(29,'2024-10-14 23:41:07.010768','2024-10-14 23:41:07.010768',1,4,1,117,9,25);
/*!40000 ALTER TABLE `ecommerce_rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_shipping`
--

DROP TABLE IF EXISTS `ecommerce_shipping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_shipping` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `name` varchar(50) NOT NULL,
  `fee` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_shipping`
--

LOCK TABLES `ecommerce_shipping` WRITE;
/*!40000 ALTER TABLE `ecommerce_shipping` DISABLE KEYS */;
INSERT INTO `ecommerce_shipping` VALUES (1,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'VN Express',17000),(2,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'GKTK',32000),(3,'2024-06-27 00:00:00.000000','2024-06-27 00:00:00.000000',1,'Ninja',26700),(4,'2024-08-17 15:50:33.398305','2024-08-17 15:50:33.398305',1,'Aloha',86000),(5,'2024-08-17 15:52:13.304336','2024-08-17 15:52:13.304336',1,'Faster',45600);
/*!40000 ALTER TABLE `ecommerce_shipping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_shop`
--

DROP TABLE IF EXISTS `ecommerce_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_shop` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `name` varchar(100) NOT NULL,
  `image` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `following` int NOT NULL,
  `followed` int NOT NULL,
  `user_id` bigint NOT NULL,
  `shop_rating` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `eCommerce_shop_user_id_e644e197_fk_eCommerce_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_shop`
--

LOCK TABLES `ecommerce_shop` WRITE;
/*!40000 ALTER TABLE `ecommerce_shop` DISABLE KEYS */;
INSERT INTO `ecommerce_shop` VALUES (1,'2024-06-27 00:00:00.000000','2024-10-14 22:28:51.690286',1,'Teelab Official','image/upload/v1722758679/wofpbnyxwdhciosmovuv.jpg','<p>Kh&ocirc;ng chỉ l&agrave; thời trang, TEELAB c&ograve;n l&agrave; &ldquo;ph&ograve;ng th&iacute; nghiệm&rdquo; của tuổi trẻ - nơi nghi&ecirc;n cứu v&agrave; cho ra đời nguồn năng lượng mang t&ecirc;n &ldquo;Youth&rdquo;. Ch&uacute;ng m&igrave;nh lu&ocirc;n muốn tạo n&ecirc;n những trải nghiệm vui vẻ, năng động v&agrave; trẻ trung.</p>',0,0,3,5),(2,'2024-06-28 00:00:00.000000','2024-10-14 23:41:07.016072',1,'Channel Official','image/upload/v1722758668/viofmacikvuy6iwj0v6o.jpg','<p>This my my new shop</p>',0,0,2,4.8),(6,'2024-10-14 23:38:27.389918','2024-10-14 23:38:27.389918',1,'Solite','image/upload/https://res.cloudinary.com/dt8k6pijd/image/upload/v1728923578/wzohn9rbyceogzoyzznq.png','<p>This is my new description</p>',0,0,34,0);
/*!40000 ALTER TABLE `ecommerce_shop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_shopconfirmation`
--

DROP TABLE IF EXISTS `ecommerce_shopconfirmation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_shopconfirmation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `citizen_identification_image` varchar(255) NOT NULL,
  `shop_name` varchar(50) NOT NULL,
  `shop_image` varchar(255) NOT NULL,
  `shop_description` longtext NOT NULL,
  `user_id` bigint NOT NULL,
  `status_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_shopconfirmation_user_id_1997b14e_fk_eCommerce_user_id` (`user_id`),
  KEY `eCommerce_shopconfir_status_id_d8448b8b_fk_eCommerce` (`status_id`),
  CONSTRAINT `eCommerce_shopconfir_status_id_d8448b8b_fk_eCommerce` FOREIGN KEY (`status_id`) REFERENCES `ecommerce_shopconfirmationstatus` (`id`),
  CONSTRAINT `eCommerce_shopconfirmation_user_id_1997b14e_fk_eCommerce_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_shopconfirmation`
--

LOCK TABLES `ecommerce_shopconfirmation` WRITE;
/*!40000 ALTER TABLE `ecommerce_shopconfirmation` DISABLE KEYS */;
INSERT INTO `ecommerce_shopconfirmation` VALUES (1,'2024-06-27 00:00:00.000000','2024-10-11 15:41:07.227479',1,'image/upload/v1722758679/wofpbnyxwdhciosmovuv.jpg','Teelab Official','image/upload/v1728636066/lzbf5rqxt6sk6h1fkmzz.jpg','',3,2),(2,'2024-06-28 00:00:00.000000','2024-10-11 15:40:41.312850',1,'image/upload/v1722758668/viofmacikvuy6iwj0v6o.jpg','Channel Official','image/upload/v1728636044/btvlkz6ewq571qfjccxg.jpg','<p>Oke</p>',2,2),(23,'2024-10-14 23:32:59.645633','2024-11-11 21:21:31.876049',1,'image/upload/https://res.cloudinary.com/dt8k6pijd/image/upload/v1728923577/dskkprij0gnl5ta9iwhm.png','Solite','image/upload/https://res.cloudinary.com/dt8k6pijd/image/upload/v1728923578/wzohn9rbyceogzoyzznq.png','<p>This is my new description</p>',34,4);
/*!40000 ALTER TABLE `ecommerce_shopconfirmation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_shopconfirmationstatus`
--

DROP TABLE IF EXISTS `ecommerce_shopconfirmationstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_shopconfirmationstatus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_shopconfirmationstatus`
--

LOCK TABLES `ecommerce_shopconfirmationstatus` WRITE;
/*!40000 ALTER TABLE `ecommerce_shopconfirmationstatus` DISABLE KEYS */;
INSERT INTO `ecommerce_shopconfirmationstatus` VALUES (1,'Approving'),(2,'Successful'),(3,'Providing Additional Information'),(4,'Failed');
/*!40000 ALTER TABLE `ecommerce_shopconfirmationstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_storage`
--

DROP TABLE IF EXISTS `ecommerce_storage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_storage` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `address` varchar(100) NOT NULL,
  `shop_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_storage_shop_id_78debe73_fk_eCommerce_shop_id` (`shop_id`),
  CONSTRAINT `eCommerce_storage_shop_id_78debe73_fk_eCommerce_shop_id` FOREIGN KEY (`shop_id`) REFERENCES `ecommerce_shop` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_storage`
--

LOCK TABLES `ecommerce_storage` WRITE;
/*!40000 ALTER TABLE `ecommerce_storage` DISABLE KEYS */;
INSERT INTO `ecommerce_storage` VALUES (1,'2024-06-30 00:00:00.000000','2024-06-30 00:00:00.000000',1,'77 Ngô Đức Kế',1),(2,'2024-07-01 00:00:00.000000','2024-07-01 00:00:00.000000',1,'516 Phan Văn Trị',1),(3,'2024-08-06 00:00:00.000000','2024-08-06 00:00:00.000000',1,'398 Phan Van Tri, Ward 7, Go Vap District,',2);
/*!40000 ALTER TABLE `ecommerce_storage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_storageproduct`
--

DROP TABLE IF EXISTS `ecommerce_storageproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_storageproduct` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `remain` int NOT NULL,
  `product_id` bigint NOT NULL,
  `product_color_id` bigint DEFAULT NULL,
  `storage_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_storagepro_product_id_15b9602f_fk_eCommerce` (`product_id`),
  KEY `eCommerce_storagepro_storage_id_f99ceecd_fk_eCommerce` (`storage_id`),
  KEY `eCommerce_storagepro_product_color_id_891f0d67_fk_eCommerce` (`product_color_id`),
  CONSTRAINT `eCommerce_storagepro_product_color_id_891f0d67_fk_eCommerce` FOREIGN KEY (`product_color_id`) REFERENCES `ecommerce_productcolor` (`id`),
  CONSTRAINT `eCommerce_storagepro_product_id_15b9602f_fk_eCommerce` FOREIGN KEY (`product_id`) REFERENCES `ecommerce_product` (`id`),
  CONSTRAINT `eCommerce_storagepro_storage_id_f99ceecd_fk_eCommerce` FOREIGN KEY (`storage_id`) REFERENCES `ecommerce_storage` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_storageproduct`
--

LOCK TABLES `ecommerce_storageproduct` WRITE;
/*!40000 ALTER TABLE `ecommerce_storageproduct` DISABLE KEYS */;
INSERT INTO `ecommerce_storageproduct` VALUES (1,200,5,NULL,1),(2,894,1,3,1),(3,97,1,3,2),(4,25,9,NULL,3),(5,996,7,4,3),(6,90,6,5,1),(7,193,4,NULL,1),(8,197,3,NULL,1),(9,59,2,NULL,2);
/*!40000 ALTER TABLE `ecommerce_storageproduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_user`
--

DROP TABLE IF EXISTS `ecommerce_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `avatar` varchar(255) NOT NULL,
  `is_vendor` tinyint(1) NOT NULL,
  `birthday` date DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_user`
--

LOCK TABLES `ecommerce_user` WRITE;
/*!40000 ALTER TABLE `ecommerce_user` DISABLE KEYS */;
INSERT INTO `ecommerce_user` VALUES (1,'pbkdf2_sha256$870000$91SV0zUggAaG1yWtkz9mSo$1+AOJjbyaauxryV5GqP9/X1yJ4zDtIHCr5fc7Q4iUyA=','2024-11-14 14:47:29.945316',1,'admin','','','admin@gmail.com',1,1,'2024-06-27 04:17:47.000000','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(2,'pbkdf2_sha256$870000$cvhnvN84QTBnOaJkwuNQBr$yDa7AyPmA8ZTp05lbPbXG48AYzOeshDua238Dz/n6kk=','2024-10-14 15:20:05.119854',0,'user2','','','',1,1,'2024-06-27 04:21:11.000000','image/upload/v1699349141/cld-sample.jpg',1,NULL,NULL),(3,'pbkdf2_sha256$870000$9QrgW36gLdf5QX09spTav2$0JKWxiYq7oErdtUTAYCAueGW5ZJEu+0M/Gg33t/yLRQ=','2024-11-10 11:17:51.511703',0,'user3','','','',1,1,'2024-06-27 04:21:52.000000','image/upload/v1699349141/cld-sample.jpg',1,NULL,NULL),(4,'pbkdf2_sha256$870000$PlzpAPanPmLUvcmJbaqpR8$rRwWv3S64ZUJSO4BFUH5xXx7LFLnGaqfOOkCY6hJA04=','2024-11-11 21:14:04.056757',0,'staff','','','',1,1,'2024-06-27 04:22:20.000000','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(5,'pbkdf2_sha256$870000$pUvywP9XV2l5MuRkza2BJs$NL+5XsyJ2KIaCDA6G6HZzaQ8vp9XKkF6a1xSHyT/NxQ=',NULL,0,'customer','Huy','John','',0,1,'2024-06-27 07:23:37.000000','image/upload/v1699349141/cld-sample.jpg',0,NULL,'0908804444'),(6,'pbkdf2_sha256$720000$sPWHsfzIv6DyKs6GwOB8Bi$AiXlXNBA4zhHVURgFfOLPwN1W/Ye5WO87Tvj856kNKM=',NULL,0,'customer2','','','',0,1,'2024-07-11 08:05:30.268930','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(7,'pbkdf2_sha256$720000$dsmEkxEAwyM5brxW0CJbqz$WDhQblQOIXh6CD4ZiFRtbHbZw1xkkByIlip9GaYIZrM=',NULL,0,'customer3','','','',0,1,'2024-07-11 09:04:21.684565','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(8,'pbkdf2_sha256$720000$YqJY8bEzxxhgFPHN0AWeoX$mCn5N9HbC0WpD+x+Ww9oqgRBHt5rVoVAF807zMyPOQY=',NULL,0,'tester','','','',0,1,'2024-07-31 10:06:05.715642','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(9,'pbkdf2_sha256$720000$mjfP21a2fDFqwHZcAlIc16$klphSo/1gG5Z6OhKpxnpKilOYMN+qrr2DZbI0lRZ6Es=',NULL,0,'tester2','','','',0,1,'2024-07-31 10:14:49.363778','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(10,'pbkdf2_sha256$720000$mRILahiYYwuBGy4F8p6lNW$2EmG6WX17a+qHgtpSGUF9aBSo4rrVHVaoY+xQJ3SkmQ=',NULL,0,'tester3','','','',0,1,'2024-07-31 10:15:19.704096','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(11,'pbkdf2_sha256$720000$dhewalLNhbBK9GyRkUHy1C$T3rRYMSetYjeeMchsd3Gq+OEJtGcjPGBus3xDBHxgp8=',NULL,0,'tester4','','','',0,1,'2024-07-31 10:17:41.087527','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(12,'pbkdf2_sha256$720000$Fur0xGkct6UUdjUEpAB3Dr$EBvxbPvxiQ3qKz7ee8tPz4MV65fbKSNbBk2sBUwjZCg=',NULL,0,'tester5','','','',0,1,'2024-07-31 13:27:25.059655','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(13,'pbkdf2_sha256$720000$fP6Be8dWH2QFiDFBj06qxs$LydLJC/8btcGhjh5LEkc1XSQcUhPF7shjIy5L8x4hxU=',NULL,0,'tester6','','','',0,1,'2024-07-31 13:29:42.082263','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(14,'pbkdf2_sha256$720000$8aezYGi3X7Z3KZMnK0bdXo$nUoHCqWGTMmJwdpwy1ueVV5tJFch+7ZgYB7j7o+ROKA=',NULL,0,'tester7','','','',0,1,'2024-07-31 13:36:47.160017','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(15,'pbkdf2_sha256$720000$SB2tB0TcLhMX6bOxssWX2f$RfDvkkI8qaZ/FmPMUij5ACa5jeGpucquowt8ypXBRdI=',NULL,0,'tester8','','','',0,1,'2024-07-31 13:44:00.303059','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(16,'pbkdf2_sha256$720000$SE5a1kTtO33TM8hkDRlxzZ$nwg0UVEQOQiohAYodyLPdw3aycw12ux+I4uEye5MfUI=',NULL,0,'tester9','','','',0,1,'2024-07-31 14:04:08.171810','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(17,'pbkdf2_sha256$720000$FvQcl93lCXppXrd8rsx0cy$xSh9pk2W247C1BicbxZotcHHV3p/gXLFBWFZddyXgek=',NULL,0,'tester10','','','',0,1,'2024-07-31 14:20:45.367922','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(18,'pbkdf2_sha256$720000$vLAf9pU0Q6GCwOTlhwERKJ$MbCvexaEudN98SvoxRuPrysclCUIk9NmBkiwSH8ekZs=',NULL,0,'tester20','','','',0,1,'2024-07-31 14:25:53.804559','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(19,'pbkdf2_sha256$720000$5fxhpNYyKjhz3Ccd1xECL0$SLQth3n5jFMDWs2PmytwciEdfnfbU8t+LA4lXu65nLk=',NULL,0,'tester30','','','',0,1,'2024-07-31 14:38:34.988751','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(20,'pbkdf2_sha256$720000$69fRSkICQgwPnNNrjpt4Hw$TlIPZomlYRxsvZ1mWnoNlSCUVlFAevMUj/vuM/3ui44=',NULL,0,'tester40','','','',0,1,'2024-07-31 14:49:02.797726','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(21,'pbkdf2_sha256$720000$RJl2i8wycjfohQJhWdKyt6$4QS7HpuzDglSI7fxVS7AXHvtmAAm2R9CMf3jezG5ujk=',NULL,0,'tester50','','','',0,1,'2024-07-31 14:51:16.550271','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(22,'pbkdf2_sha256$720000$wO9OhiHUQ3WnPt1aYx1rZ6$eN+nZgyuWZd3ksYJFcN0i8zOecZbWxATzvOuTZc/+Xw=',NULL,0,'tester66','','','',0,1,'2024-07-31 14:52:43.000000','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(25,'pbkdf2_sha256$870000$eDCNcHcG6srn9dNpouHFkA$wp6nI/1UmygygnjRIQ3xp0uIaCxBKK72x+Ny0yYAQW8=',NULL,0,'1af6de63b78ec236gf','Huy','Nguyễn Viết','nguyenviethuy2301@gmail.com',0,1,'2024-08-01 07:04:27.000000','image/upload/v1699349141/cld-sample.jpg',0,NULL,'0908804445'),(26,'pbkdf2_sha256$720000$f523VdCa3qPEcs5leEkL2u$TG2/UqwWXetmTHjHAydxL1aK7Zd3ErhJ1aP20pNMo+c=',NULL,0,'a9a8398ed17a56da','Nguyễn Thị Chúc','Linh','linhnguyenthichuc17@gmail.com',0,1,'2024-08-01 07:09:28.335941','image/upload/v1699349141/cld-sample.jpg',0,NULL,NULL),(34,'pbkdf2_sha256$870000$1aUQ4i5mEf9HSOM6tHkp1Y$oekBPNLm7vFaLFpsg1F6fiXOFSzWxtnc9UDys+r0/4g=','2024-11-10 15:09:27.000000',0,'usertest14102024','','','',0,1,'2024-10-14 23:32:06.000000','image/upload/https://res.cloudinary.com/diiopq4yg/image/upload/v1728921553/cld-sample.jpg',0,NULL,NULL);
/*!40000 ALTER TABLE `ecommerce_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_user_groups`
--

DROP TABLE IF EXISTS `ecommerce_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eCommerce_user_groups_user_id_group_id_201897cb_uniq` (`user_id`,`group_id`),
  KEY `eCommerce_user_groups_group_id_f9718a7b_fk_auth_group_id` (`group_id`),
  CONSTRAINT `eCommerce_user_groups_group_id_f9718a7b_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `eCommerce_user_groups_user_id_cc9f4acb_fk_eCommerce_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_user_groups`
--

LOCK TABLES `ecommerce_user_groups` WRITE;
/*!40000 ALTER TABLE `ecommerce_user_groups` DISABLE KEYS */;
INSERT INTO `ecommerce_user_groups` VALUES (7,2,1),(4,3,1),(2,4,2);
/*!40000 ALTER TABLE `ecommerce_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_user_user_permissions`
--

DROP TABLE IF EXISTS `ecommerce_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eCommerce_user_user_perm_user_id_permission_id_890f3861_uniq` (`user_id`,`permission_id`),
  KEY `eCommerce_user_user__permission_id_3152ec54_fk_auth_perm` (`permission_id`),
  CONSTRAINT `eCommerce_user_user__permission_id_3152ec54_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `eCommerce_user_user__user_id_72886fe5_fk_eCommerce` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_user_user_permissions`
--

LOCK TABLES `ecommerce_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `ecommerce_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ecommerce_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_useraddressphone`
--

DROP TABLE IF EXISTS `ecommerce_useraddressphone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_useraddressphone` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `address` varchar(150) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `default` tinyint(1) NOT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `eCommerce_useraddressphone_user_id_c2cd0fa0_fk_eCommerce_user_id` (`user_id`),
  CONSTRAINT `eCommerce_useraddressphone_user_id_c2cd0fa0_fk_eCommerce_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_useraddressphone`
--

LOCK TABLES `ecommerce_useraddressphone` WRITE;
/*!40000 ALTER TABLE `ecommerce_useraddressphone` DISABLE KEYS */;
INSERT INTO `ecommerce_useraddressphone` VALUES (1,'Nguyen Thi Thap','102/1 Binh Gia, District 3, Ho Chi Minh City','0908804444',0,25),(2,'Le Van Luong','86/12 Le Loi, District 3, Ho Chi Minh City','0908804445',0,25),(3,'Luu Chi Hieu','75/10/8 Hai Ba Trung','0123456789',0,25),(4,'Phan Le Phuong Chi','86/12 Le Loi, District 3, Ho Chi Minh City','0908804445',0,25),(5,'Phan Chi Thanh','456 Ba Hat','0148856256',1,25),(6,'Cao Thai Son','156 Phan Dinh Phung','0117823667',0,25),(7,'Phan Anh 2','86/12 Le Loi, District 3, Ho Chi Minh City','0908804445',0,25),(8,'Le Duc Nam','75 Hoang Hoa Tham','0090909909',0,25),(9,'Le Viet Tuan','97 Ho Tung Mau','0979466046',0,25),(10,'Mai Chi Tho','75 Ba Trieu','0789565665',0,25),(11,'Phan Dinh Phung','86/12 Le Loi, District 3, Ho Chi Minh City','0908804445',0,25),(12,'Le Thanh Trung','78 Ham Tu','0499888998',0,25),(13,'Ho Bao Khang','78 Do Chieu','0795655566',1,5),(14,'Le Thi Cam Tu','372 Phan Van Tri, Quan Go Vap, Ho Chi Minh','0909325672',1,26);
/*!40000 ALTER TABLE `ecommerce_useraddressphone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_voucher`
--

DROP TABLE IF EXISTS `ecommerce_voucher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_voucher` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `start_date` datetime(6) NOT NULL,
  `end_date` datetime(6) NOT NULL,
  `voucher_type_id` bigint NOT NULL,
  `is_multiple` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `eCommerce_voucher_voucher_type_id_a305f9d5_fk_eCommerce` (`voucher_type_id`),
  CONSTRAINT `eCommerce_voucher_voucher_type_id_a305f9d5_fk_eCommerce` FOREIGN KEY (`voucher_type_id`) REFERENCES `ecommerce_vouchertype` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_voucher`
--

LOCK TABLES `ecommerce_voucher` WRITE;
/*!40000 ALTER TABLE `ecommerce_voucher` DISABLE KEYS */;
INSERT INTO `ecommerce_voucher` VALUES (1,'2024-08-18 04:50:52.458487','2024-10-14 15:18:54.532295',1,'Teelab Voucher','i98hvj0qu4','2024-10-14 00:00:00.000000','2024-10-14 23:59:59.000000',5,0),(2,'2024-08-18 19:23:13.407277','2024-10-14 15:19:33.094518',1,'Daily Discount 10000','1r9yegdx70','2024-10-14 00:00:00.000000','2024-10-14 23:59:59.000000',1,1);
/*!40000 ALTER TABLE `ecommerce_voucher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_voucher_voucher_conditions`
--

DROP TABLE IF EXISTS `ecommerce_voucher_voucher_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_voucher_voucher_conditions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `voucher_id` bigint NOT NULL,
  `vouchercondition_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eCommerce_voucher_vouche_voucher_id_vouchercondit_7a586e04_uniq` (`voucher_id`,`vouchercondition_id`),
  KEY `eCommerce_voucher_vo_vouchercondition_id_ed2fdc30_fk_eCommerce` (`vouchercondition_id`),
  CONSTRAINT `eCommerce_voucher_vo_voucher_id_8792c662_fk_eCommerce` FOREIGN KEY (`voucher_id`) REFERENCES `ecommerce_voucher` (`id`),
  CONSTRAINT `eCommerce_voucher_vo_vouchercondition_id_ed2fdc30_fk_eCommerce` FOREIGN KEY (`vouchercondition_id`) REFERENCES `ecommerce_vouchercondition` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_voucher_voucher_conditions`
--

LOCK TABLES `ecommerce_voucher_voucher_conditions` WRITE;
/*!40000 ALTER TABLE `ecommerce_voucher_voucher_conditions` DISABLE KEYS */;
INSERT INTO `ecommerce_voucher_voucher_conditions` VALUES (1,1,4),(2,1,5),(3,1,6),(4,2,3);
/*!40000 ALTER TABLE `ecommerce_voucher_voucher_conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_vouchercondition`
--

DROP TABLE IF EXISTS `ecommerce_vouchercondition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_vouchercondition` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `min_order_amount` double DEFAULT NULL,
  `remain` int DEFAULT NULL,
  `discount` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_vouchercondition`
--

LOCK TABLES `ecommerce_vouchercondition` WRITE;
/*!40000 ALTER TABLE `ecommerce_vouchercondition` DISABLE KEYS */;
INSERT INTO `ecommerce_vouchercondition` VALUES (3,10000,3941,10000),(4,500000,34629,10000),(5,1000000,0,50000),(6,5000000,0,500000);
/*!40000 ALTER TABLE `ecommerce_vouchercondition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_vouchercondition_categories`
--

DROP TABLE IF EXISTS `ecommerce_vouchercondition_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_vouchercondition_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vouchercondition_id` bigint NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eCommerce_voucherconditi_vouchercondition_id_cate_a36ce89b_uniq` (`vouchercondition_id`,`category_id`),
  KEY `eCommerce_vouchercon_category_id_02df94ce_fk_eCommerce` (`category_id`),
  CONSTRAINT `eCommerce_vouchercon_category_id_02df94ce_fk_eCommerce` FOREIGN KEY (`category_id`) REFERENCES `ecommerce_category` (`id`),
  CONSTRAINT `eCommerce_vouchercon_vouchercondition_id_3bbe9aac_fk_eCommerce` FOREIGN KEY (`vouchercondition_id`) REFERENCES `ecommerce_vouchercondition` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_vouchercondition_categories`
--

LOCK TABLES `ecommerce_vouchercondition_categories` WRITE;
/*!40000 ALTER TABLE `ecommerce_vouchercondition_categories` DISABLE KEYS */;
INSERT INTO `ecommerce_vouchercondition_categories` VALUES (9,3,1),(10,3,2),(14,3,3),(12,3,4);
/*!40000 ALTER TABLE `ecommerce_vouchercondition_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_vouchercondition_payment_methods`
--

DROP TABLE IF EXISTS `ecommerce_vouchercondition_payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_vouchercondition_payment_methods` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vouchercondition_id` bigint NOT NULL,
  `paymentmethod_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eCommerce_voucherconditi_vouchercondition_id_paym_37d42885_uniq` (`vouchercondition_id`,`paymentmethod_id`),
  KEY `eCommerce_vouchercon_paymentmethod_id_be5e4500_fk_eCommerce` (`paymentmethod_id`),
  CONSTRAINT `eCommerce_vouchercon_paymentmethod_id_be5e4500_fk_eCommerce` FOREIGN KEY (`paymentmethod_id`) REFERENCES `ecommerce_paymentmethod` (`id`),
  CONSTRAINT `eCommerce_vouchercon_vouchercondition_id_9b4ba347_fk_eCommerce` FOREIGN KEY (`vouchercondition_id`) REFERENCES `ecommerce_vouchercondition` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_vouchercondition_payment_methods`
--

LOCK TABLES `ecommerce_vouchercondition_payment_methods` WRITE;
/*!40000 ALTER TABLE `ecommerce_vouchercondition_payment_methods` DISABLE KEYS */;
INSERT INTO `ecommerce_vouchercondition_payment_methods` VALUES (9,3,1),(10,3,2),(25,3,3),(26,3,4),(13,4,1),(14,4,2),(15,4,3),(16,4,4),(17,5,1),(18,5,2),(19,5,3),(20,5,4),(21,6,1),(22,6,2),(23,6,3),(24,6,4);
/*!40000 ALTER TABLE `ecommerce_vouchercondition_payment_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_vouchercondition_products`
--

DROP TABLE IF EXISTS `ecommerce_vouchercondition_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_vouchercondition_products` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vouchercondition_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eCommerce_voucherconditi_vouchercondition_id_prod_672c047d_uniq` (`vouchercondition_id`,`product_id`),
  KEY `eCommerce_vouchercon_product_id_e5c100ac_fk_eCommerce` (`product_id`),
  CONSTRAINT `eCommerce_vouchercon_product_id_e5c100ac_fk_eCommerce` FOREIGN KEY (`product_id`) REFERENCES `ecommerce_product` (`id`),
  CONSTRAINT `eCommerce_vouchercon_vouchercondition_id_90043518_fk_eCommerce` FOREIGN KEY (`vouchercondition_id`) REFERENCES `ecommerce_vouchercondition` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_vouchercondition_products`
--

LOCK TABLES `ecommerce_vouchercondition_products` WRITE;
/*!40000 ALTER TABLE `ecommerce_vouchercondition_products` DISABLE KEYS */;
INSERT INTO `ecommerce_vouchercondition_products` VALUES (1,4,1),(2,4,2),(3,4,3),(4,4,4),(5,4,5),(6,4,6),(7,5,1),(8,5,2),(9,5,3),(10,5,4),(11,5,5),(12,5,6),(13,6,1),(14,6,2),(15,6,3),(16,6,4),(17,6,5),(18,6,6);
/*!40000 ALTER TABLE `ecommerce_vouchercondition_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_vouchercondition_shippings`
--

DROP TABLE IF EXISTS `ecommerce_vouchercondition_shippings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_vouchercondition_shippings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vouchercondition_id` bigint NOT NULL,
  `shipping_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eCommerce_voucherconditi_vouchercondition_id_ship_640a0d2b_uniq` (`vouchercondition_id`,`shipping_id`),
  KEY `eCommerce_vouchercon_shipping_id_97b0d800_fk_eCommerce` (`shipping_id`),
  CONSTRAINT `eCommerce_vouchercon_shipping_id_97b0d800_fk_eCommerce` FOREIGN KEY (`shipping_id`) REFERENCES `ecommerce_shipping` (`id`),
  CONSTRAINT `eCommerce_vouchercon_vouchercondition_id_41d87e95_fk_eCommerce` FOREIGN KEY (`vouchercondition_id`) REFERENCES `ecommerce_vouchercondition` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_vouchercondition_shippings`
--

LOCK TABLES `ecommerce_vouchercondition_shippings` WRITE;
/*!40000 ALTER TABLE `ecommerce_vouchercondition_shippings` DISABLE KEYS */;
INSERT INTO `ecommerce_vouchercondition_shippings` VALUES (11,3,1),(31,3,2),(32,3,3),(33,3,4),(34,3,5),(16,4,1),(17,4,2),(18,4,3),(19,4,4),(20,4,5),(21,5,1),(22,5,2),(23,5,3),(24,5,4),(25,5,5),(26,6,1),(27,6,2),(28,6,3),(29,6,4),(30,6,5);
/*!40000 ALTER TABLE `ecommerce_vouchercondition_shippings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecommerce_vouchertype`
--

DROP TABLE IF EXISTS `ecommerce_vouchertype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecommerce_vouchertype` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecommerce_vouchertype`
--

LOCK TABLES `ecommerce_vouchertype` WRITE;
/*!40000 ALTER TABLE `ecommerce_vouchertype` DISABLE KEYS */;
INSERT INTO `ecommerce_vouchertype` VALUES (1,'All Shops'),(4,'Assigned Products'),(6,'Live'),(2,'New User'),(5,'Private'),(3,'Repurchased User'),(7,'Video');
/*!40000 ALTER TABLE `ecommerce_vouchertype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_accesstoken`
--

DROP TABLE IF EXISTS `oauth2_provider_accesstoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth2_provider_accesstoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `expires` datetime(6) NOT NULL,
  `scope` longtext NOT NULL,
  `application_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `source_refresh_token_id` bigint DEFAULT NULL,
  `id_token_id` bigint DEFAULT NULL,
  `token_checksum` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `oauth2_provider_accesstoken_token_checksum_85319a26_uniq` (`token_checksum`),
  UNIQUE KEY `source_refresh_token_id` (`source_refresh_token_id`),
  UNIQUE KEY `id_token_id` (`id_token_id`),
  KEY `oauth2_provider_acce_application_id_b22886e1_fk_oauth2_pr` (`application_id`),
  KEY `oauth2_provider_acce_user_id_6e4c9a65_fk_eCommerce` (`user_id`),
  CONSTRAINT `oauth2_provider_acce_application_id_b22886e1_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`),
  CONSTRAINT `oauth2_provider_acce_id_token_id_85db651b_fk_oauth2_pr` FOREIGN KEY (`id_token_id`) REFERENCES `oauth2_provider_idtoken` (`id`),
  CONSTRAINT `oauth2_provider_acce_source_refresh_token_e66fbc72_fk_oauth2_pr` FOREIGN KEY (`source_refresh_token_id`) REFERENCES `oauth2_provider_refreshtoken` (`id`),
  CONSTRAINT `oauth2_provider_acce_user_id_6e4c9a65_fk_eCommerce` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_accesstoken`
--

LOCK TABLES `oauth2_provider_accesstoken` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_accesstoken` DISABLE KEYS */;
INSERT INTO `oauth2_provider_accesstoken` VALUES (1,'8a3PNThuPuLyrH2lcDlZWWsgKZPmLn','2024-10-19 19:11:22.998572','read write',1,3,'2024-06-27 04:30:33.663926','2024-10-19 18:11:22.999571',NULL,NULL,'28d31e782ab5a344e910745052bcac5bbfd1ff77705b2df488363cceafd343eb'),(2,'bf5Zpc7HsZvXct82HcVDixEuXoPq7r','2024-10-09 21:27:35.874806','read write',1,5,'2024-06-27 14:30:37.965890','2024-10-09 20:27:35.874806',NULL,NULL,'a544f6a3431a8055c1ec40241d9d2ea8b4e6529323d00f8b590fb0dbf275dc09'),(3,'stGFRDp7Jp939auM1uG6kuwQaupA4l','2024-06-28 12:09:58.496069','read write',1,5,'2024-06-28 02:09:58.497065','2024-06-28 02:09:58.497065',NULL,NULL,'5c24789069e28e7725754116cc0c9ab0aebebdb97e8eec329405a2bdfd8dedd6'),(4,'jhFdRY6kG5NrT7KRoEleOF0vylXVNg','2024-06-28 13:25:58.982643','read write',1,5,'2024-06-28 03:25:58.984378','2024-06-28 03:25:58.984378',NULL,NULL,'ce93e34c0d8552be0430228fb62e0e37f1f4f00e2a442d364b1573cabfbbb108'),(5,'udWvnDFh1T0nY88MyGda80RoBWHWKk','2024-06-28 16:08:11.115411','read write',1,3,'2024-06-28 06:08:11.117667','2024-06-28 06:08:11.117667',NULL,NULL,'32fdaaf3896e503dae8112ff4820d6e7c17c415d948a2e2715c9d050820b55e2'),(6,'wKUWMGDZN0CCkgKSz848qhsEqkzKw4','2024-10-15 00:43:10.092656','read write',1,2,'2024-06-28 06:10:58.832692','2024-10-14 23:43:10.092656',NULL,NULL,'9e032366c2e8e337383f332d493d0acb4d20ec4160929d31b9a3fbddc8e5f390'),(7,'LhmhnnJ8maRKDjbe7s4odPXtTsGBXK','2024-06-30 19:27:08.772291','read write',1,5,'2024-06-30 09:27:08.773290','2024-06-30 09:27:08.773290',NULL,NULL,'8173f4bfb3150dd5f40ba0b70e53fbbd874a8d0cbe93ea19a1283a64ba338eff'),(8,'zHSI7FAGpAirzaoDaF30QlrnujHnzv','2024-07-01 17:21:54.117087','read write',1,5,'2024-07-01 07:21:54.118099','2024-07-01 07:21:54.118099',NULL,NULL,'2f229f95ce0fe10acb289609aecb1ea516858358b920e93afd45a9fdb9170446'),(9,'MGF6LDWWNI2IJj2As8zhApSsaDQsex','2024-07-02 12:43:23.463279','read write',1,5,'2024-07-02 02:43:23.464291','2024-07-02 02:43:23.464291',NULL,NULL,'3a174bb73dabbed9948cb333278bcf79605c4453cc05056ceb70372b2975b95a'),(10,'rishnmzoSAepTpyV35tcoJJiOTbS7U','2024-07-03 14:54:11.914948','read write',1,5,'2024-07-03 04:54:11.916071','2024-07-03 04:54:11.916071',NULL,NULL,'f10719de252ccb71e1a4a081ea34a2577e59cdc7934d9406cd850304b450d0f5'),(11,'TMxsPJuz3v7xYeQYY8dXmBmUEtqhZ4','2024-07-11 10:04:06.264227','read write',1,6,'2024-07-04 01:28:10.280296','2024-07-11 09:04:06.264227',NULL,NULL,'6173cad055d0cf10de064ffc04677edded7ec92861aa078e90a0f00ffc2cb8a6'),(12,'8y3WFtQsSyuf6UNKI5EFWoa5LSUQOD','2024-07-04 12:55:50.687315','read write',1,3,'2024-07-04 02:55:50.688319','2024-07-04 02:55:50.688319',NULL,NULL,'0d3712734c6bab48c0b14c8dc6751f83d30f1a5ab472cf031413753d4e781ed4'),(13,'ju2rypjZteZYJ3sJZeFFsOJjmitwtQ','2024-07-11 16:42:34.212342','read write',1,5,'2024-07-11 06:42:34.212342','2024-07-11 06:42:34.212342',NULL,NULL,'1b4e6228c99b7d0b827c5072372956defbbb08c121db5b82d3c4c5b66711f7ac'),(14,'k5IoLBTIGp7EGtTKJUoWltusNHef5q','2024-08-08 09:32:14.552969','read write',1,7,'2024-07-11 09:04:23.354598','2024-08-08 08:32:14.554003',NULL,NULL,'4e550c80a3ba4377b4eafd6257c90d1f95014156c235ad0985305a7591f0c3e9'),(15,'WPzrXTS9VWPREbbkcS8yJduHjGK6Tp','2024-07-31 20:06:06.780367','read write',1,8,'2024-07-31 10:06:06.781367','2024-07-31 10:06:06.781367',NULL,NULL,'4417523911fe652e56ef34b245e7a3b61c3012de971fd80ea73481c3f0a22ded'),(16,'BkajOgOrpy7puTE5y4SNLbNxU3K3GT','2024-07-31 20:14:50.348334','read write',1,9,'2024-07-31 10:14:50.348334','2024-07-31 10:14:50.348334',NULL,NULL,'6ad39a2a5094d76b722edd3bc2dad6295fde428c4b5b8413f3aa092b1d10eb2a'),(17,'4qiIuCym5ZTbpMFvBFRp2uA0x2lZT6','2024-07-31 20:15:20.639654','read write',1,10,'2024-07-31 10:15:20.640650','2024-07-31 10:15:20.640650',NULL,NULL,'1b128cca458ba92f49143db76c84bc0f82b26534a22380dcb22c52e8dc520745'),(18,'iENQ9IMNS5ICvA150vpB6UzsATUVnW','2024-07-31 20:17:42.044524','read write',1,11,'2024-07-31 10:17:42.045527','2024-07-31 10:17:42.045527',NULL,NULL,'618bae88dc1e0aa1edd69a85092775fe2e9aece251979ab163bd48c1ea445128'),(19,'kwyPDb1QYk8K1ohA5CoJuTsAHnWoIp','2024-07-31 23:27:27.050505','read write',1,12,'2024-07-31 13:27:27.050505','2024-07-31 13:27:27.050505',NULL,NULL,'98fca6b8d5246633eb87da3b63214f94a7026bf6d749f4aba5be1742e41d96e8'),(20,'FXMcur4qymH7RqyrNIATo6fPBGWNop','2024-07-31 23:29:44.069345','read write',1,13,'2024-07-31 13:29:44.069345','2024-07-31 13:29:44.069345',NULL,NULL,'b48a7fb611492a86617d1bc58ee4c18a540ddb543e6c5ca5ff3ad097aa01ab8c'),(21,'Bdq1Erew2haWEBA17miWiENQPZ042T','2024-07-31 23:36:49.196218','read write',1,14,'2024-07-31 13:36:49.196729','2024-07-31 13:36:49.196729',NULL,NULL,'5a824d398beb09512ef468dcfe2007291780e22d16383462172ffe2ae9b47eee'),(22,'0wOQ38geZqWrcy0z9sFILowrcgqrFX','2024-07-31 23:44:01.957095','read write',1,15,'2024-07-31 13:44:01.958321','2024-07-31 13:44:01.958321',NULL,NULL,'b392181b4476e5815871a19accd3c81655ea15c445089be4806d434ad20a311a'),(23,'T1jn7hSO9JPkoqikXtnzFooYzxoTFg','2024-08-01 00:04:09.490022','read write',1,16,'2024-07-31 14:04:09.490022','2024-07-31 14:04:09.490022',NULL,NULL,'66a33a0e68d59e56d8626fd037b72b53d934ab2b70bfeb41fba0810c2b408cb2'),(24,'Gkm1qvEuXcO5NHfWxoDTuRYlDUxd6f','2024-08-01 00:20:47.152461','read write',1,17,'2024-07-31 14:20:47.152461','2024-07-31 14:20:47.152461',NULL,NULL,'49629ea2119dacf0710a02cfc97c819fc7712cfb8136d080bdc44b923c5443c5'),(25,'kzVuzGctt5FmNGm1v4oeU5HvULAtYL','2024-08-01 00:25:55.582985','read write',1,18,'2024-07-31 14:25:55.583495','2024-07-31 14:25:55.583495',NULL,NULL,'58929cfd01297f6f934f22e2bee0767a79b78e0decd163080397bf57a7c61b6a'),(26,'vkCUCz6sSuNzjeAIrjSSnMYxaI3LMG','2024-08-01 00:38:36.693988','read write',1,19,'2024-07-31 14:38:36.693988','2024-07-31 14:38:36.693988',NULL,NULL,'42d98c24fc6246e1f0339204737187b109789a3ca9045b17e386c315d09d9963'),(27,'5KHdNAKUh0w8NZlub7fVKlKWj6uJsX','2024-08-01 00:49:04.022550','read write',1,20,'2024-07-31 14:49:04.022550','2024-07-31 14:49:04.022550',NULL,NULL,'c9bcac647bd3347c6c94ee6bf0e44e68caea223218f56b4acf660d7cc9c80270'),(28,'qvycJZdrOiFlGu9hBPmtKdKCr3pLft','2024-08-01 00:51:17.908254','read write',1,21,'2024-07-31 14:51:17.909261','2024-07-31 14:51:17.909261',NULL,NULL,'7911539c255ef81b67cd23597cbd0be5047fc201272812ae21c38349b62a747f'),(29,'Fa8QUIZipzI8DF0P9N8SQtXJin6b7v','2024-08-01 00:52:44.668190','read write',1,22,'2024-07-31 14:52:44.669190','2024-07-31 14:52:44.669190',NULL,NULL,'5771803f35f31b507e04564b3c6a7adfcbd92373400ba1929a6b41b0ce93e9ae'),(31,'05GcaPRaRSZijok4BfJdIB703IWmv3','2024-11-11 22:05:29.696000','read write',1,25,'2024-08-01 07:04:29.035471','2024-11-11 21:05:29.696000',NULL,NULL,'bc593a6a0c52a181332367f33e041bacc41f2597ae7a2516b561162782ab9843'),(32,'N2GVhdS4hPrOjUbvU0itFyXS14LuXV','2024-10-15 00:33:08.483353','read write',1,26,'2024-08-01 07:09:29.352957','2024-10-14 23:33:08.483353',NULL,NULL,'800bfab21f66744d392b239bacfa1ec02e808e1fa765eb58d6143cde19db23b2'),(40,'PIZ1fZA1p5OGOdD5YeCzj6auLmnugT','2024-10-15 09:32:08.156379','read write',1,34,'2024-10-14 23:32:08.157474','2024-10-14 23:32:08.157474',NULL,NULL,'f68e11e66453c93cc0b1f053cad044f85a5adb78d58408e6d5fc1faf5402747d');
/*!40000 ALTER TABLE `oauth2_provider_accesstoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_application`
--

DROP TABLE IF EXISTS `oauth2_provider_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth2_provider_application` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `client_id` varchar(100) NOT NULL,
  `redirect_uris` longtext NOT NULL,
  `client_type` varchar(32) NOT NULL,
  `authorization_grant_type` varchar(32) NOT NULL,
  `client_secret` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `skip_authorization` tinyint(1) NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `algorithm` varchar(5) NOT NULL,
  `post_logout_redirect_uris` longtext NOT NULL DEFAULT (_utf8mb3''),
  `hash_client_secret` tinyint(1) NOT NULL,
  `allowed_origins` longtext NOT NULL DEFAULT (_utf8mb3''),
  PRIMARY KEY (`id`),
  UNIQUE KEY `client_id` (`client_id`),
  KEY `oauth2_provider_appl_user_id_79829054_fk_eCommerce` (`user_id`),
  KEY `oauth2_provider_application_client_secret_53133678` (`client_secret`),
  CONSTRAINT `oauth2_provider_appl_user_id_79829054_fk_eCommerce` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_application`
--

LOCK TABLES `oauth2_provider_application` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_application` DISABLE KEYS */;
INSERT INTO `oauth2_provider_application` VALUES (1,'MkRKruOGiovJ6aSyoyx8I0OIHpQlNQ8YzX19sMk6','','confidential','password','pbkdf2_sha256$720000$NZrBPylJ2odQNdWHEdXQJ9$n58NzNysZkV8Xxn6GSYlwYHTPKKLFCRHnMML2AM6+sE=','eCommerceApp',1,0,'2024-06-27 04:30:18.996210','2024-06-27 04:30:18.996210','','',1,'');
/*!40000 ALTER TABLE `oauth2_provider_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_grant`
--

DROP TABLE IF EXISTS `oauth2_provider_grant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth2_provider_grant` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `expires` datetime(6) NOT NULL,
  `redirect_uri` longtext NOT NULL,
  `scope` longtext NOT NULL,
  `application_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `code_challenge` varchar(128) NOT NULL,
  `code_challenge_method` varchar(10) NOT NULL,
  `nonce` varchar(255) NOT NULL,
  `claims` longtext NOT NULL DEFAULT (_utf8mb3''),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `oauth2_provider_gran_application_id_81923564_fk_oauth2_pr` (`application_id`),
  KEY `oauth2_provider_grant_user_id_e8f62af8_fk_eCommerce_user_id` (`user_id`),
  CONSTRAINT `oauth2_provider_gran_application_id_81923564_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`),
  CONSTRAINT `oauth2_provider_grant_user_id_e8f62af8_fk_eCommerce_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_grant`
--

LOCK TABLES `oauth2_provider_grant` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_grant` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_grant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_idtoken`
--

DROP TABLE IF EXISTS `oauth2_provider_idtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth2_provider_idtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `jti` char(32) NOT NULL,
  `expires` datetime(6) NOT NULL,
  `scope` longtext NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `application_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `jti` (`jti`),
  KEY `oauth2_provider_idto_application_id_08c5ff4f_fk_oauth2_pr` (`application_id`),
  KEY `oauth2_provider_idtoken_user_id_dd512b59_fk_eCommerce_user_id` (`user_id`),
  CONSTRAINT `oauth2_provider_idto_application_id_08c5ff4f_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`),
  CONSTRAINT `oauth2_provider_idtoken_user_id_dd512b59_fk_eCommerce_user_id` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_idtoken`
--

LOCK TABLES `oauth2_provider_idtoken` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_idtoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_idtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_refreshtoken`
--

DROP TABLE IF EXISTS `oauth2_provider_refreshtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth2_provider_refreshtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `access_token_id` bigint DEFAULT NULL,
  `application_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `revoked` datetime(6) DEFAULT NULL,
  `token_family` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `access_token_id` (`access_token_id`),
  UNIQUE KEY `oauth2_provider_refreshtoken_token_revoked_af8a5134_uniq` (`token`,`revoked`),
  KEY `oauth2_provider_refr_application_id_2d1c311b_fk_oauth2_pr` (`application_id`),
  KEY `oauth2_provider_refr_user_id_da837fce_fk_eCommerce` (`user_id`),
  CONSTRAINT `oauth2_provider_refr_access_token_id_775e84e8_fk_oauth2_pr` FOREIGN KEY (`access_token_id`) REFERENCES `oauth2_provider_accesstoken` (`id`),
  CONSTRAINT `oauth2_provider_refr_application_id_2d1c311b_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`),
  CONSTRAINT `oauth2_provider_refr_user_id_da837fce_fk_eCommerce` FOREIGN KEY (`user_id`) REFERENCES `ecommerce_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_refreshtoken`
--

LOCK TABLES `oauth2_provider_refreshtoken` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_refreshtoken` DISABLE KEYS */;
INSERT INTO `oauth2_provider_refreshtoken` VALUES (1,'pDqL6fdkpDUfq71GXMNuA1uA21xv7v',1,1,3,'2024-06-27 04:30:33.666740','2024-06-27 04:30:33.666740',NULL,NULL),(2,'MVP3VKPCZxqGzGLrQlAIuXA3nb7J4U',2,1,5,'2024-06-27 14:30:37.983324','2024-06-27 14:30:37.983324',NULL,NULL),(3,'LDZgvhJwz1wYSCpjGk2pV4ZAzMW00U',3,1,5,'2024-06-28 02:09:58.515265','2024-06-28 02:09:58.515265',NULL,NULL),(4,'nKXCGGHKJpI6GbxtALTDbklibzpEUi',4,1,5,'2024-06-28 03:25:58.985387','2024-06-28 03:25:58.985387',NULL,NULL),(5,'oJVOYVLAwERN3TlBIHIs8YL43xXktr',5,1,3,'2024-06-28 06:08:11.121593','2024-06-28 06:08:11.121593',NULL,NULL),(6,'PmZJipMHhKDGqWHctaD4EhENUh8ACP',6,1,2,'2024-06-28 06:10:58.834689','2024-06-28 06:10:58.834689',NULL,NULL),(7,'KER5t2jE7SRYlbjnQeyRCYtUBye8Dg',7,1,5,'2024-06-30 09:27:08.781468','2024-06-30 09:27:08.781468',NULL,NULL),(8,'Gw3jyxyV2DKtF3gWacr14L1dEDrnAK',8,1,5,'2024-07-01 07:21:54.121099','2024-07-01 07:21:54.121099',NULL,NULL),(9,'JaHEmnhL2tuMJIpwqEvWEkRb8R6InN',9,1,5,'2024-07-02 02:43:23.467069','2024-07-02 02:43:23.467069',NULL,NULL),(10,'vRPBF60f9Z1yer33ThW6Pf0bCpHa7x',10,1,5,'2024-07-03 04:54:11.917258','2024-07-03 04:54:11.917258',NULL,NULL),(11,'VF4n9YCyk6xcWft9UsclIbr4GzSkAJ',11,1,6,'2024-07-04 01:28:10.291832','2024-07-11 09:03:44.829437','2024-07-09 09:03:42.000000',NULL),(12,'UIwqFsuUxEIxX5XmnwPZIPzSt1BaOD',12,1,3,'2024-07-04 02:55:50.690318','2024-07-04 02:55:50.690318',NULL,NULL),(13,'5uyIEYow3onvKjGuy90fJcs3WDgoLZ',13,1,5,'2024-07-11 06:42:34.253142','2024-07-11 06:42:34.253142',NULL,NULL),(14,'mXKu9pnGG7qVFUd4peIHJZLetO4iDm',14,1,7,'2024-07-11 09:04:23.359599','2024-07-11 09:04:23.359599',NULL,NULL),(15,'bSuubOhTCx5sI9rrkOuusPHJZK0e9F',15,1,8,'2024-07-31 10:06:06.813626','2024-07-31 10:06:06.813626',NULL,NULL),(16,'2yjYYypCG24Sh3ol0ovpolit8V2fbX',16,1,9,'2024-07-31 10:14:50.358188','2024-07-31 10:14:50.358188',NULL,NULL),(17,'EKnTxkA8mZjkY67MjSIWVyXzXcRnk9',17,1,10,'2024-07-31 10:15:20.642155','2024-07-31 10:15:20.642155',NULL,NULL),(18,'wpN9kay7hL4OJxOZ2xnhjgek0zkvWR',18,1,11,'2024-07-31 10:17:42.048580','2024-07-31 10:17:42.048580',NULL,NULL),(19,'l2Kic6Ub1qJ3z4LP3PReGb7Bj38bIW',19,1,12,'2024-07-31 13:27:27.056511','2024-07-31 13:27:27.056511',NULL,NULL),(20,'wvSJN9sORONHt6kZB8MVNeRtZEBEXj',20,1,13,'2024-07-31 13:29:44.086476','2024-07-31 13:29:44.086476',NULL,NULL),(21,'paCT1YHVT5Sy0ii5A5nx1zYn6phMtC',21,1,14,'2024-07-31 13:36:49.199870','2024-07-31 13:36:49.199870',NULL,NULL),(22,'VKHqXD1uVdHUhJHilXTvsORfUyI6OA',22,1,15,'2024-07-31 13:44:01.960485','2024-07-31 13:44:01.960485',NULL,NULL),(23,'BntDfXxwZhWYsy7OwLoXgDhJXM4UGX',23,1,16,'2024-07-31 14:04:09.492353','2024-07-31 14:04:09.492353',NULL,NULL),(24,'n82ioFS79RwyRGbFyre6XNWpxroYl0',24,1,17,'2024-07-31 14:20:47.154731','2024-07-31 14:20:47.154731',NULL,NULL),(25,'RY2jz2Th3m09oA5r5pCvjgDrdsRmiV',25,1,18,'2024-07-31 14:25:55.585529','2024-07-31 14:25:55.585529',NULL,NULL),(26,'WCeXOmJyaONIt1q1iGpYXvrxY2ktNZ',26,1,19,'2024-07-31 14:38:36.709892','2024-07-31 14:38:36.709892',NULL,NULL),(27,'OspuutHOulsL06NBF4rA5ARFlMVfbX',27,1,20,'2024-07-31 14:49:04.024521','2024-07-31 14:49:04.024521',NULL,NULL),(28,'Sx4YDK1EDlIUoahv4uNEFR4OCWc5em',28,1,21,'2024-07-31 14:51:17.911564','2024-07-31 14:51:17.911564',NULL,NULL),(29,'Sz1lEGRU7dIv3HqbPvJY9YDZtNLfAj',29,1,22,'2024-07-31 14:52:44.670190','2024-07-31 14:52:44.670190',NULL,NULL),(31,'fBrnOb7Atp5qw4VrZpQDnDfhvopu2s',31,1,25,'2024-08-01 07:04:29.039979','2024-08-01 07:04:29.039979',NULL,NULL),(32,'wRrUvSrEP1F4JSnMLGo8YYwXW7j2AW',32,1,26,'2024-08-01 07:09:29.355503','2024-08-01 07:09:29.355503',NULL,NULL),(40,'eSPr7xKTdGb2yeKqm5CWYRwK8FB6jy',40,1,34,'2024-10-14 23:32:08.159683','2024-10-14 23:32:08.159683',NULL,'1d1ad3e5fece4effb38ffed0c6437642');
/*!40000 ALTER TABLE `oauth2_provider_refreshtoken` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-15  9:36:17
