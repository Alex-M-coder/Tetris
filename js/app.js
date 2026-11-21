/**
 * Tetris Neon - Capa de "App": instalación (PWA), modo offline y pantalla completa.
 */
(() => {
    // 1. Registrar el Service Worker (solo funciona en http/https, no con file://)
    if ('serviceWorker' in navigator && location.protocol.startsWith('http')) {
        window.addEventListener('load', () => {
            navigator.serviceWorker.register('sw.js').catch((err) => {
                console.warn('No se pudo registrar el Service Worker:', err);
            });
        });
    }

    const isStandalone = () =>
        window.matchMedia('(display-mode: standalone)').matches ||
        window.matchMedia('(display-mode: fullscreen)').matches ||
        window.navigator.standalone === true;

    const isIOS = /iphone|ipad|ipod/i.test(navigator.userAgent) ||
        (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);

    window.addEventListener('DOMContentLoaded', () => {
        const btnInstall = document.getElementById('btn-instalar');
        const iosHint = document.getElementById('ios-install-hint');
        let deferredPrompt = null;

        if (isStandalone()) {
            document.body.classList.add('is-app');
            return;
        }

        // Android / Chrome / Edge (PC y móvil): botón de instalación nativo
        window.addEventListener('beforeinstallprompt', (e) => {
            e.preventDefault();
            deferredPrompt = e;
            btnInstall.hidden = false;
        });

        btnInstall.addEventListener('click', async () => {
            if (!deferredPrompt) return;
            deferredPrompt.prompt();
            await deferredPrompt.userChoice;
            deferredPrompt = null;
            btnInstall.hidden = true;
        });

        window.addEventListener('appinstalled', () => {
            btnInstall.hidden = true;
            document.body.classList.add('is-app');
        });

        // iOS (Safari) no tiene botón de instalación: mostramos una pista
        if (isIOS) {
            iosHint.hidden = false;
        }
    });
})();
