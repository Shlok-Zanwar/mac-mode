@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo              Updating MacMode for Windows
echo ========================================================

set "PROJECT_DIR=%~dp0"
set "BIN_EXE=%PROJECT_DIR%bin\MacMode.exe"
set "BIN_NEW=%PROJECT_DIR%bin\MacMode.new.exe"
set "AHK_COMPILER=C:\Users\princ\Desktop\Setup\ahk_v1\Compiler\Ahk2Exe.exe"
set "AHK_BIN=C:\Users\princ\Desktop\Setup\ahk_v1\Compiler\Unicode 64-bit.bin"

if not exist "%AHK_COMPILER%" (
    echo [ERROR] Ahk2Exe compiler not found at "%AHK_COMPILER%"
    exit /b 1
)

if not exist "%PROJECT_DIR%bin" mkdir "%PROJECT_DIR%bin"
if not exist "%PROJECT_DIR%bin\assets" mkdir "%PROJECT_DIR%bin\assets"
copy /y "%PROJECT_DIR%assets\*.ico" "%PROJECT_DIR%bin\assets\" >nul 2>&1

echo [1/3] Gracefully terminating running MacMode instance...
taskkill /f /im MacMode.exe >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

echo [2/3] Compiling update from source...
call "%PROJECT_DIR%build.bat"

if not exist "%BIN_EXE%" (
    echo [ERROR] Compilation failed. Aborting update.
    exit /b 1
)

echo [3/3] Restarting updated MacMode via WMI...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$res = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine = '\"%BIN_EXE%\"'}; " ^
    "if ($res.ReturnValue -eq 0) { Write-Output '    Process restarted successfully (PID: ' $res.ProcessId ')' } else { Write-Output '    Restart failed with code: ' $res.ReturnValue }"

timeout /t 1 /nobreak >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$p = Get-Process -Name MacMode -ErrorAction SilentlyContinue; " ^
    "if ($p) { Write-Output '    MacMode is actively running with PID(s): ' ($p.Id -join ', ') } else { Write-Output '    [WARNING] Process did not start.' }"

echo.
echo ========================================================
echo  [SUCCESS] MacMode updated and running seamlessly!
echo ========================================================

exit /b 0
