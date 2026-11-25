<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';
require_once __DIR__ . '/../helpers/validaciones.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
$error = validarCampos($datos, ['id_partido', 'id_equipo_local', 'id_equipo_visitante', 'id_torneo', 'fecha', 'id_arbitro']);
if ($error) responderError($error);
if ((int)$datos['id_equipo_local'] === (int)$datos['id_equipo_visitante']) responderError('El equipo local y visitante no pueden ser el mismo.');

$stmt = $pdo->prepare("UPDATE tb_partidos SET id_equipo_local=?, id_equipo_visitante=?, id_torneo=?, fecha=?, marcador_local=?, marcador_visitante=?, id_arbitro=? WHERE id_partido=?");
$stmt->execute([
    (int)$datos['id_equipo_local'],
    (int)$datos['id_equipo_visitante'],
    (int)$datos['id_torneo'],
    $datos['fecha'],
    isset($datos['marcador_local'])     ? (int)$datos['marcador_local']     : null,
    isset($datos['marcador_visitante']) ? (int)$datos['marcador_visitante'] : null,
    (int)$datos['id_arbitro'],
    (int)$datos['id_partido']
]);
responder(['mensaje' => 'Partido actualizado']);
