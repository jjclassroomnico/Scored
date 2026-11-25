-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-05-2026 a las 22:11:23
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `scored`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_admin`
--

CREATE TABLE `tb_admin` (
  `id_admin` int(11) NOT NULL,
  `email` text DEFAULT NULL,
  `contraseña` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_admin`
--

INSERT INTO `tb_admin` (`id_admin`, `email`, `contraseña`) VALUES
(1, 'admin@torneo.com', '$2y$10$vVThX.dFLGvZ5N1B8ydTx.SBfihe0ONq7AJXCccrRDuMEi.VX71Cy'),
(2, 'soporte@torneo.com', 'pass456');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_arbitros`
--

CREATE TABLE `tb_arbitros` (
  `id_arbitro` int(11) NOT NULL,
  `email` text DEFAULT NULL,
  `contraseña` varchar(255) DEFAULT NULL,
  `nombre` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_arbitros`
--

INSERT INTO `tb_arbitros` (`id_arbitro`, `email`, `contraseña`, `nombre`) VALUES
(1, 'collina@referee.com', '$2y$10$5qqUoW.ay2iSC2GKRbgt9eSwa7pNEu9Ian92o.PpkV32WUS.PW.rK', 'Pierluigi Collina'),
(2, 'webb@referee.com', '$2y$10$yAIDJTLGjPK31Q7YcQWhMOfewXwavXXnE9hsdkJRGTiXLXMLIXD76', 'Howard Webb'),
(3, 'larronda@referee.com', '$2y$10$6ngrswbQrgbfaW7xz8vtmut6iECNrPkORZH1vFQCYOeDeeK0tNz/W', 'Jorge Larrionda');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_cursos`
--

CREATE TABLE `tb_cursos` (
  `id_curso` int(11) NOT NULL,
  `año` int(11) DEFAULT NULL,
  `division` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_cursos`
--

