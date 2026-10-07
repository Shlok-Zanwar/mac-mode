@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo              Building MacMode for Windows
echo ========================================================

set "PROJECT_DIR=%~dp0"
set "AHK_COMPILER=C:\Users\princ\Desktop\Setup\ahk_v1\Compiler\Ahk2Exe.exe"
set "AHK_BIN=C:\Users\princ\Desktop\Setup\ahk_v1\Compiler\Unicode 64-bit.bin"

if not exist "%AHK_COMPILER%" (
    echo [ERROR] Ahk2Exe compiler not found at "%AHK_COMPILER%"
    exit /b 1
)

if not exist "%AHK_BIN%" (
    echo [ERROR] Base bin not found at "%AHK_BIN%"
    exit /b 1
)

if not exist "%PROJECT_DIR%bin" mkdir "%PROJECT_DIR%bin"
if not exist "%PROJECT_DIR%bin\assets" mkdir "%PROJECT_DIR%bin\assets"

echo Copying icons to bin\assets...
copy /y "%PROJECT_DIR%assets\*.ico" "%PROJECT_DIR%bin\assets\" >nul 2>&1

echo Compiling src\MacMode.ahk -^> bin\MacMode.exe...
"%AHK_COMPILER%" /in "%PROJECT_DIR%src\MacMode.ahk" /out "%PROJECT_DIR%bin\MacMode.exe" /icon "%PROJECT_DIR%assets\apple.ico" /bin "%AHK_BIN%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo  [SUCCESS] Compiled standalone binary:
    echo  %PROJECT_DIR%bin\MacMode.exe
    echo ========================================================
) else (
    echo.
    echo [ERROR] Compilation failed with exit code %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)

exit /b 0
