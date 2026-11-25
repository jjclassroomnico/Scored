<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

try {

if (empty($_GET['id_partido'])) responderError('id_partido es requerido');
$id = (int)$_GET['id_partido'];

// Info del partido
$stmt = $pdo->prepare("
    SELECT p.id_partido, p.fecha, p.marcador_local, p.marcador_visitante,
           p.id_equipo_local, p.id_equipo_visitante,
           el.nombre AS equipo_local, ev.nombre AS equipo_visitante,
           p.id_arbitro, p.id_estado, p.id_torneo,
           t.nombre AS torneo, t.id_deporte, d.nombre AS deporte,
           es.nombre AS estado
    FROM tb_partidos p
    LEFT JOIN tb_equipos el ON p.id_equipo_local = el.id_equipo
    LEFT JOIN tb_equipos ev ON p.id_equipo_visitante = ev.id_equipo
    LEFT JOIN tb_torneos t  ON p.id_torneo = t.id_torneo
    LEFT JOIN tb_deportes d ON t.id_deporte = d.id_deporte
    LEFT JOIN tb_estados es ON p.id_estado = es.id_estado
    WHERE p.id_partido = ?
");
$stmt->execute([$id]);
$partido = $stmt->fetch();
if (!$partido) responderError('Partido no encontrado', 404);

// Plantilla local
$stmtPl = $pdo->prepare("
    SELECT pa.id_participante, pa.nombre, pa.apellido
    FROM tb_plantilla pl
    JOIN tb_participantes pa ON pl.id_participante = pa.id_participante
    WHERE pl.id_equipo = ?
    ORDER BY pa.apellido ASC
");
$stmtPl->execute([$partido['id_equipo_local']]);
$plantillaLocal = $stmtPl->fetchAll();

// Plantilla visitante
$stmtPl->execute([$partido['id_equipo_visitante']]);
$plantillaVisitante = $stmtPl->fetchAll();

// Eventos del partido
$stmtEv = $pdo->prepare("
    SELECT e.id_evento, e.id_partido, e.id_participante, e.id_tipo_evento,
           e.minuto, e.comentarios, pa.nombre, pa.apellido, te.nombre AS tipo
    FROM tb_eventos_partido e
    JOIN tb_participantes pa ON e.id_participante = pa.id_participante
    JOIN tb_tipos_evento te  ON e.id_tipo_evento  = te.id_tipo_evento
    WHERE e.id_partido = ?
    ORDER BY e.minuto ASC
");
$stmtEv->execute([$id]);
$eventos = $stmtEv->fetchAll();

responder([
    'partido'            => $partido,
    'plantilla_local'    => $plantillaLocal,
    'plantilla_visitante'=> $plantillaVisitante,
    'eventos'            => $eventos,
]);

} catch (Exception $e) {
    responderError($e->getMessage(), 500);
}
