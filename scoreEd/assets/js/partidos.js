const BASE = '/scoreEd';
let arbitrosCache = [];

sbRequireAuth('admin');
document.getElementById('btn-logout').addEventListener('click', async()=>{ await sbLogout(); history.replaceState(null,'', BASE + '/views/admin/login.html'); window.location.href = BASE + '/views/admin/login.html'; });

const badgeEstado = e => {
    const n = e?.toLowerCase();
    if (n?.includes('curso'))      return `<span class="badge badge-en-curso">En Curso</span>`;
    if (n?.includes('finalizado')) return `<span class="badge badge-finalizado">Finalizado</span>`;
    if (n?.includes('suspendido')) return `<span class="badge badge-suspendido">Suspendido</span>`;
    return `<span class="badge badge-programado">Programado</span>`;
};

async function cargarEquiposPorTorneo(idTorneo) {
    const equipos = await sbData.getEquipos(idTorneo);
    const opts = equipos.map(e=>`<option value="${e.id_equipo}">${e.nombre}</option>`).join('');
    document.getElementById('id_equipo_local').innerHTML = opts;
    document.getElementById('id_equipo_visitante').innerHTML = opts;
}

async function cargar(idDeporte) {
    const [partidos, torneos, arbitros] = await Promise.all([
        sbData.getPartidos(),
        sbData.getTorneos(idDeporte),
        sbData.getArbitros()
    ]);

    const idsTorneos = new Set(torneos.map(t => String(t.id_torneo)));
    const filtrados  = partidos.filter(p => idsTorneos.has(String(p.id_torneo)));

    document.getElementById('subtitulo').textContent = `${filtrados.length} partidos registrados`;
    document.getElementById('id_torneo').innerHTML   = torneos.map(t=>`<option value="${t.id_torneo}">${t.nombre}</option>`).join('');
    document.getElementById('id_arbitro').innerHTML  = arbitros.map(a=>`<option value="${a.id_arbitro}">${a.nombre}</option>`).join('');
    if (torneos.length) await cargarEquiposPorTorneo(torneos[0].id_torneo);

    document.getElementById('tbody').innerHTML = filtrados.map(p=>`
        <tr>
            <td style="font-weight:600">${p.equipo_local}</td>
            <td class="center" style="font-weight:800;font-size:1rem">${p.marcador_local??'—'} - ${p.marcador_visitante??'—'}</td>
            <td style="font-weight:600">${p.equipo_visitante}</td>
            <td><span class="badge badge-torneo">${p.torneo}</span></td>
            <td style="color:#64748b">${p.fecha}</td>
            <td style="color:#64748b">${p.arbitro ?? '—'}</td>
            <td>${badgeEstado(p.estado)}</td>
            <td class="center"><div class="acciones">
                <button class="btn-icon edit" onclick='editar(${JSON.stringify(p)})'>✏️</button>
                <button class="btn-icon del" onclick="eliminar(${p.id_partido})">🗑️</button>
            </div></td>
        </tr>`).join('') || `<tr class="empty-row"><td colspan="8">No hay partidos para este deporte</td></tr>`;
}

document.getElementById('id_torneo').addEventListener('change', function(){ cargarEquiposPorTorneo(this.value); });

document.getElementById('btn-nuevo').addEventListener('click', ()=>{
    document.getElementById('form-card').style.display='block';
    document.getElementById('id_partido').value='';
    document.getElementById('form-partido').reset();
});
document.getElementById('btn-cancelar').addEventListener('click', ()=>{ document.getElementById('form-card').style.display='none'; });

document.getElementById('form-partido').addEventListener('submit', async e=>{
    e.preventDefault();
    const id    = document.getElementById('id_partido').value;
    const local = document.getElementById('id_equipo_local').value;
    const visit = document.getElementById('id_equipo_visitante').value;
    const msg   = document.getElementById('msg');
    if (local === visit) { msg.textContent='El equipo local y visitante no pueden ser el mismo.'; msg.className='msg error'; return; }
    const body = { id_equipo_local:parseInt(local), id_equipo_visitante:parseInt(visit), id_torneo:parseInt(document.getElementById('id_torneo').value), fecha:document.getElementById('fecha').value, id_arbitro:document.getElementById('id_arbitro').value };
    try {
        if (id) {
            await sbData.updatePartido({ ...body, id_partido: parseInt(id) });
        } else {
            await sbData.createPartido(body);
        }
        msg.textContent = 'Partido guardado correctamente';
        msg.className = 'msg ok';
        document.getElementById('form-card').style.display='none';
        cargar(deporteActivo());
    } catch (err) {
        msg.textContent = err.message;
        msg.className = 'msg error';
    }
});

async function editar(p) {
    document.getElementById('form-card').style.display='block';
    document.getElementById('id_partido').value = p.id_partido;
    document.getElementById('id_torneo').value  = p.id_torneo;
    await cargarEquiposPorTorneo(p.id_torneo);
    document.getElementById('id_equipo_local').value     = p.id_equipo_local;
    document.getElementById('id_equipo_visitante').value = p.id_equipo_visitante;
    document.getElementById('fecha').value      = p.fecha;
    document.getElementById('id_arbitro').value = p.id_arbitro;
}

