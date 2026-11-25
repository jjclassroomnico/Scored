<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';

header('Content-Type: application/json; charset=utf-8');

try {

$filtroTorneo = '';
$params = [];

if (!empty($_GET['id_torneo'])) {
    $filtroTorneo = ' AND p.id_torneo = ?';
    $params[] = (int)$_GET['id_torneo'];
}

// Detectar tipos de evento por nombre (case-insensitive), filtrado por deporte del torneo
$filtroDeporte = !empty($_GET['id_torneo'])
    ? ' AND te.id_deporte = (SELECT id_deporte FROM tb_torneos WHERE id_torneo = ' . (int)$_GET['id_torneo'] . ')'
    : '';

$tipos = $pdo->query("SELECT id_tipo_evento, LOWER(nombre) AS nombre FROM tb_tipos_evento te WHERE 1=1 $filtroDeporte")->fetchAll(PDO::FETCH_KEY_PAIR);

$idGol = $idAmarilla = $idRoja = null;
foreach ($tipos as $id => $nombre) {
    if (strpos($nombre, 'gol') !== false && strpos($nombre, 'contra') === false && !$idGol) $idGol      = $id;
    if (strpos($nombre, 'amarilla') !== false && !$idAmarilla)                             $idAmarilla = $id;
    if (strpos($nombre, 'roja') !== false && !$idRoja)                                    $idRoja     = $id;
}

// También incluir tipos que afectan marcador (doble, triple, tiro libre, set ganado…)
// para deportes sin "gol" — se agrupan todos bajo "anotaciones"
$anotaciones = [];
$stmtAnot = $pdo->prepare("
    SELECT pa.nombre AS jugador, eq.nombre AS equipo, SUM(te.valor) AS total
    FROM tb_eventos_partido e
    JOIN tb_tipos_evento te  ON e.id_tipo_evento  = te.id_tipo_evento
    JOIN tb_participantes pa ON e.id_participante = pa.id_participante
    JOIN tb_plantilla pl     ON pl.id_participante = pa.id_participante
    JOIN tb_equipos eq       ON pl.id_equipo = eq.id_equipo
    JOIN tb_partidos p       ON e.id_partido = p.id_partido
    WHERE te.afecta_marcador = 1 AND te.afecta_propio = 1 $filtroTorneo
    GROUP BY pa.id_participante, eq.id_equipo
    ORDER BY total DESC
    LIMIT 10
");
$stmtAnot->execute($params);
$anotaciones = $stmtAnot->fetchAll();

$amarillas = [];
if ($idAmarilla) {
    $stmt = $pdo->prepare("
        SELECT eq.nombre AS equipo, COUNT(*) AS tarjetas
        FROM tb_eventos_partido e
        JOIN tb_participantes pa ON e.id_participante = pa.id_participante
        JOIN tb_plantilla pl     ON pl.id_participante = pa.id_participante
        JOIN tb_equipos eq       ON pl.id_equipo = eq.id_equipo
        JOIN tb_partidos p       ON e.id_partido = p.id_partido
        WHERE e.id_tipo_evento = ? $filtroTorneo
        GROUP BY eq.id_equipo
        ORDER BY tarjetas DESC
        LIMIT 5
    ");
    $stmt->execute(array_merge([$idAmarilla], $params));
    $amarillas = $stmt->fetchAll();
}

$rojas = [];
if ($idRoja) {
    $stmt = $pdo->prepare("
        SELECT eq.nombre AS equipo, COUNT(*) AS tarjetas
        FROM tb_eventos_partido e
        JOIN tb_participantes pa ON e.id_participante = pa.id_participante
        JOIN tb_plantilla pl     ON pl.id_participante = pa.id_participante
        JOIN tb_equipos eq       ON pl.id_equipo = eq.id_equipo
        JOIN tb_partidos p       ON e.id_partido = p.id_partido
        WHERE e.id_tipo_evento = ? $filtroTorneo
        GROUP BY eq.id_equipo
        ORDER BY tarjetas DESC
        LIMIT 5
    ");
    $stmt->execute(array_merge([$idRoja], $params));
    $rojas = $stmt->fetchAll();
}

responder([
    'goleadores'         => $anotaciones,
    'tarjetas_amarillas' => $amarillas,
    'tarjetas_rojas'     => $rojas,
]);

} catch (Exception $e) {
    responderError($e->getMessage(), 500);
}
