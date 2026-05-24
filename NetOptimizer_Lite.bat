@echo off
setlocal EnableDelayedExpansion
title NetOptimizer Lite v2.9 - By ALI SAKKAF

:: ==========================================
:: ADMINISTRATOR PRIVILEGES CHECK
:: ==========================================
net session >nul 2>&1
if %errorlevel% EQU 0 goto ADMIN_OK

echo.
echo [!] ERROR: This script requires Administrator privileges.
echo [*] Requesting elevation... please wait.
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /b

:ADMIN_OK
:: ==========================================
:: INITIALIZE VARIABLES & LOGGING
:: ==========================================
set "SVC_UPDATE_CORE=wuauserv bits dosvc UsoSvc"
set "SVC_UPDATE_EXTRA=WaaSMedicSvc"
set "SVC_TELEMETRY=DiagTrack dmwappushservice PcaSvc CDPSvc WpnService NcbService InstallService MapsBroker lfsvc OneSyncSvc AppXSVC ClipSVC SysMain GamingServices GamingServicesNet XblAuthManager WerSvc WSearch PhoneSvc PushToInstall diagnosticshub.standardcollector.service TrkWks BcastDVRUserService BluetoothUserService RemoteRegistry wisvc Fax SensorService SensorDataService Sensors embeddedmode DsSvc rmsvc tzautoupdate"
set "SVC_BROWSERS=gupdate gupdatem braveupdate bravemupdate edgeupdate edgeupdatem MozillaMaintenance"
set "PROC_TELEMETRY=msedgewebview2.exe OneDrive.exe Widgets.exe CompatTelRunner.exe DeviceCensus.exe software_reporter_tool.exe gamebarpresencewriter.exe PhoneExperienceHost.exe mscopilot.exe copilot_setup.exe Teams.exe cortana.exe SearchApp.exe"
set "PROC_BROWSERS=GoogleUpdate.exe BraveUpdate.exe MicrosoftEdgeUpdate.exe maintenanceservice.exe opera_autoupdate.exe updater.exe BraveUpdateOnDemand.exe BraveCrashHandler.exe BraveCrashHandler64.exe BraveCrashHandlerArm64.exe BraveUpdateBroker.exe BraveUpdateComRegisterShell64.exe BraveUpdateComRegisterShellArm64.exe BraveUpdateCore.exe remoting_crashpad_handler.exe remoting_native_messaging_host.exe remote_assistance_host_uiaccess.exe remote_open_url.exe remote_assistance_host.exe remote_security_key.exe remoting_start_host.exe remote_webauthn.exe remoting_desktop.exe remoting_host.exe elevated_tracing_service.exe mscopilot.exe elevation_service.exe msedge_pwa_launcher.exe passkey_authenticator_plugin.exe notification_helper.exe notification_click_helper.exe msedge_proxy.exe identity_helper.exe pwahelper.exe ie_to_edge_stub.exe cookie_exporter.exe copilot_setup.exe"

set "LOG_DIR=%~dp0NetOptimizer_Logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
set "LOG_FILE=%LOG_DIR%\NetOptimizer_Log.txt"

:: ==========================================
:: AUTO-UPDATE ENGINE (LITE) 
:: ==========================================
set "CURRENT_VERSION=2.9"
set "SCRIPT_NAME=NetOptimizer_Lite.bat"
set "PASTEBIN_URL=https://pastebin.com/raw/uKR3Lvhg"

echo.
echo [*] Checking for updates... (Timeout in 5s)

