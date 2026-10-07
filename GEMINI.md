# GEMINI.md — Antigravity / Gemini Agent Instructions

> **Context Reference**: This repository uses [`AGENTS.md`](./AGENTS.md) as the central project specification and single source of truth.

---

## Quick Reference for Gemini / Antigravity

When working on this repository:
1. **Always read [`AGENTS.md`](./AGENTS.md)** before proposing or modifying key mappings or architecture.
2. **Key Files**:
   * Source Code: [`src/MacMode.ahk`](./src/MacMode.ahk)
   * Standalone Binary: [`bin/MacMode.exe`](./bin/MacMode.exe)
   * 1-Click Update Script: [`update.bat`](./update.bat)
   * 1-Click Build Script: [`build.bat`](./build.bat)
   * 1-Click Install Script: [`install.bat`](./install.bat)
3. **Core Rules**:
   * **Do NOT remap `LCtrl` to `LWin`** (causes Windows Search popups).
   * **Do NOT try to remap standalone `Fn`** (hardware EC limitation).
   * Test syntax with AutoHotkey v1 before compiling.
   * When launching background processes in Windows from the tool runner, use WMI (`Invoke-CimMethod -ClassName Win32_Process -MethodName Create`) so the process is not killed by the agent's Job Object when the command ends.
4. **Git Operations**:
   * Commit as `Shlok Zanwar <shlokzanwar14@gmail.com>`.
   * Push to `origin main` ([https://github.com/Shlok-Zanwar/mac-mode](https://github.com/Shlok-Zanwar/mac-mode)).
