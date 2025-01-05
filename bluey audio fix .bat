@echo off
setlocal EnableDelayedExpansion
color 0B
mode con cols=80 lines=40
title Bluey Audio by Adam Frame - Audio and Bluetooth Fix Tool

:: Check for admin rights
NET SESSION >nul 2>&1
if errorlevel 1 (
    echo This tool requires administrator privileges.
    echo Please run as administrator.
    pause
    exit /b
)

for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%VERSION%"=="10.0" (
    set "TROUBLESHOOT_CMD=msdt.exe"
) else if "%VERSION%"=="6.1" (
    set "TROUBLESHOOT_CMD=control.exe /name Microsoft.Troubleshooting"
)

:: Initialize log file
set "logFile=%temp%\Bluey_Audio_log.txt"
echo Bluey Audio Log - %date% %time% > "%logFile%"
set "detailedLog=%temp%\Bluey_Audio_detailed_%random%.log"
call :LOG "Detailed execution log: %detailedLog%"
cls
call :DISPLAY_HEADER
echo.
echo ============================
echo   AUDIO AND BLUETOOTH FIX
echo ============================
echo.
echo Running audio and Bluetooth fix tasks...
call :LOG "Starting Audio and Bluetooth Fix"
call :BACKUP_CONFIG

:BLUETOOTH_SOUND_MENU
cls
call :DISPLAY_HEADER
echo.
echo ============================
echo   BLUETOOTH AND SOUND REPAIR
echo ============================
echo.
echo   1. Reset Bluetooth Services
echo   2. Reset Sound Services
echo   3. Troubleshoot Bluetooth
echo   4. Troubleshoot Sound
echo   5. Exit Program
echo   6. Restore from backup
echo.
choice /C 123456 /N /M "Select an option (1-6): "
if errorlevel 6 goto RESTORE_BACKUP
if errorlevel 5 goto EXIT
if errorlevel 4 goto SOUND_TROUBLESHOOT
if errorlevel 3 goto BLUETOOTH_TROUBLESHOOT
if errorlevel 2 goto RESET_SOUND
if errorlevel 1 goto RESET_BLUETOOTH

:RESET_BLUETOOTH
cls
call :DISPLAY_HEADER
echo.
echo Resetting Bluetooth Services...
call :LOG "Starting Bluetooth Services Reset"
sc query bthserv | find "STATE" | find "RUNNING" >nul
if errorlevel 1 (
    echo Bluetooth service is not running.
    call :LOG "Warning: Bluetooth service was not running"
)
net stop bthserv
timeout /t 5 /nobreak >nul
net start bthserv
if errorlevel 1 (
    echo Failed to start Bluetooth service.
    call :LOG "Error: Failed to start Bluetooth service"
    pause
    goto BLUETOOTH_SOUND_MENU
)
timeout /t 2 /nobreak >nul
echo Bluetooth services have been reset.
call :LOG "Bluetooth Services Reset completed"
pause
goto BLUETOOTH_SOUND_MENU

:RESET_SOUND
cls
call :DISPLAY_HEADER
echo.
echo Resetting Sound Services...
call :LOG "Starting Sound Services Reset"
sc query Audiosrv | find "STATE" | find "RUNNING" >nul
if errorlevel 1 (
    echo Audio service is not running.
    call :LOG "Warning: Audio service was not running"
)
net stop Audiosrv
net start Audiosrv
if errorlevel 1 (
    echo Failed to start Audio service.
    call :LOG "Error: Failed to start Audio service"
    pause
    goto BLUETOOTH_SOUND_MENU
)
echo Sound services have been reset.
call :LOG "Sound Services Reset completed"
pause
goto BLUETOOTH_SOUND_MENU

:BLUETOOTH_TROUBLESHOOT
cls
call :DISPLAY_HEADER
echo.
echo Launching Bluetooth Troubleshooter...
call :LOG "Starting Bluetooth Troubleshooter"
msdt.exe -id BluetoothDiagnostic
call :LOG "Bluetooth Troubleshooter completed"
pause
goto BLUETOOTH_SOUND_MENU

:SOUND_TROUBLESHOOT
cls
call :DISPLAY_HEADER
echo.
echo Launching Sound Troubleshooter...
call :LOG "Starting Sound Troubleshooter"
msdt.exe -id AudioPlaybackDiagnostic
call :LOG "Sound Troubleshooter completed"
pause
goto BLUETOOTH_SOUND_MENU

