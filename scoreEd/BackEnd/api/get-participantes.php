<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

if (empty($_GET['id_equipo'])) responderError('id_equipo es requerido');

$stmt = $pdo->prepare("
    SELECT pa.id_participante, pa.nombre, pa.apellido
    FROM tb_plantilla pl
    JOIN tb_participantes pa ON pl.id_participante = pa.id_participante
    WHERE pl.id_equipo = ?
    ORDER BY pa.apellido ASC
");
$stmt->execute([(int)$_GET['id_equipo']]);
responder($stmt->fetchAll());
