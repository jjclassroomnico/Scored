<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
if (empty($datos['id_equipo'])) responderError('id_equipo es requerido');

$stmt = $pdo->prepare("DELETE FROM tb_equipos WHERE id_equipo = ?");
$stmt->execute([(int)$datos['id_equipo']]);
responder(['mensaje' => 'Equipo eliminado']);
