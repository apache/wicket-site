/* Apache Wicket site behaviour.
   1. seasons: the photograph at the top of every page follows the date
   2. the component tree, on the homepage and in How Wicket works: the ribbon drawn through it,
      and its highlights; the steps of How Wicket works
   3. the reading rail marks the section in view
   (The copy buttons of the Maven snippets and the quick start have their own scripts.) */

document.documentElement.classList.replace('no-js', 'js');

/* ---------------------------------------------------------------- 1. seasons
   The data is _data/seasons.yml, rendered into the #seasons block. A dated occasion wins over the
   season on its days. ?season=winter|spring|summer|autumn and ?occasion=<name> choose one for
   review; review builds (season_selector: true) also have a selector on the photo, whose choice
   holds for the whole site in this browser. */
(() => {
  const block = document.getElementById('seasons');
  const photos = [...document.querySelectorAll('.photo')];
  if (!block || !photos.length) return;
  let data;
  try { data = JSON.parse(block.textContent); } catch (e) { return; }
  const base = block.dataset.base || '';
  const seasons = data.seasons || [], occasions = data.occasions || [];
  const KEY = 'wicket-season';
  const selector = block.hasAttribute('data-selector');
  const stored = () => { try { return selector ? localStorage.getItem(KEY) || '' : ''; } catch (e) { return ''; } };

  const today = new Date(), month = today.getMonth() + 1, md = month * 100 + today.getDate();
  const num = t => { const [m, d] = String(t).split('-').map(Number); return m * 100 + d; };
  const onToday = o => { const f = num(o.from), t = num(o.to); return f <= t ? md >= f && md <= t : md >= f || md <= t; };
  const byName = n => occasions.find(o => o.name === n) || seasons.find(s => s.name === n);
  const byDate = () => occasions.find(onToday) || seasons.find(s => (s.months || []).includes(month)) || seasons[0];

  function asked() {
    const params = new URLSearchParams(location.search);
    const n = params.get('occasion') || params.get('season') || stored();
    return n && byName(n) ? n : '';
  }

  function apply(s) {
    if (!s || !s.photo) return;
    photos.forEach(photo => {
      const img = photo.querySelector('img');
      const src = base + s.photo;
      if (img.getAttribute('src') !== src) {
        if (s.srcset) {
          img.srcset = s.srcset.map(f => base + f.file + ' ' + f.width + 'w').join(', ');
          img.sizes = '100vw';
        } else img.removeAttribute('srcset');
        img.src = src;
      }
      photo.dataset.season = s.name;
      photo.toggleAttribute('data-soft', !!s.soft);
      photo.toggleAttribute('data-sized', !!s.size);
      if (s.anchor) photo.dataset.anchor = s.anchor; else delete photo.dataset.anchor;
      if (s.veil) photo.dataset.veil = s.veil; else delete photo.dataset.veil;
      const vars = { '--focus-wide': s.focus, '--focus-narrow': s.focus_narrow, '--shift': s.shift, '--size': s.size, '--ground': s.ground };
      for (const k in vars) { if (vars[k]) photo.style.setProperty(k, vars[k]); else photo.style.removeProperty(k); }

      const credit = photo.parentElement.querySelector('.photo-credit');
      if (!credit) return;
      if (s.credit) {
        const link = document.createElement(s.url ? 'a' : 'span');
        link.textContent = s.credit;
        if (s.url) { link.href = s.url; link.rel = 'noreferrer'; }
        credit.replaceChildren('Photo: ', link);
        credit.hidden = false;
      } else {
        credit.replaceChildren();
        credit.hidden = true;
      }
    });
  }

  apply(byName(asked()) || byDate());

  if (!selector) return;
  document.querySelectorAll('.season-pick').forEach(pick => {
    const choice = asked();
    pick.querySelectorAll('input').forEach(input => {
      input.checked = input.value === choice;
      input.addEventListener('change', () => {
        try { if (input.value) localStorage.setItem(KEY, input.value); else localStorage.removeItem(KEY); } catch (e) { /* private mode: this page only */ }
        // The selector now decides; a season in the address would win over it on the next page.
        const url = new URL(location.href);
        url.searchParams.delete('season');
        url.searchParams.delete('occasion');
        history.replaceState(history.state, '', url);
        apply(byName(input.value) || byDate());
      });
    });
    pick.hidden = false;
  });
})();