:EXIT
cls
call :DISPLAY_HEADER
echo.
echo Exiting Bluey Audio by Adam Frame...
call :LOG "Exiting Bluey Audio by Adam Frame"
exit /b

:DISPLAY_HEADER
echo ================================================
echo Bluey Audio by Adam Frame - Audio and Bluetooth Fix Tool
echo ================================================
goto :eof

:LOG
echo %date% %time% - %~1 >> "%logFile%"
goto :eof

:BACKUP_CONFIG
if exist "%temp%\audio_backup.reg" (
    echo Backup already exists, creating timestamped backup...
    ren "%temp%\audio_backup.reg" "audio_backup_%date:~-4,4%%date:~-7,2%%date:~-10,2%.reg"
)
reg export "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" "%temp%\audio_backup.reg" /y
if errorlevel 1 (
    echo Backup failed - aborting.
    call :LOG "Error: Backup creation failed"
    exit /b 1
)
reg export "HKLM\SYSTEM\CurrentControlSet\Services\bthserv" "%temp%\bluetooth_backup.reg" /y
goto :eof

:CLEANUP
choice /C YN /N /M "Delete temporary files? (Y/N): "
if errorlevel 2 goto :eof
del /q "%temp%\Bluey_Audio_detailed_*.log" >nul 2>&1

if not exist "%temp%" (
    echo Error: Temp directory not accessible.
    exit /b 1
)
goto :eof

:RESTORE_BACKUP
echo Restoring previous configuration...
reg import "%temp%\audio_backup.reg" >nul 2>&1
reg import "%temp%\bluetooth_backup.reg" >nul 2>&1
exit /b

:CHECK_DEPENDENCIES
sc enumdepend Audiosrv >nul
if errorlevel 0 (
    for /f "tokens=2" %%i in ('sc enumdepend Audiosrv ^| find "SERVICE_NAME"') do (
        sc query %%i | find "STATE" | find "RUNNING" >nul || (
            echo Warning: Dependent service %%i is not running.
            call :LOG "Warning: Audio dependency %%i not running"
        )
    )
)

if not errorlevel 0 (
    echo Error: Command failed with code %errorlevel%.
    call :LOG "Error occurred: Command failed with code %errorlevel%"
    pause
    goto BLUETOOTH_SOUND_MENU
)
goto :eof

:VERIFY_BACKUP
for %%f in ("%temp%\audio_backup.reg" "%temp%\bluetooth_backup.reg") do (
    if exist "%%~f" (
        find /c /i "[HKEY_LOCAL_MACHINE" "%%~f" >nul || (
            echo Warning: Backup file %%~f may be corrupted.
            call :LOG "Warning: Potentially corrupted backup - %%~f"
        )
    )
)
goto :eof

:CHECK_WINDOWS_VERSION
for /f "tokens=4-5 delims=. " %%i in ('ver') do (
    if %%i LSS 10 (
        echo Warning: Some features may not work on Windows versions before 10.
        call :LOG "Warning: Running on Windows version %%i.%%j"
    )
)
goto :eof

:CLEANUP_RESOURCES
taskkill /F /IM msdt.exe >nul 2>&1
del /q "%temp%\Bluey_Audio_detailed_*.log" >nul 2>&1
call :LOG "Performed resource cleanup"
reg export "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" "%temp%\audio_backup.reg" /y
if errorlevel 1 (
    echo Error: Failed to export registry key.
    call :LOG "Error: Registry export failed"
    exit /b 1
)
goto :eof

:VALIDATE_SERVICES
sc query "Audiosrv" >nul 2>&1 || (
    echo Error: Audio service not found.
    call :LOG "Error: Required service Audiosrv missing"
    exit /b 1
)
goto :eof

:CLEANUP_OLD_BACKUPS
forfiles /p "%temp%" /m "audio_backup_*.reg" /d -30 /c "cmd /c del @path" >nul 2>&1
goto :eof

:RECOVERY_MODE
choice /C 123456 /N /M "Select an option (1-6): "
if errorlevel 6 goto RESTORE_BACKUP
goto :eof

:VALIDATE_PATHS
if not exist "%SystemRoot%\System32\msdt.exe" (
    echo Error: Required system file msdt.exe not found.
    call :LOG "Error: Missing system dependency"
    exit /b 1
)
goto :eof
