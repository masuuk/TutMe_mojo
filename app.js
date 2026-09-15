"use strict";

const appEl = document.getElementById("app");
const userNameEl = document.getElementById("userName");
const userChip = document.getElementById("userChip");
const modalRoot = document.getElementById("modalRoot");
const yearEl = document.getElementById("year");

const state = {
  userId: localStorage.getItem("tutme_user_id") || "petros",
  userName: "…",
  authed: false,
  stats: null,
  tracks: [],
  leaderboard: [],
  currentTrackId: null,
};

yearEl.textContent = new Date().getFullYear();

/* ---------- helpers ---------- */

async function api(path, options = {}) {
  const res = await fetch(path, {
    headers: { "Content-Type": "application/json" },
    ...options,
  });
  const text = await res.text().catch(() => "");
  let data = null;
  try { data = text ? JSON.parse(text) : null; } catch { data = null; }
  if (!res.ok) {
    const msg = (data && (data.error || data.message)) || text || res.statusText;
    const err = new Error(msg);
    err.status = res.status;
    throw err;
  }
  return data;
}

function formatDate(sqliteTs) {
  const d = new Date(String(sqliteTs).replace(" ", "T") + "Z");
  if (Number.isNaN(d.getTime())) return String(sqliteTs);
  return d.toLocaleDateString(undefined, { month: "short", day: "numeric", year: "numeric" });
}

function userQuery() {
  return state.authed ? "" : state.userId ? `?user=${encodeURIComponent(state.userId)}` : "";
}

function toast(msg) {
  const el = document.getElementById("toast");
  el.textContent = msg;
  el.classList.add("show");
  clearTimeout(el._t);
  el._t = setTimeout(() => el.classList.remove("show"), 2600);
}

/* ---------- markdown rendering ---------- */

