<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
if (empty($datos['id_torneo'])) responderError('id_torneo es requerido');

$stmt = $pdo->prepare("DELETE FROM tb_torneos WHERE id_torneo = ?");
$stmt->execute([(int)$datos['id_torneo']]);
responder(['mensaje' => 'Torneo eliminado']);
