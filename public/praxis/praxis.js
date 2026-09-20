document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-quiz]").forEach((quiz) => {
    const opts = [...quiz.querySelectorAll(".opt")];
    const checkBtn = quiz.querySelector(".check");
    const resetBtn = quiz.querySelector(".reset");
    const feedback = quiz.querySelector(".feedback");
    const explain = quiz.querySelector(".explain");
    if (!checkBtn) return;
    checkBtn.addEventListener("click", () => {
      const picked = opts.find((o) => {
        const i = o.querySelector("input");
        return i && i.checked;
      });
      if (!picked) {
        if (feedback) {
          feedback.textContent = "Pick an answer first.";
          feedback.className = "feedback no";
        }
        return;
      }
      opts.forEach((o) => {
        const input = o.querySelector("input");
        if (input) input.disabled = true;
        const correct = o.dataset.correct === "true";
        o.classList.add(correct ? "is-correct" : "is-wrong");
        if (correct) o.classList.remove("is-wrong");
      });
      if (feedback) {
        feedback.textContent = picked.dataset.correct === "true" ? "Correct!" : "Not quite — the right answer is highlighted above.";
        feedback.className = "feedback " + (picked.dataset.correct === "true" ? "ok" : "no");
      }
      if (explain) explain.hidden = false;
    });
    if (resetBtn) {
      resetBtn.addEventListener("click", () => {
        opts.forEach((o) => {
          const input = o.querySelector("input");
          input.checked = false;
          input.disabled = false;
          o.classList.remove("is-correct", "is-wrong");
        });
        if (feedback) feedback.textContent = "";
        if (explain) explain.hidden = true;
      });
    }
  });

  const esc = (s) =>
    s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  const RX = new RegExp(
    [
      "(#[^\\n]*)",
      '("""[\\s\\S]*?"""|"(?:[^"\\\\\\n]|\\\\.)*"|\'(?:[^\'\\\\\\n]|\\\\.)*\')',
      "(@[A-Za-z_]\\w*)",
      "\\b(var|fn|def|struct|trait|enum|alias|let|const|for|in|while|if|elif|else|return|from|import|as|with|try|except|raises|owned|borrowed|inout|self|Self|pass|break|continue|and|or|not|True|False|None|comptime|package|constraint)\\b",
      "\\b(\\d[\\d_]*(?:\\.\\d+)?(?:[eE][+-]?\\d+)?)\\b",
      "\\b([A-Z][A-Za-z0-9_]*)\\b",
      "([A-Za-z_]\\w*)(?=\\s*\\()",
    ].join("|"),
    "g"
  );
  const highlight = (src) => {
    let out = "";
    let last = 0;
    let m;
    while ((m = RX.exec(src))) {
      out += esc(src.slice(last, m.index));
      const cls = m[1]
        ? "tok-com"
        : m[2]
        ? "tok-str"
        : m[3]
        ? "tok-dec"
        : m[4]
        ? "tok-kw"
        : m[5]
        ? "tok-num"
        : m[6]
        ? "tok-type"
        : "tok-fn";
      out += '<span class="' + cls + '">' + esc(m[0]) + "</span>";
      last = m.index + m[0].length;
    }
    return out + esc(src.slice(last));
  };
  document.querySelectorAll("pre.code").forEach((el) => {
    if (el.textContent.trim() === "") return;
    el.innerHTML = highlight(el.textContent);
  });
});