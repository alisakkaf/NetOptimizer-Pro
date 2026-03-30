<div align="center">
  
# ⚡ NetOptimizer Pro & Lite
**The Ultimate Windows Network Debloater, Telemetry Purger & Bandwidth Optimizer**

![Platform](https://img.shields.io/badge/Platform-Windows_7%20%7C%208%20%7C%2010%20%7C%2011-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)
![Safety](https://img.shields.io/badge/Safety-100%25_Reversible-orange?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-v2.6-red?style=for-the-badge)

<br>

![NetOptimizer Pro Interface](https://i.ibb.co/274DXk2K/2026-03-30-18-17-48-Administrator-Net-Optimizer-Pro-v2-6-By-ALI-SAKKAF.png)

</div>

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
* **Windows Update + Phone Link [Option 3]:** Need to update safely? This option activates the Windows Update engine AND reactivates `PhoneSvc`, allowing seamless Microsoft Phone Link message/photo synchronization without unlocking the rest of the system bloatware.
* **Microsoft Store Unlocker [Option 4]:** Exclusively reactivates the essential deployment and licensing services (`ClipSVC`, `AppXSVC`, `InstallService`) required for the Microsoft Store to function perfectly, without enabling tracking agents.

### 3. ❌ The Ultimate Browser Auto-Update Controller
Browsers (Chrome, Edge, Brave, Firefox) often ignore standard service disabling by utilizing hidden crash handlers and remoting tools. NetOptimizer uses a Dual-System approach:

* **⏸️ Temporary Pause [Option 5]:** Instantly frees up RAM by terminating 30+ hidden browser processes and stops updater services for the *current session only*. Everything returns to normal automatically upon a PC reboot. Perfect for immediate bandwidth relief.
* **❌ Permanent Block [Option 6]:** Hard-kills active processes, permanently disables update services, destroys Scheduled Tasks, and injects stringent Local Group Policy (GPO) rules to block browsers from even attempting to check for updates natively.
* **✅ Restore Defaults [Option 7]:** Removes all GPO locks and restores browser updater services to normal.

### 4. 🤖 Self-Healing Auto-Updater Engine
NetOptimizer features a highly advanced, bulletproof Auto-Updater built directly into the Batch script. On launch, it safely pings a secure server to check for the latest versions. If an update is found, it uses native `curl` or `PowerShell` engines to download, replace, and restart itself within seconds—ensuring you always have the latest telemetry blocks without lifting a finger.

---

## 📸 Action Showcase

<div align="center">

![Disabling Services](https://i.ibb.co/mCj7KQnK/2.png)
<br>
![Enabling Services](https://i.ibb.co/mCz7sdJ0/3.png)
<br>
![Browser Updates Killed](https://i.ibb.co/FLV3RXns/4.png)

</div>

---

## 🚀 How To Use

1. Go to the **[Releases](../../releases)** page and download either `NetOptimizer_Pro.bat` or `NetOptimizer_Lite.bat` depending on your OS.
2. Right-click the downloaded `.bat` file and select **"Run as Administrator"**. *(The script includes an automated UAC elevation check, but manual elevation is best practice).*
3. Let the Auto-Updater check for the latest core files (takes max 5 seconds).
4. The interactive menu will appear. Select your desired execution protocol by typing a number `[1-8]` and pressing Enter.
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

<div align="center">
  
**Made By Ali Sakkaf** ❤️

</div>
