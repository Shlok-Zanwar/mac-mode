# AGENTS.md — MacMode Project Context & Agent Guidelines

> **Single Source of Truth**: This file contains the complete project architecture, technical constraints, design rationale, and development workflows for `MacMode for Windows`. Any AI agent (Gemini, Claude, Cursor, Copilot, etc.) working on this repository should read and adhere to these guidelines.

---

## 1. Project Overview & Vision

* **Repository**: [`https://github.com/Shlok-Zanwar/mac-mode`](https://github.com/Shlok-Zanwar/mac-mode)
* **Owner**: Shlok Zanwar (`shlokzanwar14@gmail.com`)
* **Purpose**: `MacMode for Windows` is a lightweight, zero-dependency, open-source Windows utility that transforms standard Windows laptop keyboards into an authentic macOS keyboard experience with an instant 1-click taskbar tray toggle.
* **Core Philosophy**: Zero bloat, zero background hooks that interfere with normal typing, zero registry corruption, and no unwanted Start Menu / Search popups.

---

## 2. Hardware Architecture & Physical Key Mappings

The primary target is the **ASUS VivoBook X571GT** (and standard PC laptop keyboards):
```
Physical Bottom Row:  [ Ctrl ]   [ Fn ]   [ Win ]   [ Alt ]   [     Spacebar     ]
Mac Equivalent:       [ Ctrl ]  (H/W Fn)  [ Option ] [ Command ] [     Spacebar     ]
```

### Critical Hardware Constraints
1. **The `Fn` Key**:
   * On ASUS laptops (and most PC laptops), the physical `Fn` key is wired directly to the motherboard's **Embedded Controller (EC)**.
   * When pressed alone, the EC emits **zero scan codes or interrupts** to Windows or the OS.
   * **Do NOT attempt to remap standalone `Fn` in software**. It is physically invisible to Windows. It is reserved for hardware volume, brightness, and `Fn + Esc` (Function Key Lock).
2. **Physical `Ctrl` (Bottom-Left Corner)**:
   * Left as native `Ctrl`.
   * **NEVER remap `LCtrl` to `LWin`** (previous third-party tools like Kinto did this, which caused accidental taps to spam the Windows Start Menu).
   * Preserves terminal safety: `Ctrl + C` sends `SIGINT` (cancels running commands safely without accidental copying).
3. **Physical `Win` (Left Windows Key)**:
   * Acts as Mac **`Option (⌥)`**.
   * Provides word-by-word jumping (`Win + Left/Right` $\rightarrow$ `Ctrl + Left/Right`) and word deletion (`Win + Backspace` $\rightarrow$ `Ctrl + Backspace`).
   * **Clean Modifier Isolation (`SendOption`)**: To prevent collisions with third-party tools that listen globally for `Ctrl + Win` combinations (e.g. Wispr Flow), Option hotkeys explicitly release `Win` (`{Blind}{LWin up}{RWin up}`) before sending `Ctrl` strokes. This guarantees `Win` and `Ctrl` are never simultaneously active in the OS input stream.
4. **Physical `Alt` (Thumb Key Left of Spacebar)**:
   * Acts as Mac **`Command (⌘)`** across the entire OS via `$LAlt::LCtrl` and `$RAlt::RCtrl`.
   * Automatically handles all Command shortcuts: Refresh (`Alt+R`), Hard Reload (`Alt+Shift+R`), Focus URL Bar (`Alt+L`), Bookmark (`Alt+D`), Print (`Alt+P`), Switch Tabs (`Alt+1..9`), Open Link in New Tab (`Alt+Click`), Copy/Paste/Cut/Undo/Redo/Select All/Save/Find/New Tab/Close Tab.
   * Specific overrides:
     * App Switcher: `LAlt & Tab::AltTab` preserves smooth Windows window switching.
     * Quit App: `Alt + Q` $\rightarrow$ `Alt + F4`.
     * Mac Spotlight Search: `Alt + Space` $\rightarrow$ `Win + S` (Windows Search / PowerToys Run).
     * Mac Screenshot to Clipboard: `Shift + Alt + 2` $\rightarrow$ `Win + Shift + S` (Windows Snipping Tool to clipboard).
     * Line navigation: `Alt + Left/Right` $\rightarrow$ `Home` / `End`.
     * Line deletion: `Alt + Backspace` $\rightarrow$ `Shift + Home + Backspace`.
5. **Native Windows Preserved**:
   * `Alt + Tab`: Preserved via `LAlt & Tab::AltTab` for smooth native app switching.

---

## 3. Directory Structure

```text
mac-mode/
├── AGENTS.md               # Universal AI agent context (this file)
├── CLAUDE.md               # Claude Code & Desktop instructions (links to AGENTS.md)
├── GEMINI.md               # Gemini & Antigravity instructions (links to AGENTS.md)
├── README.md               # Public documentation with shortcut cheat sheets
├── LICENSE                 # MIT License
├── .gitignore              # Git ignore rules
├── build.bat               # 1-click compilation: src/MacMode.ahk -> bin/MacMode.exe
├── install.bat             # 1-click installation: sets up startup shortcut & launches app
├── update.bat              # 1-click update: recompiles and hot-reloads running instance
├── uninstall.bat           # 1-click removal: stops process & removes startup shortcut
├── assets/
│   ├── apple.ico           # Multi-resolution Apple icon (16x16 to 256x256) for Mac Mode
│   ├── windows.ico         # Multi-resolution Windows 11 icon for Windows Mode
│   └── generate_icons.py   # Vector icon generator script (PIL / Pillow)
├── bin/
│   ├── MacMode.exe         # Standalone compiled 64-bit binary (~1.25 MB, zero dependencies)
│   └── assets/             # Bundled runtime icon assets
└── src/
    └── MacMode.ahk         # Core AutoHotkey v1 source code
```

---

## 4. Technical Architecture: `src/MacMode.ahk`

* **Language**: AutoHotkey v1.1 syntax (compatible with `Ahk2Exe` using `Unicode 64-bit.bin`).
* **Directives**:
  * `#Persistent`: Keeps script resident in memory.
  * `#SingleInstance force`: Automatically replaces previous instances.
  * `#InstallKeybdHook` & `#UseHook On`: Low-level keyboard hook prevents recursion.
  * `#MenuMaskKey vk07`: Uses Microsoft unassigned virtual key to prevent Windows Start menu popups without sending synthetic `Ctrl` strokes.
* **Tray Icon Behavior**:
  * In Mac Mode: Displays `apple.ico`. Tooltip: `Mac Mode: Active (Click to switch to Windows)`.
  * In Windows Mode: Displays `windows.ico`. Tooltip: `Windows Mode: Active (Click to switch to Mac)`.
  * **Left-Click on Tray Icon** (`WM_LBUTTONUP` / `0x202`): Debounced toggle (`ToggleMode()`).
    * When switching to Windows Mode: Calls `Suspend, On`, freezes tray icon to `windows.ico` (passing `1` to `Menu, Tray, Icon` to suppress default 'S' icon), and notifies via `TrayTip`.
    * When switching to Mac Mode: Calls `Suspend, Off`, restores `apple.ico`, and notifies via `TrayTip`.
  * **Right-Click Tray Menu**: Shows mode status, `Run at Windows Startup` toggle (auto-manages `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\MacMode.lnk`), `Shortcuts Cheat Sheet` dialog, and `Exit`.
  * **Global Toggle**: `Ctrl + Alt + P` (`^!p::` with `Suspend, Permit`) toggles modes instantly from keyboard.

---

## 5. Development & Contribution Workflows

### How to Modify Shortcuts
1. Edit [`src/MacMode.ahk`](src/MacMode.ahk).
2. **Syntax Check**: Verify with AutoHotkey compiler:
   ```cmd
   & "C:\Users\princ\Desktop\Setup\ahk_v1\AutoHotkeyU64.exe" /ErrorStdOut "src\MacMode.ahk"
   ```
   *(Ensure no duplicate hotkeys exist, e.g., `+!2` and `!+2` represent the exact same key combination in AHK).*
3. **Compile & Hot-Reload**: Run `update.bat`:
   ```cmd
   update.bat
   ```
   *Note: `update.bat` stops the running process first, recompiles `bin/MacMode.exe`, and restarts it via WMI.*
4. **Process Launching Rules in Agent Environments**:
   * When launching background processes in agent/tool harnesses, **always use WMI** (`Invoke-CimMethod -ClassName Win32_Process -MethodName Create`) so the process survives when the ephemeral shell session closes.

### How to Build
```cmd
build.bat
```
Uses compiler at `C:\Users\princ\Desktop\Setup\ahk_v1\Compiler\Ahk2Exe.exe` with base `Unicode 64-bit.bin`.

### How to Test & Install
```cmd
install.bat
```

### Git Workflow
* All changes should be committed with author: `Shlok Zanwar <shlokzanwar14@gmail.com>`.
* Push to `origin main`:
  ```cmd
  git add -A
  git commit -m "Your descriptive commit message"
  git push origin main
  ```
