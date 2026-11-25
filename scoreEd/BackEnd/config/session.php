<?php
// Session-less auth using database tokens

function generarToken(): string {
    return bin2hex(random_bytes(32));
}

function iniciarSesion(PDO $pdo, int $id, string $rol, ?string $nombre = null): string {
    $token = generarToken();
    $expira = date('Y-m-d H:i:s', time() + 86400 * 7); // 7 días

    $stmt = $pdo->prepare("INSERT INTO tb_tokens (token, id_usuario, rol, nombre, expira) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([$token, $id, $rol, $nombre, $expira]);

    setcookie('token', $token, time() + 86400 * 7, '/scoreEd/', '', false, true);
    $_SESSION['id'] = $id;
    $_SESSION['rol'] = $rol;
    $_SESSION['nombre'] = $nombre;

    return $token;
}

function cerrarSesion(PDO $pdo): void {
    $token = $_COOKIE['token'] ?? '';
    if ($token) {
        $stmt = $pdo->prepare("DELETE FROM tb_tokens WHERE token = ?");
        $stmt->execute([$token]);
        setcookie('token', '', time() - 3600, '/scoreEd/', '', false, true);
    }
    session_unset();
    session_destroy();
}

function sesionActiva(): bool {
    return isset($_SESSION['id'], $_SESSION['rol']);
}

// Iniciar sesión PHP normal
$sessionIdHeader = $_SERVER['HTTP_X_SESSION_ID'] ?? '';
if ($sessionIdHeader && session_status() === PHP_SESSION_NONE) {
    session_id($sessionIdHeader);
    session_start();
} elseif (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Si no hay sesión PHP activa, intentar restaurar desde token cookie
if (!sesionActiva() && isset($_COOKIE['token'])) {
    try {
        global $pdo;
        if (isset($pdo)) {
            $stmt = $pdo->prepare("SELECT id_usuario, rol, nombre FROM tb_tokens WHERE token = ? AND expira > NOW()");
            $stmt->execute([$_COOKIE['token']]);
            $data = $stmt->fetch();
            if ($data) {
                $_SESSION['id'] = (int)$data['id_usuario'];
                $_SESSION['rol'] = $data['rol'];
                $_SESSION['nombre'] = $data['nombre'];
            }
        }
    } catch (Exception $e) {
        // Si falla (tabla no existe), continuar sin sesión
    }
}
