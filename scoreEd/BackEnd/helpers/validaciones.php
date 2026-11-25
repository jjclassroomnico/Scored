<?php
function validarCampos(array $datos, array $requeridos): ?string {
    foreach ($requeridos as $campo) {
        if (!isset($datos[$campo]) || trim($datos[$campo]) === '') {
            return "El campo '$campo' es requerido";
        }
    }
    return null;
}

function sanitizar(string $valor): string {
    return htmlspecialchars(strip_tags(trim($valor)));
}
