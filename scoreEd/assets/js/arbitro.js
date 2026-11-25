const BASE = '/scoreEd';
const colores = ['#f97316','#3b82f6','#eab308','#22c55e','#a855f7','#ef4444','#14b8a6','#f43f5e'];
let sesion = null;
let partidoVivo = null;

async function init() {
    const s = await sbRequireAuth('arbitro');
    if (!s) return;
    sesion = s;
    document.getElementById('header-nombre').textContent = s.profile.nombre || 'Árbitro';
    cargarPartidos();
}

document.getElementById('btn-salir').addEventListener('click', async () => {
    await sbLogout();
    history.replaceState(null, '', BASE + '/views/arbitro/login.html');
    window.location.href = BASE + '/views/arbitro/login.html';
});

async function cargarPartidos() {
    const data = await sbData.getPartidosArbitro();

    document.getElementById('count-badge').textContent = `${data.length} partidos`;

    const enCurso     = data.filter(p => p.estado?.toLowerCase().includes('curso'));
    const programados = data.filter(p => p.estado?.toLowerCase().includes('programado'));
    const finalizados = data.filter(p => p.estado?.toLowerCase().includes('finalizado'));

    if (enCurso.length) {
        partidoVivo = enCurso[0];
        document.getElementById('badge-live').style.display = 'inline-flex';
        await renderVivo(partidoVivo);
    } else {
        partidoVivo = null;
        document.getElementById('badge-live').style.display = 'none';
        document.getElementById('seccion-vivo').innerHTML =
            '<div class="sin-partido">⚽ No hay ningún partido en curso actualmente</div>';
    }

    let html = '';
    if (programados.length) html += programados.map(p => itemPartido(p, true)).join('');
    if (finalizados.length) {
        html += '<div class="seccion-label">Finalizados</div>';
        html += finalizados.map(p => itemPartido(p, false)).join('');
    }
    document.getElementById('lista-partidos').innerHTML = html ||
        '<div style="padding:2rem;text-align:center;color:#94a3b8">No tenés partidos asignados</div>';
}

function itemPartido(p, mostrarIniciar) {
    const badge = p.estado?.toLowerCase().includes('finalizado')
        ? '<span class="badge badge-finalizado">Finalizado</span>'
        : '<span class="badge badge-programado">Prog.</span>';
    const score = p.marcador_local != null ? `${p.marcador_local} - ${p.marcador_visitante}` : '';
    return `<div class="partido-item">
        <div class="partido-item-info">
            <div class="partido-item-equipos">
                <span class="dot" style="background:${colores[0]}"></span> ${p.equipo_local}
                <span style="color:#94a3b8;font-weight:400">vs</span>
                <span class="dot" style="background:${colores[1]}"></span> ${p.equipo_visitante}
                ${score ? `<strong style="margin-left:.25rem">${score}</strong>` : ''}
            </div>
            <div class="partido-item-meta">${p.fecha} · ${p.torneo ?? ''}</div>
        </div>
        ${mostrarIniciar ? (partidoVivo ? '' : `<button class="btn-iniciar" onclick="iniciarPartido(${p.id_partido})">▷ Iniciar</button>`) : badge}
    </div>`;
}

async function renderVivo(p) {
    const detalle = await sbData.getPartidoDetalle(p.id_partido);
    const tipos   = await sbData.getTiposEvento(p.id_torneo);

    const jugLocal   = detalle.plantilla_local || [];
    const jugVisit   = detalle.plantilla_visitante || [];
    const eventos    = detalle.eventos || [];
    const partido    = detalle.partido;

    const ini = partido.equipo_local.charAt(0).toUpperCase();
    const inv = partido.equipo_visitante.charAt(0).toUpperCase();

    const optsJugadores = `
        <optgroup label="${partido.equipo_local}">
            ${jugLocal.map(j => `<option value="${j.id_participante}|local">${j.nombre} ${j.apellido}</option>`).join('')}
        </optgroup>
        <optgroup label="${partido.equipo_visitante}">
            ${jugVisit.map(j => `<option value="${j.id_participante}|visitante">${j.nombre} ${j.apellido}</option>`).join('')}
        </optgroup>`;

    const optsTipos = tipos.map(t => `<option value="${t.id_tipo_evento}">${t.nombre}</option>`).join('');

    const listaEventos = eventos.length
        ? eventos.map(e => `
            <div class="evento-item">
                <span class="evento-min">${e.minuto}'</span>
                <span style="font-size:1rem">${iconoTipo(e.tipo)}</span>
                <span class="evento-nombre">${e.nombre} ${e.apellido}</span>
                <span class="evento-tipo">${e.tipo}</span>
                <button class="btn-del-evento" onclick="eliminarEvento(${e.id_evento}, ${p.id_partido})">✕</button>
            </div>`).join('')
        : '<div style="color:#94a3b8;font-size:.82rem;padding:.5rem 0">Sin eventos registrados aún</div>';

    document.getElementById('seccion-vivo').innerHTML = `
        <div class="partido-vivo">
            <div class="partido-vivo-header">
                <span class="partido-vivo-title">PARTIDO EN VIVO</span>
                <a href="${BASE}/views/public/index.html" target="_blank" class="btn-ver-tablero">🖥 Ver tablero</a>
            </div>
            <div class="partido-vivo-body">
                <div class="marcador">
                    <div class="equipo-vivo">
                        <div class="equipo-avatar" style="background:${colores[0]}">${ini}</div>
                        <div class="equipo-vivo-nombre">${partido.equipo_local}</div>
                        <div class="equipo-vivo-rol">Local</div>
                    </div>
                    <div class="score-vivo" id="score-vivo">${partido.marcador_local ?? 0} - ${partido.marcador_visitante ?? 0}</div>
                    <div class="equipo-vivo">
                        <div class="equipo-avatar" style="background:${colores[1]}">${inv}</div>
                        <div class="equipo-vivo-nombre">${partido.equipo_visitante}</div>
                        <div class="equipo-vivo-rol">Visitante</div>
                    </div>
                </div>

                <div class="evento-form">
                    <div class="evento-form-title">📋 Registrar Evento</div>
                    <div class="evento-grid">
                        <div class="evento-group">
                            <label for="ev-jugador">Jugador</label>
                            <select id="ev-jugador" class="evento-control">${optsJugadores}</select>
                        </div>
                        <div class="evento-group">
                            <label for="ev-tipo">Tipo de evento</label>
                            <select id="ev-tipo" class="evento-control">${optsTipos}</select>
                        </div>
                        <div class="evento-group">
                            <label for="ev-minuto">Minuto</label>
                            <input type="number" id="ev-minuto" class="evento-control" min="1" max="120" placeholder="Ej: 45">
                        </div>
                        <div class="evento-group">
                            <label for="ev-comentario">Comentario (opcional)</label>
                            <input type="text" id="ev-comentario" class="evento-control" placeholder="Ej: Cabezazo al ángulo">
                        </div>
                    </div>
                    <button class="btn-registrar" onclick="registrarEvento(${p.id_partido})">✓ Registrar evento</button>
                </div>

                <div class="eventos-lista" id="eventos-lista">${listaEventos}</div>

                <button class="btn-finalizar" style="margin-top:1.25rem" onclick="finalizarPartido(${p.id_partido})">☑ Finalizar Partido</button>
            </div>
        </div>`;
}

