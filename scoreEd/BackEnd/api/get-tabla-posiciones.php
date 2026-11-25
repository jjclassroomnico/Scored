<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../helpers/respuesta.php';
require_once __DIR__ . '/../helpers/calculos.php';

header('Content-Type: application/json; charset=utf-8');
try {

if (empty($_GET['id_torneo'])) responderError('id_torneo es requerido');
$idTorneo = (int)$_GET['id_torneo'];

$reglas = cargarReglas($pdo, $idTorneo);

$stmt = $pdo->prepare("
    SELECT p.id_equipo_local, p.id_equipo_visitante, p.marcador_local, p.marcador_visitante
    FROM tb_partidos p
    WHERE p.id_torneo = ? AND p.id_estado = 3
");
$stmt->execute([$idTorneo]);
$partidos = $stmt->fetchAll();

$tabla = [];
foreach ($partidos as $p) {
    foreach (['local', 'visitante'] as $rol) {
        $id = $rol === 'local' ? $p['id_equipo_local']  : $p['id_equipo_visitante'];
        $mf = $rol === 'local' ? $p['marcador_local']   : $p['marcador_visitante'];
        $mc = $rol === 'local' ? $p['marcador_visitante']: $p['marcador_local'];
        if (!isset($tabla[$id])) {
            $tabla[$id] = ['id_equipo' => $id, 'pj' => 0, 'pg' => 0, 'pe' => 0, 'pp' => 0, 'gf' => 0, 'gc' => 0, 'dg' => 0, 'pts' => 0];
        }
        $tabla[$id]['pj']++;
        $tabla[$id]['gf'] += (int)$mf;
        $tabla[$id]['gc'] += (int)$mc;
        $pts = calcularPuntos((int)$p['marcador_local'], (int)$p['marcador_visitante'], $rol, $reglas);
        $tabla[$id]['pts'] += $pts;
        $ptsVictoria = $reglas['victoria'] ?? 3;
        $ptsEmpate   = $reglas['empate']   ?? 1;
        if ($pts === $ptsVictoria)      $tabla[$id]['pg']++;
        elseif (isset($reglas['empate']) && $pts === $ptsEmpate) $tabla[$id]['pe']++;
        else                            $tabla[$id]['pp']++;
    }
}

$ids = implode(',', array_keys($tabla));
if ($ids) {
    $equipos = $pdo->query("SELECT id_equipo, nombre FROM tb_equipos WHERE id_equipo IN ($ids)")->fetchAll(PDO::FETCH_KEY_PAIR);
    foreach ($tabla as &$fila) {
        $fila['equipo'] = $equipos[$fila['id_equipo']] ?? '';
        $fila['dg']     = calcularDiferenciaMarcador($fila['gf'], $fila['gc']);
    }
}

usort($tabla, fn($a, $b) => $b['pts'] <=> $a['pts'] ?: $b['dg'] <=> $a['dg']);
responder(array_values($tabla));
} catch (Exception $e) {
    responderError($e->getMessage(), 500);
}
