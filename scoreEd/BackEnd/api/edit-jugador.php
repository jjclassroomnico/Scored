<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';
require_once __DIR__ . '/../helpers/validaciones.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
$error = validarCampos($datos, ['id_participante', 'nombre', 'apellido', 'dni', 'id_equipo', 'id_curso']);
if ($error) responderError($error);

$pdo->beginTransaction();
$stmt = $pdo->prepare("UPDATE tb_participantes SET nombre = ?, apellido = ?, dni = ? WHERE id_participante = ?");
$stmt->execute([sanitizar($datos['nombre']), sanitizar($datos['apellido']), sanitizar($datos['dni']), (int)$datos['id_participante']]);

$stmt = $pdo->prepare("UPDATE tb_plantilla SET id_equipo = ?, id_curso = ? WHERE id_participante = ?");
$stmt->execute([(int)$datos['id_equipo'], (int)$datos['id_curso'], (int)$datos['id_participante']]);
$pdo->commit();

responder(['mensaje' => 'Jugador actualizado']);