/* ---------------------------------------------------------------- 2. the component tree
   The ribbon is drawn from the bead positions in each loom. Each bead is one component instance,
   its data-path the chain of ids from the page down; data-k lists the ids of the lines it lights.
   A loom in How Wicket works lights its step's focus while nothing is pointed at, and grows the
   ribbon into its new beads when its step is shown. */
document.querySelectorAll('.loom').forEach(loom => {
  const step = loom.closest('.how-step');
  const band = step || loom.closest('.ctree');
  const svg = loom.querySelector('.tree-ribbon');
  const beads = [...loom.querySelectorAll('.bead')];
  const focusPaths = (loom.dataset.focusPaths || '').split(' ').filter(Boolean);
  const focusKeys = (loom.dataset.focusKeys || '').split(' ').filter(Boolean);
  const ids = e => (e.dataset.c || '').split(' ');
  const lines = [...loom.querySelectorAll('.ln[data-c], .file[data-c]')];
  const reduced = matchMedia('(prefers-reduced-motion: reduce)');
  const NS = 'http://www.w3.org/2000/svg';
  const css = getComputedStyle(document.documentElement);
  const ORANGE = css.getPropertyValue('--ribbon').trim() || '#EE7F2D';
  const UNDER = css.getPropertyValue('--ribbon-under').trim() || '#C9661F';
  const parentOf = p => p.includes('/') ? p.slice(0, p.lastIndexOf('/')) : null;
  const rowOf = e => getComputedStyle(e).getPropertyValue('--r').trim();
  const colOf = e => (getComputedStyle(e).getPropertyValue('--c').trim() || '1');

  const rel = e => {
    const s = loom.getBoundingClientRect(), r = e.getBoundingClientRect();
    return { l: r.left - s.left, t: r.top - s.top, r: r.right - s.left, b: r.bottom - s.top, w: r.width, h: r.height, y: r.top - s.top + r.height / 2 };
  };
  function el(name, attrs, parent) {
    const e = document.createElementNS(NS, name);
    for (const k in attrs) e.setAttribute(k, attrs[k]);
    parent.appendChild(e);
    return e;
  }
  const f = n => n.toFixed(1);

  /* One run of ribbon as a mitred polyline; diagonal runs show the ribbon's reverse side. */
  function piece(parent, P, w, to) {
    const g = el('g', { class: 'seg', 'data-to': to }, parent);
    el('path', { d: 'M' + P.map(p => f(p[0]) + ' ' + f(p[1])).join(' L'), fill: 'none', stroke: ORANGE, 'stroke-width': w, 'stroke-linejoin': 'miter', 'stroke-miterlimit': 4 }, g);
    const sub = (a, b) => [a[0] - b[0], a[1] - b[1]];
    const norm = v => { const l = Math.hypot(v[0], v[1]) || 1; return [v[0] / l, v[1] / l]; };
    const N = P.map((p, i) => {
      const a = P[Math.max(0, i - 1)], b = P[Math.min(P.length - 1, i + 1)];
      const u1 = norm(i > 0 ? sub(p, a) : sub(b, p)), u2 = norm(i < P.length - 1 ? sub(b, p) : sub(p, a));
      const s = [u1[0] + u2[0], u1[1] + u2[1]], len = Math.hypot(...s) || 2;
      return [norm([-s[1], s[0]]), (w / 2) * 2 / len];
    });
    for (let i = 0; i < P.length - 1; i++) {
      const a = P[i], b = P[i + 1];
      if (Math.abs(a[0] - b[0]) > 0.5 && Math.abs(a[1] - b[1]) > 0.5) {
        const [na, ha] = N[i], [nb, hb] = N[i + 1];
        const q = [[a[0] + na[0] * ha, a[1] + na[1] * ha], [b[0] + nb[0] * hb, b[1] + nb[1] * hb], [b[0] - nb[0] * hb, b[1] - nb[1] * hb], [a[0] - na[0] * ha, a[1] - na[1] * ha]];
        el('polygon', { points: q.map(p => f(p[0]) + ',' + f(p[1])).join(' '), fill: UNDER }, g);
      }
    }
    return g;
  }

  let lanes = {};
  let current = null;
  function draw() {
    if (!loom.offsetWidth) return false; // the list carries the tree on narrow screens
    const L = loom.getBoundingClientRect();
    const ch = parseFloat(getComputedStyle(loom).fontSize) * 0.6;
    const d = 1.5 * ch, w = Math.max(6, 0.72 * ch);
    svg.setAttribute('viewBox', `0 0 ${f(L.width)} ${f(L.height)}`);
    svg.textContent = '';
    const threads = el('g', {}, svg), ribbon = el('g', {}, svg), knots = el('g', {}, svg);
    const R = Object.fromEntries(beads.map(b => [b.dataset.path, rel(b)]));

    // the ribbon comes down from the photograph's edge into the page, or from the top of its step
    const root = R.page, top = -(L.top - band.getBoundingClientRect().top);
    piece(ribbon, [[root.l + root.w / 2, top], [root.l + root.w / 2, root.t + 2]], w, 'page');

    // every parent drops one lane just left of its children and folds into each of them
    lanes = {};
    beads.forEach(pb => {
      const p = pb.dataset.path;
      const kids = beads.filter(b => parentOf(b.dataset.path) === p);
      if (!kids.length) return;
      const pr = R[p];
      const lane = Math.min(...kids.map(k => R[k.dataset.path].l)) - 2 * ch;
      lanes[p] = lane;
      kids.forEach(k => {
        const kr = R[k.dataset.path];
        const x0 = Math.min(pr.r - 2, lane - d);
        piece(ribbon, [[x0, pr.y], [lane - d, pr.y], [lane, pr.y + d], [lane, kr.y - d], [lane + d, kr.y], [kr.l + 2, kr.y]], w, k.dataset.path);
      });
    });

    // threads: each Java line joined to the tag of the same component on its row, under the ribbon
    lines.filter(e => colOf(e) === '1').forEach(j => {
      const r = rowOf(j), c = j.dataset.c;
      const t = lines.find(e => colOf(e) === '3' && rowOf(e) === r && ids(e).some(k => ids(j).includes(k)));
      if (!t || j.dataset.thread === 'no') return;
      const a = rel(j.querySelector('.x')), b = rel(t.querySelector('.x'));
      const y = rel(j).y;
      el('line', { class: 'thread', 'data-c': c, x1: f(a.r + 8), y1: f(y), x2: f(b.l - 8), y2: f(y) }, threads);
      // a panel's files: a knot where each instance of the panel passes them
      if (j.classList.contains('file')) {
        beads.filter(b => b.dataset.k.split(' ').includes(c) && rowOf(b) !== r).forEach(b => {
          const p = b.dataset.path;
          if (lanes[p] === undefined) return;
          const k = el('g', { class: 'seg', 'data-to': p }, knots);
          el('circle', { class: 'knot', cx: f(lanes[p]), cy: f(y), r: f(w * 0.62) }, k);
        });
      }
    });
    if (current) light(current.paths, current.keys);
    else if (focusKeys.length) rest();
    return true;
  }

  /* The ribbon grows into the step's new beads: their runs draw out from the parent, the
     reverse side and the knots fade in after. */
  function grow() {
    const fresh = new Set(beads.filter(b => b.classList.contains('new')).map(b => b.dataset.path));
    const segs = [...svg.querySelectorAll('.seg')].filter(s => fresh.has(s.dataset.to));
    if (!segs.length) return;
    segs.forEach(s => {
      s.classList.add('grow');
      s.querySelectorAll('path').forEach(p => p.style.setProperty('--len', Math.ceil(p.getTotalLength())));
    });
    svg.getBoundingClientRect();
    requestAnimationFrame(() => segs.forEach(s => s.classList.add('grown')));
  }

  /* A bead lights its path from the page and its lines; a line lights every bead that renders it. */
  function mark(paths, keys) {
    loom.classList.add('focused');
    const on = new Set();
    paths.forEach(p => { for (let q = p; q; q = parentOf(q)) on.add(q); });
    beads.forEach(b => {
      b.classList.toggle('on', paths.includes(b.dataset.path));
      b.classList.toggle('trail', on.has(b.dataset.path));
    });
    svg.querySelectorAll('.seg').forEach(s => s.classList.toggle('on', on.has(s.dataset.to)));
    lines.forEach(e => e.classList.toggle('on', ids(e).some(k => keys.includes(k))));
    svg.querySelectorAll('.thread').forEach(t => t.classList.toggle('on', ids(t).some(k => keys.includes(k))));
  }
  function light(paths, keys) {
    current = { paths, keys };
    mark(paths, keys);
  }
  // A step's focus: what it is about, lit while nothing is pointed at.
  function rest() {
    if (!focusKeys.length) return;
    mark(focusPaths, focusKeys);
    loom.classList.toggle('focused', focusPaths.length > 0);
  }
  function calm() {
    if (loom.contains(document.activeElement) && document.activeElement.classList.contains('bead')) return;
    current = null;
    loom.classList.remove('focused');
    loom.querySelectorAll('.on').forEach(e => e.classList.remove('on'));
    rest();
  }
  const fromBead = b => light([b.dataset.path], b.dataset.k.split(' '));
  const fromLine = e => {
    const keys = ids(e);
    light(beads.filter(b => b.dataset.k.split(' ').some(k => keys.includes(k))).map(b => b.dataset.path), keys);
  };

  beads.forEach((b, i) => {
    b.tabIndex = i === 0 ? 0 : -1;
    b.addEventListener('mouseenter', () => fromBead(b));
    b.addEventListener('focus', () => { beads.forEach(o => { o.tabIndex = o === b ? 0 : -1; }); fromBead(b); });
    b.addEventListener('click', () => fromBead(b));
    b.addEventListener('mouseleave', calm);
    b.addEventListener('blur', () => setTimeout(calm));
    b.addEventListener('keydown', e => {
      const n = { ArrowDown: i + 1, ArrowRight: i + 1, ArrowUp: i - 1, ArrowLeft: i - 1, Home: 0, End: beads.length - 1 }[e.key];
      if (n === undefined) return;
      e.preventDefault();
      beads[Math.max(0, Math.min(beads.length - 1, n))].focus();
    });
  });
  lines.forEach(e => { e.addEventListener('mouseenter', () => fromLine(e)); e.addEventListener('mouseleave', calm); });

  let raf = 0, first = true;
  function schedule() {
    cancelAnimationFrame(raf);
    raf = requestAnimationFrame(() => {
      if (!draw()) return;
      if (step) {
        // shown again (it measured nothing while hidden): grow into what is new in the step
        if (step.dataset.grow && !reduced.matches) grow();
        delete step.dataset.grow;
        return;
      }
      if (!first) return;
      first = false;
      if (reduced.matches) return;
      // the one authored moment: the ribbon unrolls down through the tree as it comes into view
      svg.classList.add('unroll');
      const go = () => requestAnimationFrame(() => { svg.classList.add('unrolled'); svg.classList.remove('unroll'); });
      if (!('IntersectionObserver' in window)) return go();
      const io = new IntersectionObserver(entries => {
        if (!entries.some(e => e.isIntersecting)) return;
        io.disconnect();
        go();
      }, { threshold: 0.2 });
      io.observe(loom);
    });
  }
  new ResizeObserver(schedule).observe(loom);
  if (document.fonts) document.fonts.ready.then(schedule);
  schedule();
});

