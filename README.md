<div align="center">
  
# ⚡ NetOptimizer Pro & Lite
**The Ultimate Windows Network Debloater, Telemetry Purger & Bandwidth Optimizer**

![Platform](https://img.shields.io/badge/Platform-Windows_7%20%7C%208%20%7C%2010%20%7C%2011-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)
![Safety](https://img.shields.io/badge/Safety-100%25_Reversible-orange?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-v3.0-red?style=for-the-badge)

<br>

<a href="https://i.ibb.co/8gR169XK/1.png" target="_blank"><img src="https://i.ibb.co/8gR169XK/1.png" alt="NetOptimizer Pro Interface" border="0"></a>

</div>

---

## 🆕 What's New in Version 3.0 (Recent Updates)

* **🛡️ Path Hardening & Exclamation Mark Safety:** Disables global Delayed Expansion (`setlocal EnableDelayedExpansion`) in both Pro and Lite scripts. Scripts are now 100% stable when executed from paths with spaces, exclamation marks (`!`), or other special characters.
* **🔑 Bulletproof Privilege Elevation:** Modernized UAC admin checks to use PowerShell environment variables, preventing Windows Defender/antivirus heuristic flags on temporary scripts. Includes an async VBScript fallback and a pause on refusal.
* **🌐 Multi-Interface DNS Configuration:** Applies or restores DNS settings to all active/connected interfaces concurrently rather than only modifying the last detected interface.
* **🧹 Replacement of Deprecated WMIC:** Memory diagnostics in Option 13 (RAM Optimizer) now query modern PowerShell CIM instances (`Get-CimInstance Win32_OperatingSystem`), ensuring compatibility on Windows 11 24H2+.
* **☁️ Hardened Auto-Updater:** The update check executes directly in powershell memory to avoid disk write dependencies, and checks size (minimum 10KB check) and inspects contents for the `"NetOptimizer"` keyword.


---

## 📖 About The Project

**NetOptimizer** is an aggressively optimized, deeply integrated Batch script designed to give you **100% absolute control** over your Windows network bandwidth and system resources. 

Modern Windows operating systems and browsers notoriously consume massive amounts of background data for telemetry, silent updates, and background syncing. For users on metered connections, mobile hotspots, or those who simply demand peak ping performance for competitive gaming, this background data bleed is unacceptable. 

This tool deploys a proprietary **"ZeroLeak Protocol"**, hunting down aggressive background services, tracking agents, and hidden UI processes, cutting off their internet access instantly. It operates at both the Userland and System Service levels to ensure zero unauthorized bytes leave or enter your machine.

---

## 🛡️ Safety First: 100% Non-Destructive Approach

A major concern with traditional "Debloaters" is that they often delete core system files, leading to permanent OS corruption. **NetOptimizer is fundamentally different.**

> **IMPORTANT:** This script **DOES NOT DELETE** any system files, services, or registry keys. 
> It exclusively operates by **disabling** (suspending) services, terminating active RAM processes, altering startup types, and applying Local Group Policy (GPO) blocks. Everything done by this script is **100% reversible** with a single click inside the tool.

---

## ⚙️ Choose Your Edition: Pro vs. Lite

To ensure absolute compatibility across all environments, NetOptimizer is distributed in two distinct versions. Both share the exact same aggressive core engine but differ in UI rendering to prevent crashes on legacy systems:

| Feature / Edition | ⚡ **NetOptimizer Pro** | 🪶 **NetOptimizer Lite** |
| :--- | :--- | :--- |
| **Target OS** | Windows 10 (Latest Builds) & Windows 11 | Windows 7, 8, and Legacy Win 10 |
| **Core ZeroLeak Engine** | ✅ Included (Full Power) | ✅ Included (Full Power) |
| **Browser Control Engine**| ✅ Included | ✅ Included |
| **Smart Auto-Updater** | ✅ Included (Interactive UI) | ✅ Included (Silent UI) |
| **UI Design** | Dynamic ANSI Colors & Emojis | Standard ASCII (Pure Text) |
| **Encoding** | UTF-8 (`chcp 65001`) | Native CMD Encoding |
| **Best For** | Modern Desktop Environments | Legacy Systems, Enterprise Servers |

---

## ✨ Core Features & Technical Deep Dive

### 1. 🛑 Windows System Network Control (Max Performance)
When you trigger the Disable protocol **[Option 1]**, the script dives deep into the system to perform a multi-layered lockdown:

* **Extreme Telemetry & Analytics Purge:** Force-kills Microsoft's heaviest data collectors including `CompatTelRunner.exe` and `DeviceCensus.exe`. It also halts Windows Error Reporting (`WerSvc`) and the Diagnostics Hub to stop massive crash-dump uploads.
* **Background UI & Sync Termination:** Instantly kills memory-resident hogs like `msedgewebview2.exe` (hidden web widgets), `Widgets.exe` (Win 11 news feed), and `OneDrive.exe` background pinging.
* **Chrome Scanner Block:** Terminates Google Chrome's notorious `software_reporter_tool.exe` which silently scans local drives and consumes massive bandwidth.
* **Halts Core Update Engines:** Suspends `wuauserv`, `bits`, `UsoSvc`, and bypasses registry protections to lock `WaaSMedicSvc`.
* **Gaming & Superfetch Control:** Halts Xbox background syncing (`gamebarpresencewriter.exe`, `XblAuthManager`) and disables `SysMain` (Superfetch) to prevent predictive network/disk spikes during gaming.
* **Network Throttling:** Automatically edits the Registry to enforce `Metered Connection` on both WiFi and Ethernet interfaces.

### 2. 🟢 Smart System Restoration & Enablers
* **1-Click Total Restore [Option 2]:** Reverts all 20+ disabled services, tasks, and telemetry agents back to their native `Demand` or `Automatic` state.
* **Windows Update & Store Unlocker [Option 3]:** Need to update safely? This option activates the Windows Update engine (`wuauserv`, `bits`, `InstallService`) and the Microsoft Store services (`ClipSVC`, `AppXSVC`) without re-enabling any tracking agents.
* **Microsoft Phone Link [Option 4]:** Exclusively reactivates the essential services for Microsoft Phone Link (`PhoneSvc`, `NcbService`, `WpnService`, `BcastDVRUserService`, `BluetoothUserService`) and restores the required background app registry entries, allowing seamless phone message and photo sync without unlocking the rest of the system bloatware.

### 3. ❌ The Ultimate Browser Auto-Update Controller
Browsers (Chrome, Edge, Brave, Firefox) often ignore standard service disabling by utilizing hidden crash handlers and remoting tools. NetOptimizer uses a Dual-System approach:

* **⏸️ Temporary Pause [Option 5]:** Instantly frees up RAM by terminating 30+ hidden browser processes and stops updater services for the *current session only*. Everything returns to normal automatically upon a PC reboot. Perfect for immediate bandwidth relief.
* **❌ Permanent Block [Option 6]:** Hard-kills active processes, permanently disables update services, destroys Scheduled Tasks, and injects stringent Local Group Policy (GPO) rules **and IFEO (Image File Execution Options) Debugger Traps** to block browsers from even attempting to check for updates — making updates mathematically impossible to run.
* **✅ Restore Defaults [Option 7]:** Removes all GPO locks, IFEO traps, and restores browser updater services and scheduled tasks to normal.

### 4. 🤖 Self-Healing Auto-Updater Engine
NetOptimizer features a highly advanced, bulletproof Auto-Updater built directly into the Batch script. On launch, it safely pings a secure server to check for the latest versions. If an update is found, it uses native `curl` or `PowerShell` engines to download, replace, and restart itself within seconds—ensuring you always have the latest telemetry blocks without lifting a finger.

### 5. 📋 Real-Time Status Dashboard [Option 8]
A comprehensive, at-a-glance system status panel that instantly reads and displays the live state of all critical components — no need to open `services.msc`:
* **System & Telemetry:** Shows if Windows Update Engine, BITS, Telemetry (DiagTrack), and SysMain (Superfetch) are `ENABLED` or `DISABLED`.
* **Browsers Auto-Update:** Displays the current update status for Google Chrome, Microsoft Edge, Brave Browser, and Mozilla Firefox.
* **Network & DNS:** Shows the active DNS server, the Metered Connection enforcement state, the HOSTS file integrity status, and the Browser DNS Policy (DoH).

### 6. 🌐 DNS Optimization Center [Option 9]
A professional, fully-featured DNS management hub:
* **Live Ping Check:** Before displaying the menu, each of the 9 DNS servers is pinged and labeled `[ONLINE]` or `[OFFLINE]` in real-time.
* **9 Pre-configured DNS Providers:** Cloudflare (1.1.1.1), Google DNS (8.8.8.8), Quad9, AdGuard, ControlD, UncensoredDNS, Shecan, 403 DNS, and Electro DNS.
* **[C] Custom DNS:** Smart input with Ping Test validation — protects against empty input and applies instantly.
* **Browser DoH Enforcement:** Forces Chrome, Edge, and Brave to use the selected DNS via Registry Policies (DNS-over-HTTPS in `secure` mode).
* **[10] Restore Default DHCP:** Fully resets DNS to automatic DHCP and completely removes all browser Registry Policies, including the "Managed by administrator" state.

### 7. 📁 Logs Folder [Option 10]
Every operation performed by NetOptimizer (service disabling, DNS changes, process kills, firewall rules, speed tests, RAM stats) is logged with a precise timestamp to `%USERPROFILE%\NetOptimizer_Logs\NetOptimizer_Log.txt`. Option 10 opens this logs folder instantly in Windows Explorer.

### 8. 📶 Network Speed Test [Option 11]
A built-in speed testing tool powered by PowerShell:
* Downloads a 2 MB test file from `speed.cloudflare.com` and calculates the real download speed in **Mbps**.
* Also performs a **Ping test** to Cloudflare's 1.1.1.1 to display average latency in **ms**.
* Results are logged with a timestamp for tracking over time.

### 9. 🔥 Firewall Updater Blocker [Option 12]
A dedicated Windows Firewall management sub-menu that adds a network-level enforcement layer on top of service and GPO blocks:
* **Block:** Adds outbound firewall rules to prevent update executables (`wuauclt.exe`, `WaaSMedicAgent.exe`, `GoogleUpdate.exe`, `MicrosoftEdgeUpdate.exe`, `BraveUpdate.exe`, etc.) from establishing any outgoing connection.
* **Restore:** Removes all `NetOptimizer_Block_*` firewall rules cleanly.
* **Status:** Lists all currently active NetOptimizer firewall rules.

### 10. 🧹 RAM & Cache Optimizer [Option 13]
A multi-step memory reclamation tool:
* **RAM Trimming:** Uses PowerShell to trim the working sets of all processes consuming more than 50 MB of RAM, forcing Windows to release cached memory pages.
* **DNS Cache Flush:** Clears the DNS resolver cache (`ipconfig /flushdns`).
* **Clipboard Clear:** Wipes the system clipboard to free memory.
* **Temp File Purge:** Deletes all `.tmp` and `.log` files from the user's `%TEMP%` folder.
* Displays **Free RAM before and after** in MB so you can see exactly how much was recovered. Results are logged.

### 11. ☁️ OneDrive Complete Killer [Option 14]
A targeted OneDrive elimination sub-menu that does not touch your files:
* **Kill & Block:** Force-terminates `OneDrive.exe`, removes it from all startup Registry keys (`HKCU` and `HKLM`), injects GPO blocks to disable file sync (`DisableFileSyncNGSC`), and disables OneDrive's scheduled update and reporting tasks.
* **Restore:** Removes all GPO blocks and restores OneDrive's startup Registry entry so it runs again after a reboot.

### 12. 🕵️ Telemetry Deep Clean [Option 15]
A surgical, registry-level telemetry neutralization protocol that goes beyond service stopping:
* **Registry Lockdown:** Sets `AllowTelemetry` to `0` (Security level — minimum possible) across all Microsoft data collection policy paths.
* **Advertising & Activity Block:** Disables the Windows Advertising ID and completely shuts down Activity History and Timeline feed uploads (`EnableActivityFeed`, `PublishUserActivities`).
* **HOSTS File Nullrouting:** Appends `0.0.0.0` entries to the system HOSTS file for 10 known Microsoft telemetry domains (including `vortex.data.microsoft.com`, `watson.telemetry.microsoft.com`, etc.), effectively cutting off their network access at the OS level. Already-blocked domains are intelligently skipped.

### 13. 🚀 Startup Programs Manager [Option 16]
A comprehensive startup entry audit and management tool:
* **Full Audit View:** Lists all startup entries from three sources: `HKCU` Run registry (current user), `HKLM` Run registry (all users), and the Startup Folder.
* **Disable by Name:** Allows you to type the exact name of any registry startup entry to remove it permanently from `HKCU` or `HKLM` Run keys. Logs the action with a timestamp.
* **Quick Access:** Shortcut buttons to open the Startup Folder in Explorer or launch Task Manager directly to the Startup tab.

---

## 📸 Action Showcase

<div align="center">

<a href="https://i.ibb.co/C3GB2x53/2.png" target="_blank"><img src="https://i.ibb.co/C3GB2x53/2.png" alt="Disabling All Services" border="0"></a>
<br>
<a href="https://i.ibb.co/qf1pkp0/3.png" target="_blank"><img src="https://i.ibb.co/qf1pkp0/3.png" alt="DNS Optimization Center" border="0"></a>
<br>
<a href="https://i.ibb.co/k2v46r89/4.png" target="_blank"><img src="https://i.ibb.co/k2v46r89/4.png" alt="Status Dashboard" border="0"></a>
<br>
<a href="https://i.ibb.co/WvSZD6Cp/5.png" target="_blank"><img src="https://i.ibb.co/WvSZD6Cp/5.png" alt="Browser Update Control" border="0"></a>
<br>
<a href="https://i.ibb.co/WvDkDPFQ/6.png" target="_blank"><img src="https://i.ibb.co/WvDkDPFQ/6.png" alt="Advanced Tools Menu" border="0"></a>

</div>

---

## 🧠 RAM Optimizer in Action

<p align="center">
  <i>Witness the true power of the NetOptimizer RAM & Cache engine. Reclaim gigabytes of wasted memory in seconds!</i>
</p>

<div align="center">

| 🔴 **Before Optimization** | 🟢 **After Optimization** |
| :---: | :---: |
| <a href="https://i.ibb.co/fdj9qkD0/RAM-OPTIMIZER-Before.png" target="_blank"><img src="https://i.ibb.co/fdj9qkD0/RAM-OPTIMIZER-Before.png" alt="RAM-OPTIMIZER-Before" border="0"></a> | <a href="https://i.ibb.co/HfbVTWP6/RAM-OPTIMIZER-After.png" target="_blank"><img src="https://i.ibb.co/HfbVTWP6/RAM-OPTIMIZER-After.png" alt="RAM-OPTIMIZER-After" border="0"></a> |

| ⚡ **Interactive CLI** | 📖 **Smart Guide** |
| :---: | :---: |
| <a href="https://i.ibb.co/yFNZ37bm/RAM-OPTIMIZER.png" target="_blank"><img src="https://i.ibb.co/yFNZ37bm/RAM-OPTIMIZER.png" alt="RAM-OPTIMIZER" border="0"></a> | <a href="https://i.ibb.co/1JRhJ4CR/RAM-OPTIMIZER-GUIDE.jpg" target="_blank"><img src="https://i.ibb.co/1JRhJ4CR/RAM-OPTIMIZER-GUIDE.jpg" alt="RAM-OPTIMIZER-GUIDE" border="0"></a> |

</div>

---

## 🚀 How To Use

1. Go to the **[Releases](../../releases)** page and download either `NetOptimizer_Pro.bat` or `NetOptimizer_Lite.bat` depending on your OS.
2. Right-click the downloaded `.bat` file and select **"Run as Administrator"**. *(The script includes an automated UAC elevation check, but manual elevation is best practice).*
3. Let the Auto-Updater check for the latest core files (takes max 5 seconds).
4. The interactive menu will appear. Select your desired execution protocol by typing a number `[1-17]` and pressing Enter.
5. Watch the dynamic console log execute your commands. Wait for the green `[✔] OPERATION COMPLETE` message. 
6. Restart your PC to allow Registry (GPO) changes to propagate fully.

---

## ⚠️ Strict Disclaimer & Liability

**USE AT YOUR OWN RISK.**
This is an aggressive system administration script. By using this tool, you acknowledge and agree to the following:
* Disabling Windows Updates permanently prevents your system from receiving critical security patches, leaving you vulnerable to zero-day exploits. 
* It is **highly recommended** to periodically use the **[2] Restore** or **[3] Enable Windows Update ONLY** option to update your system securely, let it finish, and then deploy the Disable protocol again.
* The developer is **not responsible** for any system instability, security breaches, data loss, or OS corruption that may occur from the misuse of this tool.

---

### 💡 Support the Developer

<div align="center">
  <i>If you find my tools and projects useful, consider supporting my work. Your support helps keep these projects completely free!</i>
</div>

<br>

<div align="center">

| Crypto Asset | Network | Wallet Address (Copy) | Quick Scan |
| :--- | :--- | :--- | :---: |
| ![USDT](https://img.shields.io/badge/USDT-Tether-26A17B?style=for-the-badge&logo=tether&logoColor=white) | **TRC20** | `TYLBeDA5aGNcc3WkVqf3xWPHXmsZzs2p28` | <a href="https://api.qrserver.com/v1/create-qr-code/?size=300x300&margin=10&data=TYLBeDA5aGNcc3WkVqf3xWPHXmsZzs2p28" target="_blank"><img src="https://img.shields.io/badge/Show_QR-Click_Here-black?style=flat-square&logo=qr-code" alt="QR"></a> |
| ![USDT](https://img.shields.io/badge/USDT-Tether-26A17B?style=for-the-badge&logo=tether&logoColor=white) | **BEP20** | `0x67cf27f33c80479ea96372810f9e2ee4c3b095c5` | <a href="https://api.qrserver.com/v1/create-qr-code/?size=300x300&margin=10&data=0x67cf27f33c80479ea96372810f9e2ee4c3b095c5" target="_blank"><img src="https://img.shields.io/badge/Show_QR-Click_Here-black?style=flat-square&logo=qr-code" alt="QR"></a> |
| ![BTC](https://img.shields.io/badge/BTC-Bitcoin-F7931A?style=for-the-badge&logo=bitcoin&logoColor=white) | **Bitcoin** | `bc1q97dr37h37npzarmmrv0tjz2nm50htqc7pfpzj6` | <a href="https://api.qrserver.com/v1/create-qr-code/?size=300x300&margin=10&data=bitcoin:bc1q97dr37h37npzarmmrv0tjz2nm50htqc7pfpzj6" target="_blank"><img src="https://img.shields.io/badge/Show_QR-Click_Here-black?style=flat-square&logo=qr-code" alt="QR"></a> |
| ![ETH](https://img.shields.io/badge/ETH-Ethereum-3C3C3D?style=for-the-badge&logo=ethereum&logoColor=white) | **ERC20** | `0x67cf27f33c80479ea96372810F9e2EE4C3b095C5` | <a href="https://api.qrserver.com/v1/create-qr-code/?size=300x300&margin=10&data=ethereum:0x67cf27f33c80479ea96372810F9e2EE4C3b095C5" target="_blank"><img src="https://img.shields.io/badge/Show_QR-Click_Here-black?style=flat-square&logo=qr-code" alt="QR"></a> |
| ![SOL](https://img.shields.io/badge/SOL-Solana-9945FF?style=for-the-badge&logo=solana&logoColor=white) | **Solana** | `Cbesgr4tvo4T1inNMFe46GSym2qMYjkmofbXFc77rDNK` | <a href="https://api.qrserver.com/v1/create-qr-code/?size=300x300&margin=10&data=solana:Cbesgr4tvo4T1inNMFe46GSym2qMYjkmofbXFc77rDNK" target="_blank"><img src="https://img.shields.io/badge/Show_QR-Click_Here-black?style=flat-square&logo=qr-code" alt="QR"></a> |

</div>

---

<div align="center">
  
**Made By Ali Sakkaf** ❤️

</div>