INSERT INTO `tb_cursos` (`id_curso`, `año`, `division`) VALUES
(1, 5, 1),
(2, 5, 2),
(3, 6, 1),
(4, 6, 2),
(5, 7, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_equipos`
--

CREATE TABLE `tb_equipos` (
  `id_equipo` int(11) NOT NULL,
  `nombre` text DEFAULT NULL,
  `id_torneo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_equipos`
--

INSERT INTO `tb_equipos` (`id_equipo`, `nombre`, `id_torneo`) VALUES
(1, 'Los Galacticos', 1),
(2, 'Pibes del Fondo', 1),
(3, 'La Banda del Sur', 1),
(4, 'Villa Crespo FC', 1),
(5, 'Los Choris', 2),
(6, 'Mateo y Compania', 2),
(7, 'Los Equilibrados', 2),
(8, 'Palermo United', 3),
(9, 'Boedo Warriors', 3),
(10, 'San Telmo Juniors', 3),
(11, 'Belgrano Boys', 3),
(12, 'prueba', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_estados`
--

CREATE TABLE `tb_estados` (
  `id_estado` int(11) NOT NULL,
  `nombre` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_estados`
--

INSERT INTO `tb_estados` (`id_estado`, `nombre`) VALUES
(1, 'Programado'),
(2, 'En Curso'),
(3, 'Finalizado'),
(4, 'Suspendido');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_eventos_partido`
--

CREATE TABLE `tb_eventos_partido` (
  `id_evento` int(11) NOT NULL,
  `id_partido` int(11) DEFAULT NULL,
  `id_participante` int(11) DEFAULT NULL,
  `id_tipo_evento` int(11) DEFAULT NULL,
  `minuto` int(11) DEFAULT NULL,
  `comentarios` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_eventos_partido`
--

INSERT INTO `tb_eventos_partido` (`id_evento`, `id_partido`, `id_participante`, `id_tipo_evento`, `minuto`, `comentarios`) VALUES
(1, 1, 1, 1, 12, ''),
(2, 1, 2, 1, 34, ''),
(3, 1, 5, 1, 55, ''),
(4, 1, 1, 1, 78, ''),
(5, 1, 7, 2, 40, ''),
(6, 2, 15, 1, 22, ''),
(7, 2, 16, 1, 67, ''),
(8, 2, 9, 2, 30, ''),
(9, 2, 13, 2, 80, ''),
(10, 3, 3, 1, 15, ''),
(11, 3, 11, 1, 28, ''),
(12, 3, 4, 1, 60, ''),
(13, 3, 12, 1, 88, ''),
(14, 4, 6, 1, 45, ''),
(15, 4, 14, 2, 55, ''),
(16, 4, 16, 3, 70, ''),
(17, 5, 13, 1, 10, ''),
(18, 5, 1, 1, 20, ''),
(19, 5, 2, 1, 35, ''),
(20, 5, 2, 1, 50, ''),
(21, 5, 4, 1, 75, ''),
(22, 5, 15, 2, 60, ''),
(23, 6, 5, 1, 33, ''),
(24, 6, 8, 1, 71, ''),
(25, 6, 10, 2, 45, ''),
(26, 6, 11, 2, 82, ''),
(27, 7, 1, 1, 23, ''),
(28, 11, 17, 1, 18, ''),
(29, 11, 18, 1, 55, ''),
(30, 11, 19, 2, 44, ''),
(31, 12, 21, 1, 30, ''),
(32, 12, 17, 1, 65, ''),
(33, 13, 21, 1, 10, ''),
(34, 13, 22, 1, 44, ''),
(35, 13, 21, 1, 88, ''),
(36, 13, 20, 2, 35, ''),
(37, 13, 19, 3, 78, ''),
(38, 14, 17, 1, 15, ''),
(39, 14, 18, 1, 40, ''),
(40, 14, 22, 1, 55, ''),
(41, 17, 23, 1, 38, ''),
(42, 17, 25, 2, 50, ''),
(43, 18, 27, 1, 20, ''),
(44, 18, 29, 1, 45, ''),
(45, 18, 28, 1, 60, ''),
(46, 18, 30, 1, 85, ''),
(47, 19, 25, 1, 12, ''),
(48, 19, 26, 1, 34, ''),
(49, 19, 27, 1, 56, ''),
(50, 19, 26, 1, 78, ''),
(51, 19, 28, 2, 40, ''),
(52, 19, 29, 3, 70, ''),
(53, 20, 24, 1, 55, ''),
(54, 20, 30, 2, 30, ''),
(55, 21, 23, 1, 25, ''),
(56, 21, 24, 1, 70, ''),
(57, 22, 25, 1, 44, ''),
(58, 22, 29, 1, 80, ''),
(59, 23, 23, 1, 18, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_participantes`
--

CREATE TABLE `tb_participantes` (
  `id_participante` int(11) NOT NULL,
  `nombre` text DEFAULT NULL,
  `apellido` text DEFAULT NULL,
  `dni` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_participantes`
--

INSERT INTO `tb_participantes` (`id_participante`, `nombre`, `apellido`, `dni`) VALUES
(1, 'Lionel', 'Messi', '10101010'),
(2, 'Julian', 'Alvarez', '90909090'),
(3, 'Rodrigo', 'De Paul', '22334455'),
(4, 'Angel', 'Di Maria', '33445566'),
(5, 'Lautaro', 'Martinez', '44556677'),
(6, 'Nicolas', 'Gonzalez', '55667788'),
(7, 'Exequiel', 'Palacios', '66778899'),
(8, 'Leandro', 'Paredes', '77889900'),
(9, 'German', 'Pezzella', '88990011'),
(10, 'Marcos', 'Acuna', '99001122'),
(11, 'Guido', 'Rodriguez', '11223344'),
(12, 'Thiago', 'Almada', '12345678'),
(13, 'Valentin', 'Carboni', '23456789'),
(14, 'Facundo', 'Buonanotte', '34567890'),
(15, 'Matias', 'Soule', '45678901'),
(16, 'Alejandro', 'Garnacho', '56789012'),
(17, 'Ezequiel', 'Barco', '67890123'),
(18, 'Tomas', 'Cuello', '78901234'),
(19, 'Mateo', 'Retegui', '89012345'),
(20, 'Gino', 'Infantino', '90123456'),
(21, 'Franco', 'Mastantuono', '01234567'),
(22, 'Claudio', 'Echeverri', '13579246'),
(23, 'Bruno', 'Zuculini', '24681357'),
(24, 'Ramiro', 'Funes Mori', '35792468'),
(25, 'Diego', 'Valdez', '46813579'),
(26, 'Sebastian', 'Driussi', '57924680'),
(27, 'Ignacio', 'Fernandez', '68035791'),
(28, 'Agustin', 'Urzi', '79146802'),
(29, 'Nicolas', 'Orsini', '80257913'),
(30, 'Cristian', 'Pavon', '91368024'),
(31, 'aaa', 'sss', '1234135'),
(32, 'gghhgg', 'jjyyuu', '2352465246');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_partidos`
--

CREATE TABLE `tb_partidos` (
  `id_partido` int(11) NOT NULL,
  `id_equipo_local` int(11) DEFAULT NULL,
  `id_equipo_visitante` int(11) DEFAULT NULL,
  `id_torneo` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `goles_local` int(11) DEFAULT NULL,
  `goles_visitante` int(11) DEFAULT NULL,
  `id_arbitro` int(11) DEFAULT NULL,
  `id_estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_partidos`
--

INSERT INTO `tb_partidos` (`id_partido`, `id_equipo_local`, `id_equipo_visitante`, `id_torneo`, `fecha`, `goles_local`, `goles_visitante`, `id_arbitro`, `id_estado`) VALUES
(1, 1, 2, 1, '2026-03-10', 3, 1, 1, 3),
(2, 3, 4, 1, '2026-03-10', 0, 2, 2, 3),
(3, 1, 3, 1, '2026-03-17', 2, 2, 1, 3),
(4, 2, 4, 1, '2026-03-17', 1, 0, 3, 3),
(5, 4, 1, 1, '2026-03-24', 1, 4, 2, 3),
(6, 2, 3, 1, '2026-03-24', 2, 0, 1, 3),
(7, 1, 4, 1, '2026-04-07', 1, 0, 2, 2),
(8, 2, 3, 1, '2026-04-14', NULL, NULL, 3, 1),
(9, 3, 1, 1, '2026-04-21', NULL, NULL, 1, 1),
(10, 4, 2, 1, '2026-04-21', NULL, NULL, 2, 1),
(11, 5, 6, 2, '2026-03-15', 2, 0, 1, 3),
(12, 7, 5, 2, '2026-03-15', 1, 1, 2, 3),
(13, 6, 7, 2, '2026-03-22', 0, 3, 3, 3),
(14, 5, 7, 2, '2026-04-07', 2, 1, 1, 2),
(15, 6, 5, 2, '2026-04-14', NULL, NULL, 2, 1),
(16, 7, 6, 2, '2026-04-14', NULL, NULL, 3, 1),
(17, 8, 9, 3, '2026-03-08', 1, 0, 1, 3),
(18, 10, 11, 3, '2026-03-08', 2, 2, 2, 3),
(19, 9, 10, 3, '2026-03-15', 3, 1, 3, 3),
(20, 11, 8, 3, '2026-03-15', 0, 1, 1, 3),
(21, 8, 10, 3, '2026-03-22', 2, 0, 2, 3),
(22, 9, 11, 3, '2026-03-22', 1, 1, 3, 3),
(23, 10, 8, 3, '2026-04-07', 0, 1, 1, 2),
(24, 11, 9, 3, '2026-04-14', NULL, NULL, 2, 1),
(25, 8, 11, 3, '2026-04-21', NULL, NULL, 3, 1),
(26, 9, 10, 3, '2026-04-21', NULL, NULL, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_plantilla`
--

CREATE TABLE `tb_plantilla` (
  `id_plantilla` int(11) NOT NULL,
  `id_equipo` int(11) DEFAULT NULL,
  `id_participante` int(11) DEFAULT NULL,
  `id_curso` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_plantilla`
--

INSERT INTO `tb_plantilla` (`id_plantilla`, `id_equipo`, `id_participante`, `id_curso`) VALUES
(1, 1, 1, 3),
(2, 1, 2, 3),
(3, 1, 3, 4),
(4, 1, 4, 4),
(5, 2, 5, 1),
(6, 2, 6, 1),
(7, 2, 7, 2),
(8, 2, 8, 2),
(9, 3, 9, 3),
(10, 3, 10, 3),
(11, 3, 11, 4),
(12, 3, 12, 4),
(13, 4, 13, 1),
(14, 4, 14, 1),
(15, 4, 15, 2),
(16, 4, 16, 2),
(17, 5, 17, 1),
(18, 5, 18, 1),
(19, 6, 19, 2),
(20, 6, 20, 2),
(21, 7, 21, 3),
(22, 7, 22, 3),
(23, 8, 23, 4),
(24, 8, 24, 4),
(25, 9, 25, 5),
(26, 9, 26, 5),
(27, 10, 27, 1),
(28, 10, 28, 1),
(29, 11, 29, 2),
(30, 11, 30, 2),
(31, 12, 31, 2),
(32, 12, 32, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tipos_evento`
--

CREATE TABLE `tb_tipos_evento` (
  `id_tipo_evento` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_tipos_evento`
--

INSERT INTO `tb_tipos_evento` (`id_tipo_evento`, `nombre`) VALUES
(1, 'Gol'),
(2, 'Tarjeta Amarilla'),
(3, 'Tarjeta Roja'),
(4, 'Gol en contra');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_torneos`
--

CREATE TABLE `tb_torneos` (
  `id_torneo` int(11) NOT NULL,
  `nombre` text DEFAULT NULL,
  `año` int(11) DEFAULT NULL,
  `descripción` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tb_torneos`
--

INSERT INTO `tb_torneos` (`id_torneo`, `nombre`, `año`, `descripción`) VALUES
(1, 'Copa de Campeones Escolar', 2026, 'Torneo anual de secundaria'),
(2, 'Torneo Relampago Otono', 2026, 'Torneo corto de fin de semana'),
(3, 'Liga Intercolegial 2026', 2026, 'Liga entre colegios del distrito');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tb_admin`
--
ALTER TABLE `tb_admin`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indices de la tabla `tb_arbitros`
--
ALTER TABLE `tb_arbitros`
  ADD PRIMARY KEY (`id_arbitro`);

--
-- Indices de la tabla `tb_cursos`
--
ALTER TABLE `tb_cursos`
  ADD PRIMARY KEY (`id_curso`);

--
-- Indices de la tabla `tb_equipos`
--
ALTER TABLE `tb_equipos`
  ADD PRIMARY KEY (`id_equipo`),
  ADD KEY `id_torneo` (`id_torneo`);

--
-- Indices de la tabla `tb_estados`
--
ALTER TABLE `tb_estados`
  ADD PRIMARY KEY (`id_estado`);

--
-- Indices de la tabla `tb_eventos_partido`
--
ALTER TABLE `tb_eventos_partido`
  ADD PRIMARY KEY (`id_evento`),
  ADD KEY `id_partido` (`id_partido`),
  ADD KEY `id_participante` (`id_participante`),
  ADD KEY `id_tipo_evento` (`id_tipo_evento`);

--
-- Indices de la tabla `tb_participantes`
--
ALTER TABLE `tb_participantes`
  ADD PRIMARY KEY (`id_participante`);

--
-- Indices de la tabla `tb_partidos`
--
ALTER TABLE `tb_partidos`
  ADD PRIMARY KEY (`id_partido`),
  ADD KEY `id_equipo_local` (`id_equipo_local`),
  ADD KEY `id_equipo_visitante` (`id_equipo_visitante`),
  ADD KEY `id_torneo` (`id_torneo`),
  ADD KEY `id_arbitro` (`id_arbitro`),
  ADD KEY `id_estado` (`id_estado`);

--
-- Indices de la tabla `tb_plantilla`
--
ALTER TABLE `tb_plantilla`
  ADD PRIMARY KEY (`id_plantilla`),
  ADD KEY `id_equipo` (`id_equipo`),
  ADD KEY `id_participante` (`id_participante`),
  ADD KEY `id_curso` (`id_curso`);

--
-- Indices de la tabla `tb_tipos_evento`
--
ALTER TABLE `tb_tipos_evento`
  ADD PRIMARY KEY (`id_tipo_evento`);

--
-- Indices de la tabla `tb_torneos`
--
ALTER TABLE `tb_torneos`
  ADD PRIMARY KEY (`id_torneo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tb_admin`
--
ALTER TABLE `tb_admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tb_arbitros`
--
ALTER TABLE `tb_arbitros`
  MODIFY `id_arbitro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tb_cursos`
--
ALTER TABLE `tb_cursos`
  MODIFY `id_curso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tb_equipos`
--
ALTER TABLE `tb_equipos`
  MODIFY `id_equipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `tb_estados`
--
ALTER TABLE `tb_estados`
  MODIFY `id_estado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tb_eventos_partido`
--
ALTER TABLE `tb_eventos_partido`
  MODIFY `id_evento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT de la tabla `tb_participantes`
--
ALTER TABLE `tb_participantes`
  MODIFY `id_participante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `tb_partidos`
--
ALTER TABLE `tb_partidos`
  MODIFY `id_partido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `tb_plantilla`
--
ALTER TABLE `tb_plantilla`
  MODIFY `id_plantilla` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `tb_tipos_evento`
--
ALTER TABLE `tb_tipos_evento`
  MODIFY `id_tipo_evento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tb_torneos`
--
ALTER TABLE `tb_torneos`
  MODIFY `id_torneo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tb_equipos`
--
ALTER TABLE `tb_equipos`
  ADD CONSTRAINT `tb_equipos_ibfk_1` FOREIGN KEY (`id_torneo`) REFERENCES `tb_torneos` (`id_torneo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tb_eventos_partido`
--
ALTER TABLE `tb_eventos_partido`
  ADD CONSTRAINT `tb_eventos_partido_ibfk_1` FOREIGN KEY (`id_partido`) REFERENCES `tb_partidos` (`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tb_eventos_partido_ibfk_2` FOREIGN KEY (`id_participante`) REFERENCES `tb_participantes` (`id_participante`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `tb_eventos_partido_ibfk_3` FOREIGN KEY (`id_tipo_evento`) REFERENCES `tb_tipos_evento` (`id_tipo_evento`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tb_partidos`
--
ALTER TABLE `tb_partidos`
  ADD CONSTRAINT `tb_partidos_ibfk_1` FOREIGN KEY (`id_equipo_local`) REFERENCES `tb_equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tb_partidos_ibfk_2` FOREIGN KEY (`id_equipo_visitante`) REFERENCES `tb_equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tb_partidos_ibfk_3` FOREIGN KEY (`id_torneo`) REFERENCES `tb_torneos` (`id_torneo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tb_partidos_ibfk_4` FOREIGN KEY (`id_arbitro`) REFERENCES `tb_arbitros` (`id_arbitro`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `tb_partidos_ibfk_5` FOREIGN KEY (`id_estado`) REFERENCES `tb_estados` (`id_estado`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `tb_plantilla`
--
ALTER TABLE `tb_plantilla`
  ADD CONSTRAINT `tb_plantilla_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `tb_equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tb_plantilla_ibfk_2` FOREIGN KEY (`id_participante`) REFERENCES `tb_participantes` (`id_participante`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tb_plantilla_ibfk_3` FOREIGN KEY (`id_curso`) REFERENCES `tb_cursos` (`id_curso`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
