---
layout: null
permalink: /assets/performance.js
---

// Preconnect для внешних ресурсов
const preconnect = [
  'https://fonts.googleapis.com',
  'https://fonts.gstatic.com',
  'https://tally.so',
  'https://www.googletagmanager.com'
];

preconnect.forEach(url => {
  const link = document.createElement('link');
  link.rel = 'preconnect';
  link.href = url;
  document.head.appendChild(link);
});

// Lazy load images
if ('IntersectionObserver' in window) {
  const imageObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.classList.add('loaded');
        observer.unobserve(img);
      }
    });
  });

  document.querySelectorAll('img[data-src]').forEach(img => imageObserver.observe(img));
}

// Optimize font loading
if ('fonts' in document) {
  document.fonts.ready.then(() => {
    document.body.classList.add('fonts-loaded');
  });
}

// Prefetch critical pages
const prefetchLinks = [
  '/contact',
  '/audit-pack',
  '/blog'
];

if ('requestIdleCallback' in window) {
  requestIdleCallback(() => {
    prefetchLinks.forEach(url => {
      const link = document.createElement('link');
      link.rel = 'prefetch';
      link.href = url;
      document.head.appendChild(link);
    });
  });
}
