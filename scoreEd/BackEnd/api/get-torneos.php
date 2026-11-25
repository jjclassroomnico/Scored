<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

try {
    if (!empty($_GET['id_deporte'])) {
        $stmt = $pdo->prepare("SELECT * FROM tb_torneos WHERE id_deporte = ? ORDER BY id_torneo DESC");
        $stmt->execute([(int)$_GET['id_deporte']]);
    } else {
        $stmt = $pdo->query("SELECT * FROM tb_torneos ORDER BY id_torneo DESC");
    }
    responder($stmt->fetchAll());
} catch (Exception $e) {
    responderError($e->getMessage(), 500);
}
