-- phpMyAdmin SQL Dump
-- ScoreEd — Schema multi-deporte
-- Versión: 2.0
-- Servidor: 127.0.0.1 (MariaDB 10.4.32)

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

-- --------------------------------------------------------
-- Base de datos: `scored`
-- --------------------------------------------------------

-- ============================================================
-- tb_deportes — catálogo de deportes soportados
--   tiene_empate   : 1 = el deporte admite empate, 0 = no
--   unidad_marcador: etiqueta genérica para el marcador
--                    (goles, puntos, sets, tantos…)
-- ============================================================
CREATE TABLE `tb_deportes` (
  `id_deporte`       int(11)      NOT NULL AUTO_INCREMENT,
  `nombre`           varchar(100) NOT NULL,
  `tiene_empate`     tinyint(1)   NOT NULL DEFAULT 1,
  `unidad_marcador`  varchar(50)  NOT NULL DEFAULT 'puntos',
  PRIMARY KEY (`id_deporte`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_deportes` (`id_deporte`, `nombre`, `tiene_empate`, `unidad_marcador`) VALUES
(1, 'Fútbol',    1, 'goles'),
(2, 'Básquet',   0, 'puntos'),
(3, 'Vóley',     0, 'sets'),
(4, 'Handball',  1, 'goles'),
(5, 'Fútbol Sala', 1, 'goles');

-- ============================================================
-- tb_reglas_puntos — puntos que otorga cada resultado por deporte
--   resultado: 'victoria' | 'empate' | 'derrota'
-- ============================================================
CREATE TABLE `tb_reglas_puntos` (
  `id_regla`    int(11)     NOT NULL AUTO_INCREMENT,
  `id_deporte`  int(11)     NOT NULL,
  `resultado`   enum('victoria','empate','derrota') NOT NULL,
  `puntos`      int(11)     NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_regla`),
  UNIQUE KEY `deporte_resultado` (`id_deporte`, `resultado`),
  FOREIGN KEY (`id_deporte`) REFERENCES `tb_deportes` (`id_deporte`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Fútbol: 3/1/0
INSERT INTO `tb_reglas_puntos` (`id_deporte`, `resultado`, `puntos`) VALUES
(1, 'victoria', 3), (1, 'empate', 1), (1, 'derrota', 0),
(2, 'victoria', 2), (2, 'derrota', 1),
(3, 'victoria', 3), (3, 'derrota', 0),
(4, 'victoria', 3), (4, 'empate', 1), (4, 'derrota', 0),
(5, 'victoria', 3), (5, 'empate', 1), (5, 'derrota', 0);

-- ============================================================
-- tb_admin
-- ============================================================
CREATE TABLE `tb_admin` (
  `id_admin`   int(11)      NOT NULL AUTO_INCREMENT,
  `email`      text         DEFAULT NULL,
  `contraseña` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_admin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_admin` (`id_admin`, `email`, `contraseña`) VALUES
(1, 'admin@torneo.com',   '$2y$10$vVThX.dFLGvZ5N1B8ydTx.SBfihe0ONq7AJXCccrRDuMEi.VX71Cy'),
(2, 'soporte@torneo.com', 'pass456');

-- ============================================================
-- tb_arbitros
-- ============================================================
CREATE TABLE `tb_arbitros` (
  `id_arbitro` int(11)      NOT NULL AUTO_INCREMENT,
  `email`      text         DEFAULT NULL,
  `contraseña` varchar(255) DEFAULT NULL,
  `nombre`     text         DEFAULT NULL,
  PRIMARY KEY (`id_arbitro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_arbitros` (`id_arbitro`, `email`, `contraseña`, `nombre`) VALUES
(1, 'collina@referee.com',   '$2y$10$5qqUoW.ay2iSC2GKRbgt9eSwa7pNEu9Ian92o.PpkV32WUS.PW.rK', 'Pierluigi Collina'),
(2, 'webb@referee.com',      '$2y$10$yAIDJTLGjPK31Q7YcQWhMOfewXwavXXnE9hsdkJRGTiXLXMLIXD76', 'Howard Webb'),
(3, 'larronda@referee.com',  '$2y$10$6ngrswbQrgbfaW7xz8vtmut6iECNrPkORZH1vFQCYOeDeeK0tNz/W', 'Jorge Larrionda');

-- ============================================================
-- tb_cursos
-- ============================================================
CREATE TABLE `tb_cursos` (
  `id_curso`  int(11) NOT NULL AUTO_INCREMENT,
  `año`       int(11) DEFAULT NULL,
  `division`  int(11) DEFAULT NULL,
  PRIMARY KEY (`id_curso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_cursos` (`id_curso`, `año`, `division`) VALUES
(1, 5, 1), (2, 5, 2), (3, 6, 1), (4, 6, 2), (5, 7, 1);

-- ============================================================
-- tb_estados
-- ============================================================
CREATE TABLE `tb_estados` (
  `id_estado` int(11) NOT NULL AUTO_INCREMENT,
  `nombre`    text    DEFAULT NULL,
  PRIMARY KEY (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_estados` (`id_estado`, `nombre`) VALUES
(1, 'Programado'), (2, 'En Curso'), (3, 'Finalizado'), (4, 'Suspendido');

-- ============================================================
-- tb_torneos — ahora con id_deporte
--   Los 3 torneos existentes son de fútbol (id_deporte = 1)
-- ============================================================
CREATE TABLE `tb_torneos` (
  `id_torneo`   int(11)      NOT NULL AUTO_INCREMENT,
  `nombre`      text         DEFAULT NULL,
  `año`         int(11)      DEFAULT NULL,
  `descripción` text         DEFAULT NULL,
  `id_deporte`  int(11)      NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_torneo`),
  FOREIGN KEY (`id_deporte`) REFERENCES `tb_deportes` (`id_deporte`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_torneos` (`id_torneo`, `nombre`, `año`, `descripción`, `id_deporte`) VALUES
(1, 'Copa de Campeones Escolar', 2026, 'Torneo anual de secundaria',        1),
(2, 'Torneo Relampago Otono',    2026, 'Torneo corto de fin de semana',      1),
(3, 'Liga Intercolegial 2026',   2026, 'Liga entre colegios del distrito',   1);

-- ============================================================
-- tb_equipos
-- ============================================================
CREATE TABLE `tb_equipos` (
  `id_equipo`  int(11) NOT NULL AUTO_INCREMENT,
  `nombre`     text    DEFAULT NULL,
  `id_torneo`  int(11) DEFAULT NULL,
  PRIMARY KEY (`id_equipo`),
  KEY `id_torneo` (`id_torneo`),
  FOREIGN KEY (`id_torneo`) REFERENCES `tb_torneos` (`id_torneo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_equipos` (`id_equipo`, `nombre`, `id_torneo`) VALUES
(1,  'Los Galacticos',    1), (2,  'Pibes del Fondo',   1),
(3,  'La Banda del Sur',  1), (4,  'Villa Crespo FC',   1),
(5,  'Los Choris',        2), (6,  'Mateo y Compania',  2),
(7,  'Los Equilibrados',  2), (8,  'Palermo United',    3),
(9,  'Boedo Warriors',    3), (10, 'San Telmo Juniors',  3),
(11, 'Belgrano Boys',     3), (12, 'prueba',             1);

-- ============================================================
-- tb_participantes
-- ============================================================
CREATE TABLE `tb_participantes` (
  `id_participante` int(11)      NOT NULL AUTO_INCREMENT,
  `nombre`          text         DEFAULT NULL,
  `apellido`        text         DEFAULT NULL,
  `dni`             varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_participante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_participantes` (`id_participante`, `nombre`, `apellido`, `dni`) VALUES
(1,  'Lionel',    'Messi',         '10101010'),
(2,  'Julian',    'Alvarez',       '90909090'),
(3,  'Rodrigo',   'De Paul',       '22334455'),
(4,  'Angel',     'Di Maria',      '33445566'),
(5,  'Lautaro',   'Martinez',      '44556677'),
(6,  'Nicolas',   'Gonzalez',      '55667788'),
(7,  'Exequiel',  'Palacios',      '66778899'),
(8,  'Leandro',   'Paredes',       '77889900'),
(9,  'German',    'Pezzella',      '88990011'),
(10, 'Marcos',    'Acuna',         '99001122'),
(11, 'Guido',     'Rodriguez',     '11223344'),
(12, 'Thiago',    'Almada',        '12345678'),
(13, 'Valentin',  'Carboni',       '23456789'),
(14, 'Facundo',   'Buonanotte',    '34567890'),
(15, 'Matias',    'Soule',         '45678901'),
(16, 'Alejandro', 'Garnacho',      '56789012'),
(17, 'Ezequiel',  'Barco',         '67890123'),
(18, 'Tomas',     'Cuello',        '78901234'),
(19, 'Mateo',     'Retegui',       '89012345'),
(20, 'Gino',      'Infantino',     '90123456'),
(21, 'Franco',    'Mastantuono',   '01234567'),
(22, 'Claudio',   'Echeverri',     '13579246'),
(23, 'Bruno',     'Zuculini',      '24681357'),
(24, 'Ramiro',    'Funes Mori',    '35792468'),
(25, 'Diego',     'Valdez',        '46813579'),
(26, 'Sebastian', 'Driussi',       '57924680'),
(27, 'Ignacio',   'Fernandez',     '68035791'),
(28, 'Agustin',   'Urzi',          '79146802'),
(29, 'Nicolas',   'Orsini',        '80257913'),
(30, 'Cristian',  'Pavon',         '91368024'),
(31, 'aaa',       'sss',           '1234135'),
(32, 'gghhgg',    'jjyyuu',        '2352465246');

-- ============================================================
-- tb_plantilla
-- ============================================================
CREATE TABLE `tb_plantilla` (
  `id_plantilla`    int(11) NOT NULL AUTO_INCREMENT,
  `id_equipo`       int(11) DEFAULT NULL,
  `id_participante` int(11) DEFAULT NULL,
  `id_curso`        int(11) DEFAULT NULL,
  PRIMARY KEY (`id_plantilla`),
  KEY `id_equipo` (`id_equipo`),
  KEY `id_participante` (`id_participante`),
  KEY `id_curso` (`id_curso`),
  FOREIGN KEY (`id_equipo`)       REFERENCES `tb_equipos`       (`id_equipo`)       ON DELETE CASCADE  ON UPDATE CASCADE,
  FOREIGN KEY (`id_participante`) REFERENCES `tb_participantes` (`id_participante`) ON DELETE CASCADE  ON UPDATE CASCADE,
  FOREIGN KEY (`id_curso`)        REFERENCES `tb_cursos`        (`id_curso`)        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_plantilla` (`id_plantilla`, `id_equipo`, `id_participante`, `id_curso`) VALUES
(1,1,1,3),(2,1,2,3),(3,1,3,4),(4,1,4,4),
(5,2,5,1),(6,2,6,1),(7,2,7,2),(8,2,8,2),
(9,3,9,3),(10,3,10,3),(11,3,11,4),(12,3,12,4),
(13,4,13,1),(14,4,14,1),(15,4,15,2),(16,4,16,2),
(17,5,17,1),(18,5,18,1),(19,6,19,2),(20,6,20,2),
(21,7,21,3),(22,7,22,3),(23,8,23,4),(24,8,24,4),
(25,9,25,5),(26,9,26,5),(27,10,27,1),(28,10,28,1),
(29,11,29,2),(30,11,30,2),(31,12,31,2),(32,12,32,1);

-- ============================================================
-- tb_tipos_evento — ahora con id_deporte, afecta_marcador y valor
--   afecta_marcador: 1 = este evento modifica el marcador del partido
--   valor          : cuánto suma al marcador (1 gol, 2 pts, 3 pts…)
--   afecta_propio  : 1 = suma al equipo que lo ejecuta
--                    0 = suma al equipo contrario (gol en contra)
-- ============================================================
CREATE TABLE `tb_tipos_evento` (
  `id_tipo_evento`   int(11)      NOT NULL AUTO_INCREMENT,
  `id_deporte`       int(11)      NOT NULL,
  `nombre`           varchar(100) NOT NULL,
  `afecta_marcador`  tinyint(1)   NOT NULL DEFAULT 0,
  `valor`            int(11)      NOT NULL DEFAULT 0,
  `afecta_propio`    tinyint(1)   NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_tipo_evento`),
  KEY `id_deporte` (`id_deporte`),
  FOREIGN KEY (`id_deporte`) REFERENCES `tb_deportes` (`id_deporte`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_tipos_evento` (`id_tipo_evento`, `id_deporte`, `nombre`, `afecta_marcador`, `valor`, `afecta_propio`) VALUES
(1,  1, 'Gol',              1, 1, 1),
(2,  1, 'Tarjeta Amarilla', 0, 0, 1),
(3,  1, 'Tarjeta Roja',     0, 0, 1),
(4,  1, 'Gol en contra',    1, 1, 0),
(5,  2, 'Doble',            1, 2, 1),
(6,  2, 'Triple',           1, 3, 1),
(7,  2, 'Tiro libre',       1, 1, 1),
(8,  2, 'Falta personal',   0, 0, 1),
(9,  2, 'Falta técnica',    0, 0, 1),
(10, 3, 'Set ganado',       1, 1, 1),
(11, 3, 'Tarjeta Amarilla', 0, 0, 1),
(12, 3, 'Tarjeta Roja',     0, 0, 1),
(13, 4, 'Gol',              1, 1, 1),
(14, 4, 'Tarjeta Amarilla', 0, 0, 1),
(15, 4, 'Tarjeta Roja',     0, 0, 1),
(16, 4, 'Tarjeta Azul',     0, 0, 1),
(17, 4, 'Gol de 7 metros',  1, 1, 1),
(18, 4, 'Gol en contra',    1, 1, 0),
(19, 5, 'Gol',              1, 1, 1),
(20, 5, 'Tarjeta Amarilla', 0, 0, 1),
(21, 5, 'Tarjeta Roja',     0, 0, 1),
(22, 5, 'Tarjeta Azul',     0, 0, 1),
(23, 5, 'Gol en contra',    1, 1, 0);

-- ============================================================
-- tb_partidos — goles_* renombrado a marcador_* (genérico)
--   Los datos existentes se preservan íntegros
-- ============================================================
CREATE TABLE `tb_partidos` (
  `id_partido`          int(11) NOT NULL AUTO_INCREMENT,
  `id_equipo_local`     int(11) DEFAULT NULL,
  `id_equipo_visitante` int(11) DEFAULT NULL,
  `id_torneo`           int(11) DEFAULT NULL,
  `fecha`               date    DEFAULT NULL,
  `marcador_local`      int(11) DEFAULT NULL,
  `marcador_visitante`  int(11) DEFAULT NULL,
  `id_arbitro`          int(11) DEFAULT NULL,
  `id_estado`           int(11) DEFAULT NULL,
  PRIMARY KEY (`id_partido`),
  KEY `id_equipo_local`     (`id_equipo_local`),
  KEY `id_equipo_visitante` (`id_equipo_visitante`),
  KEY `id_torneo`           (`id_torneo`),
  KEY `id_arbitro`          (`id_arbitro`),
  KEY `id_estado`           (`id_estado`),
  FOREIGN KEY (`id_equipo_local`)     REFERENCES `tb_equipos` (`id_equipo`)  ON DELETE CASCADE  ON UPDATE CASCADE,
  FOREIGN KEY (`id_equipo_visitante`) REFERENCES `tb_equipos` (`id_equipo`)  ON DELETE CASCADE  ON UPDATE CASCADE,
  FOREIGN KEY (`id_torneo`)           REFERENCES `tb_torneos` (`id_torneo`)  ON DELETE CASCADE  ON UPDATE CASCADE,
  FOREIGN KEY (`id_arbitro`)          REFERENCES `tb_arbitros` (`id_arbitro`) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (`id_estado`)           REFERENCES `tb_estados` (`id_estado`)  ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_partidos` (`id_partido`, `id_equipo_local`, `id_equipo_visitante`, `id_torneo`, `fecha`, `marcador_local`, `marcador_visitante`, `id_arbitro`, `id_estado`) VALUES
(1,  1,  2,  1, '2026-03-10', 3,    1,    1, 3),
(2,  3,  4,  1, '2026-03-10', 0,    2,    2, 3),
(3,  1,  3,  1, '2026-03-17', 2,    2,    1, 3),
(4,  2,  4,  1, '2026-03-17', 1,    0,    3, 3),
(5,  4,  1,  1, '2026-03-24', 1,    4,    2, 3),
(6,  2,  3,  1, '2026-03-24', 2,    0,    1, 3),
(7,  1,  4,  1, '2026-04-07', 1,    0,    2, 2),
(8,  2,  3,  1, '2026-04-14', NULL, NULL, 3, 1),
(9,  3,  1,  1, '2026-04-21', NULL, NULL, 1, 1),
(10, 4,  2,  1, '2026-04-21', NULL, NULL, 2, 1),
(11, 5,  6,  2, '2026-03-15', 2,    0,    1, 3),
(12, 7,  5,  2, '2026-03-15', 1,    1,    2, 3),
(13, 6,  7,  2, '2026-03-22', 0,    3,    3, 3),
(14, 5,  7,  2, '2026-04-07', 2,    1,    1, 2),
(15, 6,  5,  2, '2026-04-14', NULL, NULL, 2, 1),
(16, 7,  6,  2, '2026-04-14', NULL, NULL, 3, 1),
(17, 8,  9,  3, '2026-03-08', 1,    0,    1, 3),
(18, 10, 11, 3, '2026-03-08', 2,    2,    2, 3),
(19, 9,  10, 3, '2026-03-15', 3,    1,    3, 3),
(20, 11, 8,  3, '2026-03-15', 0,    1,    1, 3),
(21, 8,  10, 3, '2026-03-22', 2,    0,    2, 3),
(22, 9,  11, 3, '2026-03-22', 1,    1,    3, 3),
(23, 10, 8,  3, '2026-04-07', 0,    1,    1, 2),
(24, 11, 9,  3, '2026-04-14', NULL, NULL, 2, 1),
(25, 8,  11, 3, '2026-04-21', NULL, NULL, 3, 1),
(26, 9,  10, 3, '2026-04-21', NULL, NULL, 1, 1);

-- ============================================================
-- tb_eventos_partido
-- ============================================================
CREATE TABLE `tb_eventos_partido` (
  `id_evento`       int(11) NOT NULL AUTO_INCREMENT,
  `id_partido`      int(11) DEFAULT NULL,
  `id_participante` int(11) DEFAULT NULL,
  `id_tipo_evento`  int(11) DEFAULT NULL,
  `minuto`          int(11) DEFAULT NULL,
  `comentarios`     text    DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `id_partido`      (`id_partido`),
  KEY `id_participante` (`id_participante`),
  KEY `id_tipo_evento`  (`id_tipo_evento`),
  FOREIGN KEY (`id_partido`)      REFERENCES `tb_partidos`     (`id_partido`)      ON DELETE CASCADE  ON UPDATE CASCADE,
  FOREIGN KEY (`id_participante`) REFERENCES `tb_participantes`(`id_participante`) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (`id_tipo_evento`)  REFERENCES `tb_tipos_evento` (`id_tipo_evento`)  ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_eventos_partido` (`id_evento`, `id_partido`, `id_participante`, `id_tipo_evento`, `minuto`, `comentarios`) VALUES
(1,1,1,1,12,''),(2,1,2,1,34,''),(3,1,5,1,55,''),(4,1,1,1,78,''),
(5,1,7,2,40,''),(6,2,15,1,22,''),(7,2,16,1,67,''),(8,2,9,2,30,''),
(9,2,13,2,80,''),(10,3,3,1,15,''),(11,3,11,1,28,''),(12,3,4,1,60,''),
(13,3,12,1,88,''),(14,4,6,1,45,''),(15,4,14,2,55,''),(16,4,16,3,70,''),
(17,5,13,1,10,''),(18,5,1,1,20,''),(19,5,2,1,35,''),(20,5,2,1,50,''),
(21,5,4,1,75,''),(22,5,15,2,60,''),(23,6,5,1,33,''),(24,6,8,1,71,''),
(25,6,10,2,45,''),(26,6,11,2,82,''),(27,7,1,1,23,''),(28,11,17,1,18,''),
(29,11,18,1,55,''),(30,11,19,2,44,''),(31,12,21,1,30,''),(32,12,17,1,65,''),
(33,13,21,1,10,''),(34,13,22,1,44,''),(35,13,21,1,88,''),(36,13,20,2,35,''),
(37,13,19,3,78,''),(38,14,17,1,15,''),(39,14,18,1,40,''),(40,14,22,1,55,''),
(41,17,23,1,38,''),(42,17,25,2,50,''),(43,18,27,1,20,''),(44,18,29,1,45,''),
(45,18,28,1,60,''),(46,18,30,1,85,''),(47,19,25,1,12,''),(48,19,26,1,34,''),
(49,19,27,1,56,''),(50,19,26,1,78,''),(51,19,28,2,40,''),(52,19,29,3,70,''),
(53,20,24,1,55,''),(54,20,30,2,30,''),(55,21,23,1,25,''),(56,21,24,1,70,''),
(57,22,25,1,44,''),(58,22,29,1,80,''),(59,23,23,1,18,'');

COMMIT;
