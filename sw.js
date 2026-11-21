/**
 * Service Worker de Tetris Neon: permite instalar la App y jugar sin conexión.
 * Sube el número de versión cada vez que cambies archivos del juego.
 */
const CACHE_VERSION = 'tetris-neon-v2';
const APP_SHELL = [
    './',
    './index.html',
    './manifest.webmanifest',
    './css/styles.css',
    './js/audio.js',
    './js/game.js',
    './js/app.js',
    './assets/icons/icon-192.png',
    './assets/icons/icon-512.png',
    './assets/icons/icon-maskable-512.png',
    './assets/icons/apple-touch-icon.png',
    './assets/icons/favicon-32.png'
];

self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_VERSION)
            .then((cache) => cache.addAll(APP_SHELL))
            .then(() => self.skipWaiting())
    );
});

self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys()
            .then((keys) => Promise.all(keys.filter((k) => k !== CACHE_VERSION).map((k) => caches.delete(k))))
            .then(() => self.clients.claim())
    );
});

self.addEventListener('fetch', (event) => {
    const req = event.request;
    if (req.method !== 'GET') return;

    const url = new URL(req.url);

    // Fuentes de Google: stale-while-revalidate (se guardan para uso offline)
    if (url.hostname.includes('fonts.googleapis.com') || url.hostname.includes('fonts.gstatic.com')) {
        event.respondWith(
            caches.open(CACHE_VERSION).then(async (cache) => {
                const cached = await cache.match(req);
                const network = fetch(req).then((res) => {
                    cache.put(req, res.clone());
                    return res;
                }).catch(() => cached);
                return cached || network;
            })
        );
        return;
    }

    if (url.origin !== self.location.origin) return;

    // Archivos propios: cache-first con actualización en segundo plano
    event.respondWith(
        caches.match(req, { ignoreSearch: true }).then((cached) => {
            const network = fetch(req).then((res) => {
                if (res && res.ok) {
                    const copy = res.clone();
                    caches.open(CACHE_VERSION).then((cache) => cache.put(req, copy));
                }
                return res;
            }).catch(() => cached || caches.match('./index.html'));
            return cached || network;
        })
    );
});
