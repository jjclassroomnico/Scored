<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
if (empty($datos['partidos']) || !is_array($datos['partidos'])) responderError('Se requiere un array de partidos.');

$stmt = $pdo->prepare("INSERT INTO tb_partidos (id_equipo_local, id_equipo_visitante, id_torneo, fecha, id_arbitro, id_estado) VALUES (?, ?, ?, ?, ?, 1)");

foreach ($datos['partidos'] as $p) {
    if (empty($p['id_equipo_local']) || empty($p['id_equipo_visitante']) || empty($p['id_torneo']) || empty($p['fecha']) || empty($p['id_arbitro']))
        responderError('Todos los campos de cada partido son requeridos.');
    $stmt->execute([(int)$p['id_equipo_local'], (int)$p['id_equipo_visitante'], (int)$p['id_torneo'], $p['fecha'], (int)$p['id_arbitro']]);
}

responder(['mensaje' => 'Partidos creados correctamente'], 201);
