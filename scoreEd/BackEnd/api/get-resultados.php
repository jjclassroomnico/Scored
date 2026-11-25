<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');
try {

$where = "p.id_estado IN (2, 3)";
$params = [];

if (!empty($_GET['id_torneo'])) {
    $where .= " AND p.id_torneo = ?";
    $params[] = (int)$_GET['id_torneo'];
}

if (!empty($_GET['id_deporte'])) {
    $where .= " AND t.id_deporte = ?";
    $params[] = (int)$_GET['id_deporte'];
}

$stmt = $pdo->prepare("
    SELECT p.id_partido, p.fecha, p.marcador_local, p.marcador_visitante,
           el.nombre AS equipo_local, ev.nombre AS equipo_visitante,
           t.nombre AS torneo, es.nombre AS estado
    FROM tb_partidos p
    LEFT JOIN tb_equipos el ON p.id_equipo_local = el.id_equipo
    LEFT JOIN tb_equipos ev ON p.id_equipo_visitante = ev.id_equipo
    LEFT JOIN tb_torneos t ON p.id_torneo = t.id_torneo
    LEFT JOIN tb_estados es ON p.id_estado = es.id_estado
    WHERE $where
    ORDER BY p.fecha DESC
");
$stmt->execute($params);
responder($stmt->fetchAll());
} catch (Exception $e) {
    responderError($e->getMessage(), 500);
}
