<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';
require_once __DIR__ . '/../helpers/validaciones.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
$error = validarCampos($datos, ['nombre', 'anio']);
if ($error) responderError($error);

$stmt = $pdo->prepare("INSERT INTO tb_torneos (nombre, anio, descripcion, id_deporte) VALUES (?, ?, ?, ?)");
$stmt->execute([sanitizar($datos['nombre']), (int)$datos['anio'], sanitizar($datos['descripcion'] ?? ''), (int)($datos['id_deporte'] ?? 1)]);
responder(['mensaje' => 'Torneo creado', 'id' => $pdo->lastInsertId()], 201);
