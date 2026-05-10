/* RuckOps service worker — minimal cache-first shell.
   Allows installation as a PWA. Cache version bumps to invalidate stale assets. */

const CACHE = 'ruckops-v0.1.0';
const CORE = [
  './',
  './index.html',
  './styles.css',
  './app.js',
  './manifest.webmanifest',
  './icon-192.png',
  './icon-512.png'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE).then(cache => cache.addAll(CORE)).catch(() => {})
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(k => k !== CACHE).map(k => caches.delete(k))
    ))
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;

  // Tile requests: network-only with cache fallback
  const url = new URL(req.url);
  const isTile = url.host.endsWith('tile.openstreetmap.org');

  if (isTile) {
    event.respondWith(
      fetch(req).then(resp => {
        const clone = resp.clone();
        caches.open(CACHE + '-tiles').then(c => c.put(req, clone)).catch(() => {});
        return resp;
      }).catch(() => caches.match(req))
    );
    return;
  }

  // Same-origin: cache-first
  if (url.origin === location.origin) {
    event.respondWith(
      caches.match(req).then(cached => cached || fetch(req).then(resp => {
        const clone = resp.clone();
        caches.open(CACHE).then(c => c.put(req, clone)).catch(() => {});
        return resp;
      }).catch(() => caches.match('./index.html')))
    );
    return;
  }

  // Cross-origin (fonts, leaflet CDN): network with cache fallback
  event.respondWith(
    fetch(req).then(resp => {
      if (resp.ok) {
        const clone = resp.clone();
        caches.open(CACHE + '-cdn').then(c => c.put(req, clone)).catch(() => {});
      }
      return resp;
    }).catch(() => caches.match(req))
  );
});
