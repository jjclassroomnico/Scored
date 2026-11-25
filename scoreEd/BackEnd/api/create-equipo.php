<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';
require_once __DIR__ . '/../helpers/validaciones.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
$error = validarCampos($datos, ['nombre', 'id_torneo']);
if ($error) responderError($error);

$stmt = $pdo->prepare("INSERT INTO tb_equipos (nombre, id_torneo) VALUES (?, ?)");
$stmt->execute([sanitizar($datos['nombre']), (int)$datos['id_torneo']]);
responder(['mensaje' => 'Equipo creado', 'id' => $pdo->lastInsertId()], 201);
