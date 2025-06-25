-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: bookingfootball
-- ------------------------------------------------------
-- Server version	8.4.4

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
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `stadium_id` bigint NOT NULL,
  `booking_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','CANCELLED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `stadium_id` (`stadium_id`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`stadium_id`) REFERENCES `stadium` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (11,5,1,'2025-06-24','14:00:00','17:00:00','REJECTED','2025-06-23 16:44:03'),(12,5,3,'2025-06-25','19:00:00','21:00:00','CANCELLED','2025-06-23 16:44:41'),(13,5,7,'2025-06-24','19:00:00','20:00:00','APPROVED','2025-06-23 16:45:24');
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Giày','Giày thể thao'),(2,'Quần áo',''),(3,'Phụ Kiện','');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderdetail`
--

DROP TABLE IF EXISTS `orderdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderdetail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `purchase_order_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `size` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_order_id` (`purchase_order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orderdetail_ibfk_1` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchaseorder` (`id`),
  CONSTRAINT `orderdetail_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `check_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderdetail`
--

LOCK TABLES `orderdetail` WRITE;
/*!40000 ALTER TABLE `orderdetail` DISABLE KEYS */;
INSERT INTO `orderdetail` VALUES (1,1,14,1,950000.00,'40'),(2,2,9,2,120000.00,'');
/*!40000 ALTER TABLE `orderdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `category_id` bigint NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `check_stock` CHECK ((`stock` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (3,'Giày sang xịn','',3.00,2,1,'/images/products/product_1750340043935.jfif','2025-06-16 07:54:02',0),(4,'Giày futsal Mitre','Đế bằng cao su tự nhiên, cảm giác bóng tốt, chuyên dụng cho futsal.\r\nSize: 37 - 42',650000.00,14,1,'/images/products/prod_1750587311362.jpg','2025-06-19 04:38:29',1),(5,'Áo đẹp','không bay mà',3.00,5,2,'/images/products/prod_1750425165849.jfif','2025-06-19 04:40:11',0),(6,'Áo khoác gió FootballX','Chống gió và trượt nước nhẹ, thích hợp khởi động hoặc mặc hàng ngày.\r\nSize: S M L XL',450000.00,29,2,'/images/products/prod_1750587298776.webp','2025-06-19 04:40:49',1),(7,'Giày đá bóng Wika 3 sọc','Đế TF cho sân cỏ nhân tạo, bám sân tốt, phom giày ôm chân.\r\nSize: 37 - 42',480000.00,3,1,'/images/products/prod_1750587289909.jpg','2025-06-19 04:41:32',1),(8,'Áo đấu CLB Hà Nội 2024','Mẫu áo sân nhà chính thức, chất liệu thoáng khí, co giãn tốt.\r\nSize: S M L XL',350000.00,99,2,'/images/products/prod_1750587270713.webp','2025-06-19 04:42:04',1),(9,'Bó gối co giãn','Bảo vệ và cố định khớp gối, giảm nguy cơ chấn thương khi vận động.',120000.00,9,3,'/images/products/prod_1750587260880.jpg','2025-06-19 13:32:16',1),(10,'Tất dệt kim thể thao','Chất liệu cotton pha spandex, dày dặn, thấm hút mồ hôi tốt.',50000.00,10,3,'/images/products/product_1750339968913.jfif','2025-06-19 13:32:49',1),(11,'Tất chống trơn cao cổ','Có các hạt cao su dưới đế giúp tăng độ bám trong giày, giảm phồng rộp.',85000.00,29,3,'/images/products/prod_1750582838241.webp','2025-06-21 09:39:58',1),(12,'Bộ đồ tập luyện dài tay','Giữ ấm cơ thể trong thời tiết se lạnh, thiết kế ôm sát, thoải mái.\r\nSize: S M L XL',420000.00,48,2,'/images/products/prod_1750587234413.avif','2025-06-22 09:58:44',1),(13,'Quần short thể thao ProCombat','Quần short chuyên dụng cho vận động, có lớp lót trong, siêu nhẹ.\r\nSize: S M L XL',180000.00,115,2,'/images/products/prod_1750587217664.webp','2025-06-22 10:00:07',1),(14,'Giày cỏ tự nhiên Predator','Đế FG với đinh nhựa cao cấp, tăng khả năng kiểm soát bóng.\r\nSize: 37 - 42',950000.00,13,1,'/images/products/prod_1750587208970.webp','2025-06-22 10:02:51',1);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchaseorder`
--

DROP TABLE IF EXISTS `purchaseorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchaseorder` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `shipping_name` varchar(100) NOT NULL,
  `shipping_phone` varchar(20) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('PENDING','COMPLETED','CANCELLED') DEFAULT 'PENDING',
  `payment_status` enum('UNPAID','PAID') DEFAULT 'UNPAID',
  `shipping_address` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `purchaseorder_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchaseorder`
--

LOCK TABLES `purchaseorder` WRITE;
/*!40000 ALTER TABLE `purchaseorder` DISABLE KEYS */;
INSERT INTO `purchaseorder` VALUES (1,5,'Nhung','0382157157',950000.00,'PENDING','UNPAID','36 Tô Hiến Thành, TP Quy Nhơn','2025-06-23 16:42:31',0),(2,5,'Nhung','0382157157',240000.00,'PENDING','UNPAID','36 Tô Hiến Thành, Quy Nhơn','2025-06-23 16:43:28',0);
/*!40000 ALTER TABLE `purchaseorder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stadium`
--

DROP TABLE IF EXISTS `stadium`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stadium` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `address` varchar(255) NOT NULL,
  `area` enum('Quy Nhơn','An Lão','Hoài Ân','Hoài Nhơn','Phù Cát','Phù Mỹ','Tây Sơn','Tuy Phước','Vân Canh','Vĩnh Thạnh','An Nhơn') NOT NULL,
  `price_per_hour` decimal(10,2) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `contact_phone` varchar(15) DEFAULT NULL,
  `field_type` enum('Sân 5','Sân 7','Sân 11') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stadium`
--

LOCK TABLES `stadium` WRITE;
/*!40000 ALTER TABLE `stadium` DISABLE KEYS */;
INSERT INTO `stadium` VALUES (1,'Sân số 1','123 Lê Lợi, TP. Quy Nhơn','Quy Nhơn',150000.00,'Sân bóng hiện đại, 5 người, có mái che nắng','/images/stadiums/stadium_1750587659051.jfif','0901234567','Sân 5','2025-05-23 07:54:00',1),(2,'Sân số 2','123 Lê Lợi, TP. Quy Nhơn','Phù Cát',200000.00,'Sân bóng 7 người, có nhân tạo chất lượng','/images/stadiums/stadium_1750442411315.jfif','0912345678','Sân 7','2025-05-23 07:54:00',1),(3,'Sân số 3','123 Lê Lợi, TP. Quy Nhơn','Tây Sơn',250000.00,'Sân bóng 11 người, cỏ nhân tạo chất lượng cao, có khán đài cổ vũ','/images/stadiums/stadium_1750442420780.jfif','0923456789','Sân 11','2025-05-23 07:54:00',1),(4,'Sân số 4','123 Lê Lợi, TP. Quy Nhơn','Hoài Nhơn',220000.00,'Sân bóng 5 người, có đèn chiếu sáng xịn, có mái che, cỏ nhân tạo chất lượng','/images/stadiums/stadium_1750442431276.jfif','0934567890','Sân 5','2025-05-23 07:54:00',1),(5,'Sân An Nhơn','654 Hùng Vương, Thị xã An Nhơn','An Nhơn',180000.00,'Sân bóng 7 người, không gian thoáng mát','/images/stadiums/stadium_1750442440823.jfif','0945678901','Sân 7','2025-05-23 07:54:00',0),(6,'Sân số 5','123 Lê Lợi, TP. Quy Nhơn','Quy Nhơn',200000.00,'có trà đá miễn phí, mái che','/images/stadiums/stadium_1750499189872.jfif',NULL,'Sân 7','2025-06-21 09:46:30',1),(7,'Sân số 6','123 Lê Lợi, TP. Quy Nhơn','Quy Nhơn',140000.00,'sân cỏ tự nhiên, có ghế cổ vũ, mái che, đèn chiếu sáng xịn','/images/stadiums/stadium_1750587643454.jfif',NULL,'Sân 11','2025-06-22 10:18:43',1),(8,'Sân Lê Lợi 1','ffug','Quy Nhơn',150000.00,'ẻtgewg','/images/stadiums/stadium_1750671300718.jpg',NULL,'Sân 7','2025-06-23 09:35:01',0),(9,'Sân Lê Lợi 1','123 Lê Lợi, TP. Đà Nẵng','Quy Nhơn',500000.00,'yegfb','/images/stadiums/stadium_1750671516462.jpg',NULL,'Sân 11','2025-06-23 09:38:36',0),(10,'Sân Lê Lợi 2','123 Lê Lợi 2, TP. Quy Nhơn','Quy Nhơn',123000.00,'fdsf','/images/stadiums/stadium_1750671571423.jpg',NULL,'Sân 5','2025-06-23 09:39:31',0);
/*!40000 ALTER TABLE `stadium` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `role` enum('USER','ADMIN') DEFAULT 'USER',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (4,'admin','admin123','Admin User','admin@example.com','0123456789','QuyNhon','ADMIN','2025-06-23 08:03:27'),(5,'User','User123','Hồng Nhung','nhung@gmail.com','0382157155','123 Hoa Lư, TP Quy Nhơn','USER','2025-06-23 16:38:41');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'bookingfootball'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-23 23:48:23
