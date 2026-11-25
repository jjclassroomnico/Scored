const API = '/scoreEd/BackEnd/api/';

async function iniciarSelectorDeporte(onCambio) {
    const deportes = await sbData.getDeportes();

    const sel = document.getElementById('sel-deporte-global');
    sel.innerHTML = deportes.map(d => `<option value="${d.id_deporte}">${d.nombre}</option>`).join('');

    const guardado = sessionStorage.getItem('deporteActivo');
    if (guardado) sel.value = guardado;
    else sessionStorage.setItem('deporteActivo', sel.value);

    sel.addEventListener('change', () => {
        sessionStorage.setItem('deporteActivo', sel.value);
        onCambio(sel.value);
    });

    onCambio(sel.value);
}

function deporteActivo() {
    return sessionStorage.getItem('deporteActivo') || '1';
}
