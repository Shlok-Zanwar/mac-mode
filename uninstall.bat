@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo             Uninstalling MacMode for Windows
echo ========================================================

set "STARTUP_LNK=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\MacMode.lnk"

echo [1/2] Terminating any running MacMode instance...
taskkill /f /im MacMode.exe >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

echo [2/2] Removing Windows Startup shortcut...
if exist "%STARTUP_LNK%" (
    del /f /q "%STARTUP_LNK%"
    echo     Startup shortcut removed.
) else (
    echo     Startup shortcut was not found [already clean].
)

echo.
echo ========================================================
echo  [SUCCESS] MacMode has been stopped and uninstalled from
echo  Windows Startup.
echo ========================================================

exit /b 0
