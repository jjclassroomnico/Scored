<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

if (empty($_GET['id_partido'])) responderError('id_partido es requerido');

$stmt = $pdo->prepare("
    SELECT e.id_evento, e.minuto, e.comentarios,
           p.nombre, p.apellido, t.nombre AS tipo_evento
    FROM tb_eventos_partido e
    LEFT JOIN tb_participantes p ON e.id_participante = p.id_participante
    LEFT JOIN tb_tipos_evento t ON e.id_tipo_evento = t.id_tipo_evento
    WHERE e.id_partido = ?
    ORDER BY e.minuto ASC
");
$stmt->execute([(int)$_GET['id_partido']]);
responder($stmt->fetchAll());
