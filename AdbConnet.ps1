# ----------------------------------------------------------------
# 脚本名称: ADB-Final-Stable-Direct
# ----------------------------------------------------------------

$AdbPath = "adb"
if (Test-Path "$PSScriptRoot\adb.exe") { $AdbPath = "$PSScriptRoot\adb.exe" }

# 1. 初始化
Write-Host "--- 正在初始化 ADB 环境 ---" -ForegroundColor Gray
Stop-Process -Name "adb" -ErrorAction SilentlyContinue
& $AdbPath kill-server 2>$null
& $AdbPath start-server > $null

Write-Host "--- 正在搜索局域网设备 ---" -ForegroundColor Cyan
& $AdbPath mdns services > $null
Start-Sleep -Seconds 2
$mdnsResult = & $AdbPath mdns services

# 2. 提取并连接
$uniqueAddresses = ($mdnsResult | Select-String -Pattern '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}):(\d+)').Matches.Value | Select-Object -Unique

if ($uniqueAddresses) {
    foreach ($address in $uniqueAddresses) {
        $connectResult = & $AdbPath connect $address
        
        if ($connectResult -like "*connected*") {
            # 获取型号并生成标题
            $model = (& $AdbPath -s $address shell getprop ro.product.model).Trim()
            $lastOctet = $address.Split('.')[3].Split(':')[0]
            $customTitle = "$model (.$lastOctet)"
            
            Write-Host "[√] 已连接: $customTitle" -ForegroundColor Green
            Write-Host "--- 正在启动投屏 (关闭此窗口将同步关闭投屏) ---" -ForegroundColor Yellow

            # --- 最简单的直接调用 ---
            # 直接运行 scrcpy，它会占用当前的控制台直到你关闭窗口或投屏结束
            Set-Location "$PSScriptRoot"
            .\scrcpy.exe -s $address --window-title "$customTitle"
        }
    }
} else {
    Write-Host "[!] 未发现开启无线调试的设备。" -ForegroundColor Red
}

Write-Host "`n处理完成，按任意键退出..."
$null = [Console]::ReadKey($true)