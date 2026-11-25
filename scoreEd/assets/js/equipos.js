const BASE = '/scoreEd';
const colores = ['#f97316','#3b82f6','#eab308','#22c55e','#a855f7','#ef4444','#14b8a6','#f43f5e','#0ea5e9','#ec4899'];
let tablaData = {};

sbRequireAuth('admin');
document.getElementById('btn-logout').addEventListener('click', async()=>{ await sbLogout(); history.replaceState(null,'', BASE + '/views/admin/login.html'); window.location.href = BASE + '/views/admin/login.html'; });

async function cargar(idDeporte) {
    const [equipos, torneos] = await Promise.all([
        sbData.getEquipos(),
        sbData.getTorneos(idDeporte)
    ]);

    document.getElementById('subtitulo').textContent = `${equipos.length} equipos registrados`;
    document.getElementById('id_torneo').innerHTML = torneos.map(t=>`<option value="${t.id_torneo}">${t.nombre}</option>`).join('');

    tablaData = {};
    for (const t of torneos) {
        const tabla = await sbData.getTablaPosiciones(t.id_torneo);
        tabla.forEach(e => { tablaData[e.id_equipo] = e; });
    }

    const idsTorneosDeporte = new Set(torneos.map(t => t.id_torneo));
    const equiposFiltrados = equipos.filter(e => idsTorneosDeporte.has(e.id_torneo));

    document.getElementById('tbody').innerHTML = equiposFiltrados.map((e,i) => {
        const s = tablaData[e.id_equipo] || {};
        return `<tr>
            <td><span class="equipo-dot"><span class="dot" style="background:${colores[i%colores.length]}"></span>${e.nombre}</span></td>
            <td><span class="badge badge-torneo">${e.torneo ?? '—'}</span></td>
            <td class="center">${s.pj??0}</td>
            <td class="center" style="color:var(--green);font-weight:700">${s.pg??0}</td>
            <td class="center" style="color:var(--yellow);font-weight:700">${s.pe??0}</td>
            <td class="center" style="color:var(--red);font-weight:700">${s.pp??0}</td>
            <td class="center">${s.gf??0}</td>
            <td class="center">${s.gc??0}</td>
            <td class="center" style="font-weight:800;color:var(--accent)">${s.pts??0}</td>
            <td class="center"><div class="acciones">
                <button class="btn-icon edit" onclick='editar(${JSON.stringify(e)})'>✏️</button>
                <button class="btn-icon del" onclick="eliminar(${e.id_equipo})">🗑️</button>
            </div></td>
        </tr>`;
    }).join('') || `<tr class="empty-row"><td colspan="10">No hay equipos para este deporte</td></tr>`;
}

document.getElementById('btn-nuevo').addEventListener('click', ()=>{
    document.getElementById('form-card').style.display='block';
    document.getElementById('id_equipo').value='';
    document.getElementById('form-equipo').reset();
});

document.getElementById('btn-cancelar').addEventListener('click', ()=>{
    document.getElementById('form-card').style.display='none';
});

document.getElementById('form-equipo').addEventListener('submit', async e=>{
    e.preventDefault();
    const id = document.getElementById('id_equipo').value;
    const body = { nombre: document.getElementById('nombre').value, id_torneo: parseInt(document.getElementById('id_torneo').value) };
    try {
        if (id) {
            await sbData.updateEquipo({ ...body, id_equipo: parseInt(id) });
        } else {
            await sbData.createEquipo(body);
        }
        mostrarMsg('Equipo guardado correctamente', true);
        document.getElementById('form-card').style.display='none';
        cargar(deporteActivo());
    } catch (err) {
        mostrarMsg(err.message, false);
    }
});

function editar(e) {
    document.getElementById('form-card').style.display='block';
    document.getElementById('id_equipo').value  = e.id_equipo;
    document.getElementById('nombre').value     = e.nombre;
    document.getElementById('id_torneo').value  = e.id_torneo;
}

async function eliminar(id) {
    if (!confirm('¿Eliminar equipo?')) return;
    try {
        await sbData.deleteEquipo(id);
        cargar(deporteActivo());
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

iniciarSelectorDeporte(cargar);
