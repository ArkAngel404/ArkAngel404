@echo off
setlocal enabledelayedexpansion

:: Define common paths and variables
set "STAR_CITIZEN_DIR=C:\Program Files\Roberts Space Industries\StarCitizen"
set "RSI_LAUNCHER=RSI Launcher.exe"
set "ERROR_LOG=%~dp0starcitizen_error_log.txt"
set "TEMP_FILE=%~dp0temp.txt"
set "USER_SETTINGS=%~dp0settings.ini"

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as Administrator
    echo Right-click the script and select "Run as Administrator"
    pause
    exit /b 1
)

:MainMenu
cls
echo Star Citizen Advanced Troubleshooter
echo ===================================
echo.
echo [1] Run Full System Check
echo [2] Performance Optimization
echo [3] Network Diagnostics
echo [4] Storage Management
echo [5] Game File Verification
echo [6] Clear Shader Cache
echo [7] Fix Common Errors
echo [8] Backup Management
echo [9] Settings
echo [0] Exit
echo.
set /p "choice=Enter your choice (0-9): "

if "%choice%"=="1" goto FullSystemCheck
if "%choice%"=="2" goto PerformanceMenu
if "%choice%"=="3" goto NetworkMenu
if "%choice%"=="4" goto StorageMenu
if "%choice%"=="5" goto VerifyMenu
if "%choice%"=="6" goto ClearShaders
if "%choice%"=="7" goto ErrorMenu
if "%choice%"=="8" goto BackupMenu
if "%choice%"=="9" goto SettingsMenu
if "%choice%"=="0" goto Exit
goto MainMenu

:PerformanceMenu
cls
echo Performance Optimization
echo ======================
echo [1] Optimize Windows for Gaming
echo [2] Clear System Temp Files
echo [3] Update GPU Drivers
echo [4] Configure Page File
echo [5] Back to Main Menu
echo.
set /p "pchoice=Enter your choice (1-5): "

if "%pchoice%"=="1" (
    echo Optimizing Windows settings...
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    echo Setting high performance power plan...
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f
    echo Done.
    pause
    goto PerformanceMenu
)
if "%pchoice%"=="2" (
    echo Clearing temp files...
    del /s /q %temp%\*
    echo Done.
    pause
    goto PerformanceMenu
)
if "%pchoice%"=="3" (
    echo Please visit your GPU manufacturer's website:
    echo NVIDIA: https://www.nvidia.com/Download/index.aspx
    echo AMD: https://www.amd.com/en/support
    pause
    goto PerformanceMenu
)
if "%pchoice%"=="4" (
    echo Configuring page file...
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
    wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=16384,MaximumSize=32768
    echo Page file optimized.
    pause
    goto PerformanceMenu
)
if "%pchoice%"=="5" goto MainMenu
goto PerformanceMenu

:NetworkMenu
cls
echo Network Diagnostics
echo ==================
echo [1] Test Connection to Star Citizen Servers
echo [2] Configure Firewall
echo [3] Reset Network Stack
echo [4] Check VPN Interference
echo [5] Port Forwarding Check
echo [6] Back to Main Menu
echo.
set /p "nchoice=Enter your choice (1-6): "

if "%nchoice%"=="1" (
    echo Testing connection to Star Citizen servers...
    ping -n 4 roberts-space-industries.com
    pause
    goto NetworkMenu
)
if "%nchoice%"=="2" (
    echo Adding Star Citizen to Windows Firewall...
    netsh advfirewall firewall add rule name="Star Citizen" dir=in action=allow program="%STAR_CITIZEN_DIR%\StarCitizen.exe" enable=yes
    netsh advfirewall firewall add rule name="RSI Launcher" dir=in action=allow program="%STAR_CITIZEN_DIR%\%RSI_LAUNCHER%" enable=yes
    echo Firewall rules added.
    pause
    goto NetworkMenu
)
if "%nchoice%"=="3" (
    echo Resetting network stack...
    ipconfig /release
    ipconfig /flushdns
    ipconfig /renew
    netsh winsock reset
    netsh int ip reset
    echo Network stack reset. Please restart your computer.
    pause
    goto NetworkMenu
)
if "%nchoice%"=="4" (
    echo Checking for VPN interference...
    net stop "L2TP Tunneling Adapter" 2>NUL
    net stop "PPTP Miniport" 2>NUL
    echo VPN services stopped.
    pause
    goto NetworkMenu
)
if "%nchoice%"=="5" (
    echo Checking required ports...
    netstat -an | findstr "8000"
    netstat -an | findstr "8001"
    netstat -an | findstr "8002"
    pause
    goto NetworkMenu
)
if "%nchoice%"=="6" goto MainMenu
goto NetworkMenu

