// fix_mojo_11_syntax.mjs — mechanical Mojo 1.1 fixes for code embedded in public/*.html
// Run with:  bun scripts/fix_mojo_11_syntax.mjs            (apply)
//            bun scripts/fix_mojo_11_syntax.mjs --dry-run  (report only)
//
// Applies span-aware, string-aware mechanical fixes to MOJO/UNKNOWN <pre> blocks:
//   1. `//` -> `#` comments (MOJO blocks only; never `//,`; never inside strings/#-comments)
//   2. bare stdlib imports get `std.` prefix:
//        from math import ...       -> from std.math import ...
//        from math.linalg import ... -> from std.std-less math.linalg import ... -> std.math.linalg
//      (modules: math, random, time, testing, algorithm, memory, runtime, sys, os, pathlib)
//   3. `from collections import ...` lines are DELETED (List/Dict/Optional are prelude in 1.1)
//   4. memcpy -> unsafe_memcpy (renamed in 1.1)
//
// Structural fixes (@parameter, alloc/dealloc, List ctors, __str__) are done by hand.
import { readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = new URL("..", import.meta.url).pathname;
const HTML_DIR = join(ROOT, "public");
const DRY = process.argv.includes("--dry-run");

const STD_MODULES = "math|random|time|testing|algorithm|memory|runtime|sys|os|pathlib";

function walk(dir) {
  let out = [];
  for (const e of readdirSync(dir)) {
    const p = join(dir, e);
    if (statSync(p).isDirectory()) out = out.concat(walk(p));
    else if (p.endsWith(".html")) out.push(p);
  }
  return out;
}

function unescape(html) {
  return html
    .replace(/<[^>]+>/g, "")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&amp;/g, "&")
    .replace(/&#39;/g, "'")
    .replace(/&quot;/g, '"')
    .replace(/&#x2019;/g, "'");
}

function heuristic(code) {
  let mojo = 0, py = 0, shell = 0;
  if (/\bstruct\s+\w+/.test(code)) mojo += 3;
  if (/\bcomptime\b/.test(code)) mojo += 3;
  if (/\bSIMD\s*\[/.test(code)) mojo += 3;
  if (/^\s*from\s+std\b/m.test(code) || /^\s*import\s+\w+\s*$/m.test(code)) mojo += 2;
  if (/\b(?:mut|out|deinit)\s+self\b/.test(code)) mojo += 2;
  if (/\b(?:Pointer|OptionalPointer|Allocation|Span|Layout)\s*\[/.test(code)) mojo += 2;
  if (/\b(?:unsafe_load|unsafe_store|unsafe_offset|codepoint_slices)\s*\(/.test(code)) mojo += 2;
  if (/\b(?:allequal|reduce_add|scalar)\(/.test(code)) mojo += 2;
  if (/\bdef\s+\w+\s*\[/.test(code)) mojo += 2;
  if (/\b(?:fn|let|alias|inout|owned|borrowed|@parameter|@value)\b/.test(code)) mojo += 2;
  if (/\bdealloc\s*\(/.test(code) || /\balloc\s*\(/.test(code)) mojo += 1;
  if (/\bimport\s+(?:numpy|pandas|torch|sklearn|matplotlib|scipy)\b/.test(code)) py += 3;
  if (/\bfrom\s+(?:sklearn|torch|numpy|pandas)\b/.test(code)) py += 2;
  if (/\bif\s+__name__\b/.test(code)) py += 2;
  if (/\.append\s*\(/.test(code) || /\.extend\s*\(/.test(code)) py += 1;
  if (/\bprint\s*\(\s*f["']/.test(code)) py += 1;
  if (/\blambda\b/.test(code)) py += 2;
  if (/\[[^\]]+\s+for\s+[^\]]+\s+in\b/.test(code)) py += 2;
  if (/\bdef\s+\w+\s*\([^)]*self\s*[,)]/.test(code)) py += 1;
  if (/^\s*(?:pixi|uv|curl|pip|npm|bun|cargo|git)\b/m.test(code)) shell += 3;
  return { mojo, py, shell };
}

function classify(preTag, code) {
  const cls = (preTag.match(/class="([^"]*)"/) || [])[1] || "";
  const toks = cls.split(/\s+/).filter(Boolean);
  if (toks.some((t) => /mojo/.test(t))) return "MOJO";
  if (toks.some((t) => t === "py" || /^python/.test(t))) return "PYTHON";
  const id = (preTag.match(/\bid="([^"]*)"/) || [])[1] || "";
  if (/^mojo/.test(id)) return "MOJO";
  if (/^python/.test(id)) return "PYTHON";
  const dLang = (preTag.match(/\bdata-lang="([^"]*)"/) || [])[1] || "";
  if (/mojo/.test(dLang)) return "MOJO";
  if (/python|py\b/.test(dLang)) return "PYTHON";
  const h = heuristic(code);
  if (h.mojo > h.py && h.mojo > h.shell) return "MOJO";
  if (h.py > h.mojo && h.py > h.shell) return "PYTHON";
  if (h.shell >= h.mojo && h.shell > h.py) return "SHELL";
  return "UNKNOWN";
}

// Flatten raw <pre> content to display text, keeping per-char raw [start,end) spans.
function flatten(raw) {
  const text = [];
  const start = [];
  const end = [];
  let i = 0;
  while (i < raw.length) {
    const ch = raw[i];
    if (ch === "<") {
      const gt = raw.indexOf(">", i);
      i = gt === -1 ? raw.length : gt + 1;
      continue;
    }
    if (ch === "&") {
      const semi = raw.indexOf(";", i);
      const ent = semi !== -1 && semi - i <= 10 ? raw.slice(i, semi + 1) : "";
      const dec =
        ent === "&lt;" ? "<" :
        ent === "&gt;" ? ">" :
        ent === "&amp;" ? "&" :
        ent === "&#39;" ? "'" :
        ent === "&quot;" ? '"' :
        ent === "&#x2019;" ? "'" : null;
      if (dec !== null) {
        start.push(i); text.push(dec); end.push(semi + 1);
        i = semi + 1;
        continue;
      }
    }
    start.push(i); text.push(ch); end.push(i + 1);
    i++;
  }
  return { text: text.join(""), start, end };
}

// Scan flattened text for `//` comment markers, returning [start,end] char ranges.
// Skips `//,` (valid parametric separator), strings (incl. escapes + triple-quote), # comments.
function findSlashComments(text) {
  const hits = [];
  const n = text.length;
  let inStr = null;      // ", '  or '"""' '''''
  let triple = false;
  let i = 0;
  while (i < n) {
    const ch = text[i];
    const next = text[i + 1];
    if (inStr) {
      if (ch === "\\") { i += 2; continue; }
      if (triple) {
        if (text.startsWith(inStr, i)) { inStr = null; triple = false; i += 3; continue; }
      } else if (ch === inStr) {
        inStr = null;
      }
      i++;
      continue;
    }
    // not in string
    if (ch === "#") {
      // skip to end of line (hash comment)
      while (i < n && text[i] !== "\n") i++;
      continue;
    }
    if (ch === '"' || ch === "'") {
      if (text.startsWith(ch.repeat(3), i)) { inStr = ch.repeat(3); triple = true; i += 3; continue; }
      inStr = ch; i++; continue;
    }
    if (ch === "/" && next === "/") {
      if (text[i + 2] !== ",") {
        hits.push([i, i + 2]);
        // rest of the line is comment content — stop scanning it
        while (i < n && text[i] !== "\n") i++;
      } else {
        i += 2; // `//,` — valid parametric separator, keep scanning
      }
      continue;
    }
    i++;
  }
  return hits;
}

const IMPORT_RE = new RegExp(
  "\\bfrom\\s+(" + STD_MODULES + "(?:\\.[A-Za-z_][A-Za-z0-9_]*)?)\\s+import\\b",
  "g"
);
// No ^/$/\n anchors: files use CRLF, so line-anchored patterns mis-handle `\r`.
// Matches just the `from collections import` head; rawLineDelete removes the whole raw line.
const COLLECTIONS_RE = /\bfrom\s+collections\s+import\b/g;
const MEMCPY_RE = /\bmemcpy\b/g;

function rawLineDelete(raw, charPos) {
  const nlBefore = raw.lastIndexOf("\n", charPos - 1);
  const nlAfter = raw.indexOf("\n", charPos);
  const start = nlBefore + 1;
  const end = nlAfter === -1 ? raw.length : nlAfter + 1;
  return { start, end };
}

// Fix one block's raw content. Returns {raw, changes: [{start,end,text,label}]}
function fixBlock(raw, lang) {
  const { text, start, end } = flatten(raw);
  const changes = []; // {rawStart, rawEnd, text, label}

  // 1) `//` -> `#` (MOJO only)
  if (lang === "MOJO") {
    for (const [a, b] of findSlashComments(text)) {
      changes.push({ rawStart: start[a], rawEnd: end[b - 1], text: "#", label: "//:#" });
    }
  }

  // 2) bare stdlib imports -> std. prefix
  IMPORT_RE.lastIndex = 0;
  let m;
  while ((m = IMPORT_RE.exec(text)) !== null) {
    const modStart = m.index + m[0].indexOf(m[1]);
    changes.push({ rawStart: start[modStart], rawEnd: start[modStart], text: "std.", label: "std prefix" });
  }

  // 3) delete `from collections import ...` lines
  COLLECTIONS_RE.lastIndex = 0;
  let cm;
  while ((cm = COLLECTIONS_RE.exec(text)) !== null) {
    const { start: rs, end: re } = rawLineDelete(raw, start[cm.index]);
    changes.push({ rawStart: rs, rawEnd: re, text: "", label: "del collections" });
  }

  // 4) memcpy -> unsafe_memcpy
  MEMCPY_RE.lastIndex = 0;
  let mm;
  while ((mm = MEMCPY_RE.exec(text)) !== null) {
    changes.push({ rawStart: start[mm.index], rawEnd: end[mm.index + 5], text: "unsafe_memcpy", label: "memcpy" });
  }

  return { raw, changes };
}

// ---------------------------------------------------------------------------
const files = walk(HTML_DIR);
const perFile = [];
let total = 0;

for (const file of files) {
  const html = readFileSync(file, "utf8");
  if (!html.includes("<pre")) continue;

  const tabMap = {};
  const tabs = /<button[^>]*class="[^"]*tab-btn[^"]*"[^>]*data-tab="([^"]*)"[^>]*>([\s\S]*?)<\/button>/g;
  let tm;
  while ((tm = tabs.exec(html))) tabMap[tm[1]] = unescape(tm[2]).trim();

  const paneRanges = [];
  const paneRe = /<div[^>]*data-lang="(mojo|python|shell)[^"]*"[^>]*>([\s\S]*?)<\/div>/g;
  let pm;
  while ((pm = paneRe.exec(html))) {
    const inner = pm[2];
    const preIdx = inner.indexOf("<pre");
    if (preIdx === -1) continue;
    const start = pm.index + pm[0].indexOf("<pre", 0);
    const relEnd = inner.indexOf("</pre>", preIdx);
    paneRanges.push({ lang: pm[1], start, end: start + relEnd + "</pre>".length });
  }

  let out = html;
  let fileChanges = [];
  const blockEdits = []; // {index, len, preTag, fixed} — spliced into OUT in REVERSE order

  const preRe = /<pre([^>]*)>([\s\S]*?)<\/pre>/g;
  let m, idx = 0;
  while ((m = preRe.exec(html))) {
    idx++;
    const preTag = m[1];
    const raw = m[2];
    const code = unescape(raw);

    let containerLang = null;
    const before = html.slice(0, m.index);
    const tabContent = before.match(/<div[^>]*class="[^"]*tab-content[^"]*"[^>]*id="([^"]*)"[^>]*>[\s\S]*$/);
    if (tabContent && tabMap[tabContent[1]]) containerLang = tabMap[tabContent[1]].toLowerCase();
    for (const pr of paneRanges) {
      if (m.index >= pr.start && m.index < pr.end) { containerLang = pr.lang; break; }
    }
    let lang;
    const dLangAttr = (preTag.match(/\bdata-lang="([^"]*)"/) || [])[1] || "";
    const dLabel = (preTag.match(/\bdata-label="([^"]*)"/) || [])[1] || "";
    if (dLangAttr) lang = /mojo/.test(dLangAttr) ? "MOJO" : /python|py\b/.test(dLangAttr) ? "PYTHON" : "SHELL";
    else if (/mojo/.test(dLabel.toLowerCase())) lang = "MOJO";
    else if (/python|py\b/.test(dLabel.toLowerCase())) lang = "PYTHON";
    else lang = classify(preTag, code);
    if (containerLang) {
      if (/mojo/.test(containerLang)) lang = "MOJO";
      else if (/python|py/.test(containerLang)) lang = "PYTHON";
    }
    if (lang !== "MOJO" && lang !== "UNKNOWN") continue;

    const { changes } = fixBlock(raw, lang);
    if (!changes.length) continue;

    const sorted = changes.slice().sort((a, b2) => b2.rawStart - a.rawStart);
    // Overlap guard: change ranges are in ORIGINAL coordinates; applying them in
    // descending rawStart order is only safe when no later (smaller-rawStart)
    // range contains an earlier change's start (e.g. an insert inside a deleted
    // region). Detect & skip instead of silently corrupting.
    let prevLo = raw.length, prevHi = raw.length, overlapping = false;
    for (const c of sorted) {
      if (c.rawStart < prevHi && c.rawEnd > prevLo) { overlapping = true; break; }
      prevLo = Math.min(prevLo, c.rawStart);
      prevHi = Math.max(prevHi, c.rawEnd);
    }
    if (overlapping) {
      console.error(`  !! OVERLAPPING CHANGES in ${file} block#${idx} — skipped`);
      continue;
    }
    let fixed = raw;
    for (const c of sorted) {
      fixed = fixed.slice(0, c.rawStart) + c.text + fixed.slice(c.rawEnd);
    }
    // sanity: span balance must not REGRESS vs the original block
    const bal = (s) => (s.match(/<span\b/g) || []).length - (s.match(/<\/span>/g) || []).length;
    if (bal(fixed) !== bal(raw)) {
      console.error(`  !! SPAN BALANCE CHANGED in ${file} block#${idx} (${bal(raw)} -> ${bal(fixed)}) — skipped`);
      continue;
    }
    total += changes.length;
    fileChanges.push({ block: idx, lang, n: changes.length, kinds: [...new Set(changes.map((c) => c.label))] });
    blockEdits.push({ index: m.index, len: m[0].length, preTag, fixed });
  }

  // Splice all block edits into `out` in REVERSE offset order so that edits at
  // higher positions never shift the offsets of lower positions (all offsets
  // were computed against the ORIGINAL html).
  blockEdits.sort((a, b) => b.index - a.index);
  for (const e of blockEdits) {
    out = out.slice(0, e.index) + "<pre" + e.preTag + ">" + e.fixed + "</pre>" + out.slice(e.index + e.len);
  }

  if (fileChanges.length) perFile.push({ file: file.replace(HTML_DIR + "/", ""), changes: fileChanges });

  if (!DRY && fileChanges.length) writeFileSync(file, out, "utf8");
}

perFile.sort((a, b) => a.file.localeCompare(b.file));
for (const f of perFile) {
  console.log(f.file);
  for (const c of f.changes) {
    console.log(`  block#${c.block} (${c.lang}): ${c.n} change(s) [${c.kinds.join(", ")}]`);
  }
}
console.log(`\n${DRY ? "[dry-run] planned" : "applied"} ${total} change(s) across ${perFile.length} file(s).`);