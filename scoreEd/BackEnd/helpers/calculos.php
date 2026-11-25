<?php
/**
 * Devuelve los puntos que corresponden según el resultado,
 * leyendo las reglas desde tb_reglas_puntos para el deporte del torneo.
 *
 * $reglas: array indexado por 'victoria'|'empate'|'derrota' => puntos
 *          (obtenido con cargarReglas())
 */
function calcularPuntos(int $marcadorLocal, int $marcadorVisitante, string $rol, array $reglas): int {
    if ($marcadorLocal > $marcadorVisitante) {
        $resultado = $rol === 'local' ? 'victoria' : 'derrota';
    } elseif ($marcadorLocal < $marcadorVisitante) {
        $resultado = $rol === 'visitante' ? 'victoria' : 'derrota';
    } else {
        $resultado = 'empate';
    }
    return $reglas[$resultado] ?? 0;
}

/**
 * Carga las reglas de puntos para el deporte de un torneo dado.
 * Retorna array ['victoria' => int, 'empate' => int, 'derrota' => int]
 */
function cargarReglas(PDO $pdo, int $idTorneo): array {
    $stmt = $pdo->prepare("
        SELECT rp.resultado, rp.puntos
        FROM tb_reglas_puntos rp
        JOIN tb_torneos t ON t.id_deporte = rp.id_deporte
        WHERE t.id_torneo = ?
    ");
    $stmt->execute([$idTorneo]);
    $reglas = [];
    foreach ($stmt->fetchAll() as $fila) {
        $reglas[$fila['resultado']] = (int)$fila['puntos'];
    }
    // Fallback: si no hay reglas definidas, usar fútbol estándar
    return $reglas ?: ['victoria' => 3, 'empate' => 1, 'derrota' => 0];
}

function calcularDiferenciaMarcador(int $marcadorAFavor, int $marcadorEnContra): int {
    return $marcadorAFavor - $marcadorEnContra;
}
