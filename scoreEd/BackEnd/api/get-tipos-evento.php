<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

// Si se pasa id_torneo, filtra por el deporte del torneo
if (!empty($_GET['id_torneo'])) {
    $stmt = $pdo->prepare("
        SELECT te.id_tipo_evento, te.nombre, te.afecta_marcador, te.valor, te.afecta_propio
        FROM tb_tipos_evento te
        JOIN tb_torneos t ON t.id_deporte = te.id_deporte
        WHERE t.id_torneo = ?
        ORDER BY te.id_tipo_evento ASC
    ");
    $stmt->execute([(int)$_GET['id_torneo']]);
} else {
    $stmt = $pdo->query("SELECT id_tipo_evento, nombre, afecta_marcador, valor, afecta_propio FROM tb_tipos_evento ORDER BY id_tipo_evento ASC");
}
responder($stmt->fetchAll());
