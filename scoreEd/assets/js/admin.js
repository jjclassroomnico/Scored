const BASE = '/scoreEd';
const colores = ['#f97316','#3b82f6','#eab308','#22c55e','#a855f7','#ef4444','#14b8a6','#f43f5e'];

sbRequireAuth('admin');

document.getElementById('btn-logout').addEventListener('click', async () => {
    await sbLogout();
    history.replaceState(null, '', BASE + '/views/admin/login.html');
    window.location.href = BASE + '/views/admin/login.html';
});

async function cargarDashboard(idDeporte) {
    const [proximos, resultados, equipos, jugadores, torneos] = await Promise.all([
        sbData.getProximos(null, idDeporte),
        sbData.getResultados(null, idDeporte),
        sbData.getEquipos(),
        sbData.getJugadores(idDeporte),
        sbData.getTorneos(idDeporte)
    ]);

    document.getElementById('stat-equipos').textContent   = equipos.length;
    document.getElementById('stat-jugadores').textContent = jugadores.length;
    document.getElementById('stat-partidos').textContent  = proximos.length + resultados.length;
    const goles = resultados.reduce((s, r) => s + (parseInt(r.marcador_local)||0) + (parseInt(r.marcador_visitante)||0), 0);
    document.getElementById('stat-goles').textContent = goles;

    document.getElementById('proximos-lista').innerHTML = proximos.slice(0,4).map(p => `
        <div class="partido-item">
            <div>
                <div class="partido-item-equipos">${p.equipo_local} vs ${p.equipo_visitante}</div>
                <div class="partido-item-meta">${p.fecha} · ${p.torneo ?? ''}</div>
            </div>
            <span class="badge badge-programado">Prog.</span>
        </div>`).join('') || '<p style="color:#94a3b8;font-size:.85rem">No hay próximos partidos</p>';

    document.getElementById('resultados-lista').innerHTML = resultados
        .filter(r => r.estado?.toLowerCase().includes('finalizado')).slice(0,5).map(r => `
        <div class="partido-item">
            <div>
                <div class="partido-item-equipos">
                    ${r.equipo_local} <span class="score-local">${r.marcador_local}</span>
                    — <span class="score-visit">${r.marcador_visitante}</span> ${r.equipo_visitante}
                </div>
                <div class="partido-item-meta">${r.fecha}</div>
            </div>
        </div>`).join('') || '<p style="color:#94a3b8;font-size:.85rem">Sin resultados aún</p>';

    const grid = document.getElementById('tablas-grid');
    grid.innerHTML = '';
    for (const t of torneos) {
        const tabla = await sbData.getTablaPosiciones(t.id_torneo);
        const filas = tabla.slice(0,4).map((e, i) => `
            <div class="tabla-mini-row ${i===0?'lider':''}">
                <div class="tabla-mini-pos ${i<3?'pos-'+(i+1):'pos-n'}">${i+1}</div>
                <div class="equipo-dot">
                    <span class="dot" style="background:${colores[i%colores.length]}"></span>
                    <span class="tabla-mini-nombre">${e.equipo}</span>
                </div>
                <div class="tabla-mini-pts">${e.pts} pts</div>
            </div>`).join('');
        grid.innerHTML += `
            <div class="card">
                <div class="card-header">
                    <span class="card-title">📈 ${t.nombre}</span>
                    <a href="/views/public/index.html" style="font-size:.8rem;color:var(--accent2);text-decoration:none">Completa →</a>
                </div>
                <div class="card-body">${filas || '<p style="color:#94a3b8;font-size:.85rem">Sin partidos finalizados</p>'}</div>
            </div>`;
    }
}

iniciarSelectorDeporte(cargarDashboard);
