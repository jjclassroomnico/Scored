<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';
require_once __DIR__ . '/../helpers/validaciones.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
$error = validarCampos($datos, ['nombre', 'email', 'password']);
if ($error) responderError($error);

$stmt = $pdo->prepare("INSERT INTO tb_arbitros (nombre, email, contraseña) VALUES (?, ?, ?)");
$stmt->execute([sanitizar($datos['nombre']), sanitizar($datos['email']), password_hash($datos['password'], PASSWORD_DEFAULT)]);
responder(['mensaje' => 'Árbitro creado', 'id' => $pdo->lastInsertId()], 201);
