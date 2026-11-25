const BASE = '/scoreEd';
let mapaDeportes = {};

sbRequireAuth('admin');
document.getElementById('btn-logout').addEventListener('click', async()=>{ await sbLogout(); history.replaceState(null,'', BASE + '/views/admin/login.html'); window.location.href = BASE + '/views/admin/login.html'; });

async function cargar(idDeporte) {
    const [torneos, deportes] = await Promise.all([
        sbData.getTorneos(idDeporte),
        sbData.getDeportes()
    ]);

    mapaDeportes = Object.fromEntries(deportes.map(d => [d.id_deporte, d.nombre]));

    document.getElementById('subtitulo').textContent = `${torneos.length} torneos registrados`;
    document.getElementById('sel-deporte-text').value = mapaDeportes[idDeporte] || '';
    document.getElementById('sel-deporte').value = idDeporte;

    document.getElementById('tbody').innerHTML = torneos.map(t=>`
        <tr>
            <td style="font-weight:700">📈 ${t.nombre}</td>
            <td style="color:#64748b">${t.anio}</td>
            <td><span class="badge badge-torneo">${mapaDeportes[t.id_deporte] ?? '—'}</span></td>
            <td style="color:#64748b">${t.descripcion||'—'}</td>
            <td class="center"><div class="acciones">
                <button class="btn-icon edit" onclick='editar(${JSON.stringify(t)})'>✏️</button>
                <button class="btn-icon del" onclick="eliminar(${t.id_torneo})">🗑️</button>
            </div></td>
        </tr>`).join('') || `<tr class="empty-row"><td colspan="5">No hay torneos para este deporte</td></tr>`;
}

document.getElementById('btn-nuevo').addEventListener('click', ()=>{
    document.getElementById('form-card').style.display='block';
    document.getElementById('id_torneo').value='';
    document.getElementById('form-torneo').reset();
    document.getElementById('sel-deporte-text').value = mapaDeportes[deporteActivo()] || '';
    document.getElementById('sel-deporte').value = deporteActivo();
});
document.getElementById('btn-cancelar').addEventListener('click', ()=>{ document.getElementById('form-card').style.display='none'; });

document.getElementById('form-torneo').addEventListener('submit', async e=>{
    e.preventDefault();
    const id = document.getElementById('id_torneo').value;
    const body = {
        nombre:      document.getElementById('nombre').value,
        anio:        parseInt(document.getElementById('anio').value),
        descripcion: document.getElementById('descripcion').value,
        id_deporte:  parseInt(document.getElementById('sel-deporte').value)
    };
    try {
        if (id) {
            await sbData.updateTorneo({ ...body, id_torneo: parseInt(id) });
        } else {
            await sbData.createTorneo(body);
        }
        mostrarMsg('Torneo guardado correctamente', true);
        document.getElementById('form-card').style.display='none';
        cargar(deporteActivo());
    } catch (err) {
        mostrarMsg(err.message, false);
    }
});

function editar(t) {
    document.getElementById('form-card').style.display='block';
    document.getElementById('id_torneo').value   = t.id_torneo;
    document.getElementById('nombre').value      = t.nombre;
    document.getElementById('anio').value        = t.anio;
    document.getElementById('descripcion').value = t.descripcion||'';
    document.getElementById('sel-deporte-text').value = mapaDeportes[t.id_deporte] || '';
    document.getElementById('sel-deporte').value = t.id_deporte;
}

async function eliminar(id) {
    if (!confirm('¿Eliminar torneo?')) return;
    try {
        await sbData.deleteTorneo(id);
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
