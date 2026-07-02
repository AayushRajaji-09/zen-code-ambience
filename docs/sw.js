const CACHE = "zen-audio-v1";
const SHELL = [
  ".",
  "manifest.json",
  "icons/icon-192.png",
  "icons/icon-512.png"
];

self.addEventListener("install", (e) => {
  e.waitUntil(
    caches.open(CACHE).then((c) => c.addAll(SHELL)).then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys().then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
  );
});

self.addEventListener("fetch", (e) => {
  // Audio URLs: network-first with cache fallback (don't cache large audio)
  if (e.request.url.includes("soundhelix") || e.request.url.includes("raw.githubusercontent") || e.request.url.includes("fluxfm")) {
    e.respondWith(
      fetch(e.request).catch(() => caches.match(e.request))
    );
    return;
  }
  // Everything else: stale-while-revalidate
  e.respondWith(
    caches.match(e.request).then((cached) => cached || fetch(e.request))
  );
});
