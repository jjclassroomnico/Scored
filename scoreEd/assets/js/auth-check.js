// auth-check.js — verificación de sesión al cargar y al volver con botón atrás

const BASE = '/scoreEd';
const API = BASE + '/BackEnd/api/';

async function verificarSesion(rolRequerido, urlLogin) {
    document.body.style.visibility = 'hidden';

    // Timeout de seguridad: si algo falla, mostrar el body igual
    const timeout = setTimeout(() => {
        document.body.style.visibility = 'visible';
    }, 3000);

    try {
        const res = await fetch(API + 'get-sesion.php', { cache: 'no-store' });
        clearTimeout(timeout);
        if (!res.ok) throw new Error();
        const sesion = await res.json();
        if (sesion.rol !== rolRequerido) throw new Error();
        document.body.style.visibility = 'visible';
        return sesion;
    } catch {
        clearTimeout(timeout);
        window.location.replace(urlLogin);
        return null;
    }
}

// Detectar botón "atrás" (pageshow con caché del navegador)
window.addEventListener('pageshow', async (e) => {
    if (!e.persisted) return;
    const rol   = document.body.dataset.rol;
    const login = document.body.dataset.login;
    if (!rol || !login) return;

    try {
        const res = await fetch(API + 'get-sesion.php', { cache: 'no-store' });
        if (!res.ok) throw new Error();
        const sesion = await res.json();
        if (sesion.rol !== rol) throw new Error();
    } catch {
        window.location.replace(login);
    }
});
