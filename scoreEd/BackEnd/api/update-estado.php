<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');
requiereAutenticado();

$datos = json_decode(file_get_contents('php://input'), true);
if (empty($datos['id_partido']) || empty($datos['id_estado'])) responderError('id_partido e id_estado son requeridos');

$idPartido = (int)$datos['id_partido'];
$idEstado  = (int)$datos['id_estado'];

if ($idEstado === 2) {
    $stmt = $pdo->prepare(
        "SELECT COUNT(*) FROM tb_partidos WHERE id_arbitro = (SELECT id_arbitro FROM tb_partidos WHERE id_partido = ?) AND id_estado = 2 AND id_partido != ?"
    );
    $stmt->execute([$idPartido, $idPartido]);
    if ($stmt->fetchColumn() > 0) responderError('Ya tenés un partido en curso. Finalizalo antes de iniciar otro.', 409);
}

$stmt = $pdo->prepare("UPDATE tb_partidos SET id_estado = ? WHERE id_partido = ?");
$stmt->execute([$idEstado, $idPartido]);
responder(['mensaje' => 'Estado actualizado']);
