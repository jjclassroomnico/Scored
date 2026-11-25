<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../config/db.php';

try {
    $data = [];

    // Tablas de referencia (siempre limpias)
    $data['deportes'] = $pdo->query("SELECT * FROM tb_deportes")->fetchAll();
    $data['reglas_puntos'] = $pdo->query("SELECT * FROM tb_reglas_puntos")->fetchAll();
    $data['cursos'] = $pdo->query("SELECT * FROM tb_cursos")->fetchAll();
    $data['estados'] = $pdo->query("SELECT * FROM tb_estados")->fetchAll();
    $data['tipos_evento'] = $pdo->query("SELECT * FROM tb_tipos_evento")->fetchAll();

    // Torneos, equipos, participantes, plantilla
    $data['torneos'] = $pdo->query("SELECT * FROM tb_torneos")->fetchAll();
    $data['equipos'] = $pdo->query("SELECT * FROM tb_equipos")->fetchAll();
    $data['participantes'] = $pdo->query("SELECT * FROM tb_participantes")->fetchAll();
    $data['plantilla'] = $pdo->query("SELECT * FROM tb_plantilla")->fetchAll();

    // Partidos - solo los que tienen datos consistentes
    $stmtPartidos = $pdo->query("
        SELECT p.*, t.id_deporte
        FROM tb_partidos p
        LEFT JOIN tb_torneos t ON p.id_torneo = t.id_torneo
        WHERE p.id_equipo_local IS NOT NULL
          AND p.id_equipo_visitante IS NOT NULL
          AND p.id_torneo IS NOT NULL
    ");
    $data['partidos'] = $stmtPartidos->fetchAll();

    // Eventos - solo los que tienen participante válido
    $stmtEventos = $pdo->query("
        SELECT e.*
        FROM tb_eventos_partido e
        WHERE e.id_participante IS NOT NULL
          AND e.id_partido IS NOT NULL
    ");
    $data['eventos_partido'] = $stmtEventos->fetchAll();

    echo json_encode($data, JSON_UNESCAPED_UNICODE);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
