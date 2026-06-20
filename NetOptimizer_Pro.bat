@echo off
setlocal
:: Full Support for UTF-8
chcp 65001 >nul
title NetOptimizer Pro v3.0 - By ALI SAKKAF

:: ==========================================
:: ANSI COLOR ENGINE
:: ==========================================
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "C_RST=%ESC%[0m"
set "C_RED=%ESC%[91m"
set "C_GRN=%ESC%[92m"
set "C_YEL=%ESC%[93m"
set "C_BLU=%ESC%[94m"
set "C_CYA=%ESC%[96m"
set "C_WHT=%ESC%[97m"
set "C_GRY=%ESC%[90m"

:: ==========================================
:: ADMINISTRATOR PRIVILEGES CHECK
:: ==========================================
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo.
    echo %C_RED%  [!] ERROR: This script requires Administrator privileges.%C_RST%
    echo %C_YEL%  [*] Requesting elevation... please wait.%C_RST%
    
    set "SCRIPT_PATH=%~f0"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath $env:SCRIPT_PATH -Verb RunAs" 2>nul
    if %errorlevel% NEQ 0 (
        echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
        echo UAC.ShellExecute """%~f0""", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
        "%temp%\getadmin.vbs" 2>nul
        del "%temp%\getadmin.vbs" >nul 2>&1
        echo.
        echo %C_RED%  [!] Elevation refused or failed.%C_RST%
        echo %C_YEL%  [*] Please right-click the script and select "Run as administrator".%C_RST%
        pause
    )
    exit /b
)

:ADMIN_OK
cd /d "%~dp0"

:: ==========================================
:: INITIALIZE VARIABLES & LOGGING
:: ==========================================
set "SVC_UPDATE_CORE=wuauserv bits dosvc UsoSvc"
set "SVC_UPDATE_EXTRA=WaaSMedicSvc"
set "SVC_TELEMETRY=DiagTrack dmwappushservice PcaSvc CDPSvc WpnService NcbService InstallService MapsBroker lfsvc OneSyncSvc AppXSVC ClipSVC SysMain GamingServices GamingServicesNet XblAuthManager WerSvc WSearch PhoneSvc PushToInstall diagnosticshub.standardcollector.service TrkWks BcastDVRUserService BluetoothUserService RemoteRegistry wisvc Fax SensorService SensorDataService SensrSvc embeddedmode DsSvc rmsvc tzautoupdate"
set "SVC_BROWSERS=gupdate gupdatem braveupdate bravemupdate edgeupdate edgeupdatem MozillaMaintenance"
set "PROC_TELEMETRY=msedgewebview2.exe OneDrive.exe Widgets.exe CompatTelRunner.exe DeviceCensus.exe software_reporter_tool.exe gamebarpresencewriter.exe PhoneExperienceHost.exe mscopilot.exe copilot_setup.exe Teams.exe cortana.exe SearchApp.exe"
set "PROC_BROWSERS=GoogleUpdate.exe BraveUpdate.exe MicrosoftEdgeUpdate.exe maintenanceservice.exe opera_autoupdate.exe updater.exe BraveUpdateOnDemand.exe BraveCrashHandler.exe BraveCrashHandler64.exe BraveCrashHandlerArm64.exe BraveUpdateBroker.exe BraveUpdateComRegisterShell64.exe BraveUpdateComRegisterShellArm64.exe BraveUpdateCore.exe remoting_crashpad_handler.exe remoting_native_messaging_host.exe remote_assistance_host_uiaccess.exe remote_open_url.exe remote_assistance_host.exe remote_security_key.exe remoting_start_host.exe remote_webauthn.exe remoting_desktop.exe remoting_host.exe elevated_tracing_service.exe mscopilot.exe elevation_service.exe msedge_pwa_launcher.exe passkey_authenticator_plugin.exe notification_helper.exe notification_click_helper.exe msedge_proxy.exe identity_helper.exe pwahelper.exe ie_to_edge_stub.exe cookie_exporter.exe copilot_setup.exe"

set "LOG_DIR=%~dp0NetOptimizer_Logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
set "LOG_FILE=%LOG_DIR%\NetOptimizer_Log.txt"

:: ==========================================
:: AUTO-UPDATE ENGINE (PRO)
:: ==========================================
set "CURRENT_VERSION=3.0"
set "SCRIPT_NAME=NetOptimizer_Pro.bat"
set "PASTEBIN_URL=https://pastebin.com/raw/uKR3Lvhg"
set "PS_TLS=[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;"

echo.
echo %C_CYA%  [☁] Checking for updates... (Timeout in 5s)%C_RST%

set "LATEST_VERSION="
for /f "delims=" %%V in ('powershell -NoProfile -Command "$ErrorActionPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; (Invoke-RestMethod -Uri '%PASTEBIN_URL%' -TimeoutSec 5).ToString().Trim()" 2^>nul') do set "LATEST_VERSION=%%V"

if "%LATEST_VERSION%"=="" (
    echo %C_RED%  [!] Server unreachable or check timed out. Proceeding to menu...%C_RST%
    timeout /t 2 >nul
    goto MENU
)

if "%LATEST_VERSION%"=="%CURRENT_VERSION%" (
    echo %C_GRN%  [✔] You are using the latest version ^(v%CURRENT_VERSION%^).%C_RST%
    timeout /t 2 >nul
    goto MENU
)

echo %C_GRN%  [+] New Update Found: v%LATEST_VERSION% %C_YEL%[Current: v%CURRENT_VERSION%]%C_RST%
echo %C_WHT%  [*] Downloading... (Timeout in 10s)%C_RST%

set "DOWNLOAD_URL=https://github.com/alisakkaf/NetOptimizer-Pro/releases/download/v%LATEST_VERSION%/%SCRIPT_NAME%"

if exist "%SystemRoot%\System32\curl.exe" (
    curl.exe -# -m 10 -L -o "%SCRIPT_NAME%.tmp" "%DOWNLOAD_URL%" 2>nul
) else (
    set "DOWNLOAD_URL_VAL=%DOWNLOAD_URL%"
    set "SCRIPT_NAME_VAL=%SCRIPT_NAME%"
    powershell -NoProfile -Command "$ErrorActionPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile($env:DOWNLOAD_URL_VAL, $env:SCRIPT_NAME_VAL + '.tmp')" 2>nul
)

if exist "%SCRIPT_NAME%.tmp" (
    set "VALID_DOWNLOAD=0"
    for %%F in ("%SCRIPT_NAME%.tmp") do (
        if %%~zF GEQ 10000 (
            findstr /i "NetOptimizer" "%SCRIPT_NAME%.tmp" >nul 2>&1
            if not errorlevel 1 set "VALID_DOWNLOAD=1"
        )
    )
    if "%VALID_DOWNLOAD%"=="1" (
        echo.
        for /l %%N in (5,-1,1) do (
            <nul set /p "=%ESC%[2K%ESC%[G%C_YEL%  [✔] Downloaded! Restarting in %%N seconds...%C_RST%"
            ping 127.0.0.1 -n 2 >nul
        )
        (
            echo @echo off
            echo timeout /t 1 ^>nul
            echo move /y "%~dp0%SCRIPT_NAME%.tmp" "%~f0" ^>nul
            echo start "" "%~f0"
            echo del "%%~f0"
        ) > "%~dp0updater.bat"
        start "" /min "%~dp0updater.bat" & exit /b
    ) else (
        del /f /q "%SCRIPT_NAME%.tmp" >nul 2>&1
        echo %C_RED%  [!] Downloaded file is corrupted or invalid. Going to Menu...%C_RST%
        timeout /t 2 >nul
        goto MENU
    )
) else (
    echo %C_RED%  [!] Download failed. Going to Menu...%C_RST%
    timeout /t 2 >nul
    goto MENU
)


