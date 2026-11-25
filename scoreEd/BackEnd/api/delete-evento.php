<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');
requiereArbitro();

$datos = json_decode(file_get_contents('php://input'), true);
if (empty($datos['id_evento'])) responderError('id_evento es requerido');

$idEvento = (int)$datos['id_evento'];

// Obtener el evento y la configuración de su tipo antes de borrarlo
$stmt = $pdo->prepare("
    SELECT e.id_partido, e.id_participante,
           te.afecta_marcador, te.valor, te.afecta_propio,
           p.id_equipo_local,
           pl.id_equipo AS id_equipo_jugador
    FROM tb_eventos_partido e
    JOIN tb_tipos_evento te ON e.id_tipo_evento = te.id_tipo_evento
    JOIN tb_partidos p      ON e.id_partido = p.id_partido
    JOIN tb_plantilla pl    ON e.id_participante = pl.id_participante
                           AND pl.id_equipo IN (p.id_equipo_local, p.id_equipo_visitante)
    WHERE e.id_evento = ?
");
$stmt->execute([$idEvento]);
$evento = $stmt->fetch();

if (!$evento) responderError('Evento no encontrado', 404);

$pdo->beginTransaction();

$pdo->prepare("DELETE FROM tb_eventos_partido WHERE id_evento = ?")->execute([$idEvento]);

// Revertir marcador si el tipo de evento lo afectaba
if ($evento['afecta_marcador']) {
    $esLocal     = $evento['id_equipo_jugador'] == $evento['id_equipo_local'];
    $sumaAPropio = (bool)$evento['afecta_propio'];
    $eraLocal    = $esLocal === $sumaAPropio;
    $campo       = $eraLocal ? 'marcador_local' : 'marcador_visitante';
    $valor       = (int)$evento['valor'];
    $pdo->prepare("UPDATE tb_partidos SET $campo = GREATEST(COALESCE($campo, 0) - ?, 0) WHERE id_partido = ?")
        ->execute([$valor, $evento['id_partido']]);
}

$pdo->commit();
responder(['mensaje' => 'Evento eliminado']);
