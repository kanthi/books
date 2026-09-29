// Reliable reader / focus mode for Quarto books.
// Quarto's stock toggle is easy to miss visually (opacity-only chrome) and its
// onclick can race with other handlers. We own the control fully:
//   body.quarto-reader-active  → layout CSS hides sidebars + widens article
(function () {
  const STORAGE_KEY = "quarto-reader-mode";
  const BODY_CLASS = "quarto-reader-active";
  const TOGGLE_CLASS = "reader";

  function isOn() {
    try {
      return window.localStorage.getItem(STORAGE_KEY) === "true";
    } catch (_) {
      return document.body.classList.contains(BODY_CLASS);
    }
  }

  function setOn(on) {
    on = !!on;
    try {
      window.localStorage.setItem(STORAGE_KEY, on ? "true" : "false");
    } catch (_) {
      /* private mode / file restrictions */
    }
    document.documentElement.classList.toggle(BODY_CLASS, on);
    document.body.classList.toggle(BODY_CLASS, on);
    document.querySelectorAll(".quarto-reader-toggle").forEach(function (el) {
      el.classList.toggle(TOGGLE_CLASS, on);
      el.setAttribute("aria-pressed", on ? "true" : "false");
    });
  }

  function toggle(ev) {
    if (ev) {
      ev.preventDefault();
      ev.stopPropagation();
      if (ev.stopImmediatePropagation) ev.stopImmediatePropagation();
    }
    setOn(!isOn());
    return false;
  }

  function wireToggles() {
    document.querySelectorAll(".quarto-reader-toggle").forEach(function (el) {
      // Always re-bind: Quarto may re-render nav tools
      el.onclick = null;
      el.removeAttribute("onclick");
      el.setAttribute("href", "#");
      el.setAttribute("role", "button");
      el.setAttribute("aria-pressed", isOn() ? "true" : "false");
      el.setAttribute("title", "Toggle reader mode (hide sidebars, wider text)");
      if (el.dataset.readerWired === "1") return;
      el.dataset.readerWired = "1";
      // Capture phase so we win over any leftover handlers
      el.addEventListener("click", toggle, true);
    });
  }

  function installGlobal() {
    // Replace Quarto's implementation entirely (layout CSS is ours)
    window.quartoToggleReader = function () {
      setOn(!isOn());
    };
  }

  function init() {
    installGlobal();
    wireToggles();
    setOn(isOn());

    // Quarto assigns window.quartoToggleReader late in DOMContentLoaded — reassert
    let n = 0;
    const id = window.setInterval(function () {
      installGlobal();
      wireToggles();
      if (++n > 40) window.clearInterval(id);
    }, 50);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
