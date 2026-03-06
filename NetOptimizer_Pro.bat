@echo off
setlocal EnableDelayedExpansion
:: Full Support for UTF-8
chcp 65001 >nul
title Ultimate Network Killer - By ALI SAKKAF

:: ==========================================
:: ANSI COLOR ENGINE (Dynamically Generated)
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
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

:MENU
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
echo %C_WHT%   ║%C_YEL%              ⚡ ULTIMATE NETWORK ^& UPDATE SERVICES KILLER ⚡             %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_GRN%                    Developed By: A L I  S A K K A F                     %C_WHT%║%C_RST%
echo %C_WHT%   ║%C_WHT%                    GitHub User: github.com/alisakkaf                     %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo %C_WHT%   [ SYSTEM NETWORK CONTROL ]%C_RST%
echo %C_GRY%   ----------------------------------------------------------------------%C_RST%
echo   %C_CYA%[1]%C_RST% %C_RED%🛑%C_RST% Disable ALL Network-Hungry Services %C_YEL%(Max Performance / No Leaks)%C_RST%
echo   %C_CYA%[2]%C_RST% %C_GRN%🟢%C_RST% Restore ALL Windows Services to Default State
echo   %C_CYA%[3]%C_RST% %C_BLU%🔄%C_RST% Enable Windows Update Engine ONLY
echo.
echo %C_WHT%   [ BROWSERS AUTO-UPDATE CONTROL ]%C_RST%
echo %C_GRY%   ----------------------------------------------------------------------%C_RST%
echo   %C_CYA%[4]%C_RST% %C_RED%❌%C_RST% Hard Kill ^& Block Chrome/Brave/Edge/Firefox Updates
echo   %C_CYA%[5]%C_RST% %C_GRN%✅%C_RST% Restore Browser Auto-Updates to Default
echo.
echo   %C_GRY%[6] 🚪 Exit Application%C_RST%
echo.
set /p choice="   %C_YEL%>> Select an execution protocol [1-6]: %C_RST%"

if "%choice%"=="1" goto DISABLE
if "%choice%"=="2" goto ENABLE
if "%choice%"=="3" goto ENABLE_WU
if "%choice%"=="4" goto DISABLE_BROWSERS
if "%choice%"=="5" goto ENABLE_BROWSERS
if "%choice%"=="6" exit
goto MENU

:: ==========================================
:: [1] DISABLE ALL SERVICES
:: ==========================================
:DISABLE
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_RED%[*] DEPLOYING MAXIMUM NETWORK PERFORMANCE PROTOCOL...                  %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Stopping Windows Update Core Engine...
net stop wuauserv /y >nul 2>&1
net stop bits /y >nul 2>&1
net stop dosvc /y >nul 2>&1
net stop UsoSvc /y >nul 2>&1
net stop WaaSMedicSvc /y >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Update Engine Halted.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Stopping Telemetry, Sync ^& App Store Data Services...
net stop DiagTrack /y >nul 2>&1
net stop dmwappushservice /y >nul 2>&1
net stop PcaSvc /y >nul 2>&1
net stop CDPSvc /y >nul 2>&1
net stop WpnService /y >nul 2>&1
net stop NcbService /y >nul 2>&1
net stop InstallService /y >nul 2>&1
net stop MapsBroker /y >nul 2>&1
net stop lfsvc /y >nul 2>&1
net stop OneSyncSvc /y >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Background Data Services Halted.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Permanently Disabling Services from Auto-Start...
for %%S in (wuauserv bits dosvc UsoSvc DiagTrack dmwappushservice PcaSvc CDPSvc WpnService NcbService InstallService MapsBroker lfsvc OneSyncSvc) do (
    sc config %%S start= disabled >nul 2>&1
)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Services Locked (Start=Disabled).
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Suspending Telemetry ^& Scheduled Maintenance Tasks...
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /Disable >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Scheduled Tasks Disabled.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Enforcing "Metered Connection" on Network Adapters...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v Ethernet /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi /t REG_DWORD /d 2 /f >nul 2>&1
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
for %%S in (wuauserv bits dosvc UsoSvc DiagTrack dmwappushservice PcaSvc CDPSvc WpnService NcbService InstallService MapsBroker lfsvc OneSyncSvc) do (
    sc config %%S start= demand >nul 2>&1
)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Services Restored (Start=Demand).
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Re-Enabling Scheduled Maintenance Tasks...
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Enable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /Enable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /Enable >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Tasks Restored.
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
:: [3] ENABLE WINDOWS UPDATE ONLY
:: ==========================================
:ENABLE_WU
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_BLU%[*] ACTIVATING WINDOWS UPDATE ENGINE (BITS ^& WUAUSERV)...             %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Re-configuring update services...
sc config bits start= demand >nul 2>&1
sc config wuauserv start= demand >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Starting services...
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Windows Update is Operational.
echo.
echo %C_GRN%   [✔] SUCCESS: YOU CAN NOW CHECK FOR UPDATES.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [4] DISABLE BROWSERS UPDATES
:: ==========================================
:DISABLE_BROWSERS
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_RED%[*] INITIATING HARD BROWSER UPDATER ELIMINATION PROTOCOL...            %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_RED%[KILL]%C_RST% Hunting ^& Terminating Active Updater Processes in RAM...
:: Core Updaters
for %%P in (GoogleUpdate.exe BraveUpdate.exe MicrosoftEdgeUpdate.exe maintenanceservice.exe opera_autoupdate.exe updater.exe) do ( taskkill /F /IM %%P /T >nul 2>&1 )
:: Brave Handlers
for %%P in (BraveUpdateOnDemand.exe BraveCrashHandler.exe BraveCrashHandler64.exe BraveCrashHandlerArm64.exe BraveUpdateBroker.exe BraveUpdateComRegisterShell64.exe BraveUpdateComRegisterShellArm64.exe BraveUpdateCore.exe) do ( taskkill /F /IM %%P /T >nul 2>&1 )
:: Chrome Remoting & Handlers
for %%P in (remoting_crashpad_handler.exe remoting_native_messaging_host.exe remote_assistance_host_uiaccess.exe remote_open_url.exe remote_assistance_host.exe remote_security_key.exe remoting_start_host.exe remote_webauthn.exe remoting_desktop.exe remoting_host.exe) do ( taskkill /F /IM %%P /T >nul 2>&1 )
:: Edge Helpers & Copilot
for %%P in (elevated_tracing_service.exe mscopilot.exe elevation_service.exe msedge_pwa_launcher.exe passkey_authenticator_plugin.exe notification_helper.exe notification_click_helper.exe msedge_proxy.exe identity_helper.exe pwahelper.exe ie_to_edge_stub.exe cookie_exporter.exe copilot_setup.exe) do ( taskkill /F /IM %%P /T >nul 2>&1 )

echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% All Ghost Processes Eliminated.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Disabling Chrome, Brave, Edge ^& Firefox Updater Services...
for %%B in (gupdate gupdatem braveupdate bravemupdate edgeupdate edgeupdatem MozillaMaintenance) do (
    net stop %%B /y >nul 2>&1
    sc config %%B start= disabled >nul 2>&1
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Browser Services Disabled.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Eradicating Browser Scheduled Update Tasks...
schtasks /Change /TN "\GoogleUpdateTaskMachineCore" /Disable >nul 2>&1
schtasks /Change /TN "\GoogleUpdateTaskMachineUA" /Disable >nul 2>&1
schtasks /Change /TN "\BraveUpdateTaskMachineCore" /Disable >nul 2>&1
schtasks /Change /TN "\BraveUpdateTaskMachineUA" /Disable >nul 2>&1
schtasks /Change /TN "\MicrosoftEdgeUpdateTaskMachineCore" /Disable >nul 2>&1
schtasks /Change /TN "\MicrosoftEdgeUpdateTaskMachineUA" /Disable >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Tasks Successfully Deactivated.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_YEL%[LOCK]%C_RST% Injecting Local Group Policies (GPO) to Block Internal Updates...
reg add "HKLM\SOFTWARE\Policies\Google\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Update" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableAppUpdate /t REG_DWORD /d 1 /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Security Policies Enforced.
echo.
echo %C_GRN%   [✔] OPERATION COMPLETE: BROWSERS WILL NO LONGER UPDATE IN BACKGROUND.%C_RST%
echo.
pause
goto MENU

:: ==========================================
:: [5] ENABLE BROWSERS UPDATES
:: ==========================================
:ENABLE_BROWSERS
cls
echo.
echo %C_WHT%   ╔════════════════════════════════════════════════════════════════════════╗%C_RST%
echo %C_WHT%   ║ %C_GRN%[*] RESTORING BROWSER AUTO-UPDATE FUNCTIONALITY...                     %C_WHT%║%C_RST%
echo %C_WHT%   ╚════════════════════════════════════════════════════════════════════════╝%C_RST%
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Re-Enabling Browser Updater Services...
for %%B in (gupdate gupdatem braveupdate bravemupdate edgeupdate edgeupdatem MozillaMaintenance) do (
    sc config %%B start= demand >nul 2>&1
)
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Services Restored.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_CYA%[INFO]%C_RST% Re-Enabling Browser Scheduled Tasks...
schtasks /Change /TN "\GoogleUpdateTaskMachineCore" /Enable >nul 2>&1
schtasks /Change /TN "\GoogleUpdateTaskMachineUA" /Enable >nul 2>&1
schtasks /Change /TN "\BraveUpdateTaskMachineCore" /Enable >nul 2>&1
schtasks /Change /TN "\BraveUpdateTaskMachineUA" /Enable >nul 2>&1
schtasks /Change /TN "\MicrosoftEdgeUpdateTaskMachineCore" /Enable >nul 2>&1
schtasks /Change /TN "\MicrosoftEdgeUpdateTaskMachineUA" /Enable >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Tasks Restored.
echo.

echo %C_GRY%[%time:~0,8%]%C_RST% %C_YEL%[UNLOCK]%C_RST% Removing Update Blocks from Local Group Policies (GPO)...
reg delete "HKLM\SOFTWARE\Policies\Google\Update" /v UpdateDefault /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\BraveSoftware\Update" /v UpdateDefault /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v UpdateDefault /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableAppUpdate /f >nul 2>&1
echo %C_GRY%[%time:~0,8%]%C_RST% %C_GRN%[DONE]%C_RST% Security Policies Removed.
echo.
echo %C_GRN%   [✔] OPERATION COMPLETE: BROWSERS CAN NOW UPDATE NORMALLY.%C_RST%
echo.
pause
goto MENU