<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

if (!empty($_GET['id_torneo'])) {
    $stmt = $pdo->prepare("SELECT id_equipo, nombre FROM tb_equipos WHERE id_torneo = ?");
    $stmt->execute([(int)$_GET['id_torneo']]);
} else {
    $stmt = $pdo->query("SELECT e.id_equipo, e.nombre, e.id_torneo, t.nombre AS torneo FROM tb_equipos e LEFT JOIN tb_torneos t ON e.id_torneo = t.id_torneo");
}
responder($stmt->fetchAll());
