// check_mojo_11_syntax.mjs — audit Mojo 1.1 syntax compliance of code embedded in public/*.html
// Run with:  bun scripts/check_mojo_11_syntax.mjs [--json]
// Static check only (no mojo compiler on PATH). Flags syntax that Mojo 1.1 removed
// (hard parse errors) plus patterns that were renamed/deprecated for 1.1.
import { readFileSync, readdirSync, statSync } from "fs";
import { join, basename } from "path";

const ROOT = new URL("..", import.meta.url).pathname; // repo root
const HTML_DIR = join(ROOT, "public");
const WANT_JSON = process.argv.includes("--json");

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

// ---------------------------------------------------------------------------
// Rules. Each rule: { label, level: "HARD"|"RENAMED"|"ADVISORY", re, fix }
// Names refer to the Blue Print / mojo-syntax skill for Mojo 1.1.
// ---------------------------------------------------------------------------
const RULES = [
  { label: "fn keyword", level: "HARD", re: /\bfn\b/g, fix: "`fn` removed in 1.1 — use `def`" },
  { label: "let keyword", level: "HARD", re: /\blet\s+[A-Za-z_]\w*(?=\s*=)/g, fix: "`let` removed — use `var` (no `let` in 1.1)" },
  { label: "alias keyword", level: "HARD", re: /\balias\s+[A-Za-z_]/g, fix: "`alias` removed — use `comptime`" },
  { label: "inout convention", level: "HARD", re: /\binout\b/g, fix: "`inout` removed — use `mut` (and `out self` in __init__)" },
  { label: "owned convention", level: "HARD", re: /\bowned\b/g, fix: "`owned` removed — `var` is owned-by-default in 1.1" },
  { label: "borrowed convention", level: "HARD", re: /\bborrowed\b/g, fix: "`borrowed` removed — use `imm` (default)" },
  { label: "read convention", level: "HARD", re: /\bread\s+[A-Za-z_]/g, fix: "`read` arg convention is a hard error — use `imm`" },
  { label: "@value decorator", level: "HARD", re: /@value\b/g, fix: "removed — use `@fieldwise_init` + traits" },
  { label: "@parameter", level: "HARD", re: /@parameter\b/g, fix: "renamed to `@__parameter` (legacy only) — migrate to unified closures or `comptime if/for`" },
  { label: "@parameter if/for", level: "HARD", re: /@parameter\s+(if|for)\b/g, fix: "removed — use `comptime if` / `comptime for`" },
  { label: "old @always_inline/@no_inline", level: "RENAMED", re: /@(?:always_inline|no_inline)\b/g, fix: "use `@inline(.always)` / `@inline(.never)`" },
  { label: "@register_passable", level: "HARD", re: /@register_passable\b/g, fix: "removed — conform to `RegisterPassable` / `TrivialRegisterPassable` traits" },
  { label: "escaping closures", level: "HARD", re: /\bescaping\b/g, fix: "removed — use unified closures with capture lists" },
  { label: "__del__", level: "HARD", re: /\b__del__\s*\(/g, fix: "removed — use `__deinit__(deinit self)`" },
  { label: "constrained()", level: "HARD", re: /\bconstrained\s*\(/g, fix: "removed — use `comptime assert`" },
  { label: "Stringable / __str__", level: "HARD", re: /\bStringable\b|\b__str__\b/g, fix: "removed — conform to `Writable` / `write_to`" },
  { label: "old imports (collections)", level: "HARD", re: /\bfrom\s+collections\s+import/g, fix: "use `from std.collections import` (List/Dict/Optional are prelude — import may be deletable)" },
  { label: "old imports (memory)", level: "HARD", re: /\bfrom\s+memory\s+import/g, fix: "use `from std.memory import`" },
  { label: "old imports (sys)", level: "HARD", re: /\bfrom\s+sys\s+import/g, fix: "use `from std.sys import`" },
  { label: "old imports (os)", level: "HARD", re: /\bfrom\s+os\s+import/g, fix: "use `from std.os import`" },
  { label: "old imports (pathlib)", level: "HARD", re: /\bfrom\s+pathlib\s+import/g, fix: "use `from std.pathlib import`" },
  { label: "old imports (runtime)", level: "HARD", re: /\bfrom\s+runtime\s+import/g, fix: "use `from std.runtime import`" },
  { label: "old imports (math)", level: "HARD", re: /\bfrom\s+math\s+import/g, fix: "use `from std.math import` (most math fns are in the prelude — import may be deletable)" },
  { label: "old imports (algorithm)", level: "HARD", re: /\bfrom\s+algorithm\s+import/g, fix: "use `from std.algorithm import`" },
  { label: "old imports (random)", level: "HARD", re: /\bfrom\s+random\s+import/g, fix: "use `from std.random import`" },
  { label: "old imports (time)", level: "HARD", re: /\bfrom\s+time\s+import/g, fix: "use `from std.time import`" },
  { label: "old imports (testing)", level: "HARD", re: /\bfrom\s+testing\s+import/g, fix: "use `from std.testing import`" },
  { label: "bare `from std import`", level: "HARD", re: /\bfrom\s+std\s+import/g, fix: "`std` itself is not importable — import from `std.<module>`" },
  { label: "DynamicVector", level: "HARD", re: /\bDynamicVector\b/g, fix: "removed — use `List[T]`" },
  { label: "InlinedFixedVector", level: "HARD", re: /\bInlinedFixedVector\b/g, fix: "removed — use `Array[T, N]`" },
  { label: "UnsafePointer family", level: "HARD", re: /\b(?:Mut|Imm|Optional)?UnsafePointer\b/g, fix: "use `Pointer[T, mut=_, origin=_]` / `OptionalPointer`" },
  { label: "alloc[T]( count ) old form", level: "ADVISORY", re: /\balloc\s*\[\s*[A-Za-z_]+\s*\]\s*\(/g, fix: "prefer `alloc(Layout[T](count=n))` (old form still compiles with warning, being renamed)" },
  { label: "pointer .free()", level: "ADVISORY", re: /\.free\s*\(\s*\)/g, fix: "removed — use `dealloc(allocation^)`" },
  { label: "// comment lines", level: "ADVISORY", re: null, fix: "not a valid Mojo comment — use `#` (note: `//,` param separators are valid 1.1 syntax)" },
  { label: "List variadic positional ctor", level: "ADVISORY", re: null, fix: "List has no variadic positional constructor — use bracket literal `[a, b, c]` or named args (size=, capacity=)" },
  { label: "f-string literal", level: "INFO", re: /\bf["']/g, fix: "valid in Mojo 1.1 but prefer t-strings (`t\"...\"`) / String.format" },
];

// Content heuristics used only when class/tab/label give no signal.
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
  if (/\bdef\s+\w+\s*\([^)]*self\s*[,)]/.test(code)) py += 1; // python-style method

  if (/^\s*(?:pixi|uv|curl|pip|npm|bun|cargo|git)\b/m.test(code)) shell += 3;
  return { mojo, py, shell };
}

// Strip `#` and `//` comments and then string literals, for keyword scanning.
function stripComments(code) {
  return code
    .split("\n")
    .map((line) => {
      const hash = line.indexOf("#");
      const slashes = line.indexOf("//");
      let cut = -1;
      for (const i of [hash, slashes]) {
        if (i !== -1 && (cut === -1 || i < cut)) cut = i;
      }
      return cut === -1 ? line : line.slice(0, cut);
    })
    .join("\n");
}

function stripStrings(code) {
  return code
    .replace(/"""(?:[^"\\]|\\.)*?"""/g, '""" """')
    .replace(/'''(?:[^'\\]|\\.)*?'''/g, "''' '''")
    .replace(/"(?:[^"\\\n]|\\.)*"/g, '""')
    .replace(/'(?:[^'\\\n]|\\.)*'/g, "''");
}

// Find `List[T](a, b, c)` calls with >= 2 positional (non-keyword) args.
function findVariadicList(target) {
  const re = /\bList\s*\[\s*[A-Za-z_.]+\s*\]\s*\(/g;
  const hits = [];
  let m;
  while ((m = re.exec(target)) !== null) {
    let depth = 1;
    let i = re.lastIndex;
    const parts = [];
    let start = i;
    while (i < target.length) {
      const ch = target[i];
      if (ch === "(" || ch === "[" || ch === "{") depth++;
      else if (ch === ")" || ch === "]" || ch === "}") {
        depth--;
        if (depth === 0) break;
      } else if (ch === "," && depth === 1) {
        parts.push(target.slice(start, i));
        start = i + 1;
      }
      i++;
    }
    if (depth !== 0) continue; // unbalanced — skip
    parts.push(target.slice(start, i));
    const positional = parts.filter((a) => !/^\s*[A-Za-z_]\w*\s*=/.test(a) && a.trim() !== "");
    if (positional.length >= 2) hits.push(target.slice(m.index, i + 1));
  }
  return hits;
}

// ---------------------------------------------------------------------------
// Scan
// ---------------------------------------------------------------------------
const files = walk(HTML_DIR);
const findings = [];
let counts = { files: 0, blocks: 0, jsFields: 0, mojo: 0, python: 0, shell: 0, unknown: 0, violations: 0 };
const byRule = {};
const blockLabel = (i) => "block#" + i;

// Pre-extract pane data-lang divs per file
function classify(preTag, code) {
  // 1) pane data-lang divs handled in scan (containerInfo).
  // 2) class tokens on <pre>
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
  // 3) content heuristic
  const h = heuristic(code);
  if (h.mojo > h.py && h.mojo > h.shell) return "MOJO";
  if (h.py > h.mojo && h.py > h.shell) return "PYTHON";
  if (h.shell >= h.mojo && h.shell > h.py) return "SHELL";
  return "UNKNOWN";
}

for (const file of files) {
  const html = readFileSync(file, "utf8");
  if (!html.includes("<pre")) continue;
  counts.files++;

  // Map tab-content ids -> tab button labels
  const tabMap = {};
  const tabs = /<button[^>]*class="[^"]*tab-btn[^"]*"[^>]*data-tab="([^"]*)"[^>]*>([\s\S]*?)<\/button>/g;
  let tm;
  while ((tm = tabs.exec(html))) tabMap[tm[1]] = unescape(tm[2]).trim();

  // Map pane div data-lang region to the immediate pre inside
  // (match pane divs first, mark pre ranges, fall back to generic <pre> scan)
  const paneRanges = [];
  const paneRe = /<div[^>]*data-lang="(mojo|python|shell)[^"]*"[^>]*>([\s\S]*?)<\/div>/g;
  let pm;
  while ((pm = paneRe.exec(html))) {
    const inner = pm[2];
    const preIdx = inner.indexOf("<pre");
    if (preIdx === -1) continue;
    const start = pm.index + pm[0].indexOf("<pre", 0);
    // find matching </pre> relative to that <pre>
    const relEnd = inner.indexOf("</pre>", preIdx);
    paneRanges.push({ lang: pm[1], start, end: start + relEnd + "</pre>".length });
  }

  const preRe = /<pre([^>]*)>([\s\S]*?)<\/pre>/g;
  let m, idx = 0;
  while ((m = preRe.exec(html))) {
    idx++;
    counts.blocks++;
    const preTag = m[1];
    const raw = m[2];
    const code = unescape(raw);

    // container info: tab-content id enclosing this pre
    let containerLang = null;
    const before = html.slice(0, m.index);
    const tabContent = before.match(/<div[^>]*class="[^"]*tab-content[^"]*"[^>]*id="([^"]*)"[^>]*>[\s\S]*$/);
    if (tabContent && tabMap[tabContent[1]]) containerLang = tabMap[tabContent[1]].toLowerCase();
    // pane range check
    for (const pr of paneRanges) {
      if (m.index >= pr.start && m.index < pr.end) { containerLang = pr.lang; break; }
    }
    let lang;
    const dLangAttr = (preTag.match(/\bdata-lang="([^"]*)"/) || [])[1] || "";
    const dLabel = (preTag.match(/\bdata-label="([^"]*)"/) || [])[1] || "";
    if (dLangAttr) lang = /mojo/.test(dLangAttr) ? "MOJO" : /python|py\b/.test(dLangAttr) ? "PYTHON" : "SHELL";
    else if (/mojo/.test(dLabel.toLowerCase()) || /mojo 1\.[01]/.test(dLabel.toLowerCase())) lang = "MOJO";
    else if (/python|py\b/.test(dLabel.toLowerCase())) lang = "PYTHON";
    else lang = classify(preTag, code);
    if (containerLang) {
      // container label wins when a tab is labelled mojo but the pre has no signal
      if (/mojo/.test(containerLang)) lang = "MOJO";
      else if (/python|py/.test(containerLang)) lang = "PYTHON";
    }
    if (lang === "MOJO") counts.mojo++;
    else if (lang === "PYTHON") counts.python++;
    else if (lang === "SHELL") counts.shell++;
    else counts.unknown++;

    // Run rules on MOJO blocks; on UNKNOWN run only HARD rules as "unclassified"
    if (lang === "MOJO" || lang === "UNKNOWN") {
      const lineOf = (offset) => html.slice(0, m.index + offset).split("\n").length;
      audit(file, blockLabel(idx), lang, code, lineOf(0));
    }
  }

  // ----------------------------------------------------------------
  // JS-embedded Mojo fields (progressive.html ladders):
  //   code:'…'  solutionCode:'…'   — single-quoted with \n escapes
  // ----------------------------------------------------------------
  const jsCodeRe = /(?:code|solutionCode):\s*'((?:[^'\\]|\\.)*)'/g;
  let jm, jidx = 0;
  while ((jm = jsCodeRe.exec(html)) !== null) {
    jidx++;
    counts.jsFields++;
    if (jm[1].trim() === "") continue;
    const rawJs = jm[1];
    // decode \n \r \t \\ \' \uXXXX escapes
    const code = rawJs
      .replace(/\\n/g, "\n").replace(/\\r/g, "").replace(/\\t/g, "\t")
      .replace(/\\'/g, "'").replace(/\\u([0-9a-fA-F]{4})/g, (_, h) => String.fromCharCode(parseInt(h, 16)));
    audit(file, `js#${jidx}`, "MOJO", code, html.slice(0, jm.index).split("\n").length);
  }
}