:StorageMenu
cls
echo Storage Management
echo =================
echo [1] Check Disk Space
echo [2] Clean User Folder
echo [3] Delete Shader Cache
echo [4] Analyze Large Files
echo [5] Back to Main Menu
echo.
set /p "schoice=Enter your choice (1-5): "

if "%schoice%"=="1" (
    call :CheckDiskSpace
    pause
    goto StorageMenu
)
if "%schoice%"=="2" (
    echo Cleaning USER folder...
    rd /s /q "%LOCALAPPDATA%\Star Citizen"
    echo USER folder cleaned.
    pause
    goto StorageMenu
)
if "%schoice%"=="3" (
    echo Deleting shader cache...
    rd /s /q "%LOCALAPPDATA%\Star Citizen\sc-alpha\LIVE\shadercache"
    echo Shader cache deleted.
    pause
    goto StorageMenu
)
if "%schoice%"=="4" (
    echo Analyzing large files...
    dir /s /b /a-d "%STAR_CITIZEN_DIR%" | sort /r /+65 > large_files.txt
    echo Results saved to large_files.txt
    pause
    goto StorageMenu
)
if "%schoice%"=="5" goto MainMenu
goto StorageMenu

:VerifyMenu
cls
echo Game File Verification
echo ====================
echo [1] Verify Game Files
echo [2] Check File Permissions
echo [3] Repair EasyAntiCheat
echo [4] Back to Main Menu
echo.
set /p "vchoice=Enter your choice (1-4): "

if "%vchoice%"=="1" (
    call :VerifyGameFiles
    pause
    goto VerifyMenu
)
if "%vchoice%"=="2" (
    echo Checking file permissions...
    icacls "%STAR_CITIZEN_DIR%" /reset /T
    echo Permissions reset.
    pause
    goto VerifyMenu
)
if "%vchoice%"=="3" (
    echo Repairing EasyAntiCheat...
    "%STAR_CITIZEN_DIR%\LIVE\EasyAntiCheat\EasyAntiCheat_Setup.exe" repair
    echo EasyAntiCheat repaired.
    pause
    goto VerifyMenu
)
if "%vchoice%"=="4" goto MainMenu
goto VerifyMenu

:ErrorMenu
cls
echo Fix Common Errors
echo ================
echo [1]  Error 30000 (Connection Timeout)
echo [2]  Error 60015 (Server Connection)
echo [3]  Error 19003 (Login Failed)
echo [4]  Error 10002 (Game Access)
echo [5]  Error 15008 (Authenticator)
echo [6]  Error 16008 (Authentication)
echo [7]  Error 50001 (Launcher)
echo [8]  Error 20007 (Account)
echo [9]  Error 40014 (Game Files)
echo [10] Error 10008 (Anticheat)
echo [11] Error 5xx (Server)
echo [12] Back to Main Menu
echo.
set /p "echoice=Enter your choice (1-12): "

if "%echoice%"=="1" goto Fix30k
if "%echoice%"=="2" goto Fix60k
if "%echoice%"=="3" goto Fix19k
if "%echoice%"=="4" goto Fix10k
if "%echoice%"=="5" goto Fix15k
if "%echoice%"=="6" goto Fix16k
if "%echoice%"=="7" goto Fix50k
if "%echoice%"=="8" goto Fix20k
if "%echoice%"=="9" goto Fix40k
if "%echoice%"=="10" goto Fix10008
if "%echoice%"=="11" goto Fix5xx
if "%echoice%"=="12" goto MainMenu
goto ErrorMenu

:Fix30k
cls
echo Fixing Error 30000 (Connection Timeout)
echo =====================================
echo Running comprehensive network fix...
echo.
echo Step 1: Checking network stability
ping -n 4 roberts-space-industries.com
echo.
echo Step 2: Flushing DNS cache
ipconfig /flushdns
echo.
echo Step 3: Resetting Winsock
netsh winsock reset
echo.
echo Step 4: Checking firewall settings
netsh advfirewall firewall show rule name="Star Citizen"
echo.
echo Step 5: Stopping VPN services
net stop "L2TP Tunneling Adapter" 2>NUL
net stop "PPTP Miniport" 2>NUL
echo.
echo Step 6: Optimizing network settings
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
echo.
pause
goto ErrorMenu

:Fix60k
cls
echo Fixing Error 60015 (Server Connection)
echo ===================================
echo Running server connection fix...
echo.
echo Step 1: Testing connection to game servers
ping -n 4 roberts-space-industries.com
echo.
echo Step 2: Checking required ports
netstat -an | findstr "8000"
netstat -an | findstr "8001"
netstat -an | findstr "8002"
echo.
echo Step 3: Verifying DNS settings
nslookup roberts-space-industries.com
echo.
echo Step 4: Checking for server status
start https://status.robertsspaceindustries.com
echo.
pause
goto ErrorMenu

