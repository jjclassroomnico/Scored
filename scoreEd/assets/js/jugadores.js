const BASE = '/scoreEd';
const colores = ['#f97316','#3b82f6','#eab308','#22c55e','#a855f7','#ef4444','#14b8a6','#f43f5e','#0ea5e9','#ec4899'];
let todosJugadores = [];
let equiposMap = {};

sbRequireAuth('admin');
document.getElementById('btn-logout').addEventListener('click', async()=>{ await sbLogout(); history.replaceState(null,'', BASE + '/views/admin/login.html'); window.location.href = BASE + '/views/admin/login.html'; });

async function cargar(idDeporte) {
    const [jugadoresData, equipos, cursos, torneos] = await Promise.all([
        sbData.getJugadores(idDeporte),
        sbData.getEquipos(),
        sbData.getCursos(),
        sbData.getTorneos(idDeporte)
    ]);
    todosJugadores = jugadoresData;

    equipos.forEach((e,i) => { equiposMap[e.id_equipo] = { nombre: e.nombre, color: colores[i%colores.length] }; });

    const idsTorneos = new Set(torneos.map(t => t.id_torneo));
    const equiposFiltrados = equipos.filter(e => idsTorneos.has(e.id_torneo));

    document.getElementById('subtitulo').textContent = `${todosJugadores.length} jugadores registrados`;
    document.getElementById('id_equipo').innerHTML = equiposFiltrados.map(e=>`<option value="${e.id_equipo}">${e.nombre}</option>`).join('');
    document.getElementById('id_curso').innerHTML  = cursos.map(c=>`<option value="${c.id_curso}">${c.anio}° ${c.division}°</option>`).join('');
    document.getElementById('filtro-equipo').innerHTML = '<option value="">Todos los equipos</option>' +
        equiposFiltrados.map(e=>`<option value="${e.id_equipo}">${e.nombre}</option>`).join('');

    renderTabla(todosJugadores);
}

function renderTabla(lista) {
    document.getElementById('tbody').innerHTML = lista.map(j => {
        const eq = equiposMap[j.id_equipo] || {};
        return `<tr>
            <td style="font-weight:600">${j.nombre} ${j.apellido}</td>
            <td><span class="equipo-dot"><span class="dot" style="background:${eq.color||'#94a3b8'}"></span>${eq.nombre||'—'}</span></td>
            <td style="color:#94a3b8">${j.dni||'—'}</td>
            <td style="color:#94a3b8">${j.anio ? j.anio+'° '+j.division+'°' : '—'}</td>
            <td class="center"><div class="acciones">
                <button class="btn-icon edit" onclick='editar(${JSON.stringify(j)})'>✏️</button>
                <button class="btn-icon del" onclick="eliminar(${j.id_participante})">🗑️</button>
            </div></td>
        </tr>`;
    }).join('') || `<tr class="empty-row"><td colspan="5">No hay jugadores registrados</td></tr>`;
}

function filtrar() {
    const q  = document.getElementById('buscador').value.toLowerCase();
    const eq = document.getElementById('filtro-equipo').value;
    renderTabla(todosJugadores.filter(j =>
        (!q  || (j.nombre+' '+j.apellido).toLowerCase().includes(q)) &&
        (!eq || String(j.id_equipo) === eq)
    ));
}

document.getElementById('btn-nuevo').addEventListener('click', ()=>{
    document.getElementById('form-card').style.display='block';
    document.getElementById('id_participante').value='';
    document.getElementById('form-jugador').reset();
});
document.getElementById('btn-cancelar').addEventListener('click', ()=>{ document.getElementById('form-card').style.display='none'; });

document.getElementById('form-jugador').addEventListener('submit', async e=>{
    e.preventDefault();
    const id = document.getElementById('id_participante').value;
    const body = {
        nombre: document.getElementById('nombre').value,
        apellido: document.getElementById('apellido').value,
        dni: document.getElementById('dni').value,
        id_equipo: parseInt(document.getElementById('id_equipo').value),
        id_curso: parseInt(document.getElementById('id_curso').value),
    };
    try {
        if (id) {
            await sbData.updateJugador({ ...body, id_participante: parseInt(id) });
        } else {
            await sbData.createJugador(body);
        }
        document.getElementById('form-card').style.display='none';
        cargar(deporteActivo());
    } catch (err) {
        const msg = document.getElementById('msg');
        msg.textContent = err.message;
        msg.className = 'msg error';
    }
});

function editar(j) {
    document.getElementById('form-card').style.display='block';
    document.getElementById('id_participante').value = j.id_participante;
    document.getElementById('nombre').value    = j.nombre;
    document.getElementById('apellido').value  = j.apellido;
    document.getElementById('dni').value       = j.dni || '';
    document.getElementById('id_equipo').value = j.id_equipo;
    document.getElementById('id_curso').value  = j.id_curso;
}

async function eliminar(id) {
    if (!confirm('¿Eliminar jugador?')) return;
    try {
        await sbData.deleteJugador(id);
        cargar(deporteActivo());
    } catch (err) {
        const msg = document.getElementById('msg');
        msg.textContent = err.message;
        msg.className = 'msg error';
    }
}

iniciarSelectorDeporte(cargar);
