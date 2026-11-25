-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: scored
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

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
-- Table structure for table `tb_admin`
--

DROP TABLE IF EXISTS `tb_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_admin` (
  `id_admin` int(11) NOT NULL AUTO_INCREMENT,
  `email` text DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_admin`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_admin`
--

LOCK TABLES `tb_admin` WRITE;
/*!40000 ALTER TABLE `tb_admin` DISABLE KEYS */;
INSERT INTO `tb_admin` VALUES (1,'admin@torneo.com','$2y$10$vVThX.dFLGvZ5N1B8ydTx.SBfihe0ONq7AJXCccrRDuMEi.VX71Cy'),(2,'soporte@torneo.com','$2y$10$gFCTxkXZd.4CVf5mWd04O.qBVKHX3/iT7qYhff3br9xyGMjZQYmg.');
/*!40000 ALTER TABLE `tb_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_arbitros`
--

DROP TABLE IF EXISTS `tb_arbitros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_arbitros` (
  `id_arbitro` int(11) NOT NULL AUTO_INCREMENT,
  `email` text DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `nombre` text DEFAULT NULL,
  `foto_url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_arbitro`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_arbitros`
--

LOCK TABLES `tb_arbitros` WRITE;
/*!40000 ALTER TABLE `tb_arbitros` DISABLE KEYS */;
INSERT INTO `tb_arbitros` VALUES (1,'collina@referee.com','$2y$10$dBg4lkHNdtwnzCV5dbYn6uVNcuRPiUynUg2uYP3HgeZglpUdXzKnm','Pierluigi Collina',NULL),(2,'webb@referee.com','$2y$10$Fct.dBF5TsTz/Xji35Piq.GOeJkdUp.WCQn9/5wDrsqy4TfhFjIEG','Howard Webb',NULL),(3,'larronda@referee.com','$2y$10$TccB45.cM9x2.jkSHMN8Cep1dEA2ZOFxGmYlH./8kSZOvWHuwPDQC','Jorge Larrionda',NULL);
/*!40000 ALTER TABLE `tb_arbitros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_cursos`
--

DROP TABLE IF EXISTS `tb_cursos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_cursos` (
  `id_curso` int(11) NOT NULL AUTO_INCREMENT,
  `anio` int(11) DEFAULT NULL,
  `division` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_curso`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_cursos`
--

LOCK TABLES `tb_cursos` WRITE;
/*!40000 ALTER TABLE `tb_cursos` DISABLE KEYS */;
INSERT INTO `tb_cursos` VALUES (1,5,1),(2,5,2),(3,6,1),(4,6,2),(5,7,1);
/*!40000 ALTER TABLE `tb_cursos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_deportes`
--

DROP TABLE IF EXISTS `tb_deportes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_deportes` (
  `id_deporte` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `tiene_empate` tinyint(1) NOT NULL DEFAULT 1,
  `unidad_marcador` varchar(50) NOT NULL DEFAULT 'puntos',
  PRIMARY KEY (`id_deporte`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_deportes`
--

LOCK TABLES `tb_deportes` WRITE;
/*!40000 ALTER TABLE `tb_deportes` DISABLE KEYS */;
INSERT INTO `tb_deportes` VALUES (1,'F├║tbol',1,'goles'),(2,'B├ísquet',0,'puntos'),(3,'V├│ley',0,'sets'),(4,'Handball',1,'goles'),(5,'F├║tbol Sala',1,'goles');
/*!40000 ALTER TABLE `tb_deportes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_equipos`
--

DROP TABLE IF EXISTS `tb_equipos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_equipos` (
  `id_equipo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` text DEFAULT NULL,
  `id_torneo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_equipo`),
  KEY `id_torneo` (`id_torneo`),
  CONSTRAINT `tb_equipos_ibfk_1` FOREIGN KEY (`id_torneo`) REFERENCES `tb_torneos` (`id_torneo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_equipos`
--

LOCK TABLES `tb_equipos` WRITE;
/*!40000 ALTER TABLE `tb_equipos` DISABLE KEYS */;
INSERT INTO `tb_equipos` VALUES (1,'Los Galacticos',1),(2,'Pibes del Fondo',1),(3,'La Banda del Sur',1),(4,'Villa Crespo FC',1),(5,'Los Choris',2),(6,'Mateo y Compania',2),(7,'Los Equilibrados',2),(8,'Palermo United',3),(9,'Boedo Warriors',3),(10,'San Telmo Juniors',3),(11,'Belgrano Boys',3),(12,'prueba',1);
/*!40000 ALTER TABLE `tb_equipos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_estados`
--

DROP TABLE IF EXISTS `tb_estados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_estados` (
  `id_estado` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` text DEFAULT NULL,
  PRIMARY KEY (`id_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_estados`
--

LOCK TABLES `tb_estados` WRITE;
/*!40000 ALTER TABLE `tb_estados` DISABLE KEYS */;
INSERT INTO `tb_estados` VALUES (1,'Programado'),(2,'En Curso'),(3,'Finalizado'),(4,'Suspendido');
/*!40000 ALTER TABLE `tb_estados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_eventos_partido`
--

DROP TABLE IF EXISTS `tb_eventos_partido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_eventos_partido` (
  `id_evento` int(11) NOT NULL AUTO_INCREMENT,
  `id_partido` int(11) DEFAULT NULL,
  `id_participante` int(11) DEFAULT NULL,
  `id_tipo_evento` int(11) DEFAULT NULL,
  `minuto` int(11) DEFAULT NULL,
  `comentarios` text DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `id_partido` (`id_partido`),
  KEY `id_participante` (`id_participante`),
  KEY `id_tipo_evento` (`id_tipo_evento`),
  CONSTRAINT `tb_eventos_partido_ibfk_1` FOREIGN KEY (`id_partido`) REFERENCES `tb_partidos` (`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tb_eventos_partido_ibfk_2` FOREIGN KEY (`id_participante`) REFERENCES `tb_participantes` (`id_participante`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tb_eventos_partido_ibfk_3` FOREIGN KEY (`id_tipo_evento`) REFERENCES `tb_tipos_evento` (`id_tipo_evento`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_eventos_partido`
--

LOCK TABLES `tb_eventos_partido` WRITE;
/*!40000 ALTER TABLE `tb_eventos_partido` DISABLE KEYS */;
INSERT INTO `tb_eventos_partido` VALUES (1,1,1,1,12,''),(2,1,2,1,34,''),(3,1,5,1,55,''),(4,1,1,1,78,''),(5,1,7,2,40,''),(6,2,15,1,22,''),(7,2,16,1,67,''),(8,2,9,2,30,''),(9,2,13,2,80,''),(10,3,3,1,15,''),(11,3,11,1,28,''),(12,3,4,1,60,''),(13,3,12,1,88,''),(14,4,6,1,45,''),(15,4,14,2,55,''),(16,4,16,3,70,''),(17,5,13,1,10,''),(18,5,1,1,20,''),(19,5,2,1,35,''),(20,5,2,1,50,''),(21,5,4,1,75,''),(22,5,15,2,60,''),(23,6,5,1,33,''),(24,6,8,1,71,''),(25,6,10,2,45,''),(26,6,11,2,82,''),(27,7,1,1,23,''),(28,11,17,1,18,''),(29,11,18,1,55,''),(30,11,19,2,44,''),(31,12,21,1,30,''),(32,12,17,1,65,''),(33,13,21,1,10,''),(34,13,22,1,44,''),(35,13,21,1,88,''),(36,13,20,2,35,''),(37,13,19,3,78,''),(38,14,17,1,15,''),(39,14,18,1,40,''),(40,14,22,1,55,''),(41,17,23,1,38,''),(42,17,25,2,50,''),(43,18,27,1,20,''),(44,18,29,1,45,''),(45,18,28,1,60,''),(46,18,30,1,85,''),(47,19,25,1,12,''),(48,19,26,1,34,''),(49,19,27,1,56,''),(50,19,26,1,78,''),(51,19,28,2,40,''),(52,19,29,3,70,''),(53,20,24,1,55,''),(54,20,30,2,30,''),(55,21,23,1,25,''),(56,21,24,1,70,''),(57,22,25,1,44,''),(58,22,29,1,80,''),(59,23,23,1,18,''),(68,9,10,1,60,'Gooool');
/*!40000 ALTER TABLE `tb_eventos_partido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_participantes`
--

DROP TABLE IF EXISTS `tb_participantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_participantes` (
  `id_participante` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` text DEFAULT NULL,
  `apellido` text DEFAULT NULL,
  `dni` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_participante`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_participantes`
--

LOCK TABLES `tb_participantes` WRITE;
/*!40000 ALTER TABLE `tb_participantes` DISABLE KEYS */;
INSERT INTO `tb_participantes` VALUES (1,'Lionel','Messi','10101010'),(2,'Julian','Alvarez','90909090'),(3,'Rodrigo','De Paul','22334455'),(4,'Angel','Di Maria','33445566'),(5,'Lautaro','Martinez','44556677'),(6,'Nicolas','Gonzalez','55667788'),(7,'Exequiel','Palacios','66778899'),(8,'Leandro','Paredes','77889900'),(9,'German','Pezzella','88990011'),(10,'Marcos','Acuna','99001122'),(11,'Guido','Rodriguez','11223344'),(12,'Thiago','Almada','12345678'),(13,'Valentin','Carboni','23456789'),(14,'Facundo','Buonanotte','34567890'),(15,'Matias','Soule','45678901'),(16,'Alejandro','Garnacho','56789012'),(17,'Ezequiel','Barco','67890123'),(18,'Tomas','Cuello','78901234'),(19,'Mateo','Retegui','89012345'),(20,'Gino','Infantino','90123456'),(21,'Franco','Mastantuono','01234567'),(22,'Claudio','Echeverri','13579246'),(23,'Bruno','Zuculini','24681357'),(24,'Ramiro','Funes Mori','35792468'),(25,'Diego','Valdez','46813579'),(26,'Sebastian','Driussi','57924680'),(27,'Ignacio','Fernandez','68035791'),(28,'Agustin','Urzi','79146802'),(29,'Nicolas','Orsini','80257913'),(30,'Cristian','Pavon','91368024'),(31,'aaa','sss','1234135'),(32,'gghhgg','jjyyuu','2352465246');
/*!40000 ALTER TABLE `tb_participantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_partidos`
--

DROP TABLE IF EXISTS `tb_partidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_partidos` (
  `id_partido` int(11) NOT NULL AUTO_INCREMENT,
  `id_equipo_local` int(11) DEFAULT NULL,
  `id_equipo_visitante` int(11) DEFAULT NULL,
  `id_torneo` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `marcador_local` int(11) DEFAULT NULL,
  `marcador_visitante` int(11) DEFAULT NULL,
  `id_arbitro` int(11) DEFAULT NULL,
  `id_estado` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_partido`),
  KEY `id_equipo_local` (`id_equipo_local`),
  KEY `id_equipo_visitante` (`id_equipo_visitante`),
  KEY `id_torneo` (`id_torneo`),
  KEY `id_arbitro` (`id_arbitro`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `tb_partidos_ibfk_1` FOREIGN KEY (`id_equipo_local`) REFERENCES `tb_equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tb_partidos_ibfk_2` FOREIGN KEY (`id_equipo_visitante`) REFERENCES `tb_equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tb_partidos_ibfk_3` FOREIGN KEY (`id_torneo`) REFERENCES `tb_torneos` (`id_torneo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tb_partidos_ibfk_4` FOREIGN KEY (`id_arbitro`) REFERENCES `tb_arbitros` (`id_arbitro`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tb_partidos_ibfk_5` FOREIGN KEY (`id_estado`) REFERENCES `tb_estados` (`id_estado`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_partidos`
--

LOCK TABLES `tb_partidos` WRITE;
/*!40000 ALTER TABLE `tb_partidos` DISABLE KEYS */;
INSERT INTO `tb_partidos` VALUES (1,1,2,1,'2026-03-10',3,1,1,3),(2,3,4,1,'2026-03-10',0,2,2,3),(3,1,3,1,'2026-03-17',2,2,1,3),(4,2,4,1,'2026-03-17',1,0,3,3),(5,4,1,1,'2026-03-24',1,4,2,3),(6,2,3,1,'2026-03-24',2,0,1,3),(7,1,4,1,'2026-04-07',1,0,2,3),(8,2,3,1,'2026-04-14',1,NULL,3,3),(9,3,1,1,'2026-04-21',2,0,1,2),(10,4,2,1,'2026-04-21',NULL,NULL,2,1),(11,5,6,2,'2026-03-15',2,0,1,3),(12,7,5,2,'2026-03-15',1,1,2,3),(13,6,7,2,'2026-03-22',0,3,3,3),(14,5,7,2,'2026-04-07',2,1,1,3),(15,6,5,2,'2026-04-14',NULL,NULL,2,2),(16,7,6,2,'2026-04-14',NULL,NULL,3,1),(17,8,9,3,'2026-03-08',1,0,1,3),(18,10,11,3,'2026-03-08',2,2,2,3),(19,9,10,3,'2026-03-15',3,1,3,3),(20,11,8,3,'2026-03-15',0,1,1,3),(21,8,10,3,'2026-03-22',2,0,2,3),(22,9,11,3,'2026-03-22',1,1,3,3),(23,10,8,3,'2026-04-07',0,1,1,3),(24,11,9,3,'2026-04-14',NULL,NULL,2,1),(25,8,11,3,'2026-04-21',NULL,NULL,3,1),(26,9,10,3,'2026-04-21',NULL,NULL,1,1);
/*!40000 ALTER TABLE `tb_partidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_plantilla`
--

DROP TABLE IF EXISTS `tb_plantilla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_plantilla` (
  `id_plantilla` int(11) NOT NULL AUTO_INCREMENT,
  `id_equipo` int(11) DEFAULT NULL,
  `id_participante` int(11) DEFAULT NULL,
  `id_curso` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_plantilla`),
  KEY `id_equipo` (`id_equipo`),
  KEY `id_participante` (`id_participante`),
  KEY `id_curso` (`id_curso`),
  CONSTRAINT `tb_plantilla_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `tb_equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tb_plantilla_ibfk_2` FOREIGN KEY (`id_participante`) REFERENCES `tb_participantes` (`id_participante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tb_plantilla_ibfk_3` FOREIGN KEY (`id_curso`) REFERENCES `tb_cursos` (`id_curso`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_plantilla`
--

LOCK TABLES `tb_plantilla` WRITE;
/*!40000 ALTER TABLE `tb_plantilla` DISABLE KEYS */;
INSERT INTO `tb_plantilla` VALUES (1,1,1,3),(2,1,2,3),(3,1,3,4),(4,1,4,4),(5,2,5,1),(6,2,6,1),(7,2,7,2),(8,2,8,2),(9,3,9,3),(10,3,10,3),(11,3,11,4),(12,3,12,4),(13,4,13,1),(14,4,14,1),(15,4,15,2),(16,4,16,2),(17,5,17,1),(18,5,18,1),(19,6,19,2),(20,6,20,2),(21,7,21,3),(22,7,22,3),(23,8,23,4),(24,8,24,4),(25,9,25,5),(26,9,26,5),(27,10,27,1),(28,10,28,1),(29,11,29,2),(30,11,30,2),(31,12,31,2),(32,12,32,1);
/*!40000 ALTER TABLE `tb_plantilla` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_reglas_puntos`
--

DROP TABLE IF EXISTS `tb_reglas_puntos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_reglas_puntos` (
  `id_regla` int(11) NOT NULL AUTO_INCREMENT,
  `id_deporte` int(11) NOT NULL,
  `resultado` enum('victoria','empate','derrota') NOT NULL,
  `puntos` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_regla`),
  UNIQUE KEY `deporte_resultado` (`id_deporte`,`resultado`),
  CONSTRAINT `tb_reglas_puntos_ibfk_1` FOREIGN KEY (`id_deporte`) REFERENCES `tb_deportes` (`id_deporte`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_reglas_puntos`
--

LOCK TABLES `tb_reglas_puntos` WRITE;
/*!40000 ALTER TABLE `tb_reglas_puntos` DISABLE KEYS */;
INSERT INTO `tb_reglas_puntos` VALUES (1,1,'victoria',3),(2,1,'empate',1),(3,1,'derrota',0),(4,2,'victoria',2),(5,2,'derrota',1),(6,3,'victoria',3),(7,3,'derrota',0),(8,4,'victoria',3),(9,4,'empate',1),(10,4,'derrota',0),(11,5,'victoria',3),(12,5,'empate',1),(13,5,'derrota',0);
/*!40000 ALTER TABLE `tb_reglas_puntos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_tipos_evento`
--

DROP TABLE IF EXISTS `tb_tipos_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_tipos_evento` (
  `id_tipo_evento` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `id_deporte` int(11) NOT NULL DEFAULT 1,
  `afecta_marcador` tinyint(1) NOT NULL DEFAULT 0,
  `valor` int(11) NOT NULL DEFAULT 0,
  `afecta_propio` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_tipo_evento`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_tipos_evento`
--

LOCK TABLES `tb_tipos_evento` WRITE;
/*!40000 ALTER TABLE `tb_tipos_evento` DISABLE KEYS */;
INSERT INTO `tb_tipos_evento` VALUES (1,'Gol',1,1,1,1),(2,'Tarjeta Amarilla',1,0,0,1),(3,'Tarjeta Roja',1,0,0,1),(4,'Gol en contra',1,1,1,0),(5,'Doble',2,1,2,1),(6,'Triple',2,1,3,1),(7,'Tiro libre',2,1,1,1),(8,'Falta personal',2,0,0,1),(9,'Falta t├®cnica',2,0,0,1),(10,'Set ganado',3,1,1,1),(11,'Tarjeta Amarilla',3,0,0,1),(12,'Tarjeta Roja',3,0,0,1),(13,'Gol',4,1,1,1),(14,'Tarjeta Amarilla',4,0,0,1),(15,'Tarjeta Roja',4,0,0,1),(16,'Tarjeta Azul',4,0,0,1),(17,'Gol de 7 metros',4,1,1,1),(18,'Gol en contra',4,1,1,0),(19,'Gol',5,1,1,1),(20,'Tarjeta Amarilla',5,0,0,1),(21,'Tarjeta Roja',5,0,0,1),(22,'Tarjeta Azul',5,0,0,1),(23,'Gol en contra',5,1,1,0);
/*!40000 ALTER TABLE `tb_tipos_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_torneos`
--

DROP TABLE IF EXISTS `tb_torneos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_torneos` (
  `id_torneo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` text DEFAULT NULL,
  `anio` int(11) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `id_deporte` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_torneo`),
  KEY `id_deporte` (`id_deporte`),
  CONSTRAINT `tb_torneos_ibfk_1` FOREIGN KEY (`id_deporte`) REFERENCES `tb_deportes` (`id_deporte`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_torneos`
--

LOCK TABLES `tb_torneos` WRITE;
/*!40000 ALTER TABLE `tb_torneos` DISABLE KEYS */;
INSERT INTO `tb_torneos` VALUES (1,'Copa de Campeones Escolar',2026,'Torneo anual de secundaria',1),(2,'Torneo Relampago Otono',2026,'Torneo corto de fin de semana',1),(3,'Liga Intercolegial 2026',2026,'Liga entre colegios del distrito',1),(5,'La Copa del Aro Roto',2026,'Porque al final, todos acaban con el bal├│n en el aro... o en la espalda.',2),(6,'El Torneo de los Saltos al Vac├¡o',2026,'Donde la gravedad es solo una sugerencia y las lesiones, una certeza.',2),(7,'La Liga de los &quot;┬íP├ísamela, Nerd!&quot;',2026,'Para equipos que parecen que nunca han jugado juntos.',2),(8,'El Campeonato del Salto al Desconocido',2026,'Donde el bal├│n nunca cae donde t├║ piensas, pero siempre donde el rival quiere.',3),(9,'La Copa del Remate al Aire (y al Suelo)',2026,'Porque a veces el bal├│n vuela y a veces... ┬ízas! Al suelo.',3),(10,'El Torneo de los &quot;┬íNo toques la red!&quot;',2026,'Un desaf├¡o para ver qui├®n puede tocarla m├ís veces sin que se den cuenta.',3),(11,'La Copa del Golpe de Hombro (y de Codo)',2026,'Donde el contacto f├¡sico es m├ís intenso que una discusi├│n familiar.',4),(12,'El Torneo de los &quot;┬íP├ísamela, ┬íQue Me Muerden!&quot;',2026,'Para equipos que parecen una manada de lobos hambrientos.',4),(13,'La Liga de los Porteros que No Ven el Bal├│n',2026,'Porque si no lo ven, ┬┐c├│mo van a parar el gol?',4),(14,'El Campeonato del &quot;┬íEs que era fuera!&quot;',2026,'Donde cada gol es discutido como si fuera un juicio de la ONU.',5),(15,'La Copa del Pat├¡n al Aire (y al Techo)',2026,'Para los equipos que juegan con m├ís pasi├│n que control.',5),(16,'El Torneo de los &quot;┬íNo se puede, es f├║tbol!&quot;',2026,'Porque en el f├║tbol sala, todo vale... o no.',5);
/*!40000 ALTER TABLE `tb_torneos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'scored'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-01 15:24:44
