const BASE = '/scoreEd';

const RUTAS_LOGIN = {
    admin: BASE + '/views/admin/login.html',
    arbitro: BASE + '/views/arbitro/login.html'
};

const RUTAS_PANEL = {
    admin: BASE + '/views/admin/torneos.html',
    arbitro: BASE + '/views/arbitro/panel.html'
};

async function verificarRol(rolEsperado) {
    try {
        const res = await fetch(BASE + '/BackEnd/api/get-sesion.php');
        if (!res.ok) {
            window.location.href = RUTAS_LOGIN[rolEsperado];
            return;
        }
        const sesion = await res.json();
        if (sesion.rol !== rolEsperado) {
            await fetch(BASE + '/BackEnd/api/logout.php');
            window.location.href = RUTAS_LOGIN[rolEsperado];
        }
    } catch {
        window.location.href = RUTAS_LOGIN[rolEsperado];
    }
}

async function redirigirSiAutenticado() {
    try {
        const res = await fetch(BASE + '/BackEnd/api/get-sesion.php');
        if (!res.ok) return;
        const sesion = await res.json();
        if (sesion.rol && RUTAS_PANEL[sesion.rol]) {
            window.location.href = RUTAS_PANEL[sesion.rol];
        }
    } catch {
        // sin sesión, no hacer nada
    }
}