// Run the rule battery against one code snippet.
function audit(file, blockLabel, lang, code, blockStartLine) {
  const relFile = file.replace(HTML_DIR + "/", "");
  const runRules = lang === "MOJO" ? RULES : RULES.filter((r) => r.level === "HARD");
  for (const rule of runRules) {
    // `//` comment rule scans raw lines directly (regex `\s*^` shifts line
    // counts). The `//,` form is the valid parametric-separator syntax.
    if (rule.label === "// comment lines") {
      const rawLines = code.split("\n");
      for (let li = 0; li < rawLines.length; li++) {
        if (!/^\s*\/\/[^\n]*/.test(rawLines[li]) || /^\s*\/\/,/.test(rawLines[li])) continue;
        counts.violations++;
        byRule[rule.label] = (byRule[rule.label] || 0) + 1;
        findings.push({
          file: relFile,
          block: blockLabel,
          lang,
          rule: rule.label,
          level: rule.level,
          line: blockStartLine + li + 1,
          snippet: rawLines[li].trim().slice(0, 110),
          fix: rule.fix,
        });
        break;
      }
      continue;
    }
    // keyword rules get comments AND strings stripped; f-string rule keeps strings
    let target;
    if (rule.label === "f-string literal") target = stripComments(code);
    else target = stripStrings(stripComments(code));

    // custom structural rule: variadic List[...](...) constructor
    if (rule.label === "List variadic positional ctor") {
      for (const hit of findVariadicList(target)) {
        const blockRelLine = target.slice(0, target.indexOf(hit)).split("\n").length;
        counts.violations++;
        byRule[rule.label] = (byRule[rule.label] || 0) + 1;
        findings.push({
          file: relFile,
          block: blockLabel,
          lang,
          rule: rule.label,
          level: rule.level,
          line: blockStartLine + blockRelLine,
          snippet: hit.trim().slice(0, 110),
          fix: rule.fix,
        });
        break;
      }
      continue;
    }

    rule.re.lastIndex = 0;
    let rm;
    while ((rm = rule.re.exec(target)) !== null) {
      if (rm[0].trim() === "") continue;
      const blockRelLine = target.slice(0, rm.index).split("\n").length;
      counts.violations++;
      byRule[rule.label] = (byRule[rule.label] || 0) + 1;
      const snippet = target.split("\n")[blockRelLine - 1]?.trim().slice(0, 110) || "";
      findings.push({
        file: relFile,
        block: blockLabel,
        lang,
        rule: rule.label,
        level: rule.level,
        line: blockStartLine + blockRelLine - 1,
        snippet,
        fix: rule.fix,
      });
      break; // one hit per block per rule is enough
    }
  }
}