/* ---------------------------------------------------------------- 2b. the tree as a list
   Below the loom's width the tree is a list of components followed by the four files. Each name
   becomes a bead that lights its lines in the files; on wide screens the list is only read aloud,
   so its beads leave the tab order there. */
document.querySelectorAll('.tree-list').forEach(list => {
  const code = list.nextElementSibling;
  if (!code || !code.classList.contains('tree-code')) return;
  const narrow = matchMedia('(max-width: 1239px)');
  const lines = [...code.querySelectorAll('.tcl[data-c], .tc-file[data-c]')];
  const beads = [...list.querySelectorAll('.tl-name b[data-c]')].map(b => {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'tl-bead';
    button.dataset.c = b.dataset.c;
    button.setAttribute('aria-pressed', 'false');
    button.innerHTML = b.innerHTML;
    b.replaceWith(button);
    return button;
  });
  const tabs = () => beads.forEach(b => { b.tabIndex = narrow.matches ? 0 : -1; });
  tabs();
  narrow.addEventListener('change', tabs);
  beads.forEach(bead => bead.addEventListener('click', () => {
    const on = bead.getAttribute('aria-pressed') !== 'true';
    beads.forEach(b => b.setAttribute('aria-pressed', 'false'));
    const keys = on ? bead.dataset.c.split(' ') : [];
    if (on) bead.setAttribute('aria-pressed', 'true');
    lines.forEach(l => l.classList.toggle('on', l.dataset.c.split(' ').some(k => keys.includes(k))));
  }));
});

