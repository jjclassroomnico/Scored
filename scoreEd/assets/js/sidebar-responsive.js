// sidebar-responsive.js — menú hamburguesa para móvil

(function () {
    // Inyectar overlay
    const overlay = document.createElement('div');
    overlay.className = 'sidebar-overlay';
    overlay.id = 'sidebar-overlay';
    document.body.appendChild(overlay);

    // Inyectar topbar con botón hamburguesa al inicio del main-content
    const main = document.querySelector('.main-content');
    if (main) {
        const topbar = document.createElement('div');
        topbar.className = 'topbar';
        topbar.innerHTML = `
            <button class="btn-menu" id="btn-menu">☰</button>
            <span class="topbar-title">${document.title.replace(' — ScoreEd', '')}</span>
        `;
        main.insertBefore(topbar, main.firstChild);
    }

    function abrirSidebar() {
        document.querySelector('.sidebar')?.classList.add('open');
        overlay.classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function cerrarSidebar() {
        document.querySelector('.sidebar')?.classList.remove('open');
        overlay.classList.remove('open');
        document.body.style.overflow = '';
    }

    document.getElementById('btn-menu')?.addEventListener('click', abrirSidebar);
    overlay.addEventListener('click', cerrarSidebar);

    // Cerrar al navegar en móvil
    document.querySelectorAll('.sidebar-nav a').forEach(a => {
        a.addEventListener('click', cerrarSidebar);
    });

    // Mostrar topbar solo en móvil
    const style = document.createElement('style');
    style.textContent = '.topbar { display: none; } @media (max-width: 768px) { .topbar { display: flex; } }';
    document.head.appendChild(style);
})();
