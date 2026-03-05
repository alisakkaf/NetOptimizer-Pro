<div align="center">
  
# ⚡ NetOptimizer Pro
**The Ultimate Windows Network Debloater & Bandwidth Optimizer**

![Platform](https://img.shields.io/badge/Platform-Windows_10%20%7C%2011-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)
![Safety](https://img.shields.io/badge/Safety-100%25_Reversible-orange?style=for-the-badge)

<br>

![NetOptimizer Pro Interface](https://i.ibb.co/G3shrTwx/1.png)

</div>

---

## 📖 About The Project

**NetOptimizer Pro** is an aggressively optimized, deeply integrated Batch script designed to give you **100% absolute control** over your Windows network bandwidth. 

Modern Windows operating systems and browsers notoriously consume massive amounts of background data for telemetry, silent updates, and background syncing. For users on metered connections, mobile hotspots, or those who simply demand peak ping performance for gaming, this background data bleed is unacceptable. 

This tool deploys a "ZeroLeak Protocol", hunting down aggressive background services and cutting off their internet access instantly. 

---

## 🛡️ Safety First: Non-Destructive Approach

A major concern with "Debloaters" is that they often delete core system files, leading to permanent corruption. **NetOptimizer Pro is different.**

> **IMPORTANT:** This script **DOES NOT DELETE** any system files, services, or registry keys. 
> It exclusively operates by **disabling** (suspending) services, altering startup types, and applying Group Policy (GPO) blocks. Everything done by this script is **100% reversible** with a single click inside the tool.

---

## ✨ Core Features & Technical Deep Dive

### 1. 🛑 Windows System Network Control (Max Performance)
When you trigger the disable protocol, the script performs the following actions:
* **Halts Core Update Engines:** Suspends `wuauserv`, `bits`, `UsoSvc`, and `WaaSMedicSvc`.
* **Kills Telemetry & Sync:** Stops background data harvesting (`DiagTrack`, `dmwappushservice`) and cloud sync services.
* **Network Throttling:** Automatically edits the Registry to enforce `Metered Connection` on both WiFi and Ethernet interfaces, forcing Windows to natively restrict background downloads.
* **Flushes Network Stack:** Resets DNS and Winsock to clear any pending ghost connections.

### 2. 🟢 1-Click System Restoration
* Reverts all disabled services back to their native `Demand` or `Automatic` state.
* Removes the Metered Connection limits.
* Reactivates Windows Scheduled Maintenance tasks.

### 3. ❌ Hard Kill: Browser Auto-Updates 
Browsers like Chrome, Brave, and Edge often ignore standard service disabling. NetOptimizer Pro uses a multi-layered attack to stop them:
* **RAM Execution:** Force-kills active updaters (`GoogleUpdate.exe`, `BraveUpdate.exe`, `MicrosoftEdgeUpdate.exe`) instantly.
* **Service Lock:** Disables the browser-specific update services.
* **GPO Injection:** Injects Local Group Policy (Registry) rules to permanently block the browsers from attempting to search for updates internally. (Supports Chrome, Brave, Edge, and Firefox).

---

## 📸 Action Showcase

![Disabling Services](https://i.ibb.co/mCj7KQnK/2.png)
![Enabling Services](https://i.ibb.co/mCz7sdJ0/3.png)
![Browser Updates Killed](https://i.ibb.co/FLV3RXns/4.png)

---

## 🚀 How To Use

1. Go to the [Releases](../../releases) page and download the latest `NetOptimizer_Pro.bat` file.
2. Right-click the downloaded file and select **"Run as Administrator"**. *(The script includes an auto-elevation check, but manual elevation is recommended).*
3. Select your desired protocol by typing a number `[1-6]`.
4. Wait for the green `[✔] SUCCESS` message. 
5. Restart your PC if recommended by the script.

---

## ⚠️ Strict Disclaimer & Liability

**USE AT YOUR OWN RISK.**
This is an aggressive system script. By using this tool, you acknowledge and agree to the following:
* Disabling Windows Updates prevents your system from receiving critical security patches, leaving you vulnerable to exploits. 
* It is highly recommended to periodically use the **[2] Restore** or **[3] Enable Windows Update ONLY** option to update your system securely, then disable them again.
* The developer is **not responsible** for any system instability, security breaches, data loss, or OS corruption that may occur from the misuse of this tool.

---

<div align="center">
  
**Made By Ali Sakkaf** ❤️

</div>