function iconoTipo(tipo) {
    const t = tipo?.toLowerCase() || '';
    if (t.includes('gol') && !t.includes('contra')) return '⚽';
    if (t.includes('contra')) return '⚽🔴';
    if (t.includes('amarilla')) return '🟨';
    if (t.includes('roja')) return '🟥';
    return '📌';
}

async function registrarEvento(idPartido) {
    const selectJugador  = document.getElementById('ev-jugador');
    const [idParticipante, rolEquipo] = selectJugador.value.split('|');
    const idTipo     = document.getElementById('ev-tipo').value;
    const minuto    = parseInt(document.getElementById('ev-minuto').value);
    const comentario = document.getElementById('ev-comentario').value;

    if (!minuto) { mostrarMsg('El minuto es requerido', false); return; }

    const body = {
        id_partido: idPartido,
        id_participante: parseInt(idParticipante),
        id_tipo_evento: parseInt(idTipo),
        minuto: minuto,
        comentarios: comentario,
        equipo_rol: rolEquipo
    };

    try {
        await sbData.createEvento(body);
        mostrarMsg('Evento registrado', true);
        document.getElementById('ev-minuto').value = '';
        document.getElementById('ev-comentario').value = '';
        const detalle = await sbData.getPartidoDetalle(idPartido);
        document.getElementById('score-vivo').textContent = `${detalle.partido.marcador_local ?? 0} - ${detalle.partido.marcador_visitante ?? 0}`;
        partidoVivo = { ...partidoVivo, marcador_local: detalle.partido.marcador_local, marcador_visitante: detalle.partido.marcador_visitante };
        await recargarEventos(idPartido);
    } catch (err) {
        mostrarMsg(err.message, false);
    }
}

async function recargarEventos(idPartido) {
    const detalle = await sbData.getPartidoDetalle(idPartido);
    const eventos = detalle.eventos || [];
    document.getElementById('eventos-lista').innerHTML = eventos.length
        ? eventos.map(e => `
            <div class="evento-item">
                <span class="evento-min">${e.minuto}'</span>
                <span style="font-size:1rem">${iconoTipo(e.tipo)}</span>
                <span class="evento-nombre">${e.nombre} ${e.apellido}</span>
                <span class="evento-tipo">${e.tipo}</span>
                <button class="btn-del-evento" onclick="eliminarEvento(${e.id_evento}, ${idPartido})">✕</button>
            </div>`).join('')
        : '<div style="color:#94a3b8;font-size:.82rem;padding:.5rem 0">Sin eventos registrados aún</div>';
}

async function eliminarEvento(idEvento, idPartido) {
    if (!confirm('¿Eliminar este evento?')) return;
    try {
        await sbData.deleteEvento(idEvento);
        mostrarMsg('Evento eliminado', true);
        const detalle = await sbData.getPartidoDetalle(idPartido);
        document.getElementById('score-vivo').textContent = `${detalle.partido.marcador_local ?? 0} - ${detalle.partido.marcador_visitante ?? 0}`;
        await recargarEventos(idPartido);
    } catch (err) {
        mostrarMsg(err.message, false);
    }
}

async function iniciarPartido(id) {
    try {
        await sbData.updateEstadoPartido(id, 2);
        mostrarMsg('Partido iniciado', true);
        cargarPartidos();
    } catch (err) {
        mostrarMsg(err.message, false);
    }
}

async function finalizarPartido(id) {
    if (!confirm('¿Finalizar el partido?')) return;
    try {
        await sbData.updateEstadoPartido(id, 3);
        mostrarMsg('Partido finalizado', true);
        cargarPartidos();
    } catch (err) {
        mostrarMsg(err.message, false);
    }
}

function mostrarMsg(texto, ok) {
    const el = document.getElementById('msg');
    el.textContent = texto;
    el.className = 'msg ' + (ok ? 'ok' : 'error');
    setTimeout(() => { el.className = 'msg'; }, 3000);
}

init();