findings.sort((a, b) => a.file.localeCompare(b.file) || a.line - b.line);

if (WANT_JSON) {
  console.log(JSON.stringify({ scans: counts, findings }, null, 2));
} else {
  const byLevel = { HARD: 0, RENAMED: 0, ADVISORY: 0, INFO: 0 };
  for (const f of findings) byLevel[f.level]++;

  console.log("=== Mojo 1.1 syntax compliance scan ===");
  console.log(`files scanned      : ${counts.files} (${files.length} html on disk, ${files.length - counts.files} without <pre>)`);
  console.log(`code blocks total  : ${counts.blocks} <pre> blocks + ${counts.jsFields} JS-embedded snippets`);
  console.log(`  MOJO   : ${counts.mojo}`);
  console.log(`  PYTHON : ${counts.python}`);
  console.log(`  SHELL  : ${counts.shell}`);
  console.log(`  UNKNOWN: ${counts.unknown}`);
  console.log(`findings by level  : HARD ${byLevel.HARD} | RENAMED ${byLevel.RENAMED} | ADVISORY ${byLevel.ADVISORY} | INFO(f-string) ${byLevel.INFO}`);
  console.log(`violations (non-INFO): ${byLevel.HARD + byLevel.RENAMED + byLevel.ADVISORY}`);
  console.log("\n=== by rule ===");
  for (const [r, n] of Object.entries(byRule).sort((a, b) => b[1] - a[1])) {
    console.log(`  ${String(n).padStart(3)}  ${r}`);
  }
  console.log("\n=== details (excluding INFO) ===");
  let cur = "";
  for (const f of findings) {
    if (f.level === "INFO") continue;
    if (f.file !== cur) { console.log(`\n${f.file}`); cur = f.file; }
    console.log(`  [${f.level}] ${f.block} (${f.lang}) line ${f.line}: ${f.snippet}`);
    console.log(`        fix: ${f.fix}`);
  }
  console.log("\n=== INFO (f-strings — valid 1.1, t-strings preferred) count per file ===");
  const infoByFile = {};
  for (const f of findings) if (f.level === "INFO") infoByFile[f.file] = (infoByFile[f.file] || 0) + 1;
  for (const [f, n] of Object.entries(infoByFile).sort((a, b) => b[1] - a[1])) console.log(`  ${String(n).padStart(3)}  ${f}`);
  console.log("\nNote: static scan only — `mojo` compiler not on PATH. No type/ownership/semantic analysis.");
}