:Fix19k
cls
echo Fixing Error 19003 (Login Failed)
echo ==============================
echo Running login fix...
echo.
echo Step 1: Clearing RSI Launcher cache
rd /s /q "%APPDATA%\rsilauncher" 2>NUL
echo.
echo Step 2: Resetting credentials
cmdkey /delete:robertsspaceindustries.com
echo.
echo Step 3: Checking SSL/TLS settings
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Protocols\TLS 1.2"
echo.
echo Step 4: Opening account page
start https://robertsspaceindustries.com/account/settings
echo.
pause
goto ErrorMenu

:Fix10k
cls
echo Fixing Error 10002 (Game Access)
echo =============================
echo Running access verification...
echo.
echo Step 1: Verifying game package
start https://robertsspaceindustries.com/account/pledges
echo.
echo Step 2: Checking account status
start https://robertsspaceindustries.com/account/settings
echo.
echo Step 3: Clearing account cache
del /s /q "%APPDATA%\rsilauncher\*"
echo.
pause
goto ErrorMenu

:Fix15k
cls
echo Fixing Error 15008 (Authenticator)
echo ==============================
echo Running authenticator fix...
echo.
echo Step 1: Resetting authentication cache
del /s /q "%APPDATA%\rsilauncher\*.token"
echo.
echo Step 2: Checking time synchronization
w32tm /resync
echo.
echo Step 3: Opening authenticator page
start https://robertsspaceindustries.com/account/security
echo.
pause
goto ErrorMenu

:Fix50k
cls
echo Fixing Error 50001 (Launcher)
echo ==========================
echo Running launcher repair...
echo.
echo Step 1: Killing launcher processes
taskkill /f /im "RSI Launcher.exe" 2>NUL
echo.
echo Step 2: Clearing launcher cache
rd /s /q "%APPDATA%\rsilauncher" 2>NUL
echo.
echo Step 3: Repairing launcher
if exist "%STAR_CITIZEN_DIR%\RSI Launcher\RSI Launcher Repair.exe" (
    start "" "%STAR_CITIZEN_DIR%\RSI Launcher\RSI Launcher Repair.exe"
) else (
    echo Launcher repair tool not found
    echo Please download the launcher from robertsspaceindustries.com
)
echo.
pause
goto ErrorMenu

:Fix20k
cls
echo Fixing Error 20007 (Account)
echo =========================
echo Running account verification...
echo.
echo Step 1: Checking account status
start https://robertsspaceindustries.com/account/settings
echo.
echo Step 2: Verifying email
start https://robertsspaceindustries.com/account/security
echo.
echo Step 3: Clearing account cache
del /s /q "%APPDATA%\rsilauncher\*.account"
echo.
pause
goto ErrorMenu

:Fix40k
cls
echo Fixing Error 40014 (Game Files)
echo ===========================
echo Running file verification...
echo.
echo Step 1: Verifying file integrity
call :VerifyGameFiles
echo.
echo Step 2: Checking permissions
icacls "%STAR_CITIZEN_DIR%" /reset /T
echo.
echo Step 3: Analyzing file system
sfc /scannow
echo.
pause
goto ErrorMenu

:Fix10008
cls
echo Fixing Error 10008 (Anticheat)
echo ===========================
echo Running EasyAntiCheat repair...
echo.
echo Step 1: Stopping EAC service
net stop EasyAntiCheat 2>NUL
echo.
echo Step 2: Repairing EAC
if exist "%STAR_CITIZEN_DIR%\LIVE\EasyAntiCheat\EasyAntiCheat_Setup.exe" (
    start "" "%STAR_CITIZEN_DIR%\LIVE\EasyAntiCheat\EasyAntiCheat_Setup.exe" repair
) else (
    echo EAC installer not found
)
echo.
echo Step 3: Verifying Windows services
sc query EasyAntiCheat
echo.
pause
goto ErrorMenu

:Fix5xx
cls
echo Fixing 5xx Server Errors
echo =====================
echo Running server connection diagnostics...
echo.
echo Step 1: Checking server status
start https://status.robertsspaceindustries.com
echo.
echo Step 2: Testing connection
ping -n 4 roberts-space-industries.com
echo.
echo Step 3: Clearing DNS cache
ipconfig /flushdns
echo.
echo Step 4: Optimizing connection
netsh int tcp set global autotuninglevel=normal
echo.
pause
goto ErrorMenu

:BackupMenu
cls
echo Backup Management
echo ================
echo [1] Backup User Profile
echo [2] Backup Control Settings
echo [3] Restore Backup
echo [4] Back to Main Menu
echo.
set /p "bchoice=Enter your choice (1-4): "

