<?php
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../config/roles.php';
require_once __DIR__ . '/../helpers/respuesta.php';
require_once __DIR__ . '/../helpers/validaciones.php';

header('Content-Type: application/json; charset=utf-8');
requiereArbitro();

$datos = json_decode(file_get_contents('php://input'), true);
$error = validarCampos($datos, ['id_partido', 'id_participante', 'id_tipo_evento', 'minuto']);
if ($error) responderError($error);

$idPartido    = (int)$datos['id_partido'];
$idTipoEvento = (int)$datos['id_tipo_evento'];
$rolEquipo    = $datos['equipo_rol'] ?? '';

// Leer configuración del tipo de evento (afecta_marcador, valor, afecta_propio)
$stmtTipo = $pdo->prepare("SELECT afecta_marcador, valor, afecta_propio FROM tb_tipos_evento WHERE id_tipo_evento = ?");
$stmtTipo->execute([$idTipoEvento]);
$tipoEvento = $stmtTipo->fetch();
if (!$tipoEvento) responderError('Tipo de evento no válido');

$pdo->beginTransaction();

$stmt = $pdo->prepare("INSERT INTO tb_eventos_partido (id_partido, id_participante, id_tipo_evento, minuto, comentarios) VALUES (?, ?, ?, ?, ?)");
$stmt->execute([$idPartido, (int)$datos['id_participante'], $idTipoEvento, (int)$datos['minuto'], sanitizar($datos['comentarios'] ?? '')]);

// Actualizar marcador solo si el tipo de evento lo requiere
if ($tipoEvento['afecta_marcador'] && $rolEquipo) {
    $sumaAPropio    = (bool)$tipoEvento['afecta_propio'];
    $sumaALocal     = ($rolEquipo === 'local')     === $sumaAPropio;
    $campo          = $sumaALocal ? 'marcador_local' : 'marcador_visitante';
    $valor          = (int)$tipoEvento['valor'];
    $pdo->prepare("UPDATE tb_partidos SET $campo = COALESCE($campo, 0) + ? WHERE id_partido = ?")->execute([$valor, $idPartido]);
}

$pdo->commit();
responder(['mensaje' => 'Evento registrado', 'id' => $pdo->lastInsertId()], 201);
