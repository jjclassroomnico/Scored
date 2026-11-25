<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/session.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

cerrarSesion($pdo);
responder(['mensaje' => 'Sesión cerrada']);
