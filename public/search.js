(function () {
  'use strict';
  var BASE = new URL('.', (document.currentScript && document.currentScript.src) || location.href).href;
  var INDEX_URL = new URL('search-index.json', BASE).href;
  var indexCache = null;
  var lastQuery = '';

  var CSS = [
    '.tts-btn{display:inline-flex;align-items:center;gap:7px;font-family:ui-monospace,\'Cascadia Code\',\'JetBrains Mono\',monospace;font-size:11.5px;letter-spacing:0.05em;color:#9fc3dc;background:rgba(255,255,255,0.05);border:1px solid rgba(95,212,255,0.22);border-radius:999px;padding:5px 12px;cursor:pointer;transition:color .15s,border-color .15s,background .15s;white-space:nowrap;text-transform:lowercase;}',
    '.tts-btn:hover{color:#e7f5ff;border-color:rgba(95,212,255,0.5);background:rgba(63,201,242,0.12);}',
    '.tts-btn kbd{font:inherit;color:#6fa9cc;border:1px solid rgba(95,212,255,0.25);border-radius:4px;padding:0 4px;line-height:1.4;}',
    '.tts-overlay{position:fixed;inset:0;z-index:10000;display:none;align-items:flex-start;justify-content:center;padding:9vh 18px 18px;background:rgba(3,10,18,0.66);backdrop-filter:blur(10px);-webkit-backdrop-filter:blur(10px);}',
    '.tts-overlay.open{display:flex;}',
    '.tts-panel{width:100%;max-width:660px;max-height:82vh;display:flex;flex-direction:column;background:linear-gradient(180deg,#0a1420,#08101b);border:1px solid rgba(95,212,255,0.22);border-radius:16px;box-shadow:0 24px 70px rgba(0,0,0,0.55),0 0 40px rgba(63,201,242,0.12);overflow:hidden;}',
    '.tts-head{display:flex;align-items:center;gap:10px;padding:14px 16px;border-bottom:1px solid rgba(95,212,255,0.14);}',
    '.tts-head svg{flex:0 0 auto;color:#5bd4ff;}',
    '.tts-input{flex:1;background:transparent;border:none;outline:none;color:#e7f5ff;font-family:ui-monospace,\'Cascadia Code\',\'JetBrains Mono\',monospace;font-size:15px;padding:2px 0;}',
    '.tts-input::placeholder{color:#6a89a3;}',
    '.tts-hint{font-size:10.5px;color:#6a89a3;font-family:ui-monospace,\'Cascadia Code\',\'JetBrains Mono\',monospace;white-space:nowrap;}',
    '.tts-body{overflow-y:auto;overscroll-behavior:contain;padding:8px;}',
    '.tts-empty{padding:34px 18px;text-align:center;color:#6a89a3;font-size:13.5px;font-family:ui-monospace,\'Cascadia Code\',\'JetBrains Mono\',monospace;}',
    '.tts-item{display:block;padding:12px 14px;border-radius:10px;text-decoration:none;transition:background .12s;border-left:2px solid transparent;}',
    '.tts-item:hover,.tts-item.sel{background:rgba(63,201,242,0.1);border-left-color:#5bd4ff;}',
    '.tts-item.active-crumb{background:rgba(63,201,242,0.1);}',
    '.tts-ititle{color:#e7f5ff;font-weight:600;font-size:14.5px;line-height:1.35;}',
    '.tts-imeta{color:#6a89a3;font-family:ui-monospace,\'Cascadia Code\',\'JetBrains Mono\',monospace;font-size:11px;letter-spacing:0.04em;margin-top:2px;}',
    '.tts-chips{margin-top:8px;display:flex;flex-wrap:wrap;gap:6px;}',
    '.tts-chip{color:#9fc3dc;background:rgba(95,212,255,0.08);border:1px solid rgba(95,212,255,0.16);border-radius:6px;padding:2px 8px;font-family:ui-monospace,\'Cascadia Code\',\'JetBrains Mono\',monospace;font-size:11px;text-decoration:none;transition:border-color .12s,color .12s;}',
    '.tts-chip:hover{color:#e7f5ff;border-color:rgba(95,212,255,0.45);}',
    '.tts-mark{background:rgba(63,201,242,0.3);color:#e7f5ff;border-radius:3px;padding:0 1px;}',
    '.tts-count{font-size:10.5px;color:#6a89a3;font-family:ui-monospace,\'Cascadia Code\',\'JetBrains Mono\',monospace;margin:2px 2px 6px;}'
  ].join('\n');

  var style = document.createElement('style');
  style.id = 'tts-style';
  style.textContent = CSS;
  document.head.appendChild(style);

  function el(tag, attrs) {
    var n = document.createElement(tag);
    if (attrs) {
      Object.keys(attrs).forEach(function (k) { n.setAttribute(k, attrs[k]); });
    }
    return n;
  }

  var btn = el('button', { type: 'button', class: 'tts-btn', 'aria-label': 'Search topics', title: 'Search topics ( / )' });
  btn.innerHTML = '<svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" aria-hidden="true"><circle cx="10.5" cy="10.5" r="6.5"/><path d="M21 21l-4.35-4.35"/></svg><span>search</span><kbd>/</kbd>';

  var overlay = el('div', { class: 'tts-overlay', role: 'dialog', 'aria-label': 'Site search' });
  var panel = el('div', { class: 'tts-panel' });
  var head = el('div', { class: 'tts-head' });
  head.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" aria-hidden="true"><circle cx="10.5" cy="10.5" r="6.5"/><path d="M21 21l-4.35-4.35"/></svg>';
  var input = el('input', { class: 'tts-input', type: 'text', placeholder: 'search topics — e.g. types, control flow, simplex', autocomplete: 'off', spellcheck: 'false', 'aria-label': 'Search query' });
  var hint = el('span', { class: 'tts-hint' });
  hint.textContent = 'esc to close';
  head.appendChild(input);
  head.appendChild(hint);
  panel.appendChild(head);
  var body = el('div', { class: 'tts-body' });
  panel.appendChild(body);
  overlay.appendChild(panel);
  document.body.appendChild(overlay);

  function dock() {
    var siteline = document.querySelector('.siteline');
    if (siteline) {
      var tail = siteline.querySelector('.tail') || siteline;
      tail.insertBefore(btn, tail.firstChild);
      return;
    }
    var links = document.querySelector('.navlinks');
    if (links) {
      links.appendChild(btn);
      return;
    }
    var nav = document.querySelector('nav');
    if (nav) {
      nav.appendChild(btn);
      return;
    }
    btn.style.position = 'fixed';
    btn.style.top = '14px';
    btn.style.right = '14px';
    btn.style.zIndex = '9999';
    document.body.appendChild(btn);
  }
  dock();

  function loadIndex(done) {
    if (indexCache) { done(indexCache); return; }
    var shown = null;
    body.innerHTML = '<div class="tts-empty">loading index…</div>';
    fetch(INDEX_URL, { cache: 'no-store' }).then(function (r) { return r.json(); }).then(function (data) {
      indexCache = Array.isArray(data) ? data : (data.files || []);
      done(indexCache);
    }).catch(function () {
      body.innerHTML = '<div class="tts-empty">search index unavailable</div>';
    });
  }

  function tokens(q) {
    return q.toLowerCase().split(/\s+/).filter(Boolean);
  }

  function metaMarkup(e) {
    var parts = [];
    if (e.dir) parts.push(e.dir);
    if (e.sections && e.sections.length) parts.push(e.sections.length + ' section' + (e.sections.length === 1 ? '' : 's'));
    return parts.join(' · ');
  }

  function render(q) {
    lastQuery = q;
    var tks = tokens(q);
    if (!tks.length) {
      body.innerHTML = '<div class="tts-empty">type something to search</div>';
      return;
    }
    var scored = [];
    var cache = indexCache || [];
    for (var i = 0; i < cache.length; i++) {
      var e = cache[i];
      var title = (e.title || '').toLowerCase();
      var dir = (e.dir || '').toLowerCase();
      var titleAll = tks.every(function (x) { return title.indexOf(x) >= 0; });
      var s = titleAll ? 90 : 0;
      var hits = [];
      (e.sections || []).forEach(function (sec) {
        var st = (sec.t || '').toLowerCase();
        var n = 0;
        tks.forEach(function (x) { if (st.indexOf(x) >= 0) { n++; } });
        if (n > 0) { s += n * (titleAll ? 4 : 10); hits.push(sec); }
      });
      if (!titleAll) {
        var dn = tks.filter(function (x) { return dir.indexOf(x) >= 0; }).length;
        if (dn) { s += dn * 3; }
        var any = tks.filter(function (x) { return title.indexOf(x) >= 0 || hits.length; }).length;
        if (!hits.length && any === 0 && dn === 0) { s = 0; }
      }
      if (s > 0) scored.push({ e: e, s: s, hits: hits });
    }
    scored.sort(function (a, b) {
      if (b.s !== a.s) return b.s - a.s;
      return (a.e.title || '').localeCompare(b.e.title || '');
    });
    var top = scored.slice(0, 30);
    var frag = document.createDocumentFragment();
    var count = el('div', { class: 'tts-count' });
    count.textContent = top.length + ' of ' + scored.length + ' matches';
    frag.appendChild(count);
    if (!top.length) {
      var empty = el('div', { class: 'tts-empty' });
      empty.textContent = 'no matches for "' + q + '"';
      frag.appendChild(empty);
    } else {
      top.forEach(function (r) {
        frag.appendChild(itemMarkup(r.e, r.hits, tks));
      });
    }
    body.innerHTML = '';
    body.appendChild(frag);
  }

  function mark(text, tks) {
    var out = '';
    var low = text.toLowerCase();
    var i = 0;
    while (i < text.length) {
      var best = -1;
      var j = -1;
      for (var k = 0; k < tks.length; k++) {
        var at = low.indexOf(tks[k], i);
        if (at >= 0 && (at < best || best === -1)) { best = at; j = k; }
      }
      if (best === -1) { out += text.slice(i); break; }
      out += text.slice(i, best);
      out += '<mark class="tts-mark">' + text.substr(best, tks[j].length) + '</mark>';
      i = best + tks[j].length;
    }
    return out;
  }

  function itemMarkup(e, hits, tks) {
    var wrap = el('div', { class: 'tts-item' });
    var href = new URL(e.path, BASE).href;
    var link = el('a', { href: href, class: 'tts-item-link' });
    link.innerHTML = mark(e.title || e.path, tks);
    var meta = el('div', { class: 'tts-imeta' });
    meta.textContent = metaMarkup(e);
    wrap.appendChild(link);
    wrap.appendChild(meta);
    if (hits.length) {
      var chips = el('div', { class: 'tts-chips' });
      hits.slice(0, 4).forEach(function (sec) {
        var href2 = new URL(e.path + (sec.h ? '#' + sec.h : ''), BASE).href;
        var chip = el('a', { href: href2, class: 'tts-chip' });
        chip.innerHTML = mark(sec.t || 'section', tks);
        chips.appendChild(chip);
      });
      if (hits.length > 4) {
        var more = el('span', { class: 'tts-chip' });
        more.textContent = '+' + (hits.length - 4) + ' more';
        chips.appendChild(more);
      }
      wrap.appendChild(chips);
    }
    return wrap;
  }

  function openSearch() {
    overlay.classList.add('open');
    input.value = lastQuery;
    if (lastQuery) { render(lastQuery); }
    input.focus();
    input.select();
  }
  function closeSearch() {
    overlay.classList.remove('open');
    input.blur();
  }

  btn.addEventListener('click', function (e) {
    e.preventDefault();
    loadIndex(function () { openSearch(); });
  });

  overlay.addEventListener('click', function (e) {
    if (e.target === overlay) closeSearch();
  });

  document.addEventListener('keydown', function (e) {
    var tag = (e.target && e.target.tagName) || '';
    var typed = tag === 'INPUT' || tag === 'TEXTAREA' || (e.target && e.target.isContentEditable);
    if (e.key === 'Escape' && overlay.classList.contains('open')) { closeSearch(); return; }
    if (e.key === '/' && !typed && !overlay.classList.contains('open')) {
      e.preventDefault();
      loadIndex(function () { openSearch(); });
    }
  });

  input.addEventListener('input', function () {
    if (!indexCache) { loadIndex(function () { render(input.value); }); return; }
    render(input.value);
  });

  document.addEventListener('DOMContentLoaded', function () {
    try { localStorage.removeItem('theme'); } catch (err) {}
  });
})();