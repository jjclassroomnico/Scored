<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

$stmt = $pdo->query("SELECT id_deporte, nombre, tiene_empate, unidad_marcador FROM tb_deportes ORDER BY id_deporte ASC");
responder($stmt->fetchAll());
