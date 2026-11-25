<?php
require_once __DIR__ . '/../config/db.php';
header('Content-Type: application/json; charset=utf-8');

try {
    // Test 1: Simple select
    $stmt = $pdo->query("SELECT 1 AS test");
    $test1 = $stmt->fetch();

    // Test 2: Check tb_torneos columns
    $stmt = $pdo->query("DESCRIBE tb_torneos");
    $columns = $stmt->fetchAll(PDO::FETCH_COLUMN);

    // Test 3: Try query with año
    $stmt = $pdo->query("SELECT id_torneo, nombre FROM tb_torneos ORDER BY `año` DESC LIMIT 1");
    $data = $stmt->fetchAll();

    echo json_encode([
        'test_connection' => 'OK',
        'test_simple' => $test1,
        'columns' => $columns,
        'query_with_anyo' => $data
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage(), 'file' => $e->getFile(), 'line' => $e->getLine()]);
}
