<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

$stmt = $pdo->query("SELECT id_arbitro, nombre, email FROM tb_arbitros");
responder($stmt->fetchAll());