set "PS_CHECK=%temp%\check_update.ps1"
echo $ErrorActionPreference='SilentlyContinue'; > "!PS_CHECK!"
echo [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; >> "!PS_CHECK!"
echo $req=[System.Net.WebRequest]::Create('%PASTEBIN_URL%'); >> "!PS_CHECK!"
echo $req.Timeout=5000; >> "!PS_CHECK!"
echo $res=$req.GetResponse(); >> "!PS_CHECK!"
echo $sr=New-Object System.IO.StreamReader($res.GetResponseStream()); >> "!PS_CHECK!"
echo $sr.ReadToEnd().Trim(); >> "!PS_CHECK!"

set "LATEST_VERSION="
for /f "delims=" %%V in ('powershell -NoProfile -ExecutionPolicy Bypass -File "!PS_CHECK!" 2^>nul') do set "LATEST_VERSION=%%V"
del "!PS_CHECK!" >nul 2>&1

if "!LATEST_VERSION!"=="" goto UPDATE_FAILED
if "!LATEST_VERSION!"=="!CURRENT_VERSION!" goto UPDATE_LATEST
goto UPDATE_FOUND

:UPDATE_FAILED
echo [!] Server unreachable or check timed out. Proceeding to menu...
timeout /t 2 >nul
goto MENU

:UPDATE_LATEST
echo [SUCCESS] Your version is up to date (v!CURRENT_VERSION!).
timeout /t 2 >nul
goto MENU

:UPDATE_FOUND
echo [+] New Update Found: v!LATEST_VERSION! [Current: v!CURRENT_VERSION!]
echo [*] Downloading... (Timeout in 10s)
echo.

set "DOWNLOAD_URL=https://github.com/alisakkaf/NetOptimizer-Pro/releases/download/v!LATEST_VERSION!/!SCRIPT_NAME!"

if exist "%SystemRoot%\System32\curl.exe" goto DL_CURL
goto DL_PS

:DL_CURL
curl.exe -# -m 10 -L -o "!SCRIPT_NAME!.tmp" "!DOWNLOAD_URL!" 2>nul
goto DL_VERIFY

:DL_PS
set "PS_DL=%temp%\dl_update.ps1"
echo $ErrorActionPreference='SilentlyContinue'; > "!PS_DL!"
echo [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; >> "!PS_DL!"
echo (New-Object Net.WebClient).DownloadFile('!DOWNLOAD_URL!', '!SCRIPT_NAME!.tmp'); >> "!PS_DL!"
powershell -NoProfile -ExecutionPolicy Bypass -File "!PS_DL!" 2>nul
del "!PS_DL!" >nul 2>&1
goto DL_VERIFY

:DL_VERIFY
if exist "!SCRIPT_NAME!.tmp" goto DL_SUCCESS
echo [!] Download failed or timed out. Returning to menu...
timeout /t 2 >nul
goto MENU

:DL_SUCCESS
echo [SUCCESS] Update Downloaded! Restarting script in 5 seconds...
timeout /t 5 >nul

echo @echo off> "updater.bat"
echo timeout /t 1 ^>nul>> "updater.bat"
echo move /y "!SCRIPT_NAME!.tmp" "%~nx0" ^>nul>> "updater.bat"
echo start "" "%~nx0">> "updater.bat"
echo del "%%~f0">> "updater.bat"

start "" /min "updater.bat"
exit /b

:: ==========================================
:: MAIN INTERFACE
:: ==========================================


:MENU
if not exist "!LOG_DIR!" mkdir "!LOG_DIR!" >nul 2>&1
cls
echo.
echo ==============================================================================
echo                      ULTIMATE NETWORK ^& UPDATE KILLER (LITE) v2.9
echo                      Developed By: ALI SAKKAF
echo                      GitHub: github.com/alisakkaf
echo ==============================================================================
echo.
echo [ SYSTEM NETWORK CONTROL ]
echo ------------------------------------------------------------------------------
echo    [1]  Disable ALL Network-Hungry Services (Max Performance)
echo    [2]  Restore ALL Windows Services to Default State
echo    [3]  Enable Windows Update ^& Store Services ONLY
echo    [4]  Enable Microsoft Phone Link Services ONLY
echo.
echo [ BROWSERS AUTO-UPDATE CONTROL ]
echo ------------------------------------------------------------------------------
echo    [5]  Temporary Pause: Kill active updaters (Restores on reboot)
echo    [6]  Permanent Block: Hard Kill, Disable Services, GPO ^& IFEO Locks
echo    [7]  Restore Defaults: Enable all browser updates
echo.
echo [ MONITORING ^& TOOLS ]
echo ------------------------------------------------------------------------------
echo    [8]  Status Dashboard (View current system state)
echo    [9]  DNS Optimization Profile (Apply fast DNS)
echo    [10] Open Logs Folder
echo.
echo [ ADVANCED TOOLS - NEW ]
echo ------------------------------------------------------------------------------
echo    [11] Network Speed Test
echo    [12] Firewall Updater Blocker (Block/Restore update traffic)
echo    [13] RAM ^& Cache Optimizer
echo    [14] OneDrive Complete Killer
echo    [15] Telemetry Deep Clean
echo    [16] Startup Programs Manager
echo.
echo    [17] Exit Application
echo.
set /p choice=" >> Select an option [1-17]: "

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
echo ==============================================================================
echo [!] WARNING: This will disable all background services ^& telemetry.
echo ==============================================================================
echo.
set "confirm="
set /p confirm=" >> Confirm? [Press ENTER, Y, or YES to proceed, any other key to cancel]: "
if not defined confirm set "confirm=YES"
set "is_yes=0"
if /i "!confirm!"=="YES" set "is_yes=1"
if /i "!confirm!"=="Y" set "is_yes=1"
if "!is_yes!"=="0" (
    echo [*] Cancelled. Returning to menu...
    timeout /t 2 >nul
    goto MENU
)
cls
echo.
echo ==============================================================================
echo [*] DEPLOYING MAXIMUM NETWORK PERFORMANCE PROTOCOL...
echo ==============================================================================
echo.

echo [INFO] Creating Secure System Restore Point...
powershell -NoProfile -Command "$ErrorActionPreference='SilentlyContinue'; Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'NetOptimizer Restore Point - By Ali Sakkaf' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
echo [+] DONE.
echo.

echo [KILL] Terminating Resource-Heavy Background UI ^& Telemetry Processes...
for %%P in (%PROC_TELEMETRY%) do (
    start "" /b taskkill /F /IM %%P /T >nul 2>&1
    echo [%date% %time:~0,8%] [KILL] Process: %%P -^> TERMINATED >> "%LOG_FILE%" 2>nul
)
echo [+] DONE.
echo.

echo [INFO] Stopping Windows Update Core Engine...
for %%S in (%SVC_UPDATE_CORE% %SVC_UPDATE_EXTRA%) do (
    start "" /b sc stop %%S >nul 2>&1
    echo [%date% %time:~0,8%] [STOP] Service: %%S -^> STOPPED >> "%LOG_FILE%" 2>nul
)
echo [+] DONE.
echo.

echo [INFO] Stopping Telemetry, Sync, Error Reporting ^& App Store Services...
for %%S in (%SVC_TELEMETRY%) do (
    start "" /b sc stop %%S >nul 2>&1
    echo [%date% %time:~0,8%] [STOP] Service: %%S -^> STOPPED >> "%LOG_FILE%" 2>nul
)
echo [+] DONE.
echo.

echo [INFO] Permanently Disabling Services from Auto-Start...
for %%S in (%SVC_UPDATE_CORE% %SVC_TELEMETRY%) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    echo [%date% %time:~0,8%] [DISABLE] Service: %%S -^> DISABLED >> "%LOG_FILE%" 2>nul
)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\%SVC_UPDATE_EXTRA%" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
echo [%date% %time:~0,8%] [DISABLE] Service: %SVC_UPDATE_EXTRA% -^> DISABLED >> "%LOG_FILE%" 2>nul
echo [+] DONE.
echo.

echo [INFO] Suspending Telemetry ^& Scheduled Maintenance Tasks...
for %%T in ("Application Experience\ProgramDataUpdater" "Customer Experience Improvement Program\Consolidator" "Customer Experience Improvement Program\UsbCeip" "WindowsUpdate\Scheduled Start" "UpdateOrchestrator\Schedule Scan") do (
    schtasks /Change /TN "Microsoft\Windows\%%~T" /Disable >nul 2>&1
    echo [%date% %time:~0,8%] [TASK] Task: %%~T -^> DISABLED >> "%LOG_FILE%" 2>nul
)
echo [+] DONE.
echo.

echo [INFO] Disabling Bing Search Background Network Queries...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d 0 /f >nul 2>&1
echo [+] DONE.
echo.

echo [INFO] Enforcing "Metered Connection" on Network Adapters...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v Ethernet /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi /t REG_DWORD /d 2 /f >nul 2>&1
echo [%date% %time:~0,8%] [REGISTRY] Metered Connection -^> ENFORCED >> "%LOG_FILE%" 2>nul
echo [+] DONE.
echo.

echo [INFO] Resetting Network Stack ^& Clearing DNS Cache...
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
echo [+] DONE.
echo.
echo [ SUCCESS ] OPERATION COMPLETE: WINDOWS NETWORK CONSUMPTION IS NOW AT 0%%.
echo.
pause
goto MENU

:: ==========================================
:: [2] ENABLE ALL SERVICES
:: ==========================================
:ENABLE
cls
echo.
echo ==============================================================================
echo [*] RESTORING SYSTEM SERVICES TO DEFAULT CONFIGURATION...
echo ==============================================================================
echo.

echo [INFO] Restoring Service Startup Types...
for %%S in (%SVC_UPDATE_CORE% %SVC_TELEMETRY%) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
    echo [%date% %time:~0,8%] [ENABLE] Service: %%S -^> DEMAND >> "%LOG_FILE%"
)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\%SVC_UPDATE_EXTRA%" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
echo [%date% %time:~0,8%] [ENABLE] Service: %SVC_UPDATE_EXTRA% -^> DEMAND >> "%LOG_FILE%"
echo [+] DONE.
echo.

