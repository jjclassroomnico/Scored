<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';
require_once __DIR__ . '/../helpers/validaciones.php';

header('Content-Type: application/json; charset=utf-8');
requiereAdmin();

$datos = json_decode(file_get_contents('php://input'), true);
$error = validarCampos($datos, ['id_arbitro', 'nombre', 'email']);
if ($error) responderError($error);

$campos = "nombre = ?, email = ?";
$valores = [sanitizar($datos['nombre']), sanitizar($datos['email'])];

if (!empty($datos['password'])) {
    $campos .= ", contraseña = ?";
    $valores[] = password_hash($datos['password'], PASSWORD_DEFAULT);
}
$valores[] = (int)$datos['id_arbitro'];

$stmt = $pdo->prepare("UPDATE tb_arbitros SET $campos WHERE id_arbitro = ?");
$stmt->execute($valores);
responder(['mensaje' => 'Árbitro actualizado']);
