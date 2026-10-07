; ==============================================================================
; MacMode for Windows
; High-performance macOS keyboard shortcut layer with 1-click Tray Toggle
; ==============================================================================

#Persistent
#SingleInstance force
#NoEnv
#InstallKeybdHook
#UseHook On
#MenuMaskKey vkE8
SetWorkingDir %A_ScriptDir%
SendMode Input

; ------------------------------------------------------------------------------
; Initialization & Asset Resolution
; ------------------------------------------------------------------------------
global isMacMode := true
global appleIco := FindIcon("apple.ico")
global windowsIco := FindIcon("windows.ico")
global startupLnk := A_Startup . "\MacMode.lnk"

; Configure Tray Menu
Menu, Tray, NoStandard
if FileExist(appleIco)
    Menu, Tray, Icon, %appleIco%, 1, 1
Menu, Tray, Tip, Mac Mode: Active (Click to switch to Windows)
Gosub, UpdateTrayMenu

; Register Left-Click Hook on Tray Icon
OnMessage(0x404, "AHK_NOTIFYICON")
return

; ------------------------------------------------------------------------------
; Helper Functions
; ------------------------------------------------------------------------------
FindIcon(iconName) {
    paths := [A_ScriptDir . "\" . iconName
            , A_ScriptDir . "\assets\" . iconName
            , A_ScriptDir . "\..\assets\" . iconName
            , A_WorkingDir . "\" . iconName
            , A_WorkingDir . "\assets\" . iconName]
    for index, path in paths {
        if FileExist(path)
            return path
    }
    return ""
}

AHK_NOTIFYICON(wParam, lParam) {
    static lastClick := 0
    if (lParam = 0x202) ; WM_LBUTTONUP (Single Left-Click)
    {
        now := A_TickCount
        if (now - lastClick > 250)
        {
            lastClick := now
            ToggleMode()
        }
        return 0
    }
}

ToggleMode() {
    global isMacMode, appleIco, windowsIco
    isMacMode := !isMacMode
    if (isMacMode)
    {
        Suspend, Off
        if FileExist(appleIco)
            Menu, Tray, Icon, %appleIco%, 1, 1
        Menu, Tray, Tip, Mac Mode: Active (Click to switch to Windows)
        TrayTip, MacMode, Switched to Mac Mode (Mac shortcuts active), 2, 1
    }
    else
    {
        Suspend, On
        if FileExist(windowsIco)
            Menu, Tray, Icon, %windowsIco%, 1, 1
        Menu, Tray, Tip, Windows Mode: Active (Click to switch to Mac)
        TrayTip, MacMode, Switched to Windows Mode (All keys standard), 2, 1
    }
    Gosub, UpdateTrayMenu
}

; ------------------------------------------------------------------------------
; Tray Menu Actions
; ------------------------------------------------------------------------------
UpdateTrayMenu:
    Menu, Tray, DeleteAll
    if (isMacMode) {
        Menu, Tray, Add, ● Mac Mode (Active), MenuToggleMode
        Menu, Tray, Check, ● Mac Mode (Active)
    } else {
        Menu, Tray, Add, ○ Windows Mode, MenuToggleMode
        Menu, Tray, Check, ○ Windows Mode
    }
    Menu, Tray, Add
    Menu, Tray, Add, Run at Windows Startup, MenuToggleStartup
    if FileExist(startupLnk)
        Menu, Tray, Check, Run at Windows Startup
    else
        Menu, Tray, Uncheck, Run at Windows Startup
    Menu, Tray, Add, Shortcuts Cheat Sheet, MenuCheatSheet
    Menu, Tray, Add
    Menu, Tray, Add, Exit, MenuExit
return

MenuToggleMode:
    ToggleMode()
return

MenuToggleStartup:
    if FileExist(startupLnk)
    {
        FileDelete, %startupLnk%
        TrayTip, MacMode, Removed from Windows Startup, 2, 1
    }
    else
    {
        exePath := A_ScriptFullPath
        if (!A_IsCompiled)
        {
            binExe := A_ScriptDir . "\..\bin\MacMode.exe"
            if FileExist(binExe)
                exePath := binExe
        }
        SplitPath, exePath, , exeDir
        iconForShortcut := appleIco ? appleIco : exePath
        FileCreateShortcut, %exePath%, %startupLnk%, %exeDir%, , MacMode - macOS keyboard shortcuts for Windows, %iconForShortcut%
        TrayTip, MacMode, Added to Windows Startup, 2, 1
    }
    Gosub, UpdateTrayMenu
return

MenuCheatSheet:
    MsgBox, 64, MacMode - Shortcuts Cheat Sheet,
    (LTrim
    MacMode Keyboard Shortcuts Cheatsheet
    =====================================

    TOGGLE MODE
    • Ctrl + Alt + P : Toggle Mac / Windows Mode
    • Tray Left-Click : Instant Toggle (Apple 🍎 <-> Windows 🪟)

    COMMAND (Thumb Alt = ⌘)
    • Alt + C : Copy (Ctrl + C)
    • Alt + V : Paste (Ctrl + V)
    • Alt + X : Cut (Ctrl + X)
    • Alt + Z : Undo (Ctrl + Z)
    • Alt + Shift + Z / Alt + Y : Redo (Ctrl + Y)
    • Alt + A : Select All (Ctrl + A)
    • Alt + S : Save (Ctrl + S)
    • Alt + F : Find (Ctrl + F)
    • Alt + T : New Tab (Ctrl + T)
    • Alt + W : Close Tab (Ctrl + W)
    • Alt + Shift + T : Reopen Closed Tab (Ctrl + Shift + T)
    • Alt + Q : Quit Application (Alt + F4)
    • Alt + Space : Mac Spotlight Search (Windows Search)

    TEXT NAVIGATION (Alt = ⌘)
    • Alt + Left : Beginning of Line (Home)
    • Alt + Right : End of Line (End)
    • Alt + Shift + Left : Select to Beginning of Line (Shift + Home)
    • Alt + Shift + Right : Select to End of Line (Shift + End)
    • Alt + Up : Top of Document (Ctrl + Home)
    • Alt + Down : Bottom of Document (Ctrl + End)
    • Alt + Shift + Up : Select to Top of Document (Ctrl + Shift + Home)
    • Alt + Shift + Down : Select to Bottom of Document (Ctrl + Shift + End)
    • Alt + BackSpace : Delete Line Backwards (Shift + Home -> Backspace)
    • Alt + Delete : Delete Line Forwards (Shift + End -> Delete)

    OPTION (Win = ⌥)
    • Win + Left : Jump Word Left (Ctrl + Left)
    • Win + Right : Jump Word Right (Ctrl + Right)
    • Win + Shift + Left : Select Word Left (Ctrl + Shift + Left)
    • Win + Shift + Right : Select Word Right (Ctrl + Shift + Right)
    • Win + BackSpace : Delete Word Backwards (Ctrl + BackSpace)
    • Win + Delete : Delete Word Forwards (Ctrl + Delete)

    PRESERVED NATIVE SHORTCUTS
    • Alt + Tab : Native Windows App Switching
    • Ctrl + C : Terminal SIGINT cancellation (unaltered)
    )
return

MenuExit:
    ExitApp
return

; ==============================================================================
; GLOBAL HOTKEY: Toggle Mode
; Works in both Mac Mode and Windows Mode (Suspend, Permit)
; ==============================================================================
^!p::
Suspend, Permit
ToggleMode()
return

; ==============================================================================
; MAC MODE SHORTCUTS (Active only when Suspend is Off)
; ==============================================================================

; --- Command Key Equivalents (Thumb Alt = ⌘) ---
!c::SendInput, ^c
!v::SendInput, ^v
!x::SendInput, ^x
!z::SendInput, ^z
!+z::SendInput, ^y
!y::SendInput, ^y
!a::SendInput, ^a
!s::SendInput, ^s
!f::SendInput, ^f
!t::SendInput, ^t
!w::SendInput, ^w
!+t::SendInput, ^+t
!q::SendInput, !{F4}
!Space::SendInput, #{s}

; --- Text Navigation (Alt = ⌘) ---
!Left::SendInput, {Home}
!Right::SendInput, {End}
!+Left::SendInput, +{Home}
!+Right::SendInput, +{End}
!Up::SendInput, ^{Home}
!Down::SendInput, ^{End}
!+Up::SendInput, ^+{Home}
!+Down::SendInput, ^+{End}
!BackSpace::SendInput, +{Home}{BackSpace}
!Delete::SendInput, +{End}{Delete}

; --- Option Key Equivalents (Physical Win = ⌥) ---
#Left::SendInput, ^{Left}
#Right::SendInput, ^{Right}
#+Left::SendInput, ^+{Left}
#+Right::SendInput, ^+{Right}
#BackSpace::SendInput, ^{BackSpace}
#Delete::SendInput, ^{Delete}
