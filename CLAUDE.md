# CLAUDE.md — Claude Code & Claude Agent Instructions

> **Context Reference**: This repository uses [`AGENTS.md`](./AGENTS.md) as the primary project specification and architectural guide. Please read [`AGENTS.md`](./AGENTS.md) for full context.

---

## Build & Test Commands

* **Compile Binary**:
  ```cmd
  build.bat
  ```
  *Compiles `src/MacMode.ahk` $\rightarrow$ `bin/MacMode.exe` using bundled Ahk2Exe.*

* **Update & Hot-Reload (Running Application)**:
  ```cmd
  update.bat
  ```
  *Terminates current `MacMode.exe`, recompiles, and relaunches via WMI.*

* **Install to Startup**:
  ```cmd
  install.bat
  ```

* **Uninstall / Stop**:
  ```cmd
  uninstall.bat
  ```

* **Syntax Check**:
  ```cmd
  & "C:\Users\princ\Desktop\Setup\ahk_v1\AutoHotkeyU64.exe" /ErrorStdOut "src\MacMode.ahk"
  ```

---

## Critical Development Conventions

1. **Hardware Invariants**:
   * Laptop: ASUS VivoBook X571GT.
   * `Fn` key is wired directly to the Embedded Controller (EC) and does not emit OS scan codes when pressed alone. Do not attempt to remap it.
   * `Ctrl` is native Control (`⌃`). Never remap it to `Win` (avoids Start Menu popups).
   * `Alt` (left of Space) is Mac Command (`⌘`).
   * `Win` is Mac Option (`⌥`).
2. **AutoHotkey v1 Syntax**:
   * Use AutoHotkey v1.1 syntax only (v2 syntax will fail compilation with `Ahk2Exe`).
   * Avoid duplicate hotkey identifiers (e.g. `+!2` and `!+2` conflict).
3. **Tray Toggle**:
   * Left-click on tray icon toggles between Apple logo (Mac Mode) and Windows logo (Windows Mode).
   * Global toggle shortcut: `Ctrl + Alt + P`.
4. **Git Workflow**:
   * Author: `Shlok Zanwar <shlokzanwar14@gmail.com>`.
   * Remote: `https://github.com/Shlok-Zanwar/mac-mode.git` on branch `main`.
