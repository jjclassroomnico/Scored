<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/session.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

try {
    $datos = json_decode(file_get_contents('php://input'), true);
    $email     = trim($datos['email'] ?? '');
    $contrasena = $datos['password'] ?? $datos['contraseña'] ?? '';

    if (empty($email) || empty($contrasena)) {
        responderError('Email y contraseña son requeridos');
    }

    // Admin login
    $stmt = $pdo->prepare("SELECT * FROM tb_admin WHERE email = ?");
    $stmt->execute([$email]);
    $admin = $stmt->fetch();

    if ($admin && password_verify($contrasena, $admin['contraseña'])) {
        iniciarSesion($pdo, $admin['id_admin'], 'admin');
        responder(['rol' => 'admin', 'session_id' => session_id()]);
    }

    if ($admin) {
        responderError('Contraseña incorrecta', 401);
    }

    // Árbitro login
    $stmt = $pdo->prepare("SELECT * FROM tb_arbitros WHERE email = ?");
    $stmt->execute([$email]);
    $arbitro = $stmt->fetch();

    if ($arbitro && password_verify($contrasena, $arbitro['contraseña'])) {
        iniciarSesion($pdo, $arbitro['id_arbitro'], 'arbitro', $arbitro['nombre'] ?? '');
        responder(['rol' => 'arbitro', 'nombre' => $arbitro['nombre'], 'id_arbitro' => (int)$arbitro['id_arbitro'], 'session_id' => session_id()]);
    }

    if ($arbitro) {
        responderError('Contraseña incorrecta', 401);
    }

    responderError('El email no está registrado', 401);
} catch (Exception $e) {
    responderError($e->getMessage(), 500);
}