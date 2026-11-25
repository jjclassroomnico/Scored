<?php
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if (preg_match('#^https?://localhost(:\d+)?$#', $origin)) {
    header("Access-Control-Allow-Origin: $origin");
    header('Access-Control-Allow-Credentials: true');
} else {
    header('Access-Control-Allow-Origin: *');
}
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-Session-Id, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

function responder(array $data, int $codigo = 200) {
    header('Content-Type: application/json; charset=utf-8');
    http_response_code($codigo);
    echo json_encode($data);
    exit;
}

function responderError(string $mensaje, int $codigo = 400) {
    responder(['error' => $mensaje], $codigo);
}
