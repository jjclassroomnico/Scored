<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

$stmt = $pdo->query("
    SELECT p.id_partido, p.id_torneo, p.fecha, p.marcador_local, p.marcador_visitante,
           el.nombre AS equipo_local, ev.nombre AS equipo_visitante,
           p.id_equipo_local, p.id_equipo_visitante, p.id_arbitro,
           t.nombre AS torneo, a.nombre AS arbitro, es.nombre AS estado
    FROM tb_partidos p
    LEFT JOIN tb_equipos el ON p.id_equipo_local = el.id_equipo
    LEFT JOIN tb_equipos ev ON p.id_equipo_visitante = ev.id_equipo
    LEFT JOIN tb_torneos t ON p.id_torneo = t.id_torneo
    LEFT JOIN tb_arbitros a ON p.id_arbitro = a.id_arbitro
    LEFT JOIN tb_estados es ON p.id_estado = es.id_estado
    ORDER BY p.fecha ASC
");
responder($stmt->fetchAll());
