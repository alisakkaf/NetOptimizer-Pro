@echo off
setlocal EnableDelayedExpansion
title NetOptimizer Lite v2.5 - By ALI SAKKAF

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
:: AUTO-UPDATE ENGINE (LITE) 
:: ==========================================
set "CURRENT_VERSION=2.5"
set "SCRIPT_NAME=NetOptimizer_Lite.bat"
set "PASTEBIN_URL=https://pastebin.com/raw/uKR3Lvhg"

echo.
echo [*] Checking for updates... (Timeout in 5s)

:: Create a temporary PS1 file to completely isolate CMD from PowerShell brackets/dots
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

:: Fail-safe routing (No brackets used in IF statements to prevent ANY crashes)
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
cls
echo.
echo ==============================================================================
echo                      ULTIMATE NETWORK ^& UPDATE KILLER (LITE)
echo                      Developed By: ALI SAKKAF
echo                      GitHub: github.com/alisakkaf
echo ==============================================================================
echo.
echo [ SYSTEM NETWORK CONTROL ]
echo ------------------------------------------------------------------------------
echo    [1] Disable ALL Network-Hungry Services (Max Performance)
echo    [2] Restore ALL Windows Services to Default State
echo    [3] Enable Windows Update ^& Phone Link ONLY
echo    [4] Enable Microsoft Store Services ONLY
echo.
echo [ BROWSERS AUTO-UPDATE CONTROL ]
echo ------------------------------------------------------------------------------
echo    [5] Temporary Pause: Kill active updaters (Restores on reboot)
echo    [6] Permanent Block: Hard Kill ^& Disable Services/GPO
echo    [7] Restore Defaults: Enable all browser updates
echo.
echo    [8] Exit Application
echo.
set /p choice=" >> Select an option [1-8]: "

if "%choice%"=="1" goto DISABLE
if "%choice%"=="2" goto ENABLE
if "%choice%"=="3" goto ENABLE_WU
if "%choice%"=="4" goto ENABLE_STORE
if "%choice%"=="5" goto DISABLE_BROWSERS_TEMP
if "%choice%"=="6" goto DISABLE_BROWSERS_PERM
if "%choice%"=="7" goto ENABLE_BROWSERS
if "%choice%"=="8" exit
goto MENU

:: ==========================================
:: [1] DISABLE ALL SERVICES
:: ==========================================
:DISABLE
cls
echo.
echo ==============================================================================
echo [*] DEPLOYING MAXIMUM NETWORK PERFORMANCE PROTOCOL...
echo ==============================================================================
echo.

echo [KILL] Terminating Resource-Heavy Background UI ^& Telemetry Processes...
for %%P in (msedgewebview2.exe OneDrive.exe Widgets.exe CompatTelRunner.exe DeviceCensus.exe software_reporter_tool.exe gamebarpresencewriter.exe) do ( taskkill /F /IM %%P /T >nul 2>&1 )
echo [+] DONE.
echo.

echo [INFO] Stopping Windows Update Core Engine...
for %%S in (wuauserv bits dosvc UsoSvc WaaSMedicSvc) do ( net stop %%S /y >nul 2>&1 )
echo [+] DONE.
echo.

echo [INFO] Stopping Telemetry, Sync, Error Reporting ^& App Store Services...
for %%S in (DiagTrack dmwappushservice PcaSvc CDPSvc WpnService NcbService InstallService MapsBroker lfsvc OneSyncSvc AppXSVC ClipSVC SysMain GamingServices GamingServicesNet XblAuthManager WerSvc WSearch PhoneSvc PushToInstall diagnosticshub.standardcollector.service TrkWks) do ( net stop %%S /y >nul 2>&1 )
echo [+] DONE.
echo.

echo [INFO] Permanently Disabling Services from Auto-Start...
for %%S in (wuauserv bits dosvc UsoSvc DiagTrack dmwappushservice PcaSvc CDPSvc WpnService NcbService InstallService MapsBroker lfsvc OneSyncSvc AppXSVC ClipSVC SysMain GamingServices GamingServicesNet XblAuthManager WerSvc WSearch PhoneSvc PushToInstall diagnosticshub.standardcollector.service TrkWks) do (
    sc config %%S start= disabled >nul 2>&1
)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
echo [+] DONE.
echo.

