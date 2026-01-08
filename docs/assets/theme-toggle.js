(function(){
  const STORAGE_KEY = 'brandshield-theme';
  const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  const saved = localStorage.getItem(STORAGE_KEY);
  const initial = saved || (prefersDark ? 'dark':'light');
  document.documentElement.setAttribute('data-theme', initial);

  function setTheme(next){
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem(STORAGE_KEY, next);
  }

  window.BrandshieldTheme = { set: setTheme, get: () => document.documentElement.getAttribute('data-theme') };

  document.addEventListener('click', function(e){
    const t = e.target.closest('[data-action="toggle-theme"]');
    if(!t) return;
    const cur = document.documentElement.getAttribute('data-theme');
    setTheme(cur === 'dark' ? 'light':'dark');
  });
})();