:MENU
if not exist "!LOG_DIR!" mkdir "!LOG_DIR!" >nul 2>&1
cls
echo.
echo %C_RED%  ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★%C_RST%
echo %C_RED%  ★                                                                          ★%C_RST%
echo %C_RED%  ★%C_CYA%    █████╗ ██╗     ██╗    ███████╗ █████╗ ██╗  ██╗██╗  ██╗ █████╗ ███████╗%C_RED%★%C_RST%
echo %C_RED%  ★%C_CYA%   ██╔══██╗██║     ██║    ██╔════╝██╔══██╗██║ ██╔╝██║ ██╔╝██╔══██╗██╔════╝%C_RED%★%C_RST%
echo %C_RED%  ★%C_CYA%   ███████║██║     ██║    ███████╗███████║█████╔╝ █████╔╝ ███████║█████╗  %C_RED%★%C_RST%
echo %C_RED%  ★%C_CYA%   ██╔══██║██║     ██║    ╚════██║██╔══██║██╔═██╗ ██╔═██╗ ██╔══██║██╔══╝  %C_RED%★%C_RST%
echo %C_RED%  ★%C_CYA%   ██║  ██║███████╗██║    ███████║██║  ██║██║  ██╗██║  ██╗██║  ██║██║     %C_RED%★%C_RST%
echo %C_RED%  ★%C_CYA%   ╚═╝  ╚═╝╚══════╝╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     %C_RED%★%C_RST%
echo %C_RED%  ★                                                                          ★%C_RST%
echo %C_RED%  ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★%C_RST%
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║%C_YEL%              ⚡ ULTIMATE NETWORK ^& UPDATE SERVICES KILLER ⚡           %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_GRN%                    Developed By: A L I  S A K K A F  v3.0              %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_WHT%                    GitHub User: github.com/alisakkaf                   %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo %C_WHT%   [ SYSTEM NETWORK CONTROL ]%C_RST%
echo %C_GRY%   ----------------------------------------------------------------------%C_RST%
echo   %C_CYA%[1]%C_RST% %C_RED%🛑%C_RST% Disable ALL Network-Hungry Services %C_YEL%(Max Performance)%C_RST%
echo   %C_CYA%[2]%C_RST% %C_GRN%🟢%C_RST% Restore ALL Windows Services to Default State
echo   %C_CYA%[3]%C_RST% %C_BLU%🔄%C_RST% Enable Windows Update ^& Store Services ONLY
echo   %C_CYA%[4]%C_RST% %C_BLU%📱%C_RST% Enable Microsoft Phone Link Services ONLY
echo.
echo %C_WHT%   [ BROWSERS AUTO-UPDATE CONTROL ]%C_RST%
echo %C_GRY%   ----------------------------------------------------------------------%C_RST%
echo   %C_CYA%[5]%C_RST% %C_YEL%⏸️ %C_RST%Temporary Pause: Kill active updaters %C_YEL%(Restores on reboot)%C_RST%
echo   %C_CYA%[6]%C_RST% %C_RED%❌%C_RST% Permanent Block: Hard Kill, Disable Services, GPO ^& IFEO Locks
echo   %C_CYA%[7]%C_RST% %C_GRN%✅%C_RST% Restore Defaults: Enable all browser updates
echo.
echo %C_WHT%   [ MONITORING ^& TOOLS ]%C_RST%
echo %C_GRY%   ----------------------------------------------------------------------%C_RST%
echo   %C_CYA%[8]%C_RST% %C_WHT% 📋%C_RST%  Status Dashboard %C_GRY%(View current system state)%C_RST%
echo   %C_CYA%[9]%C_RST% %C_CYA% 🌐%C_RST%  DNS Optimization Profile %C_GRY%(Apply fast DNS)%C_RST%
echo   %C_CYA%[10]%C_RST% %C_YEL%📁%C_RST%  Open Logs Folder
echo.
echo %C_WHT%   [ ADVANCED TOOLS - NEW ]%C_RST%
echo %C_GRY%   ----------------------------------------------------------------------%C_RST%
echo   %C_CYA%[11]%C_RST% %C_GRN%📶%C_RST% Network Speed Test
echo   %C_CYA%[12]%C_RST% %C_RED%🔥%C_RST% Firewall Updater Blocker %C_GRY%(Block/Restore update traffic)%C_RST%
echo   %C_CYA%[13]%C_RST% %C_MAG%🧹%C_RST% RAM ^& Cache Optimizer
echo   %C_CYA%[14]%C_RST% %C_BLU%☁️ %C_RST%OneDrive Complete Killer
echo   %C_CYA%[15]%C_RST% %C_YEL%🕵️ %C_RST%Telemetry Deep Clean
echo   %C_CYA%[16]%C_RST% %C_CYA%🚀%C_RST% Startup Programs Manager
echo.
echo   %C_GRY%[17] 🚪 Exit Application%C_RST%
echo.
set /p choice="   %C_YEL%>> Select [1-17]: %C_RST%"

if "%choice%"=="1"  goto DISABLE
if "%choice%"=="2"  goto ENABLE
if "%choice%"=="3"  goto ENABLE_WU_STORE
if "%choice%"=="4"  goto ENABLE_PHONE_LINK
if "%choice%"=="5"  goto DISABLE_BROWSERS_TEMP
if "%choice%"=="6"  goto DISABLE_BROWSERS_PERM
if "%choice%"=="7"  goto ENABLE_BROWSERS
if "%choice%"=="8"  goto STATUS_DASHBOARD
if "%choice%"=="9"  goto DNS_OPTIMIZATION
if "%choice%"=="10" goto OPEN_LOGS
if "%choice%"=="11" goto NET_SPEED_TEST
if "%choice%"=="12" goto FIREWALL_MANAGER
if "%choice%"=="13" goto RAM_OPTIMIZER
if "%choice%"=="14" goto ONEDRIVE_KILLER
if "%choice%"=="15" goto TELEMETRY_DEEP
if "%choice%"=="16" goto STARTUP_MANAGER
if "%choice%"=="17" exit
goto MENU