echo [INFO] Suspending Telemetry ^& Scheduled Maintenance Tasks...
for %%T in ("Application Experience\ProgramDataUpdater" "Customer Experience Improvement Program\Consolidator" "Customer Experience Improvement Program\UsbCeip" "WindowsUpdate\Scheduled Start" "UpdateOrchestrator\Schedule Scan") do (
    schtasks /Change /TN "Microsoft\Windows\%%~T" /Disable >nul 2>&1
)
echo [+] DONE.
echo.

echo [INFO] Enforcing "Metered Connection" on Network Adapters...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v Ethernet /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi /t REG_DWORD /d 2 /f >nul 2>&1
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
for %%S in (wuauserv bits dosvc UsoSvc DiagTrack dmwappushservice PcaSvc CDPSvc WpnService NcbService InstallService MapsBroker lfsvc OneSyncSvc AppXSVC ClipSVC SysMain GamingServices GamingServicesNet XblAuthManager WerSvc WSearch PhoneSvc PushToInstall diagnosticshub.standardcollector.service TrkWks) do (
    sc config %%S start= demand >nul 2>&1
)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
echo [+] DONE.
echo.

echo [INFO] Re-Enabling Scheduled Maintenance Tasks...
for %%T in ("Application Experience\ProgramDataUpdater" "WindowsUpdate\Scheduled Start" "UpdateOrchestrator\Schedule Scan") do (
    schtasks /Change /TN "Microsoft\Windows\%%~T" /Enable >nul 2>&1
)
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
:: [3] ENABLE WINDOWS UPDATE ONLY
:: ==========================================
:ENABLE_WU
cls
echo.
echo ==============================================================================
echo [*] ACTIVATING WINDOWS UPDATE ^& PHONE LINK SERVICES...
echo ==============================================================================
echo.
echo [INFO] Re-configuring essential services...
sc config bits start= demand >nul 2>&1
sc config wuauserv start= demand >nul 2>&1
sc config PhoneSvc start= demand >nul 2>&1
echo [INFO] Starting services...
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
net start PhoneSvc >nul 2>&1
echo [+] DONE.
echo.
echo [ SUCCESS ] YOU CAN NOW CHECK FOR UPDATES AND USE PHONE LINK.
echo.
pause
goto MENU

:: ==========================================
:: [4] ENABLE MICROSOFT STORE ONLY
:: ==========================================
:ENABLE_STORE
cls
echo.
echo ==============================================================================
echo [*] ACTIVATING MICROSOFT STORE ^& APP INSTALLATION SERVICES...
echo ==============================================================================
echo.
echo [INFO] Re-configuring Store licensing and deployment services...
for %%S in (wuauserv bits InstallService ClipSVC AppXSVC PushToInstall) do (
    sc config %%S start= demand >nul 2>&1
)
echo [INFO] Starting Store services...
for %%S in (bits wuauserv InstallService ClipSVC AppXSVC) do (
    net start %%S >nul 2>&1
)
echo [+] DONE.
echo.
echo [ SUCCESS ] YOU CAN NOW DOWNLOAD AND INSTALL APPS FROM THE STORE.
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
for %%P in (GoogleUpdate.exe BraveUpdate.exe MicrosoftEdgeUpdate.exe maintenanceservice.exe opera_autoupdate.exe updater.exe BraveUpdateOnDemand.exe BraveCrashHandler.exe BraveCrashHandler64.exe BraveCrashHandlerArm64.exe BraveUpdateBroker.exe BraveUpdateComRegisterShell64.exe BraveUpdateComRegisterShellArm64.exe BraveUpdateCore.exe remoting_crashpad_handler.exe remoting_native_messaging_host.exe remote_assistance_host_uiaccess.exe remote_open_url.exe remote_assistance_host.exe remote_security_key.exe remoting_start_host.exe remote_webauthn.exe remoting_desktop.exe remoting_host.exe elevated_tracing_service.exe mscopilot.exe elevation_service.exe msedge_pwa_launcher.exe passkey_authenticator_plugin.exe notification_helper.exe notification_click_helper.exe msedge_proxy.exe identity_helper.exe pwahelper.exe ie_to_edge_stub.exe cookie_exporter.exe copilot_setup.exe) do ( taskkill /F /IM %%P /T >nul 2>&1 )
echo [+] DONE.
echo.

