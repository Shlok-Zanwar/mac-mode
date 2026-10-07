@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo             Installing MacMode for Windows
echo ========================================================

set "PROJECT_DIR=%~dp0"
set "BIN_EXE=%PROJECT_DIR%bin\MacMode.exe"
set "ICON_FILE=%PROJECT_DIR%assets\apple.ico"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "STARTUP_LNK=%STARTUP_DIR%\MacMode.lnk"

if not exist "%BIN_EXE%" (
    echo [INFO] MacMode.exe not found. Running build.bat first...
    call "%PROJECT_DIR%build.bat"
    if not exist "%BIN_EXE%" (
        echo [ERROR] Build failed. Cannot proceed with installation.
        exit /b 1
    )
)

echo [1/3] Creating Windows Startup shortcut...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ws = New-Object -ComObject WScript.Shell; " ^
    "$s = $ws.CreateShortcut('%STARTUP_LNK%'); " ^
    "$s.TargetPath = '%BIN_EXE%'; " ^
    "$s.WorkingDirectory = '%PROJECT_DIR%'; " ^
    "$s.IconLocation = '%ICON_FILE%,0'; " ^
    "$s.Description = 'MacMode - macOS keyboard shortcuts for Windows'; " ^
    "$s.Save()"

if exist "%STARTUP_LNK%" (
    echo     Shortcut created at: %STARTUP_LNK%
) else (
    echo [WARNING] Could not create startup shortcut.
)

echo [2/3] Stopping any running MacMode instance...
taskkill /f /im MacMode.exe >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

echo [3/3] Launching MacMode via WMI (persistent background process)...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$res = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine = '\"%BIN_EXE%\"'}; " ^
    "if ($res.ReturnValue -eq 0) { Write-Output '    Process launched successfully (PID: ' $res.ProcessId ')' } else { Write-Output '    Launch failed with code: ' $res.ReturnValue }"

timeout /t 1 /nobreak >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$p = Get-Process -Name MacMode -ErrorAction SilentlyContinue; " ^
    "if ($p) { Write-Output '    MacMode is actively running with PID(s): ' ($p.Id -join ', ') } else { Write-Output '    [WARNING] Process did not start.' }"

echo.
echo ========================================================
echo  [SUCCESS] MacMode is installed and active!
echo  - Tray icon (Apple logo) is in your taskbar tray
echo  - Press Ctrl + Alt + P or click tray icon to toggle
echo ========================================================

exit /b 0