function esc(text) {
  return String(text ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
}

const TOK_SPAN = "\u0000TOK";

function inlineMarkdown(text) {
  let html = esc(text);
  const codes = [];
  html = html.replace(/`([^`]+)`/g, (_m, c) => {
    codes.push(c);
    return `${TOK_SPAN}C${codes.length - 1}`;
  });
  html = html
    .replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>")
    .replace(/__([^_]+)__/g, "<strong>$1</strong>")
    .replace(/(^|[^*])\*([^*\n]+)\*/g, "$1<em>$2</em>")
    .replace(/(^|[^_])_([^_\n]+)_/g, "$1<em>$2</em>");
  return html.replace(new RegExp(`${TOK_SPAN}C(\\d+)`, "g"), (_m, i) => `<code>${codes[+i]}</code>`);
}

function blockMarkdown(block) {
  const chunks = block.split(/\n\s*\n/);
  return chunks
    .map((chunk) => {
      let html = "";
      let para = [];
      let list = null;
      let listOpen = false;
      const flushPara = () => {
        if (para.length) {
          html += `<p>${para.join("<br>")}</p>`;
          para = [];
        }
      };
      const closeList = () => {
        if (listOpen) {
          html += `</${list}>`;
          listOpen = false;
          list = null;
        }
      };
      for (const raw of chunk.split("\n")) {
        const line = raw.trim();
        if (!line) continue;
        let m;
        if ((m = line.match(/^(#{1,5})\s+(.*)$/))) {
          flushPara();
          closeList();
          const level = Math.min(m[1].length + 1, 4);
          html += `<h${level}>${inlineMarkdown(m[2])}</h${level}>`;
        } else if ((m = line.match(/^[-*+]\s+(.*)$/))) {
          flushPara();
          if (list !== "ul") {
            closeList();
            html += "<ul>";
            list = "ul";
            listOpen = true;
          }
          html += `<li>${inlineMarkdown(m[1])}</li>`;
        } else if ((m = line.match(/^\d+[.)]\s+(.*)$/))) {
          flushPara();
          if (list !== "ol") {
            closeList();
            html += "<ol>";
            list = "ol";
            listOpen = true;
          }
          html += `<li>${inlineMarkdown(m[1])}</li>`;
        } else {
          closeList();
          para.push(inlineMarkdown(line));
        }
      }
      flushPara();
      closeList();
      return html;
    })
    .join("");
}

const HIGHLIGHT_KEYWORDS = {
  python: ["def", "return", "import", "from", "as", "class", "if", "elif", "else", "for", "while", "with", "try", "except", "finally", "lambda", "yield", "global", "nonlocal", "pass", "break", "continue", "raise", "in", "is", "not", "and", "or", "True", "False", "None", "async", "await", "del"],
  mojo: ["fn", "def", "var", "let", "if", "else", "elif", "for", "while", "return", "struct", "class", "from", "import", "as", "in", "not", "and", "or", "True", "False", "None"],
  bash: ["if", "then", "else", "elif", "fi", "for", "do", "done", "while", "case", "esac", "echo", "export", "local", "return"],
  typescript: ["const", "let", "var", "function", "return", "async", "await", "if", "else", "for", "while", "import", "export", "from", "interface", "type", "class", "new", "this", "true", "false", "null", "undefined", "of", "in"],
  text: [],
};

function highlightCode(code, lang) {
  const kw = HIGHLIGHT_KEYWORDS[lang || ""] || [];
  let html = esc(code);
  const spans = [];
  html = html.replace(/(&quot;|")(?:[^"\\]|\\.)*(?:&quot;|")|'(?:[^'\\]|\\.)*'/g, (m, _q) => {
    spans.push({ cls: "tok-string", text: m });
    return `${TOK_SPAN}S${spans.length - 1}`;
  });
  html = html.replace(/(#[^\n]*|(?:\/\/)[^\n]*|\/\*[\s\S]*?\*\/)/g, (m) => {
    spans.push({ cls: "tok-comment", text: m });
    return `${TOK_SPAN}S${spans.length - 1}`;
  });
  if (kw.length) {
    const re = new RegExp(`\\b(${kw.map((k) => k.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")).join("|")})\\b`, "g");
    html = html.replace(re, (m) => {
      spans.push({ cls: "tok-keyword", text: m });
      return `${TOK_SPAN}S${spans.length - 1}`;
    });
  }
  html = html.replace(/\b(\d+(?:\.\d+)?)\b/g, (m) => {
    spans.push({ cls: "tok-number", text: m });
    return `${TOK_SPAN}S${spans.length - 1}`;
  });
  return html.replace(new RegExp(`${TOK_SPAN}S(\\d+)`, "g"), (_m, i) => `<span class="${spans[+i].cls}">${spans[+i].text}</span>`);
}

function renderContent(text) {
  const blocks = String(text).split(/```/);
  let html = "";
  blocks.forEach((block, i) => {
    if (i % 2 === 1) {
      const nl = block.indexOf("\n");
      const lang = (nl === -1 ? block : block.slice(0, nl)).trim().toLowerCase();
      const code = nl === -1 ? "" : block.slice(nl + 1).trimEnd();
      html += `<pre class="code-block"><code${lang ? ` class="lang-${esc(lang)}"` : ""}>${highlightCode(code, lang)}</code></pre>`;
    } else {
      html += blockMarkdown(block);
    }
  });
  return html;
}

const trackColor = (id) => ({ mojo: "#CE82FF", applications: "#1F7A8C" }[id] || "#306998");
const trackIconBg = (id) => ({ mojo: "#F8F0FF", applications: "#E0F2F5" }[id] || "#E3F0FA");

/* ---------- data loading ---------- */

async function loadBoot() {
  try {
    const me = await api("/api/me");
    state.authed = !!me.authenticated;
    state.userId = me.user.id;
    localStorage.setItem("tutme_user_id", state.userId);
    await reloadData();
  } catch (err) {
    appEl.innerHTML = `<div class="error-card"><h2>😵 Couldn't reach the server</h2><p>${esc(err.message)}</p><p>Make sure Bun is running: <code>bun run dev</code></p></div>`;
  }
}

async function reloadData() {
  const [stats, tracks, leaderboard] = await Promise.all([
    api(`/api/stats${userQuery()}`),
    api(`/api/tracks${userQuery()}`),
    api("/api/leaderboard"),
  ]);
  state.stats = stats;
  state.tracks = tracks.tracks;
  state.leaderboard = leaderboard.leaderboard;
  updateNavbar();
  route();
}

async function refreshStats() {
  try {
    state.stats = await api(`/api/stats${userQuery()}`);
    updateNavbar();
  } catch { /* non-fatal */ }
}

function updateNavbar() {
  state.userName = state.stats?.user?.displayName ?? state.userName;
  userNameEl.textContent = state.userName;
}

/* ---------- auth ---------- */

function openModal(html) {
  const overlay = document.createElement("div");
  overlay.className = "modal-overlay";
  overlay.setAttribute("role", "dialog");
  overlay.setAttribute("aria-modal", "true");
  overlay.setAttribute("aria-label", "Dialog");
  overlay.innerHTML = `<div class="modal-card">${html}</div>`;
  modalRoot.appendChild(overlay);
  const prevFocus = document.activeElement;
  requestAnimationFrame(() => {
    overlay.classList.add("open");
    const first = overlay.querySelector("input, button, select, textarea, [href], [tabindex]:not([tabindex='-1'])");
    if (first) first.focus();
  });
  const close = () => {
    overlay.classList.remove("open");
    setTimeout(() => {
      overlay.remove();
      if (prevFocus && typeof prevFocus.focus === "function") prevFocus.focus();
    }, 200);
  };
  overlay.addEventListener("click", (e) => { if (e.target === overlay) close(); });
  overlay.addEventListener("keydown", (e) => {
    if (e.key === "Escape") close();
    if (e.key === "Tab") {
      const focusables = overlay.querySelectorAll("input, button, select, textarea, [href], a, [tabindex]:not([tabindex='-1'])");
      if (!focusables.length) return;
      const first = focusables[0];
      const last = focusables[focusables.length - 1];
      if (e.shiftKey && document.activeElement === first) {
        e.preventDefault();
        last.focus();
      } else if (!e.shiftKey && document.activeElement === last) {
        e.preventDefault();
        first.focus();
      }
    }
  });
  return { overlay, close };
}

function openAccountModal() {
  const { close } = openModal(`
    <h3>Account</h3>
    <div class="account-info">
      <strong>${esc(state.userName)}</strong>
      <p>@${esc(state.stats?.user?.username ?? "")} · ⚡ ${state.stats?.xp ?? 0} XP · 🔥 ${state.stats?.streak ?? 0}d streak</p>
    </div>
    <div class="field"><label>Display name</label><input class="modal-input" id="renameInput" maxlength="40" value="${esc(state.userName)}"></div>
    <div class="modal-actions">
      <button class="btn-outline" id="renameBtn">Rename</button>
    </div>
    <div class="modal-actions" style="margin-top:12px;">
      <button class="btn-outline" id="closeAccount">Close</button>
    </div>
  `);

  modalRoot.lastElementChild.querySelector("#closeAccount").addEventListener("click", close);
  modalRoot.lastElementChild.querySelector("#renameBtn").addEventListener("click", async () => {
    const input = modalRoot.lastElementChild.querySelector("#renameInput");
    const name = input.value.trim();
    if (!name) return;
    try {
      await api(`/api/users/${state.userId}`, { method: "PATCH", body: JSON.stringify({ displayName: name }) });
      close();
      toast("✅ Name updated");
      await reloadData();
    } catch (err) {
      toast("⚠️ " + err.message);
    }
  });
}

/* ---------- rendering ---------- */

function renderHome() {
  const s = state.stats;
  const streak = s?.streak || 0;
  const xp = s?.xp ?? 0;
  const next = s?.nextLesson;

  const sidePanel = `
    <aside class="side-panel" id="sidePanel">
      <div class="sp-user">
        <span class="sp-avatar">${esc((state.userName || "?").charAt(0).toUpperCase())}</span>
        <div class="sp-user-info">
          <strong>${esc(state.userName ?? "Guest")}</strong>
          <small>⚡ ${xp} XP · 🔥 ${streak}d</small>
        </div>
      </div>

      <div class="sp-section">
        <span class="sp-label">Tracks</span>
        ${state.tracks.map((t) => {
          const done = t.completed_count ?? 0;
          const pct = t.lesson_count ? Math.round((done / t.lesson_count) * 100) : 0;
          return `
          <a class="sp-link" href="#/track/${t.id}">
            <span class="sp-icon">${t.emoji}</span>
            <span class="sp-body">
              <strong>${esc(t.name)}</strong>
              <span class="sp-bar"><i style="width:${pct}%"></i></span>
            </span>
            <span class="sp-pct">${pct}%</span>
          </a>`;
        }).join("")}
      </div>

      <div class="sp-section">
        <span class="sp-label">Quick Links</span>
        <button class="sp-link plain" data-scroll="tracks"><span class="sp-icon">📚</span><span class="sp-body"><strong>All Tracks</strong></span></button>
        <button class="sp-link plain" data-scroll="leaderboard"><span class="sp-icon">🏆</span><span class="sp-body"><strong>Leaderboard</strong></span></button>
        <a class="sp-link plain" href="#/track/applications"><span class="sp-icon">🧩</span><span class="sp-body"><strong>Applications</strong></span></a>
      </div>
    </aside>
  `;

  appEl.innerHTML = `
    <div class="home-layout">
    ${sidePanel}
    <div class="home-main">
    <section class="hero">
      <div class="hero-badge"><span>✨</span><span>Now featuring Mojo &amp; Data Science tracks</span></div>
      <h1>${s ? `Welcome back, ${esc(s.user.displayName)}.` : "Daily Code &amp; Math Mastery"}</h1>
      <p>Level up your programming and mathematical skills with interactive daily workouts, comprehensive textbooks, and real-world practical applications.</p>
      <div class="cta-group">
        ${next
          ? `<a class="btn btn-primary" href="#/lesson/${next.id}"><span>🚀</span> Continue: ${esc(next.title)}</a>`
          : `<a class="btn btn-primary" href="#/track/mojo"><span>💪</span> Start Daily Workout</a>`}
        <a class="btn btn-secondary" href="/mojo_v1/mojo-101.html"><span>🌱</span> Explore Mojo 101</a>
      </div>
    </section>

    <section class="features" id="tracks">
      <h2 class="section-title">Choose Your Learning Path</h2>
      <div class="features-grid">
        <a href="#/track/mojo" class="feature-card">
          <div class="feature-icon">💪</div>
          <span class="feature-tag">Interactive</span>
          <h3>Daily Workouts</h3>
          <p>Short, focused daily exercises to keep your coding and math skills sharp and build consistent habits.</p>
        </a>
        <a href="/mojo_v1/mojo-101.html" class="feature-card">
          <div class="feature-icon">🌱</div>
          <span class="feature-tag">Beginner Friendly</span>
          <h3>Mojo 101</h3>
          <p>Foundational programming concepts explained simply. Perfect for those just starting their tech journey.</p>
        </a>
        <a href="/mojo_v1/mojo-book-1.html" class="feature-card">
          <div class="feature-icon">📕</div>
          <span class="feature-tag">Reference</span>
          <h3>Text Books</h3>
          <p>In-depth reading materials and documentation for comprehensive understanding of core topics.</p>
        </a>
        <a href="#/track/applications" class="feature-card">
          <div class="feature-icon">⚙️</div>
          <span class="feature-tag">Advanced</span>
          <h3>Praxis</h3>
          <p>Real-world applications and projects to put your theoretical knowledge into practical, portfolio-ready use.</p>
        </a>
        <a href="/data-science/ds-tools.html" class="feature-card">
          <div class="feature-icon">🧪</div>
          <span class="feature-tag">Specialized</span>
          <h3>DS Tools</h3>
          <p>Master the essential tools and libraries for Data Science, analytics, and machine learning workflows.</p>
        </a>
      </div>
    </section>

    <div class="stats-bar">
      <div class="stat-card"><div class="stat-icon">⚡</div><div><div class="stat-value">${xp} XP</div><div class="stat-label">Total earned</div></div></div>
      <div class="stat-card"><div class="stat-icon">🔥</div><div><div class="stat-value">${streak} days</div><div class="stat-label">Streak</div></div></div>
      <div class="stat-card"><div class="stat-icon">✅</div><div><div class="stat-value">${s?.lessonsCompleted ?? 0}/${s?.totalLessons ?? 0}</div><div class="stat-label">Lessons done</div></div></div>
      <div class="stat-card"><div class="stat-icon">🏆</div><div><div class="stat-value">${s?.rank ?? "–"}${s?.totalLearners ? ` / ${s.totalLearners}` : ""}</div><div class="stat-label">Leaderboard rank</div></div></div>
    </div>

    <section class="section" id="leaderboard">
      <div class="section-header">
        <span class="section-badge">🏆 Leaderboard</span>
        <h2>Top Learners This Season</h2>
      </div>
      ${renderLeaderboard()}
    </section>

    <section class="cta-section">
      <div class="cta-dots top-left">✦ ✦ ✦</div>
      <div class="cta-dots bottom-right">● ● ●</div>
      <h2>Ready to Transform Your Skills?</h2>
      <p>Thousands of developers are getting smarter every day with TutMe. Don't get left behind.</p>
      <a class="btn btn-primary" href="#/track/mojo"><span>🌟</span> Start Your Free Journey</a>
    </section>
    </div>
    </div>
  `;

  document.getElementById("scrollLessons")?.addEventListener("click", () =>
    document.getElementById("tracks").scrollIntoView({ behavior: "smooth" })
  );
  appEl.querySelectorAll(".sp-link[data-scroll]").forEach((btn) =>
    btn.addEventListener("click", () =>
      document.getElementById(btn.dataset.scroll)?.scrollIntoView({ behavior: "smooth" })
    )
  );
  attachParallax();
}

function trackCard(t) {
  return `
    <a class="subject-card ${t.id}" href="#/track/${t.id}">
      <div class="subject-icon">${t.emoji}</div>
      <h3>${esc(t.name)}</h3>
      <p>${esc(t.description)}</p>
      <span class="lesson-count">📖 ${t.completed_count}/${t.lesson_count} Lessons</span>
      <div class="progress-bar-wrap"><div class="progress-bar-fill" style="width: ${t.progress}%;"></div></div>
      <div class="progress-text">${t.progress}% complete</div>
    </a>`;
}

// Emoji per book so each card gets its own identity instead of a generic page icon.
const REF_ICONS = [
  [/karney|kr[uü]ger|projection|mercator/i, "🧭"],
  [/npv|annuit|future value|money|codex/i, "💰"],
  [/decision|predict|dfl|optimiz/i, "🎯"],
];

function refCard(r) {
  const meta = { local: { icon: "📄", label: "Local book" } }[r.kind] || { icon: "📄", label: "Local book" };
  const icon = REF_ICONS.find(([re]) => re.test(r.title))?.[1] || meta.icon;
  return `
    <a class="ref-card" href="${esc(r.url)}">
      <span class="ref-icon">${icon}</span>
      <div class="ref-body">
        <h3>${esc(r.title)}</h3>
        ${r.note ? `<p>${esc(r.note)}</p>` : ""}
        <span class="ref-kind">${meta.label} · Read ↗</span>
      </div>
    </a>`;
}

function renderLeaderboard() {
  if (!state.leaderboard.length) return `<div class="leaderboard-card"><p>No learners yet — be the first!</p></div>`;
  const medals = ["🥇", "🥈", "🥉"];
  const rows = state.leaderboard
    .map(
      (r, i) => `
      <div class="leader-row ${r.id === state.userId ? "me" : ""}">
        <div class="leader-rank">${medals[i] || r.rank}</div>
        <div class="leader-info">
          <strong>${esc(r.displayName)} ${r.id === state.userId ? "(you)" : ""}</strong>
          <small> · ${r.lessonsCompleted} lessons · 🔥 ${r.streak}d</small>
        </div>
        <div class="leader-metrics">
          <div class="leader-xp">⚡ ${r.xp} XP</div>
          <div class="leader-sub">rank ${r.rank}</div>
        </div>
      </div>`
    )
    .join("");
  return `<div class="leaderboard-card">${rows}</div>`;
}

const LESSON_PAGE_SIZE = 8;

function lessonItemHtml(l, i, trackName) {
  const date = l.completedAt ? formatDate(l.completedAt) : "";
  return `
    <a class="lesson-item ${l.completed ? "completed" : ""}" href="#/lesson/${l.id}">
      <div class="lesson-num">${l.completed ? "✓" : `<span class="num-value">${i + 1}</span><span class="num-label">${esc(trackName)}</span>`}</div>
      <div class="lesson-item-body">
        <h3>${esc(l.title)}</h3>
        <p>${esc(l.summary)}${date ? `<small class="done-date">· ✅ ${date}</small>` : ""}</p>
      </div>
      <span class="lesson-xp">+${l.xp} XP</span>
      <span class="lesson-check">${l.completed ? "🎉" : "▶"}</span>
    </a>`;
}

const groupEmoji = (name) =>
  ({
    "Operations Research & Decision ML": "📊",
    "Geodesy & Surveying": "🌍",
    Finance: "💰",
  })[name] || "🗂️";

/* Lessons bucketed into named domains (Applications track): one section per
   group with its own progress bar; numbering stays global across the track. */
function groupedLessonsHtml(lessons, trackName, color) {
  const order = [];
  const byGroup = new Map();
  for (const l of lessons) {
    if (!byGroup.has(l.group)) {
      byGroup.set(l.group, []);
      order.push(l.group);
    }
    byGroup.get(l.group).push(l);
  }
  let idx = 0;
  return order
    .map((g) => {
      const items = byGroup.get(g);
      const done = items.filter((l) => l.completed).length;
      const pct = items.length ? Math.round((done / items.length) * 100) : 0;
      const start = idx;
      idx += items.length;
      return `<section class="lesson-group">
        <div class="lesson-group-header">
          <span class="lesson-group-icon">${groupEmoji(g)}</span>
          <h2>${esc(g)}</h2>
          <span class="lesson-group-count">${done}/${items.length}</span>
          <div class="progress-bar-wrap lesson-group-bar"><div class="progress-bar-fill" style="width:${pct}%;background:${color};"></div></div>
        </div>
        <div class="lesson-list">
          ${items.map((l, i) => lessonItemHtml(l, start + i, trackName)).join("")}
        </div>
      </section>`;
    })
    .join("");
}

async function renderTrack(id) {
  appEl.innerHTML = `<div class="loading">Loading track…</div>`;
  try {
    const data = await api(`/api/tracks/${id}${userQuery()}`);
    const t = data.track;
    state.currentTrackId = t.id;
    const done = data.lessons.filter((l) => l.completed).length;
    const pct = data.lessons.length ? Math.round((done / data.lessons.length) * 100) : 0;
    const color = trackColor(t.id);
    const firstPage = data.lessons.slice(0, LESSON_PAGE_SIZE);
    const moreCount = data.lessons.length - firstPage.length;
    const hasGroups = data.lessons.some((l) => l.group);
    const localRefs = (data.references || []).filter((r) => r.kind === "local" && r.url.endsWith(".html"));
    const refsHtml = localRefs.length
      ? `<section class="ref-section">
           <div class="ref-header">📚 Reference Textbooks</div>
           <p class="ref-sub">Local books that complement the lessons above.</p>
           <div class="ref-grid">${localRefs.map(refCard).join("")}</div>
         </section>`
      : "";

    const prevTrackBtn = data.prevTrackId
      ? `<a class="btn-outline nav-prev" href="#/track/${data.prevTrackId}">← ${esc(data.prevTrackName)}</a>`
      : `<span></span>`;
    const nextTrackBtn = data.nextTrackId
      ? `<a class="btn-primary nav-next" href="#/track/${data.nextTrackId}">${esc(data.nextTrackName)} →</a>`
      : `<span></span>`;

    appEl.innerHTML = `
      <nav class="breadcrumbs">
        <a href="#/">Home</a><span class="bc-sep">›</span>
        <span class="bc-current">${esc(t.name)}</span>
      </nav>
      <div class="track-header">
        <div class="subject-icon" style="background:${trackIconBg(t.id)};">${t.emoji}</div>
        <div>
          <h1 style="color:${color};">${esc(t.name)}</h1>
          <p>${esc(t.description)}</p>
        </div>
        <div class="track-progress">
          <strong style="font-size:1.4rem;">${pct}%</strong>
          <div class="progress-bar-wrap"><div class="progress-bar-fill" style="width:${pct}%;background:${color};"></div></div>
        </div>
      </div>
      ${hasGroups
        ? groupedLessonsHtml(data.lessons, t.name, color)
        : `<div class="lesson-list" id="lessonList">
             ${firstPage.map((l, i) => lessonItemHtml(l, i, t.name)).join("")}
           </div>
           ${moreCount > 0 ? `<div class="lesson-more"><button class="btn-outline" id="lessonShowMore" aria-expanded="false">Show more lessons (${moreCount} remaining)</button></div>` : ""}`}
      ${refsHtml}
      <div class="track-nav-footer">
        ${prevTrackBtn}
        <a class="btn-outline" href="#/">🏠 All Tracks</a>
        ${nextTrackBtn}
      </div>
    `;

    const showMore = document.getElementById("lessonShowMore");
    if (showMore) {
      showMore.addEventListener("click", () => {
        const list = document.getElementById("lessonList");
        const shown = list.querySelectorAll(".lesson-item").length;
        const next = Math.min(shown + LESSON_PAGE_SIZE, data.lessons.length);
        list.insertAdjacentHTML("beforeend", data.lessons.slice(shown, next).map((l, i) => lessonItemHtml(l, shown + i, t.name)).join(""));
        const left = data.lessons.length - next;
        if (left > 0) showMore.textContent = `Show more lessons (${left} remaining)`;
        else showMore.remove();
      });
    }
  } catch (err) {
    appEl.innerHTML = `<div class="error-card"><h2>😵 Couldn't load track</h2><p>${esc(err.message)}</p></div>`;
  }
}

/* ---------- quiz ---------- */

let lessonQuestions = [];
let lessonGeneration = 0;

function quizCard(ex) {
  if (ex.kind === "multiple_select") return multiCard(ex);
  if (ex.kind === "fill_blank") return blankCard(ex);
  return choiceCard(ex);
}

function resultHtml(ex, answered) {
  if (!answered) return "";
  const expected = ex.kind === "fill_blank" && ex.answer ? ` Expected answer: <code>${esc(ex.answer)}</code>.` : "";
  return `<div class="quiz-result ${answered.correct ? "correct" : "wrong"}">${answered.correct ? "✅ Correct!" : "❌ Not quite."}${answered.xpEarned ? ` <span>+${answered.xpEarned} XP</span>` : ""}</div>
       <div class="quiz-explanation">💡 ${esc(ex.explanation)}${expected}</div>`;
}

function choiceCard(ex) {
  const answered = ex.answered;
  const isTrace = ex.kind === "code_trace";
  const opts = ex.options
    .map((o) => {
      let cls = "quiz-option";
      if (isTrace) cls += " code-option";
      const picked = answered && (answered.selectedOptionIds || []).includes(o.id);
      if (answered) {
        if (picked) {
          cls += answered.correct ? " chosen-correct" : " chosen-wrong";
        } else if (!answered.correct && o.id === ex.correctOptionId) {
          cls += " show-correct";
        }
      }
      const content = isTrace ? `<code>${esc(o.label)}</code>` : esc(o.label);
      return `<button class="${cls}" type="button" role="radio" aria-checked="${picked ? "true" : "false"}" data-qid="${ex.id}" data-oid="${o.id}" ${answered ? "disabled" : ""}>${content}</button>`;
    })
    .join("");
  return `
    <div class="quiz-card ${answered ? "answered" : ""}" id="quiz-${ex.id}">
      <div class="quiz-prompt">${esc(ex.prompt)}</div>
      <div class="quiz-options" role="radiogroup" aria-label="Answer options">${opts}</div>
      ${resultHtml(ex, answered)}
    </div>`;
}

function multiCard(ex) {
  const answered = ex.answered;
  const sel = new Set(ex.selection || []);
  const opts = ex.options
    .map((o) => {
      const on = sel.has(o.id);
      let cls = "quiz-option";
      if (answered) {
        const correct = new Set(ex.correctOptionIds || []);
        if (correct.has(o.id)) cls += " show-correct";
        if (on) cls += correct.has(o.id) ? " chosen-correct" : " chosen-wrong";
      }
      return `<button class="${cls}" type="button" data-qid="${ex.id}" data-oid="${o.id}" ${answered ? "disabled" : ""} aria-pressed="${on ? "true" : "false"}">${on ? "☑ " : "☐ "}${esc(o.label)}</button>`;
    })
    .join("");
  const check = answered ? "" : `<button class="btn-primary quiz-check" type="button" data-submit="${ex.id}" ${sel.size ? "" : "disabled"}>Check Answer</button>`;
  return `
    <div class="quiz-card ${answered ? "answered" : ""}" id="quiz-${ex.id}">
      <div class="quiz-prompt">${esc(ex.prompt)}</div>
      <p class="quiz-hint">Select all that apply.</p>
      <div class="quiz-options">${opts}</div>
      ${check}
      ${resultHtml(ex, answered)}
    </div>`;
}

function blankCard(ex) {
  const answered = ex.answered;
  const value = ex.response || "";
  const input = answered
    ? `<div class="quiz-blank-answer">Your answer: <code>${esc(value)}</code></div>`
    : `<input class="modal-input quiz-blank-input" type="text" data-qid="${ex.id}" value="${esc(value)}" placeholder="Type your answer…" aria-label="Your answer">`;
  const check = answered ? "" : `<button class="btn-primary quiz-check" type="button" data-submit="${ex.id}" ${value.trim() ? "" : "disabled"}>Check Answer</button>`;
  return `
    <div class="quiz-card ${answered ? "answered" : ""}" id="quiz-${ex.id}">
      <div class="quiz-prompt">${esc(ex.prompt)}</div>
      ${input}
      ${check}
      ${resultHtml(ex, answered)}
    </div>`;
}

async function answerExercise(exId, payload) {
  const currentGen = lessonGeneration;
  const q = lessonQuestions.find((x) => x.id === exId);
  if (!q) return;
  try {
    const res = await api(`/api/exercises/${exId}/answer${userQuery()}`, {
      method: "POST",
      body: JSON.stringify(payload),
    });
    if (currentGen !== lessonGeneration) return;
    q.answered = res.answered;
    q.explanation = res.explanation;
    q.correctOptionId = res.correctOptionId;
    q.correctOptionIds = res.correctOptionIds;
    if (res.answer != null) q.answer = res.answer;
    const el = document.getElementById(`quiz-${exId}`);
    if (el) {
      el.outerHTML = quizCard(q);
      const fresh = document.getElementById(`quiz-${exId}`);
      if (fresh) fresh.scrollIntoView({ block: "nearest", behavior: "smooth" });
    }
    refreshQuizScore();
    if (res.correct && res.xpEarned) toast(`🎉 +${res.xpEarned} XP!`);
    else if (res.correct) toast("✅ Already earned that one!");
    else toast("❌ Not quite — check the explanation");
    refreshStats();
  } catch (err) {
    toast("⚠️ " + err.message);
  }
}

function refreshQuizScore() {
  const scoreEl = document.querySelector(".quiz-score");
  if (scoreEl) {
    const answeredCount = lessonQuestions.filter((x) => x.answered).length;
    scoreEl.textContent = `${answeredCount}/${lessonQuestions.length} questions answered`;
  }
}

function toggleMulti(ex, oid) {
  const sel = new Set(ex.selection || []);
  if (sel.has(oid)) sel.delete(oid);
  else sel.add(oid);
  ex.selection = [...sel];
  const el = document.getElementById(`quiz-${ex.id}`);
  if (el) el.outerHTML = quizCard(ex);
}

function submitFor(qid) {
  const ex = lessonQuestions.find((x) => x.id === qid);
  if (!ex || ex.answered) return;
  if (ex.kind === "multiple_select") {
    if (!ex.selection?.length) return;
    answerExercise(qid, { optionIds: ex.selection });
  } else if (ex.kind === "fill_blank") {
    if (!(ex.response || "").trim()) return;
    answerExercise(qid, { response: ex.response.trim() });
  }
}

/* ---------- lesson view ---------- */

async function renderLesson(id) {
  appEl.innerHTML = `<div class="loading">Loading lesson…</div>`;
  const gen = ++lessonGeneration;
  try {
    const lesson = await api(`/api/lessons/${id}${userQuery()}`);
    if (gen !== lessonGeneration) return;
    state.currentTrackId = lesson.track_id;
    updateNavbar();
    const color = trackColor(lesson.track_id);
    lessonQuestions = lesson.exercises || [];
    const answeredCount = lessonQuestions.filter((q) => q.answered).length;

    const prevBtn = lesson.prevLessonId
      ? `<a class="btn-outline nav-prev" href="#/lesson/${lesson.prevLessonId}">← Previous</a>`
      : `<span></span>`;
    const nextBtn = lesson.nextLessonId
      ? `<a class="btn-primary nav-next" href="#/lesson/${lesson.nextLessonId}">Next →</a>`
      : `<a class="btn-primary nav-next" href="#/track/${lesson.track_id}">Back to Track →</a>`;

    appEl.innerHTML = `
      <div class="lesson-view">
        <nav class="breadcrumbs">
          <a href="#/">Home</a><span class="bc-sep">›</span>
          <a href="#/track/${lesson.track_id}">${esc(lesson.trackName)}</a><span class="bc-sep">›</span>
          <span class="bc-current">${esc(lesson.title)}</span>
        </nav>
        <div class="lesson-meta">
          <span class="badge track" style="background:${color}1a;color:${color};">${esc(lesson.trackName)}</span>
          <span class="badge xp">+${lesson.xp} XP</span>
          ${lesson.completed ? `<span class="badge done">✅ Completed</span>` : ""}
        </div>
        <article class="lesson-card">
          <div class="lesson-chapter-label">Chapter ${lesson.position + 1} · ${esc(lesson.trackName)}</div>
          <h1>${esc(lesson.title)}</h1>
          <div class="lesson-content">${renderContent(lesson.content)}</div>
          <div class="lesson-actions">
            <button class="btn-primary btn-success" id="completeBtn" ${lesson.completed ? "disabled" : ""}>
              ${lesson.completed ? "✅ Already Completed" : "Mark as Complete"}
            </button>
          </div>
          <div id="completeToast"></div>
        </article>

        <section class="quiz-section">
          <div class="quiz-section-title">📝 Check Your Understanding</div>
          <p class="quiz-subtitle">Answer each question to earn +5 XP (first try only).</p>
          <div id="quizList">${lessonQuestions.map(quizCard).join("")}</div>
          <div class="quiz-score">${answeredCount}/${lessonQuestions.length || 0} questions answered</div>
        </section>

        <div class="lesson-nav-footer">
          ${prevBtn}
          <a class="btn-outline" href="#/track/${lesson.track_id}">📋 All Chapters</a>
          ${nextBtn}
        </div>
      </div>
    `;

    document.getElementById("completeBtn")?.addEventListener("click", async () => {
      const btn = document.getElementById("completeBtn");
      btn.disabled = true;
      btn.textContent = "Saving…";
      try {
        const res = await api(`/api/lessons/${id}/complete${userQuery()}`, { method: "POST" });
        await refreshStats();
        const toastEl = document.getElementById("completeToast");
        toastEl.innerHTML = `🎉 Lesson complete! <strong>+${res.xpEarned} XP</strong> earned · Total ⚡ ${res.stats.xp}`;
        btn.textContent = "✅ Completed!";
        toast("🎉 +" + res.xpEarned + " XP earned!");
      } catch (err) {
        btn.disabled = false;
        btn.textContent = "Mark as Complete";
        toast("⚠️ " + err.message);
      }
    });

  } catch (err) {
    appEl.innerHTML = `<div class="error-card"><h2>😵 Couldn't load lesson</h2><p>${esc(err.message)}</p></div>`;
  }
}

/* ---------- routing ---------- */

function route() {
  const hash = location.hash || "#/";
  const parts = hash.replace(/^#\//, "").split("/").filter(Boolean);

  document.querySelectorAll(".topic-pill").forEach((p) => {
    const target = p.dataset.href;
    const isHome = target === "#/" && parts.length === 0;
    const isTrack = parts[0] === "track" && target === `#/track/${parts[1]}`;
    const isLessonOnTrack = parts[0] === "lesson" && state.currentTrackId && target === `#/track/${state.currentTrackId}`;
    p.classList.toggle("active", isHome || isTrack || isLessonOnTrack);
  });
  const activePill = document.querySelector(".topic-pill.active");
  if (activePill && navPillTrack) {
    activePill.scrollIntoView({ block: "nearest", inline: "nearest", behavior: "smooth" });
  }

  // The landing page carries a dedicated dark theme (see styles.css "DARK HOME THEME").
  document.body.classList.toggle("dark-home", parts.length === 0);

  if (parts[0] === "track" && parts[1]) {
    renderTrack(parts[1]);
  } else if (parts[0] === "lesson" && parts[1]) {
    renderLesson(parts[1]);
  } else {
    renderHome();
  }
  updatePillScrollButtons();
}

window.addEventListener("hashchange", route);

/* ---------- interactions ---------- */

const navPillsEl = document.getElementById("navPills");
const navPillTrack = document.getElementById("navPillTrack");
const navScrollPrev = document.getElementById("navScrollPrev");
const navScrollNext = document.getElementById("navScrollNext");

const PILL_SCROLL_STEP = 200;

function updatePillScrollButtons() {
  if (!navPillTrack) return;
  const max = navPillTrack.scrollWidth - navPillTrack.clientWidth;
  navScrollPrev.disabled = navPillTrack.scrollLeft <= 0;
  navScrollNext.disabled = navPillTrack.scrollLeft >= max - 1;
}

if (navPillTrack) {
  navScrollPrev.addEventListener("click", () => {
    navPillTrack.scrollBy({ left: -PILL_SCROLL_STEP, behavior: "smooth" });
  });
  navScrollNext.addEventListener("click", () => {
    navPillTrack.scrollBy({ left: PILL_SCROLL_STEP, behavior: "smooth" });
  });
  navPillTrack.addEventListener("scroll", updatePillScrollButtons);
  window.addEventListener("resize", updatePillScrollButtons);
}

if (navPillsEl) {
  navPillsEl.addEventListener("click", (e) => {
    const pill = e.target.closest(".topic-pill");
    if (!pill) return;
    const href = pill.dataset.href;
    // Non-hash hrefs (e.g. the Mojo TextBook pill) open a full page in a new tab.
    if (href.startsWith("/")) {
      window.open(href, "_blank", "noopener");
      return;
    }
    if (location.hash === href) route();
    else location.hash = href;
  });
  navPillsEl.addEventListener("keydown", (e) => {
    if (!["ArrowLeft", "ArrowRight"].includes(e.key)) return;
    const buttons = [...navPillsEl.querySelectorAll(".topic-pill")];
    const idx = buttons.indexOf(document.activeElement);
    if (idx === -1) return;
    e.preventDefault();
    const next = (idx + (e.key === "ArrowRight" ? 1 : buttons.length - 1)) % buttons.length;
    buttons[next].focus();
    buttons[next].scrollIntoView({ block: "nearest", inline: "nearest", behavior: "smooth" });
    updatePillScrollButtons();
  });
}

appEl.addEventListener("click", (e) => {
  const submit = e.target.closest("[data-submit]");
  if (submit) {
    submitFor(Number(submit.dataset.submit));
    return;
  }
  const btn = e.target.closest(".quiz-option");
  if (btn && !btn.disabled) {
    const ex = lessonQuestions.find((x) => x.id === Number(btn.dataset.qid));
    if (!ex) return;
    if (ex.kind === "multiple_select") {
      toggleMulti(ex, Number(btn.dataset.oid));
    } else {
      answerExercise(ex.id, { optionId: Number(btn.dataset.oid) });
    }
  }
});

appEl.addEventListener("input", (e) => {
  const inp = e.target.closest(".quiz-blank-input");
  if (!inp) return;
  const ex = lessonQuestions.find((x) => x.id === Number(inp.dataset.qid));
  if (!ex) return;
  ex.response = inp.value;
  const check = inp.closest(".quiz-card")?.querySelector("[data-submit]");
  if (check) check.disabled = !inp.value.trim();
});

appEl.addEventListener("keydown", (e) => {
  if (e.key === "Enter" && e.target.classList.contains("quiz-blank-input")) {
    submitFor(Number(e.target.dataset.qid));
  }
});

userChip.addEventListener("click", openAccountModal);

function attachParallax() {
  const hero = document.querySelector(".hero-visual");
  if (!hero || window.innerWidth <= 900) return;
  if (hero._parallaxHandler) {
    hero.removeEventListener("mousemove", hero._parallaxHandler);
    hero.removeEventListener("mouseleave", hero._leaveHandler);
  }
  const cards = hero.querySelectorAll(".hero-card");
  hero._parallaxHandler = (e) => {
    const rect = hero.getBoundingClientRect();
    const x = (e.clientX - rect.left) / rect.width - 0.5;
    const y = (e.clientY - rect.top) / rect.height - 0.5;
    cards.forEach((card, i) => {
      const factor = (i + 1) * 8;
      card.style.transform = `translate(${x * factor}px, ${y * factor}px) rotate(${i * 3}deg)`;
    });
  };
  hero._leaveHandler = () => {
    cards.forEach((card, i) => (card.style.transform = `rotate(${i * 3}deg)`));
  };
  hero.addEventListener("mousemove", hero._parallaxHandler);
  hero.addEventListener("mouseleave", hero._leaveHandler);
}

/* ---------- search ---------- */

// Lesson index for search: built lazily on first search from the per-track
// endpoints (the list endpoint only returns counts), then cached. ~45 rows.
let searchIndex = null;

async function ensureSearchIndex() {
  if (searchIndex) return;
  const tracks = await Promise.all(
    state.tracks.map((t) => api(`/api/tracks/${t.id}`).catch(() => null))
  );
  searchIndex = { tracks: state.tracks, lessons: [] };
  for (const data of tracks) {
    if (!data) continue;
    for (const l of data.lessons) {
      searchIndex.lessons.push({
        id: l.id,
        title: l.title,
        summary: l.summary,
        trackId: data.track.id,
        trackName: data.track.name,
        emoji: data.track.emoji,
        color: trackColor(data.track.id),
      });
    }
  }
}

// Fold diacritics so "krueger" matches "Krüger": decompose, strip combining
// marks, then collapse German-style transliterations (ue→u, oe→o, ae→a) on
// both the haystack and the needle.
function fold(s) {
  return String(s)
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/ue/g, "u")
    .replace(/oe/g, "o")
    .replace(/ae/g, "a");
}

function searchScore(haystack, needle) {
  const idx = haystack.indexOf(needle);
  if (idx === -1) return -1;
  return idx === 0 ? 3 : haystack.startsWith(" ") && haystack.lastIndexOf(" ", idx - 1) === idx - 1 ? 2 : 1;
}

function runSearch(q) {
  const needle = fold(q).trim();
  if (!needle || !searchIndex) return [];
  const results = [];
  for (const t of searchIndex.tracks) {
    if (fold(t.name).includes(needle)) {
      results.push({ kind: "track", href: `#/track/${t.id}`, title: t.name, sub: t.description, emoji: t.emoji, color: trackColor(t.id), score: 10 });
    }
  }
  for (const l of searchIndex.lessons) {
    const sTitle = searchScore(fold(l.title), needle);
    const sSum = sTitle === -1 ? searchScore(fold(l.summary), needle) : 0;
    const best = Math.max(sTitle, sSum);
    if (best > 0) {
      results.push({
        kind: "lesson",
        href: `#/lesson/${l.id}`,
        title: l.title,
        sub: l.summary,
        emoji: l.emoji,
        color: l.color,
        score: sTitle * 10 + sSum,
      });
    }
  }
  return results.sort((a, b) => b.score - a.score).slice(0, 12);
}

function searchResultHtml(r, active) {
  const kindLabel = r.kind === "track" ? "Track" : r.kind === "library" ? "Library" : "Lesson";
  const sub = r.kind === "track" ? `Track · ${r.sub}` : r.kind === "library" ? `${r.trackName} · ${r.sub}` : `${r.trackName ?? ""} · ${r.sub}`;
  return `
    <a class="search-result ${active ? "active" : ""}" href="${r.href}">
      <span class="search-result-icon" style="background:${r.color}1a;">${r.emoji}</span>
      <span class="search-result-body">
        <strong>${esc(r.title)}</strong>
        <small>${esc(sub)}</small>
      </span>
      <span class="search-result-kind">${kindLabel}</span>
    </a>`;
}

async function openSearchModal() {
  const { overlay, close } = openModal(`
    <h3>Search</h3>
    <input class="modal-input" id="searchInput" type="text" placeholder="Search lessons, tracks & library…" autocomplete="off" aria-label="Search lessons, tracks and library">
    <div class="search-results" id="searchResults" role="listbox" aria-label="Search results"><div class="search-empty">Type to search…</div></div>
  `);
  const input = overlay.querySelector("#searchInput");
  const resultsEl = overlay.querySelector("#searchResults");
  let results = [];
  let activeIdx = -1;

  const render = () => {
    if (!results.length) {
      resultsEl.innerHTML = `<div class="search-empty">${input.value.trim() ? "No matches found." : "Type to search…"}</div>`;
      return;
    }
    activeIdx = Math.min(activeIdx, results.length - 1);
    resultsEl.innerHTML = results.map((r, i) => searchResultHtml(r, i === activeIdx)).join("");
  };

  // Library chapters live server-side (~60 static HTML pages), so they're
  // searched via /api/library-search and merged into the local lesson/track
  // results. Each keystroke re-fetches; the request is cheap and cacheable,
  // and late responses for stale queries are dropped via the seq guard.
  let libSeq = 0;
  const fetchLibrary = async (q) => {
    const seq = ++libSeq;
    if (!q.trim()) return [];
    try {
      const data = await api(`/api/library-search?q=${encodeURIComponent(q)}`);
      if (seq !== libSeq) return [];
      return (data.results || []).map((r) => ({
        kind: "library",
        href: r.href,
        title: r.title,
        trackName: r.book || "Library",
        sub: r.snippet || "Library chapter",
        emoji: "📖",
        color: "#f59e0b",
        score: r.score,
      }));
    } catch {
      return [];
    }
  };

  const update = async () => {
    try {
      await ensureSearchIndex();
    } catch {
      resultsEl.innerHTML = `<div class="search-empty">Couldn't load the lesson index.</div>`;
      return;
    }
    activeIdx = -1;
    const local = runSearch(input.value);
    const lib = await fetchLibrary(input.value);
    results = [...local, ...lib].sort((a, b) => b.score - a.score).slice(0, 12);
    render();
  };

  input.addEventListener("input", update);

  // Keyboard navigation: arrows move, Enter opens, Escape closes (handled by openModal).
  input.addEventListener("keydown", (e) => {
    if (!results.length) return;
    if (e.key === "ArrowDown" || e.key === "ArrowUp") {
      e.preventDefault();
      activeIdx = (activeIdx + (e.key === "ArrowDown" ? 1 : -1) + results.length) % results.length;
      render();
      resultsEl.querySelector(".search-result.active")?.scrollIntoView({ block: "nearest" });
    } else if (e.key === "Enter") {
      const pick = results[Math.max(activeIdx, 0)];
      if (pick) {
        close();
        location.hash = pick.href;
      }
    }
  });

  // Clicking a result navigates via the normal hash router.
  resultsEl.addEventListener("click", (e) => {
    const link = e.target.closest(".search-result");
    if (link) close();
  });
}

document.getElementById("searchBtn")?.addEventListener("click", openSearchModal);
window.addEventListener("keydown", (e) => {
  if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "k") {
    e.preventDefault();
    openSearchModal();
  }
});

/* ---------- boot ---------- */

loadBoot();