echo [INFO] Stopping Browser Updater Services (Without disabling them)...
for %%B in (gupdate gupdatem braveupdate bravemupdate edgeupdate edgeupdatem MozillaMaintenance) do (
    net stop %%B /y >nul 2>&1
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
echo [*] INITIATING PERMANENT BROWSER UPDATER ELIMINATION PROTOCOL...
echo ==============================================================================
echo.

echo [KILL] Hunting ^& Terminating Active Updater Processes in RAM...
for %%P in (GoogleUpdate.exe BraveUpdate.exe MicrosoftEdgeUpdate.exe maintenanceservice.exe opera_autoupdate.exe updater.exe BraveUpdateOnDemand.exe BraveCrashHandler.exe BraveCrashHandler64.exe BraveCrashHandlerArm64.exe BraveUpdateBroker.exe BraveUpdateComRegisterShell64.exe BraveUpdateComRegisterShellArm64.exe BraveUpdateCore.exe remoting_crashpad_handler.exe remoting_native_messaging_host.exe remote_assistance_host_uiaccess.exe remote_open_url.exe remote_assistance_host.exe remote_security_key.exe remoting_start_host.exe remote_webauthn.exe remoting_desktop.exe remoting_host.exe elevated_tracing_service.exe mscopilot.exe elevation_service.exe msedge_pwa_launcher.exe passkey_authenticator_plugin.exe notification_helper.exe notification_click_helper.exe msedge_proxy.exe identity_helper.exe pwahelper.exe ie_to_edge_stub.exe cookie_exporter.exe copilot_setup.exe) do ( taskkill /F /IM %%P /T >nul 2>&1 )
echo [+] DONE.
echo.

echo [INFO] Disabling Chrome, Brave, Edge ^& Firefox Updater Services...
for %%B in (gupdate gupdatem braveupdate bravemupdate edgeupdate edgeupdatem MozillaMaintenance) do (
    net stop %%B /y >nul 2>&1
    sc config %%B start= disabled >nul 2>&1
)
echo [+] DONE.
echo.

echo [INFO] Eradicating Browser Scheduled Update Tasks...
for %%T in ("\GoogleUpdateTaskMachineCore" "\GoogleUpdateTaskMachineUA" "\BraveUpdateTaskMachineCore" "\BraveUpdateTaskMachineUA" "\MicrosoftEdgeUpdateTaskMachineCore" "\MicrosoftEdgeUpdateTaskMachineUA") do (
    schtasks /Change /TN "%%~T" /Disable >nul 2>&1
)
echo [+] DONE.
echo.

echo [LOCK] Injecting Local Group Policies (GPO) to Block Internal Updates...
reg add "HKLM\SOFTWARE\Policies\Google\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableAppUpdate /t REG_DWORD /d 1 /f >nul 2>&1
echo [+] DONE.
echo.
echo [ SUCCESS ] BROWSERS WILL NO LONGER UPDATE IN BACKGROUND.
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
for %%B in (gupdate gupdatem braveupdate bravemupdate edgeupdate edgeupdatem MozillaMaintenance) do (
    sc config %%B start= demand >nul 2>&1
)
echo [+] DONE.
echo.

echo [INFO] Re-Enabling Browser Scheduled Tasks...
for %%T in ("\GoogleUpdateTaskMachineCore" "\GoogleUpdateTaskMachineUA" "\BraveUpdateTaskMachineCore" "\BraveUpdateTaskMachineUA" "\MicrosoftEdgeUpdateTaskMachineCore" "\MicrosoftEdgeUpdateTaskMachineUA") do (
    schtasks /Change /TN "%%~T" /Enable >nul 2>&1
)
echo [+] DONE.
echo.

echo [UNLOCK] Removing Update Blocks from Local Group Policies (GPO)...
reg delete "HKLM\SOFTWARE\Policies\Google\Update" /v UpdateDefault /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\BraveSoftware\Update" /v UpdateDefault /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v UpdateDefault /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableAppUpdate /f >nul 2>&1
echo [+] DONE.
echo.
echo [ SUCCESS ] BROWSERS CAN NOW UPDATE NORMALLY.
echo.
pause
goto MENU