<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');
try {

$where = "p.id_estado = 1";
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
    SELECT p.id_partido, p.fecha,
           el.nombre AS equipo_local,
           ev.nombre AS equipo_visitante,
           t.nombre AS torneo
    FROM tb_partidos p
    LEFT JOIN tb_equipos el ON p.id_equipo_local = el.id_equipo
    LEFT JOIN tb_equipos ev ON p.id_equipo_visitante = ev.id_equipo
    LEFT JOIN tb_torneos t ON p.id_torneo = t.id_torneo
    WHERE $where
    ORDER BY p.fecha ASC
");
$stmt->execute($params);
responder($stmt->fetchAll());
} catch (Exception $e) {
    responderError($e->getMessage(), 500);
}
