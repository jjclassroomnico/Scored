<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../config/db.php';

try {
    $result = [];

    // Connection charset
    $stmt = $pdo->query("SELECT @@session.character_set_connection AS c");
    $result['charset'] = $stmt->fetch()['c'];

    // tb_torneos columns
    $stmt = $pdo->query("SHOW COLUMNS FROM tb_torneos");
    $cols = [];
    foreach ($stmt->fetchAll() as $col) {
        $cols[] = ['name' => $col['Field'], 'hex' => bin2hex($col['Field'])];
    }
    $result['tb_torneos'] = $cols;

    // tb_cursos columns
    try {
        $stmt = $pdo->query("SHOW COLUMNS FROM tb_cursos");
        $cols2 = [];
        foreach ($stmt->fetchAll() as $col) {
            $cols2[] = ['name' => $col['Field'], 'hex' => bin2hex($col['Field'])];
        }
        $result['tb_cursos'] = $cols2;
    } catch (Exception $e) {
        $result['tb_cursos'] = 'ERROR: ' . $e->getMessage();
    }

    // tb_deportes data
    try {
        $stmt = $pdo->query("SELECT id_deporte, nombre, hex(nombre) AS nombre_hex FROM tb_deportes ORDER BY id_deporte");
        $result['tb_deportes'] = $stmt->fetchAll();
    } catch (Exception $e) {
        $result['tb_deportes'] = 'ERROR: ' . $e->getMessage();
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage(), 'file' => $e->getFile(), 'line' => $e->getLine()]);
}
