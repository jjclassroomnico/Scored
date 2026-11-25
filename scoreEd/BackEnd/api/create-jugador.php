<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';
require_once __DIR__ . '/../helpers/validaciones.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
$error = validarCampos($datos, ['nombre', 'apellido', 'dni', 'id_equipo', 'id_curso']);
if ($error) responderError($error);

$pdo->beginTransaction();
$stmt = $pdo->prepare("INSERT INTO tb_participantes (nombre, apellido, dni) VALUES (?, ?, ?)");
$stmt->execute([sanitizar($datos['nombre']), sanitizar($datos['apellido']), sanitizar($datos['dni'])]);
$idParticipante = $pdo->lastInsertId();

$stmt = $pdo->prepare("INSERT INTO tb_plantilla (id_equipo, id_participante, id_curso) VALUES (?, ?, ?)");
$stmt->execute([(int)$datos['id_equipo'], $idParticipante, (int)$datos['id_curso']]);
$pdo->commit();

responder(['mensaje' => 'Jugador creado', 'id' => $idParticipante], 201);
