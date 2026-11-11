@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Time Zone Sync

set "APPDIR=%ProgramData%\TimeZoneSync"
set "CFG=%APPDIR%\timezone.txt"
set "TARGET=%APPDIR%\TimeZoneSync.bat"
set "TASK=TimeZoneSyncOnBoot"

:: ---------------------------------------------------------------
:: BOOT MODE: runs silently from the scheduled task, then closes
:: ---------------------------------------------------------------
if /i "%~1"=="/run" goto :boot

:: ---------------------------------------------------------------
:: INTERACTIVE MODE: needs admin
:: ---------------------------------------------------------------
net session >nul 2>&1
if errorlevel 1 (
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

if not exist "%CFG%" goto :setup

:: Already set up -> small menu
set "CUR="
set /p CUR=<"%CFG%"
cls
echo ==============================================
echo   Time Zone Sync  -  already installed
echo   Saved zone: !CUR!
echo ==============================================
echo   1. Change time zone
echo   2. Uninstall
echo   3. Exit
echo.
set "M="
set /p "M=Choose 1-3: "
if "!M!"=="1" goto :setup
if "!M!"=="2" goto :uninstall
exit /b

:: ---------------------------------------------------------------
:setup
set "NOW="
for /f "delims=" %%Z in ('tzutil /g') do set "NOW=%%Z"

cls
echo ==============================================
echo   Time Zone Sync  -  setup
echo ==============================================
echo   Pick the time zone Windows should use on every boot:
echo.
echo   C. Keep the zone Windows is using right now: !NOW!
echo.
echo   1. India Standard Time
echo   2. UTC
echo   3. GMT / London
echo   4. Eastern (US)
echo   5. Central (US)
echo   6. Pacific (US)
echo   7. Central Europe (Berlin, Paris)
echo   8. Singapore
echo   9. Tokyo
echo   0. Type a custom Windows time zone ID
echo.
set "C="
set /p "C=Choose C or 0-9: "

set "TZ="
if /i "!C!"=="C" set "TZ=!NOW!"
if "!C!"=="1" set "TZ=India Standard Time"
if "!C!"=="2" set "TZ=UTC"
if "!C!"=="3" set "TZ=GMT Standard Time"
if "!C!"=="4" set "TZ=Eastern Standard Time"
if "!C!"=="5" set "TZ=Central Standard Time"
if "!C!"=="6" set "TZ=Pacific Standard Time"
if "!C!"=="7" set "TZ=W. Europe Standard Time"
if "!C!"=="8" set "TZ=Singapore Standard Time"
if "!C!"=="9" set "TZ=Tokyo Standard Time"
if "!C!"=="0" (
    echo.
    echo   Tip: run  tzutil /l  in another window to see all valid IDs.
    set /p "TZ=Enter time zone ID: "
)
if not defined TZ goto :setup

tzutil /s "!TZ!" >nul 2>&1
if errorlevel 1 (
    echo.
    echo   "!TZ!" is not a valid time zone ID. Try again.
    timeout /t 3 >nul
    goto :setup
)

:: Save choice
if not exist "%APPDIR%" mkdir "%APPDIR%"
>"%CFG%" echo !TZ!

:: Copy this script to a permanent location
if /i not "%~f0"=="%TARGET%" copy /y "%~f0" "%TARGET%" >nul

:: Register boot task (SYSTEM, highest privileges, runs at every startup)
schtasks /create /tn "%TASK%" /tr "\"%TARGET%\" /run" /sc onstart /ru SYSTEM /rl HIGHEST /f >nul 2>&1
if errorlevel 1 (
    echo.
    echo   Could not create the startup task. Run this file as Administrator.
    pause
    exit /b 1
)

:: Sync the clock right now too
sc start w32time >nul 2>&1
w32tm /resync /force >nul 2>&1

cls
echo ==============================================
echo   HOW TO UNINSTALL  -  please read
echo ==============================================
echo.
echo   Option A: run this file again from
echo       %TARGET%
echo     and choose  2. Uninstall
echo.
echo   Option B: open Command Prompt as Administrator and run
echo       schtasks /delete /tn %TASK% /f
echo       rmdir /s /q "%APPDIR%"
echo.
echo   Either way removes the startup task. Your time zone
echo   stays as it is at the moment you uninstall.
echo.
pause

cls
echo ==============================================
echo   SETUP COMPLETE
echo ==============================================
echo.
echo   Time zone : !TZ!
echo   Startup   : added  (task "%TASK%")
echo.
echo   On every boot this will quietly set your time zone,
echo   re-sync the clock, and close by itself.
echo.
echo   You can close this window now.
echo.
pause
exit /b 0

:: ---------------------------------------------------------------
:uninstall
schtasks /delete /tn "%TASK%" /f >nul 2>&1
del /f /q "%CFG%" >nul 2>&1
echo.
echo   Startup task and saved settings removed.
echo   You can delete the folder %APPDIR% if you like.
echo.
pause
exit /b 0

:: ---------------------------------------------------------------
:boot
if not exist "%CFG%" exit /b 0
set "TZ="
set /p TZ=<"%CFG%"
if not defined TZ exit /b 0

tzutil /s "!TZ!" >nul 2>&1
sc start w32time >nul 2>&1

:: Resync clock; retry a few times in case the network is not up yet
for /l %%i in (1,1,4) do (
    w32tm /resync /force >nul 2>&1 && exit /b 0
    ping -n 6 127.0.0.1 >nul
)
exit /b 0
