<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';
require_once __DIR__ . '/../helpers/validaciones.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
$error = validarCampos($datos, ['id_equipo_local', 'id_equipo_visitante', 'id_torneo', 'fecha', 'id_arbitro']);
if ($error) responderError($error);
if ((int)$datos['id_equipo_local'] === (int)$datos['id_equipo_visitante']) responderError('El equipo local y visitante no pueden ser el mismo.');

$stmt = $pdo->prepare("INSERT INTO tb_partidos (id_equipo_local, id_equipo_visitante, id_torneo, fecha, id_arbitro, id_estado) VALUES (?, ?, ?, ?, ?, 1)");
$stmt->execute([(int)$datos['id_equipo_local'], (int)$datos['id_equipo_visitante'], (int)$datos['id_torneo'], $datos['fecha'], (int)$datos['id_arbitro']]);
responder(['mensaje' => 'Partido creado', 'id' => $pdo->lastInsertId()], 201);
