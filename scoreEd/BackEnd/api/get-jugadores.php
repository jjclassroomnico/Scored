<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

$sql = "
    SELECT p.id_participante, p.nombre, p.apellido, p.dni,
           pl.id_equipo, pl.id_curso,
           e.nombre AS equipo, '' AS anio, c.division
    FROM tb_participantes p
    LEFT JOIN tb_plantilla pl ON p.id_participante = pl.id_participante
    LEFT JOIN tb_equipos e ON pl.id_equipo = e.id_equipo
    LEFT JOIN tb_cursos c ON pl.id_curso = c.id_curso
";
$params = [];
if (!empty($_GET['id_deporte'])) {
    $sql .= " WHERE e.id_torneo IN (SELECT id_torneo FROM tb_torneos WHERE id_deporte = ?)";
    $params[] = (int)$_GET['id_deporte'];
}
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
responder($stmt->fetchAll());