async function eliminar(id) {
    if (!confirm('¿Eliminar partido?')) return;
    try {
        await sbData.deletePartido(id);
        cargar(deporteActivo());
    } catch (err) {
        const msg = document.getElementById('msg');
        msg.textContent = err.message;
        msg.className = 'msg error';
    }
}

// ── Fixture ───────────────────────────────────────────────────────────────────
document.getElementById('btn-fixture').addEventListener('click', async () => {
    const [torneos, arbitros] = await Promise.all([
        sbData.getTorneos(deporteActivo()),
        sbData.getArbitros()
    ]);
    arbitrosCache = arbitros;
    document.getElementById('fix-torneo').innerHTML = torneos.map(t=>`<option value="${t.id_torneo}">${t.nombre}</option>`).join('');
    await cargarEquiposFixture(torneos[0]?.id_torneo);
    document.getElementById('fixture-paso1').style.display = 'block';
    document.getElementById('fixture-paso2').style.display = 'none';
    document.getElementById('modal-fixture').style.display = 'block';
});

document.getElementById('fix-torneo').addEventListener('change', function(){ cargarEquiposFixture(this.value); });
document.getElementById('fix-btn-cerrar').addEventListener('click', () => { document.getElementById('modal-fixture').style.display='none'; });
document.getElementById('fix-btn-volver').addEventListener('click', () => {
    document.getElementById('fixture-paso1').style.display='block';
    document.getElementById('fixture-paso2').style.display='none';
});

async function cargarEquiposFixture(idTorneo) {
    const equipos = await sbData.getEquipos(idTorneo);
    document.getElementById('fix-equipos').innerHTML = equipos.map(e=>`
        <label style="display:flex;align-items:center;gap:.4rem;cursor:pointer">
            <input type="checkbox" value="${e.id_equipo}" data-nombre="${e.nombre}"> ${e.nombre}
        </label>`).join('');
    document.getElementById('fix-aviso').textContent = '';
}

document.getElementById('fix-btn-sortear').addEventListener('click', () => {
    const checks = [...document.querySelectorAll('#fix-equipos input:checked')];
    const n = checks.length;
    if (![2,4,8,16,32].includes(n)) {
        document.getElementById('fix-aviso').textContent = `Seleccionaste ${n} equipos. Debe ser exactamente 2, 4, 8, 16 o 32.`;
        return;
    }
    document.getElementById('fix-aviso').textContent = '';

    const equipos = checks.map(c=>({id: c.value, nombre: c.dataset.nombre}));
    for (let i = equipos.length-1; i > 0; i--) {
        const j = Math.floor(Math.random()*(i+1));
        [equipos[i], equipos[j]] = [equipos[j], equipos[i]];
    }

    const optsArbitro = arbitrosCache.map(a=>`<option value="${a.id_arbitro}">${a.nombre}</option>`).join('');
    let html = '';
    for (let i = 0; i < equipos.length; i += 2) {
        html += `<div style="border:1px solid #e2e8f0;border-radius:8px;padding:1rem;margin-bottom:.75rem">
            <div style="font-weight:600;margin-bottom:.75rem">${equipos[i].nombre} <span style="color:#94a3b8">vs</span> ${equipos[i+1].nombre}</div>
            <input type="hidden" class="fix-local" value="${equipos[i].id}">
            <input type="hidden" class="fix-visit" value="${equipos[i+1].id}">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:.75rem">
                <div class="form-group"><label>Árbitro</label><select class="form-control fix-arbitro">${optsArbitro}</select></div>
                <div class="form-group"><label>Fecha</label><input type="date" class="form-control fix-fecha"></div>
            </div>
        </div>`;
    }
    document.getElementById('fix-partidos').innerHTML = html;
    document.getElementById('fixture-paso1').style.display = 'none';
    document.getElementById('fixture-paso2').style.display = 'block';
});

document.getElementById('fix-btn-crear').addEventListener('click', async () => {
    const idTorneo = parseInt(document.getElementById('fix-torneo').value);
    const locales  = [...document.querySelectorAll('.fix-local')];
    const visitas  = [...document.querySelectorAll('.fix-visit')];
    const arbitros = [...document.querySelectorAll('.fix-arbitro')];
    const fechas   = [...document.querySelectorAll('.fix-fecha')];
    const msg      = document.getElementById('fix-msg');

    const partidos = locales.map((l, i) => ({
        id_equipo_local:     parseInt(l.value),
        id_equipo_visitante: parseInt(visitas[i].value),
        id_arbitro:          arbitros[i].value,
        fecha:               fechas[i].value,
        id_torneo:           idTorneo
    }));

    if (partidos.some(p => !p.fecha)) {
        msg.textContent = 'Completá la fecha de todos los partidos.';
        msg.className = 'msg error';
        return;
    }

    try {
        await sbData.crearFixture(partidos);
        msg.textContent = 'Fixture creado correctamente';
        msg.className = 'msg ok';
        document.getElementById('modal-fixture').style.display='none';
        cargar(deporteActivo());
    } catch (err) {
        msg.textContent = err.message;
        msg.className = 'msg error';
    }
});

iniciarSelectorDeporte(cargar);
