<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');
requiereArbitro();

if (empty($_GET['id_partido'])) responderError('id_partido es requerido');

$stmt = $pdo->prepare("
    SELECT p.id_partido, p.fecha, p.marcador_local, p.marcador_visitante,
           p.id_equipo_local, p.id_equipo_visitante,
           el.nombre AS equipo_local, ev.nombre AS equipo_visitante,
           p.id_arbitro, p.id_estado, p.id_torneo,
           t.nombre AS torneo, t.id_deporte, d.nombre AS deporte,
           es.nombre AS estado
    FROM tb_partidos p
    LEFT JOIN tb_equipos el ON p.id_equipo_local = el.id_equipo
    LEFT JOIN tb_equipos ev ON p.id_equipo_visitante = ev.id_equipo
    LEFT JOIN tb_torneos t ON p.id_torneo = t.id_torneo
    LEFT JOIN tb_deportes d ON t.id_deporte = d.id_deporte
    LEFT JOIN tb_estados es ON p.id_estado = es.id_estado
    WHERE p.id_partido = ? AND p.id_arbitro = ?
");
$stmt->execute([(int)$_GET['id_partido'], $_SESSION['id']]);
$partido = $stmt->fetch();

if (!$partido) responderError('Partido no encontrado', 404);
responder($partido);