echo [INFO] Re-Enabling Scheduled Maintenance Tasks...
for %%T in ("Application Experience\ProgramDataUpdater" "WindowsUpdate\Scheduled Start" "UpdateOrchestrator\Schedule Scan") do (
    schtasks /Change /TN "Microsoft\Windows\%%~T" /Enable >nul 2>&1
)
echo [+] DONE.
echo.

echo [INFO] Re-enabling Bing Search Start Menu Queries...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /f >nul 2>&1
echo [+] DONE.
echo.

echo [INFO] Removing "Metered Connection" Restrictions...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v Ethernet /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi /t REG_DWORD /d 1 /f >nul 2>&1
echo [+] DONE.
echo.
echo [ SUCCESS ] OPERATION COMPLETE: WINDOWS IS BACK TO NORMAL.
echo.
pause
goto MENU

:: ==========================================
:: [3] ENABLE WINDOWS UPDATE & STORE ONLY
:: ==========================================
:ENABLE_WU_STORE
cls
echo.
echo ==============================================================================
echo [*] ACTIVATING WINDOWS UPDATE ^& MICROSOFT STORE SERVICES...
echo ==============================================================================
echo.
echo [INFO] Re-configuring essential services...
for %%S in (wuauserv bits InstallService ClipSVC AppXSVC PushToInstall) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
)
echo [INFO] Starting services...
for %%S in (bits wuauserv InstallService ClipSVC AppXSVC) do (
    net start %%S >nul 2>&1
)
echo [+] DONE.
echo.
echo [ SUCCESS ] YOU CAN NOW CHECK FOR UPDATES AND USE THE STORE.
echo.
pause
goto MENU

:: ==========================================
:: [4] ENABLE MICROSOFT PHONE LINK ONLY
:: ==========================================
:ENABLE_PHONE_LINK
cls
echo.
echo ==============================================================================
echo [*] ACTIVATING MICROSOFT PHONE LINK SERVICES...
echo ==============================================================================
echo.
echo [INFO] Re-configuring Phone Link, Network Broker, and Push Notifications...
for %%S in (PhoneSvc BcastDVRUserService BluetoothUserService NcbService WpnService) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
)
:: Enabling background app execution for Phone Link via Registry
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.YourPhone_8wekyb3d8bbwe" /v Disabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.YourPhone_8wekyb3d8bbwe" /v DisabledByUser /t REG_DWORD /d 0 /f >nul 2>&1

echo [INFO] Starting services...
for %%S in (NcbService WpnService PhoneSvc BcastDVRUserService BluetoothUserService) do (
    net start %%S >nul 2>&1
)
echo [+] DONE.
echo.
echo [ SUCCESS ] YOU CAN NOW CONNECT AND SYNC YOUR PHONE.
echo.
pause
goto MENU

:: ==========================================
:: [5] TEMPORARY PAUSE BROWSERS UPDATES
:: ==========================================
:DISABLE_BROWSERS_TEMP
cls
echo.
echo ==============================================================================
echo [*] INITIATING TEMPORARY BROWSER UPDATER SUSPENSION...
echo ==============================================================================
echo.

echo [KILL] Terminating Active Updater Processes in RAM...
for %%P in (%PROC_BROWSERS%) do (
    taskkill /F /IM %%P /T >nul 2>&1
    echo [%date% %time:~0,8%] [KILL] Browser Updater: %%P -^> TERMINATED >> "%LOG_FILE%"
)
echo [+] DONE.
echo.

echo [INFO] Stopping Browser Updater Services (Without disabling them)...
for %%B in (%SVC_BROWSERS%) do (
    start "" /b sc stop %%B >nul 2>&1
    echo [%date% %time:~0,8%] [STOP] Browser Service: %%B -^> STOPPED >> "%LOG_FILE%"
)
echo [+] DONE.
echo.
echo [ NOTE ] Updaters are stopped for this session but will return on PC restart.
echo [ SUCCESS ] BROWSERS TEMPORARILY PAUSED.
echo.
pause
goto MENU

:: ==========================================
:: [6] PERMANENT DISABLE BROWSERS UPDATES
:: ==========================================
:DISABLE_BROWSERS_PERM
cls
echo.
echo ==============================================================================
echo [!] WARNING: This will permanently block ALL browser auto-updates!
echo ==============================================================================
echo.
set "confirm2="
set /p confirm2=" >> Confirm? [Press ENTER, Y, or YES to proceed, any other key to cancel]: "
if not defined confirm2 set "confirm2=YES"
set "is_yes2=0"
if /i "!confirm2!"=="YES" set "is_yes2=1"
if /i "!confirm2!"=="Y" set "is_yes2=1"
if "!is_yes2!"=="0" (
    echo [*] Cancelled. Returning to menu...
    timeout /t 2 >nul
    goto MENU
)
cls
echo.
echo ==============================================================================
echo [*] INITIATING BULLETPROOF BROWSER ELIMINATION PROTOCOL...
echo ==============================================================================
echo.

echo [KILL] Hunting ^& Terminating Active Updater Processes in RAM...
for %%P in (%PROC_BROWSERS%) do (
    taskkill /F /IM %%P /T >nul 2>&1
    echo [%date% %time:~0,8%] [KILL] Browser Updater: %%P -^> TERMINATED >> "%LOG_FILE%"
)
echo [+] DONE.
echo.

echo [INFO] Disabling Chrome, Brave, Edge ^& Firefox Updater Services...
for %%B in (%SVC_BROWSERS%) do (
    start "" /b sc stop %%B >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%B" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    echo [%date% %time:~0,8%] [DISABLE] Browser Service: %%B -^> DISABLED >> "%LOG_FILE%"
)
echo [+] DONE.
echo.

echo [INFO] Eradicating Browser Scheduled Update Tasks...
for %%T in ("\GoogleUpdateTaskMachineCore" "\GoogleUpdateTaskMachineUA" "\BraveUpdateTaskMachineCore" "\BraveUpdateTaskMachineUA" "\MicrosoftEdgeUpdateTaskMachineCore" "\MicrosoftEdgeUpdateTaskMachineUA") do (
    schtasks /Change /TN "%%~T" /Disable >nul 2>&1
)
echo [+] DONE.
echo.

