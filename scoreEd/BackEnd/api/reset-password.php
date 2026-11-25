<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../config/db.php';

try {
    $email = $_GET['email'] ?? '';
    $pass = $_GET['pass'] ?? '';
    if (!$email || !$pass) { echo json_encode(['error' => 'Faltan email o pass']); exit; }

    // Detect column name
    $stmt = $pdo->query("SHOW COLUMNS FROM tb_admin");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    $passCol = 'contraseña';
    foreach ($cols as $c) {
        if ($c === 'password' || $c === 'contraseña' || stripos($c, 'pass') !== false || stripos($c, 'contr') !== false) {
            $passCol = $c; break;
        }
    }

    $hash = password_hash($pass, PASSWORD_DEFAULT);
    $stmt = $pdo->prepare("UPDATE tb_admin SET `$passCol` = ? WHERE email = ?");
    $stmt->execute([$hash, $email]);

    echo json_encode(['ok' => 'Contraseña actualizada', 'columna' => $passCol, 'hash' => $hash]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
