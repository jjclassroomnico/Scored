<?php
require_once __DIR__ . '/../config/session.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, no-cache, must-revalidate');
header('Pragma: no-cache');

if (!sesionActiva()) {
    responderError('No autenticado', 401);
}

responder([
    'id' => $_SESSION['id'],
    'rol' => $_SESSION['rol'],
    'nombre' => $_SESSION['nombre'] ?? null
]);