echo [LOCK] Injecting Core GPO ^& IFEO Debugger Locks (The Nuclear Fix)...
:: Standard 64-bit/32-bit paths
reg add "HKLM\SOFTWARE\Policies\Google\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableAppUpdate /t REG_DWORD /d 1 /f >nul 2>&1
:: WOW6432Node paths
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Google\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\BraveSoftware\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\EdgeUpdate" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Mozilla\Firefox" /v DisableAppUpdate /t REG_DWORD /d 1 /f >nul 2>&1

:: IFEO Debugger Traps - Neutralizes updater executables
for %%X in (GoogleUpdate.exe MicrosoftEdgeUpdate.exe BraveUpdate.exe updater.exe maintenanceservice.exe) do (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%X" /v Debugger /t REG_SZ /d "systray.exe" /f >nul 2>&1
)

echo [+] DONE.
echo.
echo [ SUCCESS ] BROWSERS ARE NOW 100%% INCAPABLE OF UPDATING.
echo.
pause
goto MENU

:: ==========================================
:: [7] ENABLE BROWSERS UPDATES
:: ==========================================
:ENABLE_BROWSERS
cls
echo.
echo ==============================================================================
echo [*] RESTORING BROWSER AUTO-UPDATE FUNCTIONALITY (TEMP ^& PERM)...
echo ==============================================================================
echo.

echo [INFO] Re-Enabling Browser Updater Services...
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
echo [+] DONE.
echo.

echo [INFO] Re-Enabling Browser Scheduled Tasks...
for %%T in ("\GoogleUpdateTaskMachineCore" "\GoogleUpdateTaskMachineUA" "\BraveUpdateTaskMachineCore" "\BraveUpdateTaskMachineUA" "\MicrosoftEdgeUpdateTaskMachineCore" "\MicrosoftEdgeUpdateTaskMachineUA") do (
    schtasks /Change /TN "%%~T" /Enable >nul 2>&1
)
echo [+] DONE.
echo.

echo [UNLOCK] Erasing GPO Locks and IFEO Debugger Traps...
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

echo [+] DONE.
echo.
echo [ SUCCESS ] BROWSERS CAN NOW UPDATE NORMALLY.
echo.
pause
goto MENU
:: ==========================================
:: ==========================================
:: ==========================================
:: ==========================================
:: ==========================================
:: ==========================================
:: [8] STATUS DASHBOARD
:: ==========================================
:STATUS_DASHBOARD
cls
set "T=%temp%\nopt.tmp"
echo.
echo   +========================================================================+
echo   ^| SYSTEM STATUS DASHBOARD                                                ^|
echo   +========================================================================+

:: Check Windows Update Engine
sc query wuauserv >nul 2>&1
if %errorlevel% NEQ 0 (set "ST_WU=[ NOT FOUND ]") else (
    sc qc wuauserv 2>nul | findstr /i "DISABLED" >nul 2>&1
    if not errorlevel 1 (set "ST_WU=[  BLOCKED  ]") else (set "ST_WU=[  ACTIVE   ]")
)

:: Check Background Transfer (BITS)
sc query BITS >nul 2>&1
if %errorlevel% NEQ 0 (set "ST_BITS=[ NOT FOUND ]") else (
    sc qc BITS 2>nul | findstr /i "DISABLED" >nul 2>&1
    if not errorlevel 1 (set "ST_BITS=[  BLOCKED  ]") else (set "ST_BITS=[  ACTIVE   ]")
)

:: Check Windows Telemetry
sc query DiagTrack >nul 2>&1
if %errorlevel% NEQ 0 (set "ST_TEL=[ NOT FOUND ]") else (
    sc qc DiagTrack 2>nul | findstr /i "DISABLED" >nul 2>&1
    if not errorlevel 1 (set "ST_TEL=[  BLOCKED  ]") else (set "ST_TEL=[  ACTIVE   ]")
)

:: Check SysMain (Superfetch)
sc query SysMain >nul 2>&1
if %errorlevel% NEQ 0 (set "ST_SYS=[ NOT FOUND ]") else (
    sc qc SysMain 2>nul | findstr /i "DISABLED" >nul 2>&1
    if not errorlevel 1 (set "ST_SYS=[  BLOCKED  ]") else (set "ST_SYS=[  ACTIVE   ]")
)

:: Check Chrome Update
set "IS_CHR=0"
if exist "!ProgramFiles!\Google\Chrome\Application\chrome.exe" set "IS_CHR=1"
if exist "!ProgramFiles(x86)!\Google\Chrome\Application\chrome.exe" set "IS_CHR=1"
if exist "!LocalAppData!\Google\Chrome\Application\chrome.exe" set "IS_CHR=1"

set "ST_CHR="
if "!IS_CHR!"=="0" (
    set "ST_CHR=[UNINSTALLED]"
) else (
    set "CHK_CHR=0"
    reg query "HKLM\SOFTWARE\Policies\Google\Update" /v UpdateDefault 2>nul | findstr "0x0" >nul 2>&1
    if not errorlevel 1 set "CHK_CHR=1"
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GoogleUpdate.exe" /v Debugger 2>nul >nul 2>&1
    if not errorlevel 1 set "CHK_CHR=1"
    sc query gupdate >nul 2>&1
    if !errorlevel! EQU 0 (
        sc qc gupdate 2>nul | findstr /i "DISABLED" >nul 2>&1
        if not errorlevel 1 set "CHK_CHR=1"
    )
    if "!CHK_CHR!"=="1" (set "ST_CHR=[  BLOCKED  ]") else (set "ST_CHR=[  ACTIVE   ]")
)

:: Check Edge Update
set "IS_EDG=0"
if exist "!ProgramFiles!\Microsoft\Edge\Application\msedge.exe" set "IS_EDG=1"
if exist "!ProgramFiles(x86)!\Microsoft\Edge\Application\msedge.exe" set "IS_EDG=1"

set "ST_EDG="
if "!IS_EDG!"=="0" (
    set "ST_EDG=[UNINSTALLED]"
) else (
    set "CHK_EDG=0"
    reg query "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v UpdateDefault 2>nul | findstr "0x0" >nul 2>&1
    if not errorlevel 1 set "CHK_EDG=1"
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MicrosoftEdgeUpdate.exe" /v Debugger 2>nul >nul 2>&1
    if not errorlevel 1 set "CHK_EDG=1"
    sc query edgeupdate >nul 2>&1
    if !errorlevel! EQU 0 (
        sc qc edgeupdate 2>nul | findstr /i "DISABLED" >nul 2>&1
        if not errorlevel 1 set "CHK_EDG=1"
    )
    if "!CHK_EDG!"=="1" (set "ST_EDG=[  BLOCKED  ]") else (set "ST_EDG=[  ACTIVE   ]")
)

