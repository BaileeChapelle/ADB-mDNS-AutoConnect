# ADB Wireless Auto-Connect & Stream

A lightweight, secure, and automated PowerShell utility to discover, connect, and stream Android devices over Wi-Fi using **ADB mDNS** and **scrcpy**.

This project is built with a focus on using **high-quality, non-Chinese background open-source tools** (Google ADB, Genymobile scrcpy, Microsoft PowerShell).

## 🌟 Features

* **Zero-Config Discovery**: Uses ADB mDNS (Multicast DNS) to find your phone automatically. No need to check IP addresses or ports manually.
* **Environment Reset**: Automatically kills zombie ADB processes to ensure a clean connection every time.
* **Smart Identity**: Automatically retrieves the device model (e.g., `Pixel 7`) and appends the IP suffix to the window title to distinguish between identical devices.
* **Pure & Transparent**: Written entirely in PowerShell. No hidden binaries, no telemetry, and no bloat.
* **Portable**: Works directly out of the `scrcpy` folder.

## 🛠️ Prerequisites

1. **Android 11+**: Wireless Debugging must be enabled in *Developer Options*.
2. **scrcpy**: [Download the latest release](https://github.com/Genymobile/scrcpy).
3. **ADB Path**: Ensure `adb.exe` is in your system PATH or located in the same folder as the script.

## 🚀 Quick Start

1. **Download/Clone** this repository or copy the `.ps1` script.
2. **Place the script** inside your `scrcpy-win64` folder.
3. **Enable Wireless Debugging** on your Android device (ensure it's on the same Wi-Fi).
4. **Run the script**:
* Right-click `ADB-Connect-EN.ps1` -> *Run with PowerShell*.
* *Optional*: Create a desktop shortcut with the following target to run it with a double-click:
```text
powershell.exe -ExecutionPolicy Bypass -File "C:\path\to\your\ADB-Connect-EN.ps1"

```


## 📖 How it Works

The script follows a 4-step automation logic:

1. **Cleanup**: Runs `taskkill` and `kill-server` to reset the ADB environment.
2. **Scan**: Activates `ADB_MDNS_OPENSCREEN` and scans the local network for `_adb-tls-connect` services.
3. **Identify**: Connects to discovered IPs and queries the `ro.product.model` property.
4. **Stream**: Launches `scrcpy` with a custom title: `[Model] (.IP_Suffix)`.

## 🛡️ Privacy & Security

In compliance with the project's guiding principles:
* **Local execution**: No data is sent to the cloud; all discovery happens on your local network.

## 📄 License

This script is released under the **GPLv2 License**.