:: ==========================================
:: [1] DISABLE ALL SERVICES
:: ==========================================
:DISABLE
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_RED%[!] WARNING: This will disable all background services ^& telemetry.               %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
set "confirm="
set /p confirm="   %C_YEL%>> Confirm? [Press ENTER, Y, or YES to proceed, any other key to cancel]: %C_RST%"
if not defined confirm set "confirm=YES"
set "is_yes=0"
if /i "%confirm%"=="YES" set "is_yes=1"
if /i "%confirm%"=="Y" set "is_yes=1"
if "%is_yes%"=="0" (
    echo %C_GRY%   [*] Cancelled. Returning to menu...%C_RST%
    timeout /t 2 >nul
    goto MENU
)
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_RED%[*] DEPLOYING MAXIMUM NETWORK PERFORMANCE PROTOCOL...                  %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Creating Secure System Restore Point...
powershell -NoProfile -Command "$ErrorActionPreference='SilentlyContinue'; Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'NetOptimizer Restore Point - By Ali Sakkaf' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Safe System Restore checkpoint completed.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_RED%[KILL]%C_RST% Terminating Resource-Heavy Background UI ^& Telemetry Processes...
for %%P in (%PROC_TELEMETRY%) do (
    start "" /b taskkill /F /IM %%P /T >nul 2>&1
    echo [%date% %time:~0,8%] [KILL] Process: %%P -^> TERMINATED >> "%LOG_FILE%" 2>nul
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Telemetry ^& Background UI Engines Terminated.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Stopping Windows Update Core Engine...
for %%S in (%SVC_UPDATE_CORE% %SVC_UPDATE_EXTRA%) do (
    start "" /b sc stop %%S >nul 2>&1
    echo [%date% %time:~0,8%] [STOP] Service: %%S -^> STOPPED >> "%LOG_FILE%" 2>nul
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Update Engine Halted.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Stopping Telemetry, Sync, Error Reporting ^& App Store Services...
for %%S in (%SVC_TELEMETRY%) do (
    start "" /b sc stop %%S >nul 2>&1
    echo [%date% %time:~0,8%] [STOP] Service: %%S -^> STOPPED >> "%LOG_FILE%" 2>nul
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Background Data Services Halted.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Permanently Disabling Services from Auto-Start...
for %%S in (%SVC_UPDATE_CORE% %SVC_TELEMETRY%) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    if not errorlevel 1 (
        echo [%date% %time:~0,8%] [DISABLE] Service: %%S -^> DISABLED >> "%LOG_FILE%" 2>nul
    ) else (
        echo [%date% %time:~0,8%] [DISABLE_FAILED] Service: %%S -^> Permission Denied/Missing >> "%LOG_FILE%" 2>nul
    )
)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\%SVC_UPDATE_EXTRA%" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
if not errorlevel 1 (
    echo [%date% %time:~0,8%] [DISABLE] Service: %SVC_UPDATE_EXTRA% -^> DISABLED >> "%LOG_FILE%" 2>nul
) else (
    echo [%date% %time:~0,8%] [DISABLE_FAILED] Service: %SVC_UPDATE_EXTRA% -^> Permission Denied/Missing >> "%LOG_FILE%" 2>nul
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Services Locked (Start=Disabled).
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Suspending Telemetry ^& Scheduled Maintenance Tasks...
for %%T in ("Application Experience\ProgramDataUpdater" "Customer Experience Improvement Program\Consolidator" "Customer Experience Improvement Program\UsbCeip" "WindowsUpdate\Scheduled Start" "UpdateOrchestrator\Schedule Scan") do (
    schtasks /Change /TN "Microsoft\Windows\%%~T" /Disable >nul 2>&1
    echo [%date% %time:~0,8%] [TASK] Task: %%~T -^> DISABLED >> "%LOG_FILE%" 2>nul
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Scheduled Tasks Disabled.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Disabling Bing Search Background Network Queries...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d 0 /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Bing Search Network Telemetry Stopped.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Enforcing "Metered Connection" on Network Adapters...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v Ethernet /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi /t REG_DWORD /d 2 /f >nul 2>&1
echo [%date% %time:~0,8%] [REGISTRY] Metered Connection -^> ENFORCED >> "%LOG_FILE%" 2>nul
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Network Throttling Policies Applied.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Resetting Network Stack ^& Clearing DNS Cache...
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Network Flushed.
echo.
echo %C_GRN%   [✔] OPERATION COMPLETE: WINDOWS NETWORK CONSUMPTION IS NOW AT 0%%.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [2] ENABLE ALL SERVICES
:: ==========================================
:ENABLE
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_GRN%[*] RESTORING SYSTEM SERVICES TO DEFAULT CONFIGURATION...              %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Restoring Service Startup Types...
for %%S in (%SVC_UPDATE_CORE% %SVC_TELEMETRY%) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
    echo [%date% %time:~0,8%] [ENABLE] Service: %%S -^> DEMAND >> "%LOG_FILE%"
)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\%SVC_UPDATE_EXTRA%" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
echo [%date% %time:~0,8%] [ENABLE] Service: %SVC_UPDATE_EXTRA% -^> DEMAND >> "%LOG_FILE%"
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Services Restored (Start=Demand).
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Re-Enabling Scheduled Maintenance Tasks...
for %%T in ("Application Experience\ProgramDataUpdater" "WindowsUpdate\Scheduled Start" "UpdateOrchestrator\Schedule Scan") do (
    schtasks /Change /TN "Microsoft\Windows\%%~T" /Enable >nul 2>&1
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Tasks Restored.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Re-enabling Bing Search Start Menu Queries...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Bing Search Restored.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Removing "Metered Connection" Restrictions...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v Ethernet /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi /t REG_DWORD /d 1 /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Network Unrestricted.
echo.
echo %C_GRN%   [✔] OPERATION COMPLETE: WINDOWS IS BACK TO NORMAL.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [3] ENABLE WINDOWS UPDATE & STORE ONLY
:: ==========================================
:ENABLE_WU_STORE
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_BLU%[*] ACTIVATING WINDOWS UPDATE ^& MICROSOFT STORE SERVICES...            %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Re-configuring essential services...
for %%S in (wuauserv bits InstallService ClipSVC AppXSVC PushToInstall) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Starting services...
for %%S in (bits wuauserv InstallService ClipSVC AppXSVC) do (
    net start %%S >nul 2>&1
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Windows Update ^& Store are Operational.
echo.
echo %C_GRN%   [✔] SUCCESS: YOU CAN NOW CHECK FOR UPDATES AND USE THE STORE.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [4] ENABLE MICROSOFT PHONE LINK ONLY
:: ==========================================
:ENABLE_PHONE_LINK
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_BLU%[*] ACTIVATING MICROSOFT PHONE LINK SERVICES...                        %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Re-configuring Phone Link, Network Broker, and Push Notifications...
:: Essential background services for UWP Phone Link sync
for %%S in (PhoneSvc BcastDVRUserService BluetoothUserService NcbService WpnService) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
)
:: Enabling background app execution for Phone Link via Registry
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.YourPhone_8wekyb3d8bbwe" /v Disabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.YourPhone_8wekyb3d8bbwe" /v DisabledByUser /t REG_DWORD /d 0 /f >nul 2>&1

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Starting services...
for %%S in (NcbService WpnService PhoneSvc BcastDVRUserService BluetoothUserService) do (
    net start %%S >nul 2>&1
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Microsoft Phone Link is now Operational.
echo.
echo %C_GRN%   [✔] SUCCESS: YOU CAN NOW CONNECT AND SYNC YOUR PHONE.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [5] TEMPORARY PAUSE BROWSERS UPDATES
:: ==========================================
:DISABLE_BROWSERS_TEMP
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_YEL%[*] INITIATING TEMPORARY BROWSER UPDATER SUSPENSION...                 %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_YEL%[KILL]%C_RST% Terminating Active Updater Processes in RAM...
for %%P in (%PROC_BROWSERS%) do (
    taskkill /F /IM %%P /T >nul 2>&1
    echo [%date% %time:~0,8%] [KILL] Browser Updater: %%P -^> TERMINATED >> "%LOG_FILE%"
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Active Ghost Processes Terminated.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Stopping Browser Updater Services (Without disabling them)...
for %%B in (%SVC_BROWSERS%) do (
    start "" /b sc stop %%B >nul 2>&1
    echo [%date% %time:~0,8%] [STOP] Browser Service: %%B -^> STOPPED >> "%LOG_FILE%"
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Current Sessions Halted.
echo.
echo %C_YEL%   [ℹ] NOTE: Updaters are stopped for this session but will return on PC restart.%C_RST%
echo %C_GRN%   [✔] OPERATION COMPLETE: BROWSERS TEMPORARILY PAUSED.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [6] PERMANENT DISABLE BROWSERS UPDATES
:: ==========================================
:DISABLE_BROWSERS_PERM
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_RED%[!] WARNING: This will permanently block ALL browser auto-updates!                 %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
set "confirm2="
set /p confirm2="   %C_YEL%>> Confirm? [Press ENTER, Y, or YES to proceed, any other key to cancel]: %C_RST%"
if not defined confirm2 set "confirm2=YES"
set "is_yes2=0"
if /i "%confirm2%"=="YES" set "is_yes2=1"
if /i "%confirm2%"=="Y" set "is_yes2=1"
if "%is_yes2%"=="0" (
    echo %C_GRY%   [*] Cancelled. Returning to menu...%C_RST%
    timeout /t 2 >nul
    goto MENU
)
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_RED%[*] INITIATING BULLETPROOF BROWSER ELIMINATION PROTOCOL...             %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_RED%[KILL]%C_RST% Hunting ^& Terminating Active Updater Processes in RAM...
for %%P in (%PROC_BROWSERS%) do (
    taskkill /F /IM %%P /T >nul 2>&1
    echo [%date% %time:~0,8%] [KILL] Browser Updater: %%P -^> TERMINATED >> "%LOG_FILE%"
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% All Ghost Processes Eliminated.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Disabling Chrome, Brave, Edge ^& Firefox Updater Services...
for %%B in (%SVC_BROWSERS%) do (
    start "" /b sc stop %%B >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%B" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    echo [%date% %time:~0,8%] [DISABLE] Browser Service: %%B -^> DISABLED >> "%LOG_FILE%"
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Browser Services Disabled.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Eradicating Browser Scheduled Update Tasks...
for %%T in ("\GoogleUpdateTaskMachineCore" "\GoogleUpdateTaskMachineUA" "\BraveUpdateTaskMachineCore" "\BraveUpdateTaskMachineUA" "\MicrosoftEdgeUpdateTaskMachineCore" "\MicrosoftEdgeUpdateTaskMachineUA") do (
    schtasks /Change /TN "%%~T" /Disable >nul 2>&1
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Tasks Successfully Deactivated.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_YEL%[LOCK]%C_RST% Injecting Core GPO ^& IFEO Debugger Locks (The Nuclear Fix)...
:: 1. Standard Group Policy Locks
reg add "HKLM\SOFTWARE\Policies\Google\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableAppUpdate /t REG_DWORD /d 1 /f >nul 2>&1
:: WOW6432Node GPO Locks
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Google\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\BraveSoftware\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\EdgeUpdate" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Mozilla\Firefox" /v DisableAppUpdate /t REG_DWORD /d 1 /f >nul 2>&1

:: 2. IFEO (Image File Execution Options) Debugger Traps - Makes updates mathematically impossible to run
for %%X in (GoogleUpdate.exe MicrosoftEdgeUpdate.exe BraveUpdate.exe updater.exe maintenanceservice.exe) do (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%X" /v Debugger /t REG_SZ /d "systray.exe" /f >nul 2>&1
)

echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Bulletproof IFEO ^& GPO Security Policies Enforced.
echo.
echo %C_GRN%   [✔] OPERATION COMPLETE: BROWSERS ARE NOW 100%% INCAPABLE OF UPDATING.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [7] ENABLE BROWSERS UPDATES
:: ==========================================
:ENABLE_BROWSERS
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_GRN%[*] RESTORING BROWSER AUTO-UPDATE FUNCTIONALITY (TEMP ^& PERM)...       %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Re-Enabling Browser Updater Services...
:: Set Automatic (2) for primary updaters
for %%B in (gupdate braveupdate edgeupdate) do (
    sc config %%B start= auto >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%B" /v Start /t REG_DWORD /d 2 /f >nul 2>&1
    echo [%date% %time:~0,8%] [ENABLE] Browser Service: %%B -^> AUTO >> "%LOG_FILE%"
)
:: Set Manual (3) for secondary updaters
for %%B in (gupdatem bravemupdate edgeupdatem MozillaMaintenance) do (
    sc config %%B start= demand >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%B" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
    echo [%date% %time:~0,8%] [ENABLE] Browser Service: %%B -^> DEMAND >> "%LOG_FILE%"
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Services Restored.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Re-Enabling Browser Scheduled Tasks...
for %%T in ("\GoogleUpdateTaskMachineCore" "\GoogleUpdateTaskMachineUA" "\BraveUpdateTaskMachineCore" "\BraveUpdateTaskMachineUA" "\MicrosoftEdgeUpdateTaskMachineCore" "\MicrosoftEdgeUpdateTaskMachineUA") do (
    schtasks /Change /TN "%%~T" /Enable >nul 2>&1
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Tasks Restored.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_YEL%[UNLOCK]%C_RST% Erasing GPO Locks and IFEO Debugger Traps...
:: Delete entire GPO Update keys for Google, Brave, and Edge to restore total defaults
reg delete "HKLM\SOFTWARE\Policies\Google\Update" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\BraveSoftware\Update" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableAppUpdate /f >nul 2>&1

reg delete "HKLM\SOFTWARE\WOW6432Node\Policies\Google\Update" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\Policies\BraveSoftware\Update" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\EdgeUpdate" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\Policies\Mozilla\Firefox" /v DisableAppUpdate /f >nul 2>&1

:: Erasing IFEO Traps
for %%X in (GoogleUpdate.exe MicrosoftEdgeUpdate.exe BraveUpdate.exe updater.exe maintenanceservice.exe) do (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%X" /v Debugger /f >nul 2>&1
)

echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% All Security Policies Removed.
echo.
echo %C_GRN%   [✔] OPERATION COMPLETE: BROWSERS CAN NOW UPDATE NORMALLY.%C_RST%
echo.
pause
goto MENU
:: ==========================================
:: ==========================================
:: [8] STATUS DASHBOARD
:: ==========================================
:STATUS_DASHBOARD
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_YEL%SYSTEM STATUS DASHBOARD                                              %C_WHT%║%C_RST%
echo %C_WHT%   ╠════════════════════════════════════════════════════════════════════════╣%C_RST%

:: Check Windows Update Engine
sc query wuauserv >nul 2>&1
if %errorlevel% NEQ 0 (set "ST_WU=%C_RED%[ NOT FOUND ]%C_RST%") else (
    sc qc wuauserv 2>nul | findstr /i "DISABLED" >nul 2>&1
    if not errorlevel 1 (set "ST_WU=%C_RED%[  BLOCKED  ]%C_RST%") else (set "ST_WU=%C_GRN%[  ACTIVE   ]%C_RST%")
)

:: Check Background Transfer (BITS)
sc query BITS >nul 2>&1
if %errorlevel% NEQ 0 (set "ST_BITS=%C_RED%[ NOT FOUND ]%C_RST%") else (
    sc qc BITS 2>nul | findstr /i "DISABLED" >nul 2>&1
    if not errorlevel 1 (set "ST_BITS=%C_RED%[  BLOCKED  ]%C_RST%") else (set "ST_BITS=%C_GRN%[  ACTIVE   ]%C_RST%")
)

:: Check Windows Telemetry
sc query DiagTrack >nul 2>&1
if %errorlevel% NEQ 0 (set "ST_TEL=%C_RED%[ NOT FOUND ]%C_RST%") else (
    sc qc DiagTrack 2>nul | findstr /i "DISABLED" >nul 2>&1
    if not errorlevel 1 (set "ST_TEL=%C_RED%[  BLOCKED  ]%C_RST%") else (set "ST_TEL=%C_GRN%[  ACTIVE   ]%C_RST%")
)

:: Check SysMain (Superfetch)
sc query SysMain >nul 2>&1
if %errorlevel% NEQ 0 (set "ST_SYS=%C_RED%[ NOT FOUND ]%C_RST%") else (
    sc qc SysMain 2>nul | findstr /i "DISABLED" >nul 2>&1
    if not errorlevel 1 (set "ST_SYS=%C_RED%[  BLOCKED  ]%C_RST%") else (set "ST_SYS=%C_GRN%[  ACTIVE   ]%C_RST%")
)

:: Check Chrome Update
set "ST_CHR=%C_GRN%[  ACTIVE   ]%C_RST%"
set "IS_CHR=0"
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "IS_CHR=1"
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "IS_CHR=1"
if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "IS_CHR=1"
if "%IS_CHR%"=="0" (
    set "ST_CHR=%C_GRY%[UNINSTALLED]%C_RST%"
) else (
    reg query "HKLM\SOFTWARE\Policies\Google\Update" /v UpdateDefault 2>nul | findstr "0x0" >nul 2>&1
    if not errorlevel 1 set "ST_CHR=%C_RED%[  BLOCKED  ]%C_RST%"
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GoogleUpdate.exe" /v Debugger 2>nul >nul 2>&1
    if not errorlevel 1 set "ST_CHR=%C_RED%[  BLOCKED  ]%C_RST%"
    sc query gupdate >nul 2>&1
    if not errorlevel 1 (
        sc qc gupdate 2>nul | findstr /i "DISABLED" >nul 2>&1
        if not errorlevel 1 set "ST_CHR=%C_RED%[  BLOCKED  ]%C_RST%"
    )
)

:: Check Edge Update
set "ST_EDG=%C_GRN%[  ACTIVE   ]%C_RST%"
set "IS_EDG=0"
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "IS_EDG=1"
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "IS_EDG=1"
if "%IS_EDG%"=="0" (
    set "ST_EDG=%C_GRY%[UNINSTALLED]%C_RST%"
) else (
    reg query "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v UpdateDefault 2>nul | findstr "0x0" >nul 2>&1
    if not errorlevel 1 set "ST_EDG=%C_RED%[  BLOCKED  ]%C_RST%"
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MicrosoftEdgeUpdate.exe" /v Debugger 2>nul >nul 2>&1
    if not errorlevel 1 set "ST_EDG=%C_RED%[  BLOCKED  ]%C_RST%"
    sc query edgeupdate >nul 2>&1
    if not errorlevel 1 (
        sc qc edgeupdate 2>nul | findstr /i "DISABLED" >nul 2>&1
        if not errorlevel 1 set "ST_EDG=%C_RED%[  BLOCKED  ]%C_RST%"
    )
)

:: Check Brave Update
set "ST_BRV=%C_GRN%[  ACTIVE   ]%C_RST%"
set "IS_BRV=0"
if exist "%ProgramFiles%\BraveSoftware\Brave-Browser\Application\brave.exe" set "IS_BRV=1"
if exist "%ProgramFiles(x86)%\BraveSoftware\Brave-Browser\Application\brave.exe" set "IS_BRV=1"
if exist "%LocalAppData%\BraveSoftware\Brave-Browser\Application\brave.exe" set "IS_BRV=1"
if "%IS_BRV%"=="0" (
    set "ST_BRV=%C_GRY%[UNINSTALLED]%C_RST%"
) else (
    reg query "HKLM\SOFTWARE\Policies\BraveSoftware\Update" /v UpdateDefault 2>nul | findstr "0x0" >nul 2>&1
    if not errorlevel 1 set "ST_BRV=%C_RED%[  BLOCKED  ]%C_RST%"
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\BraveUpdate.exe" /v Debugger 2>nul >nul 2>&1
    if not errorlevel 1 set "ST_BRV=%C_RED%[  BLOCKED  ]%C_RST%"
    sc query braveupdate >nul 2>&1
    if not errorlevel 1 (
        sc qc braveupdate 2>nul | findstr /i "DISABLED" >nul 2>&1
        if not errorlevel 1 set "ST_BRV=%C_RED%[  BLOCKED  ]%C_RST%"
    )
)

:: Check Firefox Update
set "ST_FF=%C_GRN%[  ACTIVE   ]%C_RST%"
set "IS_FF=0"
if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" set "IS_FF=1"
if exist "%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe" set "IS_FF=1"
if "%IS_FF%"=="0" (
    set "ST_FF=%C_GRY%[UNINSTALLED]%C_RST%"
) else (
    reg query "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableAppUpdate 2>nul | findstr "0x1" >nul 2>&1
    if not errorlevel 1 set "ST_FF=%C_RED%[  BLOCKED  ]%C_RST%"
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\maintenanceservice.exe" /v Debugger 2>nul >nul 2>&1
    if not errorlevel 1 set "ST_FF=%C_RED%[  BLOCKED  ]%C_RST%"
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\updater.exe" /v Debugger 2>nul >nul 2>&1
    if not errorlevel 1 set "ST_FF=%C_RED%[  BLOCKED  ]%C_RST%"
    sc query MozillaMaintenance >nul 2>&1
    if not errorlevel 1 (
        sc qc MozillaMaintenance 2>nul | findstr /i "DISABLED" >nul 2>&1
        if not errorlevel 1 set "ST_FF=%C_RED%[  BLOCKED  ]%C_RST%"
    )
)

:: Check Metered WiFi Connection
set "ST_MET=%C_GRY%[  NORMAL   ]%C_RST%"
set "T_MET="
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi 2^>nul ^| find /i "WiFi"') do set "T_MET=%%a"
if "%T_MET%"=="0x2" set "ST_MET=%C_YEL%[ ENFORCED  ]%C_RST%"

:: Check Hosts File
set "ST_HOSTS=%C_GRN%[   CLEAN   ]%C_RST%"
findstr /i "microsoft.com" "%SystemRoot%\System32\drivers\etc\hosts" >nul 2>&1
if not errorlevel 1 set "ST_HOSTS=%C_YEL%[ MODIFIED  ]%C_RST%"

:: Check Active DNS Server
set "CURRENT_DNS=Default DHCP "
set "NET_INT="
for /f "tokens=1,2,3*" %%A in ('netsh interface show interface ^| find "Connected" 2^>nul') do set "NET_INT=%%D"
if not "%NET_INT%"=="" (
    for /f "tokens=*" %%A in ('netsh interface ipv4 show dns name="%NET_INT%" 2^>nul ^| findstr /R "[0-9][0-9]*\.[0-9]"') do (
        echo %%A | find "1.1.1.1" >nul 2>&1 && set "CURRENT_DNS=Cloudflare   "
        echo %%A | find "8.8.8.8" >nul 2>&1 && set "CURRENT_DNS=Google DNS   "
        echo %%A | find "9.9.9.9" >nul 2>&1 && set "CURRENT_DNS=Quad9        "
        echo %%A | find "94.140.14.14" >nul 2>&1 && set "CURRENT_DNS=AdGuard      "
        echo %%A | find "76.76.2.0" >nul 2>&1 && set "CURRENT_DNS=ControlD     "
        echo %%A | find "91.239.100.100" >nul 2>&1 && set "CURRENT_DNS=UncensoredDNS"
        echo %%A | find "178.22.122.100" >nul 2>&1 && set "CURRENT_DNS=Shecan       "
        echo %%A | find "10.202.10.202" >nul 2>&1 && set "CURRENT_DNS=403 DNS      "
        echo %%A | find "78.157.42.100" >nul 2>&1 && set "CURRENT_DNS=Electro DNS  "
    )
)
set "ST_DNS=%C_CYA%[%CURRENT_DNS%]%C_RST%"

:: Check Browser DNS Policy
set "ST_DOH=%C_GRY%[  NOT SET  ]%C_RST%"
reg query "HKLM\SOFTWARE\Policies\Google\Chrome" /v DnsOverHttpsMode >nul 2>&1
if not errorlevel 1 set "ST_DOH=%C_GRN%[  SECURE   ]%C_RST%"

echo %C_WHT%   ║ %C_CYA%[ 🖥️  SYSTEM ^& TELEMETRY SERVICES ]                              %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Windows Update Engine        : %ST_WU%                          %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Background Transfer (BITS)   : %ST_BITS%                          %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Windows Telemetry Service    : %ST_TEL%                          %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% SysMain (Superfetch) Service : %ST_SYS%                          %C_WHT%║%C_RST%
echo %C_WHT%   ╠════════════════════════════════════════════════════════════════════════╣%C_RST%
echo %C_WHT%   ║ %C_CYA%[ 🌐 BROWSER AUTO-UPDATE POLICIES ]                               %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Google Chrome Update Service : %ST_CHR%                          %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Microsoft Edge Update Service: %ST_EDG%                          %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Brave Browser Update Service : %ST_BRV%                          %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Mozilla Firefox Maintenance  : %ST_FF%                          %C_WHT%║%C_RST%
echo %C_WHT%   ╠════════════════════════════════════════════════════════════════════════╣%C_RST%
echo %C_WHT%   ║ %C_CYA%[ 📶 NETWORK COST ^& SECURITY CONFIGS ]                            %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Metered Network Adapter Cost : %ST_MET%                          %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Hosts File Integrity         : %ST_HOSTS%                          %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Active DNS Resolver          : %ST_DNS%                          %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_RST% Browser DNS Security (DoH)   : %ST_DOH%                          %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
pause
goto MENU


:: [9] DNS OPTIMIZATION CENTER
:: ==========================================
:DNS_OPTIMIZATION
cls
if "%LOG_DIR%"=="" set "LOG_DIR=%USERPROFILE%\NetOptimizer_Logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
if "%LOG_FILE%"=="" set "LOG_FILE=%LOG_DIR%\NetOptimizer_Log.txt"
echo %C_YEL%   [*] Checking DNS availability, please wait...%C_RST%
set "S1=OFFLINE" & ping -n 1 -w 600 1.1.1.1       >nul 2>&1 & if not errorlevel 1 set "S1=ONLINE "
set "S2=OFFLINE" & ping -n 1 -w 600 8.8.8.8       >nul 2>&1 & if not errorlevel 1 set "S2=ONLINE "
set "S3=OFFLINE" & ping -n 1 -w 600 9.9.9.9       >nul 2>&1 & if not errorlevel 1 set "S3=ONLINE "
set "S4=OFFLINE" & ping -n 1 -w 600 94.140.14.14  >nul 2>&1 & if not errorlevel 1 set "S4=ONLINE "
set "S5=OFFLINE" & ping -n 1 -w 600 76.76.2.0     >nul 2>&1 & if not errorlevel 1 set "S5=ONLINE "
set "S6=OFFLINE" & ping -n 1 -w 600 91.239.100.100>nul 2>&1 & if not errorlevel 1 set "S6=ONLINE "
set "S7=OFFLINE" & ping -n 1 -w 600 178.22.122.100>nul 2>&1 & if not errorlevel 1 set "S7=ONLINE "
set "S8=OFFLINE" & ping -n 1 -w 600 10.202.10.202 >nul 2>&1 & if not errorlevel 1 set "S8=ONLINE "
set "S9=OFFLINE" & ping -n 1 -w 600 78.157.42.100 >nul 2>&1 & if not errorlevel 1 set "S9=ONLINE "
cls
echo.
echo %C_WHT%   +------------------------------------------------------------------------+%C_RST%
echo %C_WHT%   ^|       %C_CYA%DNS OPTIMIZATION CENTER  -  SELECT A DNS SERVER%C_WHT%                   ^|%C_RST%
echo %C_WHT%   +------------------------------------------------------------------------+%C_RST%
echo.
echo   %C_CYA%[1]%C_RST%  1.1.1.1  / 1.0.0.1          Cloudflare            [%S1%]
echo   %C_CYA%[2]%C_RST%  8.8.8.8  / 8.8.4.4          Google DNS            [%S2%]
echo   %C_CYA%[3]%C_RST%  9.9.9.9  / 149.112.112.112  Quad9                 [%S3%]
echo   %C_CYA%[4]%C_RST%  94.140.14.14 / 94.140.15.15 AdGuard               [%S4%]
echo   %C_CYA%[5]%C_RST%  76.76.2.0 / 76.76.10.0      ControlD              [%S5%]
echo   %C_CYA%[6]%C_RST%  91.239.100.100 / 89.233.43.71  UncensoredDNS      [%S6%]
echo   %C_CYA%[7]%C_RST%  178.22.122.100 / 185.51.200.2  Shecan              [%S7%]
echo   %C_CYA%[8]%C_RST%  10.202.10.202 / 10.202.10.102  403 DNS            [%S8%]
echo   %C_CYA%[9]%C_RST%  78.157.42.100 / 78.157.42.101  Electro DNS        [%S9%]
echo.
echo   %C_CYA%[C]%C_RST%  Custom DNS (enter your own values)
echo   %C_CYA%[10]%C_RST% Restore Default DHCP (removes all overrides)
echo   %C_GRY%[0] Back to Menu%C_RST%
echo.
set /p dns_choice="   %C_YEL%>> Select [1-10 / C / 0]: %C_RST%"
if /i "%dns_choice%"=="0" goto MENU
if /i "%dns_choice%"=="c" goto DNS_CUSTOM
if "%dns_choice%"=="10" goto DNS_RESTORE

set "IP1=" & set "IP2=" & set "DOH=" & set "D_NAME="
if "%dns_choice%"=="1" set "IP1=1.1.1.1"          & set "IP2=1.0.0.1"          & set "DOH=https://chrome.cloudflare-dns.com/dns-query{?dns}" & set "D_NAME=Cloudflare"
if "%dns_choice%"=="2" set "IP1=8.8.8.8"          & set "IP2=8.8.4.4"          & set "DOH=https://dns.google/dns-query{?dns}"                 & set "D_NAME=Google DNS"
if "%dns_choice%"=="3" set "IP1=9.9.9.9"          & set "IP2=149.112.112.112"  & set "DOH=https://dns.quad9.net/dns-query{?dns}"              & set "D_NAME=Quad9"
if "%dns_choice%"=="4" set "IP1=94.140.14.14"     & set "IP2=94.140.15.15"     & set "DOH=https://dns.adguard-dns.com/dns-query{?dns}"        & set "D_NAME=AdGuard"
if "%dns_choice%"=="5" set "IP1=76.76.2.0"        & set "IP2=76.76.10.0"       & set "DOH=https://freedns.controld.com/p0{?dns}"              & set "D_NAME=ControlD"
if "%dns_choice%"=="6" set "IP1=91.239.100.100"   & set "IP2=89.233.43.71"     & set "DOH=https://anycast.uncensoredns.org/dns-query{?dns}"   & set "D_NAME=UncensoredDNS"
if "%dns_choice%"=="7" set "IP1=178.22.122.100"   & set "IP2=185.51.200.2"     & set "DOH=off"                                                & set "D_NAME=Shecan DNS"
if "%dns_choice%"=="8" set "IP1=10.202.10.202"    & set "IP2=10.202.10.102"    & set "DOH=off"                                                & set "D_NAME=403 DNS"
if "%dns_choice%"=="9" set "IP1=78.157.42.100"    & set "IP2=78.157.42.101"    & set "DOH=off"                                                & set "D_NAME=Electro DNS"
if "%D_NAME%"=="" goto MENU

if "%DOH%"=="off" (
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome"       /v DnsOverHttpsMode /t REG_SZ   /d "off" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v DnsOverHttpsMode /t REG_SZ   /d "off" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v DnsOverHttpsMode /t REG_SZ   /d "off" /f >nul 2>&1
) else (
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome"       /v DnsOverHttpsMode      /t REG_SZ    /d "secure"   /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome"       /v DnsOverHttpsTemplates /t REG_SZ    /d "%DOH%"    /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v BuiltInDnsClientEnabled /t REG_DWORD /d 1        /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v DnsOverHttpsMode      /t REG_SZ    /d "secure"   /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v DnsOverHttpsTemplates /t REG_SZ    /d "%DOH%"    /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v DnsOverHttpsMode      /t REG_SZ    /d "secure"   /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v DnsOverHttpsTemplates /t REG_SZ    /d "%DOH%"    /f >nul 2>&1
)
for /f "tokens=1,2,3*" %%A in ('netsh interface show interface ^| find "Connected" 2^>nul') do (
    netsh interface ipv4 set dns name="%%D" static %IP1% primary >nul 2>&1
    netsh interface ipv4 add dns name="%%D" %IP2% index=2 >nul 2>&1
)
ipconfig /flushdns >nul 2>&1
echo [%date% %time:~0,8%] [DNS] Applied %D_NAME% >> "%LOG_FILE%" 2>nul
echo %C_GRN%   [+] DNS set to %D_NAME% ^(%IP1%^).%C_RST%
echo %C_GRN%   [+] Browser policy applied. Restart browser to take effect.%C_RST%
echo %C_GRN%   [+] DNS Cache Flushed.%C_RST%
echo.
pause
goto MENU

:DNS_RESTORE
echo %C_GRY%   [*] Restoring DHCP and removing all overrides...%C_RST%
for /f "tokens=1,2,3*" %%A in ('netsh interface show interface ^| find "Connected" 2^>nul') do (
    netsh interface ipv4 set dns name="%%D" dhcp >nul 2>&1
    netsh interface ipv6 set dns name="%%D" dhcp >nul 2>&1
)
reg delete "HKLM\SOFTWARE\Policies\Google\Chrome"       /v DnsOverHttpsMode        /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Google\Chrome"       /v DnsOverHttpsTemplates   /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Google\Chrome"       /v QuicAllowed             /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v DnsOverHttpsMode        /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v DnsOverHttpsTemplates   /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v BuiltInDnsClientEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v QuicAllowed             /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v DnsOverHttpsMode        /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v DnsOverHttpsTemplates   /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v QuicAllowed             /f >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo [%date% %time:~0,8%] [DNS] Restored DHCP - all policies cleared >> "%LOG_FILE%" 2>nul
echo %C_GRN%   [+] DNS restored to Automatic.%C_RST%
echo %C_GRN%   [+] All browser DNS policies removed.%C_RST%
echo %C_GRN%   [+] Browsers are no longer managed by administrator.%C_RST%
echo.
pause
goto MENU

:DNS_CUSTOM
cls
echo.
echo %C_WHT%   +--------------------------------+%C_RST%
echo %C_WHT%   ^|    CUSTOM DNS CONFIGURATION    ^|%C_RST%
echo %C_WHT%   +--------------------------------+%C_RST%
echo.
echo   %C_YEL%Enter your DNS server IPs. Example: 8.8.8.8%C_RST%
echo.
set "CUST_IP1=" & set "CUST_IP2="
set /p CUST_IP1="   >> Primary DNS  : "
if "%CUST_IP1%"=="" (
    echo %C_RED%   [!] Primary DNS cannot be empty.%C_RST%
    pause
    goto MENU
)
set /p CUST_IP2="   >> Secondary DNS: "
if "%CUST_IP2%"=="" set "CUST_IP2=%CUST_IP1%"
echo %C_GRY%   [*] Testing %CUST_IP1%...%C_RST%
ping -n 1 -w 1500 %CUST_IP1% >nul 2>&1
if errorlevel 1 (
    echo %C_YEL%   [!] No ping response from %CUST_IP1%. Applying anyway...%C_RST%
    timeout /t 2 /nobreak >nul 2>&1
)
reg add "HKLM\SOFTWARE\Policies\Google\Chrome"       /v DnsOverHttpsMode /t REG_SZ /d "off" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v DnsOverHttpsMode /t REG_SZ /d "off" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v DnsOverHttpsMode /t REG_SZ /d "off" /f >nul 2>&1

for /f "tokens=1,2,3*" %%A in ('netsh interface show interface ^| find "Connected" 2^>nul') do (
    netsh interface ipv4 set dns name="%%D" static %CUST_IP1% primary >nul 2>&1
    netsh interface ipv4 add dns name="%%D" %CUST_IP2% index=2 >nul 2>&1
)
ipconfig /flushdns >nul 2>&1
echo [%date% %time:~0,8%] [DNS] Custom DNS %CUST_IP1% / %CUST_IP2% >> "%LOG_FILE%" 2>nul
echo %C_GRN%   [+] Custom DNS applied: %CUST_IP1% / %CUST_IP2%%C_RST%
echo %C_GRN%   [+] DNS Cache Flushed.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [10] OPEN LOGS FOLDER
:: ==========================================
:OPEN_LOGS
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_CYA%📁 OPENING LOGS FOLDER...                                               %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
if "%LOG_DIR%"=="" set "LOG_DIR=%USERPROFILE%\NetOptimizer_Logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
start "" "%LOG_DIR%"
echo %C_GRN%   [+] Logs folder opened.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [11] NETWORK SPEED TEST
:: ==========================================
:NET_SPEED_TEST
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_GRN%[11] 📶 NETWORK SPEED TEST                                             %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo %C_CYA%   [*] Downloading 2MB test file from Cloudflare...%C_RST%
echo %C_GRY%   (Using speed.cloudflare.com)%C_RST%
echo.
set "SPEED_RESULT="
set "PS_SPD=%temp%\nopt_speed.ps1"
(
echo $ErrorActionPreference='SilentlyContinue'
echo try {
echo   $url='https://speed.cloudflare.com/__down?bytes=2097152'
echo   $wc=New-Object System.Net.WebClient
echo   $sw=[System.Diagnostics.Stopwatch]::StartNew(^)
echo   $data=$wc.DownloadData($url^)
echo   $sw.Stop(^)
echo   $mb=[math]::Round($data.Length/1048576,2^)
echo   $sec=[math]::Round($sw.Elapsed.TotalSeconds,2^)
echo   $mbps=[math]::Round(($mb*8^)/$sec,2^)
echo   Write-Output "$mbps Mbps ^($mb MB in $sec s^)"
echo } catch { Write-Output 'FAILED' }
) > "%PS_SPD%"
for /f "delims=" %%R in ('powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SPD%" 2^>nul') do set "SPEED_RESULT=%%R"
del "%PS_SPD%" >nul 2>&1
if "%SPEED_RESULT%"=="FAILED" (
    echo %C_RED%   [!] Speed test failed. Check your internet connection.%C_RST%
) else if "%SPEED_RESULT%"=="" (
    echo %C_RED%   [!] Could not retrieve results. Check internet connection.%C_RST%
) else (
    echo %C_GRN%   [✔] Download Speed: %SPEED_RESULT%%C_RST%
    echo [%date% %time:~0,8%] [SPEEDTEST] Result: %SPEED_RESULT% >> "%LOG_FILE%" 2>nul
)
echo.
echo %C_GRY%   [*] Checking ping to 1.1.1.1 (Cloudflare)...%C_RST%
for /f "tokens=7 delims=ms " %%P in ('ping -n 3 1.1.1.1 ^| findstr "Average"') do (
    echo %C_GRN%   [✔] Avg Ping: %%P ms%C_RST%
)
echo.
pause
goto MENU

:: ==========================================
:: [12] FIREWALL UPDATER BLOCKER
:: ==========================================
:FIREWALL_MANAGER
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_RED%[12] 🔥 FIREWALL UPDATER BLOCKER                                        %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo   %C_CYA%[1]%C_RST% %C_RED%Block%C_RST%   - Add outbound firewall rules to block update traffic
echo   %C_CYA%[2]%C_RST% %C_GRN%Restore%C_RST% - Remove all NetOptimizer firewall rules
echo   %C_CYA%[3]%C_RST% %C_WHT%Status%C_RST%  - Show active NetOptimizer firewall rules
echo   %C_GRY%[0] Back to Menu%C_RST%
echo.
set /p fw_choice="   %C_YEL%>> Select [1-3/0]: %C_RST%"
if "%fw_choice%"=="0" goto MENU
if "%fw_choice%"=="1" goto FW_BLOCK
if "%fw_choice%"=="2" goto FW_RESTORE
if "%fw_choice%"=="3" goto FW_STATUS
goto FIREWALL_MANAGER

:FW_BLOCK
echo.
echo %C_GRY%[%time:~0,8%]%C_RST% %C_RED%[FIREWALL]%C_RST% Adding outbound block rules for update executables...
for %%X in (wuauclt.exe WaaSMedicAgent.exe GoogleUpdate.exe MicrosoftEdgeUpdate.exe BraveUpdate.exe maintenanceservice.exe usoclient.exe) do (
    netsh advfirewall firewall add rule name="NetOptimizer_Block_%%X" dir=out action=block program="%%X" enable=yes description="NetOptimizer auto-rule" >nul 2>&1
    echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Blocked: %%X
    echo [%date% %time:~0,8%] [FIREWALL] Blocked: %%X >> "%LOG_FILE%" 2>nul
)
echo.
echo %C_GRN%   [✔] Firewall rules applied. Update traffic is now blocked.%C_RST%
echo.
pause
goto MENU

:FW_RESTORE
echo.
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[FIREWALL]%C_RST% Removing all NetOptimizer firewall rules...
for %%X in (wuauclt.exe WaaSMedicAgent.exe GoogleUpdate.exe MicrosoftEdgeUpdate.exe BraveUpdate.exe maintenanceservice.exe usoclient.exe) do (
    netsh advfirewall firewall delete rule name="NetOptimizer_Block_%%X" >nul 2>&1
    echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Removed rule for: %%X
)
echo.
echo %C_GRN%   [✔] All NetOptimizer firewall rules removed.%C_RST%
echo.
pause
goto MENU

:FW_STATUS
echo.
echo %C_CYA%   Active NetOptimizer Firewall Rules:%C_RST%
echo %C_GRY%   ----------------------------------------------------------------------%C_RST%
netsh advfirewall firewall show rule name=all | findstr /i "NetOptimizer"
if errorlevel 1 echo %C_YEL%   [!] No NetOptimizer rules found.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [13] RAM & CACHE OPTIMIZER
:: ==========================================
:RAM_OPTIMIZER
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_MAG%[13] 🧹 RAM ^& CACHE OPTIMIZER                                           %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo %C_GRY%   [*] Reading current memory status...%C_RST%
set "RAM_BEFORE_MB="
for /f "delims=" %%M in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024)" 2^>nul') do set "RAM_BEFORE_MB=%%M"
if "%RAM_BEFORE_MB%"=="" set "RAM_BEFORE_MB=0"
echo %C_WHT%   [i] Free RAM before: %RAM_BEFORE_MB% MB%C_RST%
echo.
echo %C_CYA%   [*] Trimming working sets of high-memory processes...%C_RST%
powershell -NoProfile -Command "$ErrorActionPreference='SilentlyContinue'; Get-Process | Where-Object {$_.WorkingSet64 -gt 50MB} | ForEach-Object { try { $_.MinWorkingSet = [IntPtr]1 } catch {} }; [System.GC]::Collect()" >nul 2>&1
echo %C_CYA%   [*] Clearing DNS cache...%C_RST%
ipconfig /flushdns >nul 2>&1
echo %C_CYA%   [*] Clearing clipboard...%C_RST%
powershell -NoProfile -Command "Add-Type -AssemblyName PresentationCore; [System.Windows.Clipboard]::Clear()" >nul 2>&1
echo %C_CYA%   [*] Purging temp files...%C_RST%
del /s /f /q "%temp:"=%\*.tmp" >nul 2>&1
del /s /f /q "%temp:"=%\*.log" >nul 2>&1
echo.
set "RAM_AFTER_MB="
for /f "delims=" %%M in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024)" 2^>nul') do set "RAM_AFTER_MB=%%M"
if "%RAM_AFTER_MB%"=="" set "RAM_AFTER_MB=0"
echo %C_WHT%   [i] Free RAM after:  %RAM_AFTER_MB% MB%C_RST%
echo %C_GRN%   [✔] RAM optimization complete.%C_RST%
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
echo [%date% %time:~0,8%] [RAM] Before: %RAM_BEFORE_MB%MB After: %RAM_AFTER_MB%MB >> "%LOG_FILE%" 2>nul
echo.
pause
goto MENU

:: ==========================================
:: [14] ONEDRIVE COMPLETE KILLER
:: ==========================================
:ONEDRIVE_KILLER
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_BLU%[14] ☁️  ONEDRIVE COMPLETE KILLER                                       %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo   %C_CYA%[1]%C_RST% %C_RED%Kill ^& Block%C_RST% - Terminate, remove from startup, GPO block
echo   %C_CYA%[2]%C_RST% %C_GRN%Restore%C_RST%      - Re-enable OneDrive
echo   %C_GRY%[0] Back to Menu%C_RST%
echo.
set /p od_choice="   %C_YEL%>> Select [1-2/0]: %C_RST%"
if "%od_choice%"=="0" goto MENU
if "%od_choice%"=="1" goto OD_KILL
if "%od_choice%"=="2" goto OD_RESTORE
goto ONEDRIVE_KILLER

:OD_KILL
echo.
echo %C_GRY%[%time:~0,8%]%C_RST% %C_RED%[KILL]%C_RST% Terminating OneDrive processes...
taskkill /F /IM OneDrive.exe /T >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Removing from Startup (Registry)...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Applying GPO block...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableLibrariesDefaultSaveToOneDrive /t REG_DWORD /d 1 /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Disabling OneDrive scheduled tasks...
schtasks /Change /TN "\OneDrive Per-Machine Standalone Update Task" /Disable >nul 2>&1
schtasks /Change /TN "\OneDrive Reporting Task" /Disable >nul 2>&1
echo [%date% %time:~0,8%] [ONEDRIVE] Killed and blocked >> "%LOG_FILE%" 2>nul
echo.
echo %C_GRN%   [✔] OneDrive has been terminated and blocked from auto-start.%C_RST%
echo %C_YEL%   [i] Files in OneDrive folder are untouched.%C_RST%
echo.
pause
goto MENU

:OD_RESTORE
echo.
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[RESTORE]%C_RST% Re-enabling OneDrive...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableLibrariesDefaultSaveToOneDrive /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /t REG_SZ /d "\"%LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe\" /background" /f >nul 2>&1
echo %C_GRN%   [✔] OneDrive restored. Restart to take effect.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [15] TELEMETRY DEEP CLEAN
:: ==========================================
:TELEMETRY_DEEP
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_YEL%[15] 🕵️  TELEMETRY DEEP CLEAN                                          %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Setting Telemetry registry to minimum...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v MaxTelemetryAllowed /t REG_DWORD /d 0 /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Telemetry level set to 0 (Security).
echo.
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Disabling advertising ID and activity history...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Advertising ID disabled.
echo.
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Nullrouting Microsoft telemetry domains in HOSTS file...
set "HOSTS=%SystemRoot%\System32\drivers\etc\hosts"
set "TEL_DOMAINS=vortex.data.microsoft.com vortex-win.data.microsoft.com telecommand.telemetry.microsoft.com oca.telemetry.microsoft.com sqm.telemetry.microsoft.com watson.telemetry.microsoft.com redir.metaservices.microsoft.com choice.microsoft.com df.telemetry.microsoft.com reports.wes.df.telemetry.microsoft.com"
for %%D in (%TEL_DOMAINS%) do (
    findstr /i "%%D" "%HOSTS%" >nul 2>&1
    if errorlevel 1 (
        echo 0.0.0.0 %%D>>"%HOSTS%" 2>nul
        echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[HOSTS]%C_RST% Blocked: %%D
    ) else (
        echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRY%[SKIP]%C_RST%  Already blocked: %%D
    )
)
echo [%date% %time:~0,8%] [TELEMETRY] Deep clean applied >> "%LOG_FILE%" 2>nul
echo.
echo %C_GRN%   [✔] Telemetry Deep Clean complete.%C_RST%
echo %C_YEL%   [i] Restart required for all changes to take full effect.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [16] STARTUP PROGRAMS MANAGER
:: ==========================================
:STARTUP_MANAGER
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_CYA%[16] 🚀 STARTUP PROGRAMS MANAGER                                        %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo %C_WHT%   [ HKCU - Current User Startup ]%C_RST%
echo %C_GRY%   ----------------------------------------------------------------------%C_RST%
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul | findstr /v "HKEY"
echo.
echo %C_WHT%   [ HKLM - All Users Startup ]%C_RST%
echo %C_GRY%   ----------------------------------------------------------------------%C_RST%
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul | findstr /v "HKEY"
echo.
echo %C_WHT%   [ Startup Folder ]%C_RST%
echo %C_GRY%   ----------------------------------------------------------------------%C_RST%
dir /b "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\" 2>nul
echo.
echo %C_GRY%   ----- Actions -----%C_RST%
echo   %C_CYA%[1]%C_RST% Disable a startup entry (by name)
echo   %C_CYA%[2]%C_RST% Open Startup folder in Explorer
echo   %C_CYA%[3]%C_RST% Open Task Manager (Startup tab)
echo   %C_GRY%[0] Back to Menu%C_RST%
echo.
set /p su_choice="   %C_YEL%>> Select [1-3/0]: %C_RST%"
if "%su_choice%"=="0" goto MENU
if "%su_choice%"=="1" goto SU_DISABLE
if "%su_choice%"=="2" (start "" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" & goto STARTUP_MANAGER)
if "%su_choice%"=="3" (start taskmgr & goto STARTUP_MANAGER)
goto STARTUP_MANAGER

:SU_DISABLE
echo.
set /p su_name="   %C_YEL%>> Enter exact registry entry name to disable (or 0 to cancel): %C_RST%"
if "%su_name%"=="0" goto STARTUP_MANAGER
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%su_name%" /f >nul 2>&1
if errorlevel 1 (
    reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "%su_name%" /f >nul 2>&1
    if errorlevel 1 (
        echo %C_RED%   [!] Entry "%su_name%" not found in HKCU or HKLM.%C_RST%
    ) else (
        echo %C_GRN%   [✔] Disabled from HKLM Run: %su_name%%C_RST%
        echo [%date% %time:~0,8%] [STARTUP] Disabled HKLM: %su_name% >> "%LOG_FILE%"
    )
) else (
    echo %C_GRN%   [✔] Disabled from HKCU Run: %su_name%%C_RST%
    echo [%date% %time:~0,8%] [STARTUP] Disabled HKCU: %su_name% >> "%LOG_FILE%"
)
echo.
pause
goto STARTUP_MANAGER