const INTERVALO = 10000;
let intervaloActivo = null;

async function hayPartidosEnCurso() {
    try {
        const data = await sbData.getResultados(parseInt(torneoActual));
        return data.some(r => r.estado?.toLowerCase().includes('curso'));
    } catch {
        return false;
    }
}

async function refrescarEnVivo() {
    if (!torneoActual) return;

    const enCurso = await hayPartidosEnCurso();

    if (!enCurso) {
        detenerRefresh();
        return;
    }

    const secActiva = document.querySelector('.seccion.activa')?.id?.replace('sec-', '');
    if (secActiva === 'resultados') await cargarResultadosSilencioso();
    if (secActiva === 'posiciones') await cargarPosicionesSilencioso();
}

async function cargarResultadosSilencioso() {
    try {
        const data = await sbData.getResultados(parseInt(torneoActual));
        if (!data.length) return;

        const lista = document.getElementById('lista-resultados');
        lista.innerHTML = data.map(r => {
            const enCurso    = r.estado?.toLowerCase().includes('curso');
            const badgeClass = enCurso ? 'badge-en-curso' : 'badge-finalizado';
            const cardClass  = enCurso ? 'en-curso' : 'finalizado';
            const badgeTexto = enCurso ? 'EN VIVO' : 'Finalizado';
            return `
            <div class="partido-card ${cardClass}" onclick="abrirDetalle(${r.id_partido})">
                <div class="partido-equipo">
                    <span class="equipo-card-nombre">${r.equipo_local}</span>
                </div>
                <div class="partido-score">
                    <span class="score-num">${r.marcador_local ?? 0}<span class="score-sep"> - </span>${r.marcador_visitante ?? 0}</span>
                    <div class="partido-meta">
                        <span class="badge-estado ${badgeClass}">${badgeTexto}</span>
                        <span class="partido-fecha">${formatFecha(r.fecha)}</span>
                    </div>
                </div>
                <div class="partido-equipo visitante">
                    <span class="equipo-card-nombre">${r.equipo_visitante}</span>
                </div>
            </div>`;
        }).join('');
    } catch {}
}

async function cargarPosicionesSilencioso() {
    try {
        const data = await sbData.getTablaPosiciones(parseInt(torneoActual));
        if (!Array.isArray(data) || !data.length) return;

        const medallas = ['🥇','🥈','🥉'];
        const posClases = ['pos-1','pos-2','pos-3'];

        const filas = data.map((e, i) => {
            const dgClass = e.dg > 0 ? 'dg-pos' : e.dg < 0 ? 'dg-neg' : 'dg-neu';
            const dgStr   = e.dg > 0 ? '+' + e.dg : e.dg;
            const posBadge = i < 3
                ? `<span class="pos-badge pos-${i+1}">${medallas[i]}</span>`
                : `<span class="pos-badge">${i+1}</span>`;
            return `<tr class="${i === 0 ? 'lider-row' : ''}">
                <td>${posBadge}</td>
                <td><span class="equipo-nombre">${e.equipo}</span></td>
                <td>${e.pj}</td>
                <td class="pg-col">${e.pg}</td>
                <td class="pe-col">${e.pe}</td>
                <td class="pp-col">${e.pp}</td>
                <td>${e.gf}</td>
                <td>${e.gc}</td>
                <td class="${dgClass}">${dgStr}</td>
                <td class="pts-col">${e.pts}</td>
            </tr>`;
        }).join('');

        const tbody = document.querySelector('#tabla-posiciones-wrap tbody');
        if (tbody) tbody.innerHTML = filas;

        const tarjetas = data.map((e, i) => {
            const dgStr = e.dg > 0 ? '+' + e.dg : e.dg;
            const posLabel = i < 3 ? medallas[i] : i + 1;
            const posClass = i < 3 ? posClases[i] : '';
            return `
            <div class="tabla-card-equipo ${i === 0 ? 'lider' : ''}">
                <div class="tabla-card-top">
                    <div class="tabla-card-pos ${posClass}">${posLabel}</div>
                    <div class="tabla-card-nombre">${e.equipo}</div>
                    <div class="tabla-card-pts">${e.pts} <small style="font-size:.6rem;font-weight:600;color:var(--text-muted)">pts</small></div>
                </div>
                <div class="tabla-card-stats">
                    <span><b>${e.pj}</b>PJ</span>
                    <span><b style="color:#16a34a">${e.pg}</b>G</span>
                    <span><b style="color:#b7860b">${e.pe}</b>E</span>
                    <span><b style="color:#c0392b">${e.pp}</b>P</span>
                    <span><b>${e.gf}</b>GF</span>
                    <span><b>${e.gc}</b>GC</span>
                    <span><b style="color:${e.dg > 0 ? '#16a34a' : e.dg < 0 ? '#c0392b' : 'var(--text-muted)'}">${dgStr}</b>DG</span>
                </div>
            </div>`;
        }).join('');

        const tablaCards = document.querySelector('#tabla-posiciones-wrap .tabla-cards');
        if (tablaCards) tablaCards.innerHTML = tarjetas;

        const lider = data[0];
        const liderCard = document.getElementById('lider-card');
        if (liderCard && liderCard.innerHTML) {
            liderCard.querySelector('.lider-nombre').textContent = lider.equipo;
            liderCard.querySelector('.num').textContent = lider.pts;
            liderCard.querySelector('.lider-sub').textContent =
                `${lider.pj} partidos · ${lider.pg}G ${lider.pe}E ${lider.pp}P`;
        }
    } catch {}
}

function iniciarRefresh() {
    if (intervaloActivo) return;
    intervaloActivo = setInterval(refrescarEnVivo, INTERVALO);
}

function detenerRefresh() {
    if (intervaloActivo) {
        clearInterval(intervaloActivo);
        intervaloActivo = null;
    }
}

async function iniciarTiempoReal() {
    if (await hayPartidosEnCurso()) iniciarRefresh();
}
