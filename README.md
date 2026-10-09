#  MacMode for Windows

<div align="center">

[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D4?logo=windows&logoColor=white)](https://github.com/shlokzanwar/mac-mode)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Release](https://img.shields.io/badge/Release-v1.0.0-success.svg)](https://github.com/shlokzanwar/mac-mode/releases)
[![Architecture](https://img.shields.io/badge/Architecture-x64-blue.svg)]()
[![Engine](https://img.shields.io/badge/Engine-AutoHotkey%20v1.1-334455.svg)](https://www.autohotkey.com/)

**The ultimate keyboard bridge for Mac users working on Windows.**  
Seamlessly brings the natural ergonomics of macOS keyboard shortcuts (`⌘ Command`, `⌥ Option`, Spotlight search, and line/word text navigation) to Windows with an instant 1-click taskbar tray toggle.

</div>

---

## ⚡ Overview

When switching between macOS and Windows, muscle memory fights you every step of the way:
- Your thumb naturally reaches for **Alt** expecting it to be **Command (`⌘`)** for copy, paste, select all, new tab, and Spotlight search.
- Your thumb reaches for **Win** expecting it to be **Option (`⌥`)** for navigating and jumping whole words.
- Windows navigation uses cumbersome `Home`/`End` or `Ctrl+Arrow` keys instead of fluid Mac navigation (`⌘ + Arrow` and `⌥ + Arrow`).

**MacMode** fixes this completely without breaking Windows! It runs as a lightweight, zero-latency 64-bit background executable with zero configuration required.

---

## 🔄 Instant 1-Click Mode Toggle

MacMode sits unobtrusively in your Windows Notification Tray with dynamic icon states:

| Icon | Mode | Description |
|:---:|:---|:---|
| <img src="assets/apple.ico" width="24" height="24" /> **Apple Mode** | **Mac Mode (Active)** | macOS shortcuts active (`Alt` = `⌘`, `Win` = `⌥`, Spotlight search). |
| <img src="assets/windows.ico" width="24" height="24" /> **Windows Mode** | **Windows Mode (Active)** | Suspended to 100% native Windows keyboard behavior. |

### How to Toggle:
1. **Single Left-Click** on the tray icon in your taskbar to instantly flip between Mac Mode and Windows Mode.
2. **Keyboard Shortcut**: Press `Ctrl + Alt + P` anywhere to toggle modes instantly.
3. **Right-Click Menu**: Access the full tray menu to check active mode, view the interactive Cheat Sheet, toggle Windows Startup, or Exit.

---

## ⌨️ Shortcuts Cheatsheet

### 1. Command Key (`⌘`) — Using Thumb `Alt`

| macOS Action | Mac Shortcut | Windows Mapped Action | Windows Keystroke Sent |
|:---|:---|:---|:---|
| **Copy** | `⌘ + C` | `Alt + C` | `Ctrl + C` |
| **Paste** | `⌘ + V` | `Alt + V` | `Ctrl + V` |
| **Cut** | `⌘ + X` | `Alt + X` | `Ctrl + X` |
| **Undo** | `⌘ + Z` | `Alt + Z` | `Ctrl + Z` |
| **Redo** | `⌘ + Shift + Z` / `⌘ + Y` | `Alt + Shift + Z` / `Alt + Y` | `Ctrl + Y` |
| **Select All** | `⌘ + A` | `Alt + A` | `Ctrl + A` |
| **Save** | `⌘ + S` | `Alt + S` | `Ctrl + S` |
| **Find** | `⌘ + F` | `Alt + F` | `Ctrl + F` |
| **New Tab** | `⌘ + T` | `Alt + T` | `Ctrl + T` |
| **Close Tab** | `⌘ + W` | `Alt + W` | `Ctrl + W` |
| **Reopen Tab** | `⌘ + Shift + T` | `Alt + Shift + T` | `Ctrl + Shift + T` |
| **Refresh Page** | `⌘ + R` | `Alt + R` | `Ctrl + R` |
| **Hard Reload** | `⌘ + Shift + R` | `Alt + Shift + R` | `Ctrl + Shift + R` |
| **Focus URL Bar** | `⌘ + L` | `Alt + L` | `Ctrl + L` |
| **Bookmark** | `⌘ + D` | `Alt + D` | `Ctrl + D` |
| **Print** | `⌘ + P` | `Alt + P` | `Ctrl + P` |
| **Switch Tabs (1-9)** | `⌘ + 1..9` | `Alt + 1..9` | `Ctrl + 1..9` |
| **Open Link in New Tab**| `⌘ + Click` | `Alt + Click` | `Ctrl + Click` |
| **Quit App** | `⌘ + Q` | `Alt + Q` | `Alt + F4` |
| **Spotlight** | `⌘ + Space` | `Alt + Space` | `Win + S` (Windows Search / PowerToys Run) |
| **Screenshot to Clipboard** | `Shift + Alt + 2` / `⌘ + Shift + 2` | `Shift + Alt + 2` | `Win + Shift + S` (Snipping Tool -> Clipboard) |

### 2. Text Navigation — Using `Alt` (`⌘`)

| Action | Mac Shortcut | MacMode Windows Shortcut | Target Action |
|:---|:---|:---|:---|
| **Beginning of Line** | `⌘ + Left` | `Alt + Left` | `Home` |
| **End of Line** | `⌘ + Right` | `Alt + Right` | `End` |
| **Select to Line Start** | `⌘ + Shift + Left` | `Alt + Shift + Left` | `Shift + Home` |
| **Select to Line End** | `⌘ + Shift + Right` | `Alt + Shift + Right` | `Shift + End` |
| **Top of Document** | `⌘ + Up` | `Alt + Up` | `Ctrl + Home` |
| **End of Document** | `⌘ + Down` | `Alt + Down` | `Ctrl + End` |
| **Select to Top** | `⌘ + Shift + Up` | `Alt + Shift + Up` | `Ctrl + Shift + Home` |
| **Select to End** | `⌘ + Shift + Down` | `Alt + Shift + Down` | `Ctrl + Shift + End` |
| **Delete Line Backwards** | `⌘ + Backspace` | `Alt + Backspace` | `Shift + Home` then `Backspace` |
| **Delete Line Forwards** | `⌘ + Delete` | `Alt + Delete` | `Shift + End` then `Delete` |

### 3. Option Key (`⌥`) — Using Physical `Win`

| Action | Mac Shortcut | MacMode Windows Shortcut | Target Action |
|:---|:---|:---|:---|
| **Jump Word Left** | `⌥ + Left` | `Win + Left` | `Ctrl + Left` |
| **Jump Word Right** | `⌥ + Right` | `Win + Right` | `Ctrl + Right` |
| **Select Word Left** | `⌥ + Shift + Left` | `Win + Shift + Left` | `Ctrl + Shift + Left` |
| **Select Word Right** | `⌥ + Shift + Right` | `Win + Shift + Right` | `Ctrl + Shift + Right` |
| **Delete Word Backwards** | `⌥ + Backspace` | `Win + Backspace` | `Ctrl + Backspace` |
| **Delete Word Forwards** | `⌥ + Delete` | `Win + Delete` | `Ctrl + Delete` |

### 4. Preserved Native Windows Behaviors

- **Native App Switching**: `Alt + Tab` is untouched and works 100% natively in Windows.
- **Clean Modifier Isolation**: `Win` is cleanly isolated and released prior to injecting `Ctrl` navigation, eliminating collision with global shortcuts like `Ctrl + Win` (e.g. Wispr Flow dictation).
- **Terminal Friendly**: Physical `Ctrl + C` sends `SIGINT` to terminate terminal programs without intercepting.
- **No Keyboard Lag**: Low-level Windows keyboard hook guarantees imperceptible latency (< 1ms).

---

## 🚀 1-Click Scripts

Everything is automated via batch scripts in the project root:

### 1. Install & Launch (`install.bat`)
```cmd
install.bat
```
- Sets up startup shortcut in `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\MacMode.lnk`.
- Automatically launches `MacMode.exe` as a persistent background process via WMI.
- Verifies process status upon completion.

### 2. Update with Zero Downtime (`update.bat`)
```cmd
update.bat
```
- Compiles the latest code from `src\MacMode.ahk` into a temporary staging binary.
- Gracefully swaps the active binary and restarts `MacMode.exe` seamlessly with zero downtime.

### 3. Uninstall (`uninstall.bat`)
```cmd
uninstall.bat
```
- Gracefully terminates running `MacMode.exe` processes.
- Removes `MacMode.lnk` from your Windows Startup folder.

---

## 🛠️ Build from Source

Requirements:
- Windows 10 or 11 (64-bit)
- AutoHotkey v1.1 compiler (`Ahk2Exe.exe` and `Unicode 64-bit.bin`)
- Python 3.10+ with Pillow (only needed if regenerating custom `.ico` assets)

To re-compile manually:
```cmd
build.bat
```
Or with Ahk2Exe directly:
```cmd
"C:\Users\princ\Desktop\Setup\ahk_v1\Compiler\Ahk2Exe.exe" /in "src\MacMode.ahk" /out "bin\MacMode.exe" /icon "assets\apple.ico" /bin "C:\Users\princ\Desktop\Setup\ahk_v1\Compiler\Unicode 64-bit.bin"
```

To regenerate the multi-resolution `.ico` assets (16x16 to 256x256):
```cmd
python assets\generate_icons.py
```

---

## 📂 Project Structure

```
mac-mode/
├── assets/
│   ├── apple.ico           # Multi-resolution Apple logo (16x16 - 256x256)
│   ├── windows.ico         # Multi-resolution Windows 11 logo (16x16 - 256x256)
│   └── generate_icons.py   # High-resolution SVG/vector icon generator
├── bin/
│   └── MacMode.exe         # Standalone compiled 64-bit executable (1.2 MB)
├── src/
│   └── MacMode.ahk         # Clean, robust AutoHotkey v1 source code
├── .gitignore              # Standard Windows/Python gitignore
├── build.bat               # 1-Click compiler script
├── install.bat             # 1-Click installer (Startup shortcut + WMI launcher)
├── update.bat              # 1-Click zero-downtime updater
├── uninstall.bat           # 1-Click uninstaller
└── README.md               # Documentation
```

---

## 🌐 Publish to GitHub

To push this repository to GitHub:

```bash
# 1. Log in to GitHub CLI (if not already authenticated)
gh auth login

# 2. Create the public repository and push:
gh repo create mac-mode --public --source=. --remote=origin --push
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
