<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

try {
    $stmt = $pdo->query("SELECT * FROM tb_cursos ORDER BY id_curso ASC");
    responder($stmt->fetchAll());
} catch (Exception $e) {
    responderError($e->getMessage(), 500);
}