:: Check Brave Update
set "IS_BRV=0"
if exist "!ProgramFiles!\BraveSoftware\Brave-Browser\Application\brave.exe" set "IS_BRV=1"
if exist "!ProgramFiles(x86)!\BraveSoftware\Brave-Browser\Application\brave.exe" set "IS_BRV=1"
if exist "!LocalAppData!\BraveSoftware\Brave-Browser\Application\brave.exe" set "IS_BRV=1"

set "ST_BRV="
if "!IS_BRV!"=="0" (
    set "ST_BRV=[UNINSTALLED]"
) else (
    set "CHK_BRV=0"
    reg query "HKLM\SOFTWARE\Policies\BraveSoftware\Update" /v UpdateDefault 2>nul | findstr "0x0" >nul 2>&1
    if not errorlevel 1 set "CHK_BRV=1"
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\BraveUpdate.exe" /v Debugger 2>nul >nul 2>&1
    if not errorlevel 1 set "CHK_BRV=1"
    sc query braveupdate >nul 2>&1
    if !errorlevel! EQU 0 (
        sc qc braveupdate 2>nul | findstr /i "DISABLED" >nul 2>&1
        if not errorlevel 1 set "CHK_BRV=1"
    )
    if "!CHK_BRV!"=="1" (set "ST_BRV=[  BLOCKED  ]") else (set "ST_BRV=[  ACTIVE   ]")
)

:: Check Firefox Update
set "IS_FF=0"
if exist "!ProgramFiles!\Mozilla Firefox\firefox.exe" set "IS_FF=1"
if exist "!ProgramFiles(x86)!\Mozilla Firefox\firefox.exe" set "IS_FF=1"

set "ST_FF="
if "!IS_FF!"=="0" (
    set "ST_FF=[UNINSTALLED]"
) else (
    set "CHK_FF=0"
    reg query "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableAppUpdate 2>nul | findstr "0x1" >nul 2>&1
    if not errorlevel 1 set "CHK_FF=1"
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\maintenanceservice.exe" /v Debugger 2>nul >nul 2>&1
    if not errorlevel 1 set "CHK_FF=1"
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\updater.exe" /v Debugger 2>nul >nul 2>&1
    if not errorlevel 1 set "CHK_FF=1"
    sc query MozillaMaintenance >nul 2>&1
    if !errorlevel! EQU 0 (
        sc qc MozillaMaintenance 2>nul | findstr /i "DISABLED" >nul 2>&1
        if not errorlevel 1 set "CHK_FF=1"
    )
    if "!CHK_FF!"=="1" (set "ST_FF=[  BLOCKED  ]") else (set "ST_FF=[  ACTIVE   ]")
)

:: Check Metered WiFi Connection
set "ST_MET=[  NORMAL   ]"
set "T_MET="
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi 2^>nul ^| find /i "WiFi"') do set "T_MET=%%a"
if "!T_MET!"=="0x2" set "ST_MET=[ ENFORCED  ]"

:: Check Hosts File
set "ST_HOSTS=[   CLEAN   ]"
findstr /i "microsoft.com" "%SystemRoot%\System32\drivers\etc\hosts" >nul 2>&1
if not errorlevel 1 set "ST_HOSTS=[ MODIFIED  ]"

