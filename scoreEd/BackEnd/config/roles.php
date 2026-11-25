<?php
require_once __DIR__ . '/session.php';

function requiereRol(string $rolRequerido) {
    if (!sesionActiva() || $_SESSION['rol'] !== $rolRequerido) {
        http_response_code(403);
        echo json_encode(['error' => 'Acceso denegado']);
        exit;
    }
}

function requiereAdmin() {
    requiereRol('admin');
}

function requiereArbitro() {
    requiereRol('arbitro');
}

function requiereAutenticado() {
    if (!sesionActiva()) {
        http_response_code(401);
        echo json_encode(['error' => 'No autenticado']);
        exit;
    }
}