if "%bchoice%"=="1" (
    echo Backing up user profile...
    xcopy "%LOCALAPPDATA%\Star Citizen" "%~dp0backup\profile" /E /I /Y
    echo Backup complete.
    pause
    goto BackupMenu
)
if "%bchoice%"=="2" (
    echo Backing up control settings...
    xcopy "%LOCALAPPDATA%\Star Citizen\mappings" "%~dp0backup\controls" /E /I /Y
    echo Control settings backed up.
    pause
    goto BackupMenu
)
if "%bchoice%"=="3" (
    echo Restoring from backup...
    if exist "%~dp0backup" (
        xcopy "%~dp0backup" "%LOCALAPPDATA%\Star Citizen" /E /I /Y
        echo Restore complete.
    ) else (
        echo No backup found.
    )
    pause
    goto BackupMenu
)
if "%bchoice%"=="4" goto MainMenu
goto BackupMenu

:SettingsMenu
cls
echo Settings
echo ========
echo [1] Set Installation Path
echo [2] Configure Auto-Start Options
echo [3] Reset All Settings
echo [4] Back to Main Menu
echo.
set /p "stchoice=Enter your choice (1-4): "

if "%stchoice%"=="1" (
    set /p "newpath=Enter Star Citizen installation path: "
    echo STAR_CITIZEN_DIR=%newpath%> "%USER_SETTINGS%"
    echo Path updated.
    pause
    goto SettingsMenu
)
if "%stchoice%"=="2" (
    echo Configuring auto-start options...
    echo AUTO_CLEAN_TEMP=1>> "%USER_SETTINGS%"
    echo AUTO_CHECK_UPDATES=1>> "%USER_SETTINGS%"
    echo Options saved.
    pause
    goto SettingsMenu
)
if "%stchoice%"=="3" (
    del "%USER_SETTINGS%" 2>nul
    echo Settings reset to default.
    pause
    goto SettingsMenu
)
if "%stchoice%"=="4" goto MainMenu
goto SettingsMenu

:FullSystemCheck
cls
echo Running Full System Check
echo =======================
echo Step 1/5: Checking disk space...
call :CheckDiskSpace
echo.
echo Step 2/5: Verifying network connectivity...
call :CheckNetworkConnectivity
echo.
echo Step 3/5: Checking file corruption...
call :CheckFileCorruption
echo.
echo Step 4/5: Verifying game files...
call :VerifyGameFiles
echo.
echo Step 5/5: Optimizing performance...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo.
echo Full system check complete.
pause
goto MainMenu

:ClearShaders
cls
echo Clearing Shader Cache
echo ===================
echo This will delete all shader cache files.
echo You will need to rebuild shaders next time you launch the game.
echo.
set /p "confirm=Are you sure? (Y/N): "
if /i "%confirm%"=="Y" (
    rd /s /q "%LOCALAPPDATA%\Star Citizen\sc-alpha\LIVE\shadercache"
    echo Shader cache cleared.
) else (
    echo Operation cancelled.
)
pause
goto MainMenu

:Exit
echo Thank you for using Star Citizen Advanced Troubleshooter
timeout /t 3
exit /b 0

:: Function to check for sufficient disk space
:CheckDiskSpace
echo Checking disk space...
dir /s /a /d "%STAR_CITIZEN_DIR%" | sort /r > "%TEMP_FILE%"
set "largestFile="
for /f "tokens=3" %%a in (%TEMP_FILE%) do (
    if not defined largestFile set "largestFile=%%a"
)
del "%TEMP_FILE%" 2>nul
echo Largest file size: !largestFile! bytes
if !largestFile! GTR 10000000000 (
    echo [WARNING] Large files detected. Consider freeing up disk space.
) else (
    echo [OK] Disk space appears sufficient.
)
echo.
goto :eof

:: Function to check for file corruption
:CheckFileCorruption
echo Checking system files for corruption...
echo This may take several minutes...
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
echo.
goto :eof

:: Function to check network connectivity
:CheckNetworkConnectivity
echo Checking network connectivity...
ping -n 4 google.com >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] Network connectivity issues detected.
    echo Checking DNS resolution...
    nslookup google.com
    echo.
    echo Checking active connections...
    netstat -an | findstr "ESTABLISHED"
    echo.
    echo Checking firewall status...
    netsh advfirewall show currentprofile
) else (
    echo [OK] Network connectivity appears normal.
)
echo.
goto :eof

:: Function to verify game files
:VerifyGameFiles
echo Verifying game files...
if exist "%STAR_CITIZEN_DIR%\%RSI_LAUNCHER%" (
    start "" "%STAR_CITIZEN_DIR%\%RSI_LAUNCHER%" --verify
    echo Launcher started in verify mode.
) else (
    echo [ERROR] RSI Launcher not found at expected location.
)
echo.
goto :eof