:: Check Active DNS Server
set "CURRENT_DNS=Default DHCP "
set "NET_INT="
for /f "tokens=1,2,3*" %%A in ('netsh interface show interface ^| find "Connected" 2^>nul') do set "NET_INT=%%D"
if not "!NET_INT!"=="" (
    for /f "tokens=*" %%A in ('netsh interface ipv4 show dns name^="!NET_INT!" 2^>nul ^| findstr /R "[0-9][0-9]*\.[0-9]"') do (
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
set "ST_DNS=[!CURRENT_DNS!]"

:: Check Browser DNS Policy
set "ST_DOH=[  NOT SET  ]"
reg query "HKLM\SOFTWARE\Policies\Google\Chrome" /v DnsOverHttpsMode >nul 2>&1
if not errorlevel 1 set "ST_DOH=[  SECURE   ]"
del "!T!" >nul 2>&1

echo   ^| [ SYSTEM ^& TELEMETRY SERVICES ]                                      ^|
echo   ^| Windows Update Engine        : !ST_WU!                          ^|
echo   ^| Background Transfer (BITS)   : !ST_BITS!                          ^|
echo   ^| Windows Telemetry Service    : !ST_TEL!                          ^|
echo   ^| SysMain (Superfetch) Service : !ST_SYS!                          ^|
echo   +------------------------------------------------------------------------+
echo   ^| [ BROWSER AUTO-UPDATE POLICIES ]                                      ^|
echo   ^| Google Chrome Update Service : !ST_CHR!                          ^|
echo   ^| Microsoft Edge Update Service: !ST_EDG!                          ^|
echo   ^| Brave Browser Update Service : !ST_BRV!                          ^|
echo   ^| Mozilla Firefox Maintenance  : !ST_FF!                          ^|
echo   +------------------------------------------------------------------------+
echo   ^| [ NETWORK COST ^& SECURITY CONFIGS ]                                    ^|
echo   ^| Metered Network Adapter Cost : !ST_MET!                          ^|
echo   ^| Hosts File Integrity         : !ST_HOSTS!                          ^|
echo   ^| Active DNS Resolver          : !ST_DNS!                          ^|
echo   ^| Browser DNS Security (DoH)   : !ST_DOH!                          ^|
echo   +========================================================================+
echo.
pause
goto MENU


:: [9] DNS OPTIMIZATION CENTER
:: ==========================================
:DNS_OPTIMIZATION
cls
if "!LOG_DIR!"=="" set "LOG_DIR=%USERPROFILE%\NetOptimizer_Logs"
if not exist "!LOG_DIR!" mkdir "!LOG_DIR!" >nul 2>&1
if "!LOG_FILE!"=="" set "LOG_FILE=!LOG_DIR!\NetOptimizer_Log.txt"
echo    [*] Checking DNS availability, please wait...
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
echo    +------------------------------------------------------------------------+
echo    ^|       DNS OPTIMIZATION CENTER  -  SELECT A DNS SERVER                   ^|
echo    +------------------------------------------------------------------------+
echo.
echo   [1]  1.1.1.1  / 1.0.0.1          Cloudflare            [!S1!]
echo   [2]  8.8.8.8  / 8.8.4.4          Google DNS            [!S2!]
echo   [3]  9.9.9.9  / 149.112.112.112  Quad9                 [!S3!]
echo   [4]  94.140.14.14 / 94.140.15.15 AdGuard               [!S4!]
echo   [5]  76.76.2.0 / 76.76.10.0      ControlD              [!S5!]
echo   [6]  91.239.100.100 / 89.233.43.71  UncensoredDNS      [!S6!]
echo   [7]  178.22.122.100 / 185.51.200.2  Shecan              [!S7!]
echo   [8]  10.202.10.202 / 10.202.10.102  403 DNS            [!S8!]
echo   [9]  78.157.42.100 / 78.157.42.101  Electro DNS        [!S9!]
echo.
echo   [C]  Custom DNS (enter your own values)
echo   [10] Restore Default DHCP (removes all overrides)
echo   [0] Back to Menu
echo.
set /p dns_choice="   >> Select [1-10 / C / 0]: "
if /i "!dns_choice!"=="0" goto MENU
if /i "!dns_choice!"=="c" goto DNS_CUSTOM
if "!dns_choice!"=="10" goto DNS_RESTORE

for /f "tokens=1,2,3*" %%A in ('netsh interface show interface ^| find "Connected" 2^>nul') do set "NET_INT=%%D"
if "!NET_INT!"=="" (
    echo    [!] No active network interface found.
    pause
    goto MENU
)

set "IP1=" & set "IP2=" & set "DOH=" & set "D_NAME="
if "!dns_choice!"=="1" set "IP1=1.1.1.1"          & set "IP2=1.0.0.1"          & set "DOH=https://chrome.cloudflare-dns.com/dns-query{?dns}" & set "D_NAME=Cloudflare"
if "!dns_choice!"=="2" set "IP1=8.8.8.8"          & set "IP2=8.8.4.4"          & set "DOH=https://dns.google/dns-query{?dns}"                 & set "D_NAME=Google DNS"
if "!dns_choice!"=="3" set "IP1=9.9.9.9"          & set "IP2=149.112.112.112"  & set "DOH=https://dns.quad9.net/dns-query{?dns}"              & set "D_NAME=Quad9"
if "!dns_choice!"=="4" set "IP1=94.140.14.14"     & set "IP2=94.140.15.15"     & set "DOH=https://dns.adguard-dns.com/dns-query{?dns}"        & set "D_NAME=AdGuard"
if "!dns_choice!"=="5" set "IP1=76.76.2.0"        & set "IP2=76.76.10.0"       & set "DOH=https://freedns.controld.com/p0{?dns}"              & set "D_NAME=ControlD"
if "!dns_choice!"=="6" set "IP1=91.239.100.100"   & set "IP2=89.233.43.71"     & set "DOH=https://anycast.uncensoredns.org/dns-query{?dns}"   & set "D_NAME=UncensoredDNS"
if "!dns_choice!"=="7" set "IP1=178.22.122.100"   & set "IP2=185.51.200.2"     & set "DOH=off"                                                & set "D_NAME=Shecan DNS"
if "!dns_choice!"=="8" set "IP1=10.202.10.202"    & set "IP2=10.202.10.102"    & set "DOH=off"                                                & set "D_NAME=403 DNS"
if "!dns_choice!"=="9" set "IP1=78.157.42.100"    & set "IP2=78.157.42.101"    & set "DOH=off"                                                & set "D_NAME=Electro DNS"
if "!D_NAME!"=="" goto MENU

if "!DOH!"=="off" (
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome"       /v DnsOverHttpsMode /t REG_SZ   /d "off" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v DnsOverHttpsMode /t REG_SZ   /d "off" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v DnsOverHttpsMode /t REG_SZ   /d "off" /f >nul 2>&1
) else (
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome"       /v DnsOverHttpsMode      /t REG_SZ    /d "secure"   /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome"       /v DnsOverHttpsTemplates /t REG_SZ    /d "!DOH!"    /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v BuiltInDnsClientEnabled /t REG_DWORD /d 1        /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v DnsOverHttpsMode      /t REG_SZ    /d "secure"   /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v DnsOverHttpsTemplates /t REG_SZ    /d "!DOH!"    /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v DnsOverHttpsMode      /t REG_SZ    /d "secure"   /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v DnsOverHttpsTemplates /t REG_SZ    /d "!DOH!"    /f >nul 2>&1
)
netsh interface ipv4 set dns name="!NET_INT!" static !IP1! primary >nul 2>&1
netsh interface ipv4 add dns name="!NET_INT!" !IP2! index=2 >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo [%date% %time:~0,8%] [DNS] Applied !D_NAME! >> "!LOG_FILE!" 2>nul
echo    [+] DNS set to !D_NAME! ^(!IP1!^).
echo    [+] Browser policy applied. Restart browser to take effect.
echo    [+] DNS Cache Flushed.
echo.
pause
goto MENU

:DNS_RESTORE
echo    [*] Restoring DHCP and removing all overrides...
for /f "tokens=1,2,3*" %%A in ('netsh interface show interface ^| find "Connected" 2^>nul') do set "NET_INT=%%D"
if "!NET_INT!" NEQ "" (
    netsh interface ipv4 set dns name="!NET_INT!" dhcp >nul 2>&1
    netsh interface ipv6 set dns name="!NET_INT!" dhcp >nul 2>&1
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
echo [%date% %time:~0,8%] [DNS] Restored DHCP - all policies cleared >> "!LOG_FILE!" 2>nul
echo    [+] DNS restored to Automatic.
echo    [+] All browser DNS policies removed.
echo    [+] Browsers are no longer managed by administrator.
echo.
pause
goto MENU

:DNS_CUSTOM
cls
echo.
echo    +--------------------------------+
echo    ^|    CUSTOM DNS CONFIGURATION    ^|
echo    +--------------------------------+
echo.
echo   Enter your DNS server IPs. Example: 8.8.8.8
echo.
set "CUST_IP1=" & set "CUST_IP2="
set /p CUST_IP1="   >> Primary DNS  : "
if "!CUST_IP1!"=="" (
    echo    [!] Primary DNS cannot be empty.
    pause
    goto MENU
)
set /p CUST_IP2="   >> Secondary DNS: "
if "!CUST_IP2!"=="" set "CUST_IP2=!CUST_IP1!"
echo    [*] Testing !CUST_IP1!...
ping -n 1 -w 1500 !CUST_IP1! >nul 2>&1
if errorlevel 1 (
    echo    [!] No ping response from !CUST_IP1!. Applying anyway...
    timeout /t 2 /nobreak >nul 2>&1
)
for /f "tokens=1,2,3*" %%A in ('netsh interface show interface ^| find "Connected" 2^>nul') do set "NET_INT=%%D"
if "!NET_INT!"=="" (
    echo    [!] No active network interface found.
    pause
    goto MENU
)
reg add "HKLM\SOFTWARE\Policies\Google\Chrome"       /v DnsOverHttpsMode /t REG_SZ /d "off" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge"      /v DnsOverHttpsMode /t REG_SZ /d "off" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v DnsOverHttpsMode /t REG_SZ /d "off" /f >nul 2>&1
netsh interface ipv4 set dns name="!NET_INT!" static !CUST_IP1! primary >nul 2>&1
netsh interface ipv4 add dns name="!NET_INT!" !CUST_IP2! index=2 >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo [%date% %time:~0,8%] [DNS] Custom DNS !CUST_IP1! / !CUST_IP2! >> "!LOG_FILE!" 2>nul
echo    [+] Custom DNS applied: !CUST_IP1! / !CUST_IP2!
echo    [+] DNS Cache Flushed.
echo.
pause
goto MENU

:: ==========================================
:: [10] OPEN LOGS FOLDER
:: ==========================================
:OPEN_LOGS
cls
echo.
echo ==============================================================================
echo [*] OPENING LOGS FOLDER...
echo ==============================================================================
echo.
if "!LOG_DIR!"=="" set "LOG_DIR=%USERPROFILE%\NetOptimizer_Logs"
if not exist "!LOG_DIR!" mkdir "!LOG_DIR!" >nul 2>&1
start "" "!LOG_DIR!"
echo [+] Logs folder opened.
echo.
pause
goto MENU

:: ==========================================
:: [11] NETWORK SPEED TEST
:: ==========================================
:NET_SPEED_TEST
cls
echo.
echo ==============================================================================
echo [11] NETWORK SPEED TEST
echo ==============================================================================
echo.
echo [*] Downloading 2MB test file from Cloudflare...
echo     (Using speed.cloudflare.com)
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
) > "!PS_SPD!"
for /f "delims=" %%R in ('powershell -NoProfile -ExecutionPolicy Bypass -File "!PS_SPD!" 2^>nul') do set "SPEED_RESULT=%%R"
del "!PS_SPD!" >nul 2>&1
if "!SPEED_RESULT!"=="FAILED" (
    echo [!] Speed test failed. Check your internet connection.
) else if "!SPEED_RESULT!"=="" (
    echo [!] Could not retrieve results. Check internet connection.
) else (
    echo [+] Download Speed: !SPEED_RESULT!
    echo [%date% %time:~0,8%] [SPEEDTEST] Result: !SPEED_RESULT! >> "%LOG_FILE%" 2>nul
)
echo.
echo [*] Checking ping to 1.1.1.1...
for /f "tokens=7 delims=ms " %%P in ('ping -n 3 1.1.1.1 ^| findstr "Average"') do (
    echo [+] Avg Ping: %%P ms
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
echo ==============================================================================
echo [12] FIREWALL UPDATER BLOCKER
echo ==============================================================================
echo.
echo    [1] Block   - Add outbound firewall rules to block update traffic
echo    [2] Restore - Remove all NetOptimizer firewall rules
echo    [3] Status  - Show active NetOptimizer firewall rules
echo    [0] Back to Menu
echo.
set /p fw_choice=" >> Select [1-3/0]: "
if "!fw_choice!"=="0" goto MENU
if "!fw_choice!"=="1" goto FW_BLOCK
if "!fw_choice!"=="2" goto FW_RESTORE
if "!fw_choice!"=="3" goto FW_STATUS
goto FIREWALL_MANAGER

:FW_BLOCK
echo.
echo [FIREWALL] Adding outbound block rules for update executables...
for %%X in (wuauclt.exe WaaSMedicAgent.exe GoogleUpdate.exe MicrosoftEdgeUpdate.exe BraveUpdate.exe maintenanceservice.exe usoclient.exe) do (
    netsh advfirewall firewall add rule name="NetOptimizer_Block_%%X" dir=out action=block program="%%X" enable=yes description="NetOptimizer auto-rule" >nul 2>&1
    echo [+] Blocked: %%X
    echo [%date% %time:~0,8%] [FIREWALL] Blocked: %%X >> "%LOG_FILE%" 2>nul
)
echo.
echo [SUCCESS] Firewall rules applied. Update traffic is now blocked.
echo.
pause
goto MENU

:FW_RESTORE
echo.
echo [FIREWALL] Removing all NetOptimizer firewall rules...
for %%X in (wuauclt.exe WaaSMedicAgent.exe GoogleUpdate.exe MicrosoftEdgeUpdate.exe BraveUpdate.exe maintenanceservice.exe usoclient.exe) do (
    netsh advfirewall firewall delete rule name="NetOptimizer_Block_%%X" >nul 2>&1
    echo [+] Removed rule for: %%X
)
echo.
echo [SUCCESS] All NetOptimizer firewall rules removed.
echo.
pause
goto MENU

:FW_STATUS
echo.
echo [INFO] Active NetOptimizer Firewall Rules:
echo ------------------------------------------------------------------------------
netsh advfirewall firewall show rule name=all | findstr /i "NetOptimizer"
if errorlevel 1 echo [!] No NetOptimizer rules found.
echo.
pause
goto MENU

:: ==========================================
:: [13] RAM & CACHE OPTIMIZER
:: ==========================================
:RAM_OPTIMIZER
cls
echo.
echo ==============================================================================
echo [13] RAM ^& CACHE OPTIMIZER
echo ==============================================================================
echo.
echo [*] Reading current memory status...
set "RAM_BEFORE="
for /f "skip=1 tokens=1" %%M in ('wmic OS get FreePhysicalMemory 2^>nul') do if "!RAM_BEFORE!"=="" set "RAM_BEFORE=%%M"
if "!RAM_BEFORE!"=="" set "RAM_BEFORE=0"
set /a RAM_BEFORE_MB=!RAM_BEFORE!/1024
echo [i] Free RAM before: !RAM_BEFORE_MB! MB
echo.
echo [*] Trimming working sets of high-memory processes...
powershell -NoProfile -Command "$ErrorActionPreference='SilentlyContinue'; Get-Process | Where-Object {$_.WorkingSet64 -gt 50MB} | ForEach-Object { try { $_.MinWorkingSet = [IntPtr]1 } catch {} }; [System.GC]::Collect()" >nul 2>&1
echo [*] Clearing DNS cache...
ipconfig /flushdns >nul 2>&1
echo [*] Clearing clipboard...
powershell -NoProfile -Command "Add-Type -AssemblyName PresentationCore; [System.Windows.Clipboard]::Clear()" >nul 2>&1
echo [*] Purging temp files...
del /s /f /q "%temp:"=%\*.tmp" >nul 2>&1
del /s /f /q "%temp:"=%\*.log" >nul 2>&1
echo.
set "RAM_AFTER="
for /f "skip=1 tokens=1" %%M in ('wmic OS get FreePhysicalMemory 2^>nul') do if "!RAM_AFTER!"=="" set "RAM_AFTER=%%M"
if "!RAM_AFTER!"=="" set "RAM_AFTER=0"
set /a RAM_AFTER_MB=!RAM_AFTER!/1024
echo [i] Free RAM after:  !RAM_AFTER_MB! MB
echo [SUCCESS] RAM optimization complete.
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
echo [%date% %time:~0,8%] [RAM] Before: !RAM_BEFORE_MB!MB After: !RAM_AFTER_MB!MB >> "%LOG_FILE%" 2>nul
echo.
pause
goto MENU

:: ==========================================
:: [14] ONEDRIVE COMPLETE KILLER
:: ==========================================
:ONEDRIVE_KILLER
cls
echo.
echo ==============================================================================
echo [14] ONEDRIVE COMPLETE KILLER
echo ==============================================================================
echo.
echo    [1] Kill ^& Block - Terminate, remove from startup, GPO block
echo    [2] Restore      - Re-enable OneDrive
echo    [0] Back to Menu
echo.
set /p od_choice=" >> Select [1-2/0]: "
if "!od_choice!"=="0" goto MENU
if "!od_choice!"=="1" goto OD_KILL
if "!od_choice!"=="2" goto OD_RESTORE
goto ONEDRIVE_KILLER

:OD_KILL
echo.
echo [KILL] Terminating OneDrive processes...
taskkill /F /IM OneDrive.exe /T >nul 2>&1
echo [INFO] Removing from Startup (Registry)...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
echo [INFO] Applying GPO block...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableLibrariesDefaultSaveToOneDrive /t REG_DWORD /d 1 /f >nul 2>&1
echo [INFO] Disabling OneDrive scheduled tasks...
schtasks /Change /TN "\OneDrive Per-Machine Standalone Update Task" /Disable >nul 2>&1
schtasks /Change /TN "\OneDrive Reporting Task" /Disable >nul 2>&1
echo [%date% %time:~0,8%] [ONEDRIVE] Killed and blocked >> "%LOG_FILE%" 2>nul
echo.
echo [SUCCESS] OneDrive terminated and blocked from auto-start.
echo [NOTE] Files in OneDrive folder are untouched.
echo.
pause
goto MENU

:OD_RESTORE
echo.
echo [RESTORE] Re-enabling OneDrive...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableLibrariesDefaultSaveToOneDrive /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /t REG_SZ /d "\"%LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe\" /background" /f >nul 2>&1
echo [SUCCESS] OneDrive restored. Restart to take effect.
echo.
pause
goto MENU

:: ==========================================
:: [15] TELEMETRY DEEP CLEAN
:: ==========================================
:TELEMETRY_DEEP
cls
echo.
echo ==============================================================================
echo [15] TELEMETRY DEEP CLEAN
echo ==============================================================================
echo.
echo [INFO] Setting Telemetry registry to minimum...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v MaxTelemetryAllowed /t REG_DWORD /d 0 /f >nul 2>&1
echo [+] Telemetry level set to 0 (Security).
echo.
echo [INFO] Disabling advertising ID and activity history...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
echo [+] Advertising ID disabled.
echo.
echo [INFO] Nullrouting Microsoft telemetry domains in HOSTS file...
set "HOSTS=%SystemRoot%\System32\drivers\etc\hosts"
set "TEL_DOMAINS=vortex.data.microsoft.com vortex-win.data.microsoft.com telecommand.telemetry.microsoft.com oca.telemetry.microsoft.com sqm.telemetry.microsoft.com watson.telemetry.microsoft.com redir.metaservices.microsoft.com choice.microsoft.com df.telemetry.microsoft.com reports.wes.df.telemetry.microsoft.com"
for %%D in (!TEL_DOMAINS!) do (
    findstr /i "%%D" "!HOSTS!" >nul 2>&1
    if errorlevel 1 (
        echo 0.0.0.0 %%D >> "!HOSTS!" 2>nul
        echo [HOSTS] Blocked: %%D
    ) else (
        echo [SKIP]  Already blocked: %%D
    )
)
echo [%date% %time:~0,8%] [TELEMETRY] Deep clean applied >> "%LOG_FILE%" 2>nul
echo.
echo [SUCCESS] Telemetry Deep Clean complete.
echo [NOTE] Restart required for all changes to take full effect.
echo.
pause
goto MENU

:: ==========================================
:: [16] STARTUP PROGRAMS MANAGER
:: ==========================================
:STARTUP_MANAGER
cls
echo.
echo ==============================================================================
echo [16] STARTUP PROGRAMS MANAGER
echo ==============================================================================
echo.
echo [ HKCU - Current User Startup ]
echo ------------------------------------------------------------------------------
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul | findstr /v "HKEY"
echo.
echo [ HKLM - All Users Startup ]
echo ------------------------------------------------------------------------------
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul | findstr /v "HKEY"
echo.
echo [ Startup Folder ]
echo ------------------------------------------------------------------------------
dir /b "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\" 2>nul
echo.
echo    [1] Disable a startup entry (by name)
echo    [2] Open Startup folder in Explorer
echo    [3] Open Task Manager
echo    [0] Back to Menu
echo.
set /p su_choice=" >> Select [1-3/0]: "
if "!su_choice!"=="0" goto MENU
if "!su_choice!"=="1" goto SU_DISABLE
if "!su_choice!"=="2" (start "" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" & goto STARTUP_MANAGER)
if "!su_choice!"=="3" (start taskmgr & goto STARTUP_MANAGER)
goto STARTUP_MANAGER

:SU_DISABLE
echo.
set /p su_name=" >> Enter exact registry entry name (or 0 to cancel): "
if "!su_name!"=="0" goto STARTUP_MANAGER
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "!su_name!" /f >nul 2>&1
if errorlevel 1 (
    reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "!su_name!" /f >nul 2>&1
    if errorlevel 1 (
        echo [!] Entry "!su_name!" not found in HKCU or HKLM.
    ) else (
        echo [+] Disabled from HKLM Run: !su_name!
        echo [%date% %time:~0,8%] [STARTUP] Disabled HKLM: !su_name! >> "%LOG_FILE%"
    )
) else (
    echo [+] Disabled from HKCU Run: !su_name!
    echo [%date% %time:~0,8%] [STARTUP] Disabled HKCU: !su_name! >> "%LOG_FILE%"
)
echo.
pause
goto STARTUP_MANAGER