/* ---------------------------------------------------------------- 2c. the steps of How Wicket works
   On wide screens one step shows at a time; the rail's beads, the Next links and the address
   (#step-4) choose it, so the back button walks back through the steps. On narrow screens all
   steps follow each other and the rail is their table of contents. */
(() => {
  const how = document.querySelector('.how');
  if (!how) return;
  const steps = [...how.querySelectorAll('.how-step')];
  const rail = [...how.querySelectorAll('.how-rail a')];
  const wide = matchMedia('(min-width: 1240px)');
  const at = () => Math.max(0, steps.findIndex(s => '#' + s.id === location.hash));
  let shown = -1;

  function show(i) {
    rail.forEach((a, j) => {
      a.parentElement.classList.toggle('done', wide.matches && j < i);
      if (wide.matches && j === i) a.setAttribute('aria-current', 'step'); else a.removeAttribute('aria-current');
    });
    steps.forEach((s, j) => {
      const hide = wide.matches && j !== i;
      if (!hide && s.hidden && j !== shown) s.dataset.grow = '1';
      s.hidden = hide;
    });
    how.classList.toggle('one-step', wide.matches);
    shown = i;
  }

  how.addEventListener('click', e => {
    const a = e.target.closest('a[href^="#step-"]');
    if (!a || !wide.matches || e.metaKey || e.ctrlKey || e.shiftKey) return;
    const i = steps.findIndex(s => '#' + s.id === a.getAttribute('href'));
    if (i < 0) return;
    e.preventDefault();
    if (i !== shown) history.pushState(null, '', '#' + steps[i].id);
    show(i);
    // keep the rail in view: the step's heading starts below it
    if (how.getBoundingClientRect().top < 0) how.scrollIntoView({ behavior: matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth' });
  });
  addEventListener('popstate', () => show(at()));
  wide.addEventListener('change', () => show(shown));
  show(at());
  if (location.hash && wide.matches) how.scrollIntoView();
})();

/* ---------------------------------------------------------------- 3. reading rail */
(() => {
  const links = document.querySelectorAll('.reading-rail a[href^="#"]');
  if (!links.length || !('IntersectionObserver' in window)) return;
  const byId = {};
  links.forEach(a => { byId[decodeURIComponent(a.getAttribute('href').slice(1))] = a; });
  const headings = Object.keys(byId).map(id => document.getElementById(id)).filter(Boolean);
  let current = null;
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      if (current) current.classList.remove('is-current');
      current = byId[entry.target.id];
      if (current) current.classList.add('is-current');
    });
  }, { rootMargin: '0px 0px -70% 0px' });
  headings.forEach(h => observer.observe(h));
})();
