<?php
require_once __DIR__ . '/../../BackEnd/config/db.php';
require_once __DIR__ . '/../../BackEnd/helpers/respuesta.php';

header('Content-Type: application/html');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    if (!$email || !$password) {
        echo "Email y contraseña son requeridos";
        exit;
    }

    $stmt = $pdo->prepare("SELECT COUNT(*) FROM tb_admin WHERE email = ?");
    $stmt->execute([$email]);
    if ($stmt->fetchColumn() > 0) {
        echo "El email ya está registrado";
        exit;
    }

    $hash = password_hash($password, PASSWORD_DEFAULT);
    $stmt = $pdo->prepare("INSERT INTO tb_admin (email, contraseña) VALUES (?, ?)");
    $stmt->execute([$email, $hash]);
    echo "Admin insertado correctamente.";
}
?>   