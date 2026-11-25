const BASE = '/scoreEd';

sbRequireAuth('admin');
document.getElementById('btn-logout').addEventListener('click', async()=>{ await sbLogout(); history.replaceState(null,'', BASE + '/views/admin/login.html'); window.location.href = BASE + '/views/admin/login.html'; });

async function cargar() {
    const data = await sbData.getArbitros();
    document.getElementById('subtitulo').textContent = `${data.length} árbitros registrados`;
    document.getElementById('tbody').innerHTML = data.map(a=>`
        <tr>
            <td style="font-weight:600">👥 ${a.nombre}</td>
            <td style="color:#64748b">${a.email}</td>
            <td class="center"><div class="acciones">
                <button class="btn-icon edit" onclick='editar(${JSON.stringify(a)})'>✏️</button>
                <button class="btn-icon del" onclick="eliminar('${a.id_uuid}')">🗑️</button>
            </div></td>
        </tr>`).join('') || `<tr class="empty-row"><td colspan="3">No hay árbitros registrados</td></tr>`;
}

document.getElementById('btn-nuevo').addEventListener('click', ()=>{
    document.getElementById('form-card').style.display='block';
    document.getElementById('id_arbitro').value='';
    document.getElementById('form-arbitro').reset();
});
document.getElementById('btn-cancelar').addEventListener('click', ()=>{ document.getElementById('form-card').style.display='none'; });

document.getElementById('form-arbitro').addEventListener('submit', async e=>{
    e.preventDefault();
    const id = document.getElementById('id_arbitro').value;
    const nombre = document.getElementById('nombre').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('contrasena').value;
    const msg = document.getElementById('msg');
    try {
        if (id) {
            msg.textContent = 'Editar árbitros requiere usar la consola de Supabase Auth.';
            msg.className = 'msg error';
        } else {
            const sb = await sbInit()
            const { data, error } = await sb.rpc('create_arbitro', { p_email: email, p_password: password, p_nombre: nombre })
            if (error) throw new Error(error.message)
            if (data?.error) throw new Error(data.error)
            msg.textContent = 'Árbitro creado en Supabase Auth.';
            msg.className = 'msg ok';
            document.getElementById('form-card').style.display='none';
            cargar();
        }
    } catch (err) {
        msg.textContent = err.message;
        msg.className = 'msg error';
    }
});

function editar(a) {
    document.getElementById('form-card').style.display='block';
    document.getElementById('id_arbitro').value = a.id_arbitro;
    document.getElementById('nombre').value = a.nombre;
    document.getElementById('email').value  = a.email;
    document.getElementById('contrasena').value = '';
}

async function eliminar(id) {
    if (!confirm('¿Eliminar árbitro de Supabase Auth?')) return;
    const msg = document.getElementById('msg');
    try {
        const sb = await sbInit()
        const { data, error } = await sb.rpc('delete_arbitro', { p_user_id: id })
        if (error) throw new Error(error.message)
        if (data?.error) throw new Error(data.error)
        msg.textContent = 'Árbitro eliminado';
        msg.className = 'msg ok';
        cargar();
    } catch (err) {
        msg.textContent = err.message;
        msg.className = 'msg error';
    }
}

cargar();
