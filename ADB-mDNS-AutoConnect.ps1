# ----------------------------------------------------------------
# Script Name: ADB-mDNS-AutoConnect (English Edition)
# ----------------------------------------------------------------

$AdbPath = "adb"
if (Test-Path "$PSScriptRoot\adb.exe") { $AdbPath = "$PSScriptRoot\adb.exe" }

# 1. Initialize Environment
Write-Host "--- Initializing ADB Environment ---" -ForegroundColor Gray
Stop-Process -Name "adb" -ErrorAction SilentlyContinue
& $AdbPath kill-server 2>$null
& $AdbPath start-server > $null

# 2. Search for mDNS Services
Write-Host "--- Scanning for Android devices in local network ---" -ForegroundColor Cyan
Write-Host "(Please ensure Wireless Debugging is enabled on your phone)" -ForegroundColor Gray
& $AdbPath mdns services > $null
Start-Sleep -Seconds 2
$mdnsResult = & $AdbPath mdns services

# 3. Extract and Connect
$uniqueAddresses = ($mdnsResult | Select-String -Pattern '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}):(\d+)').Matches.Value | Select-Object -Unique

if ($uniqueAddresses) {
    foreach ($address in $uniqueAddresses) {
        $connectResult = & $AdbPath connect $address
        
        if ($connectResult -like "*connected*") {
            # Get device model for the window title
            $model = (& $AdbPath -s $address shell getprop ro.product.model).Trim()
            $lastOctet = $address.Split('.')[3].Split(':')[0]
            $customTitle = "$model (.$lastOctet)"
            
            Write-Host "[√] Connected: $customTitle" -ForegroundColor Green
            Write-Host "--- Launching scrcpy (Closing this window will stop the stream) ---" -ForegroundColor Yellow

            # 4. Launch scrcpy directly
            Set-Location "$PSScriptRoot"
            .\scrcpy.exe -s $address --window-title "$customTitle"
        }
    }
} else {
    Write-Host "[!] Error: No Wireless Debugging devices found." -ForegroundColor Red
    Write-Host "Tip: Check if your phone and PC are on the same Wi-Fi network." -ForegroundColor Gray
}

Write-Host "`nProcess finished. Press any key to exit..."
$null = [Console]::ReadKey($true)
