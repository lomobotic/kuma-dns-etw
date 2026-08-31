# Остановить и удалить сессию (молча)
logman stop etwDNS-Analytics -ets
logman delete etwDNS-Analytics

# Удалить старый ETL-файл
Remove-Item "C:\Windows\System32\LogFiles\WMI\etwDNS-Analytics.etl" -Force -ErrorAction SilentlyContinue

# Создать сессию в реальном времени
logman create trace etwDNS-Analytics `
    -p Microsoft-Windows-DNSServer 0xFFFFFFFF 0x5 `
    -rt `
    -bs 64 -nb 64 256 `
    -ets

# Настройки Autologger для real-time
$auto = "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\etwDNS-Analytics"
New-Item $auto -Force | Out-Null

Set-ItemProperty -Path $auto -Name LogFileMode     -Value 0x100 -Type DWord
Set-ItemProperty -Path $auto -Name BufferSize      -Value 64    -Type DWord
Set-ItemProperty -Path $auto -Name MinimumBuffers  -Value 64    -Type DWord
Set-ItemProperty -Path $auto -Name MaximumBuffers  -Value 256   -Type DWord
Set-ItemProperty -Path $auto -Name ClockType       -Value 1     -Type DWord
Set-ItemProperty -Path $auto -Name FlushTimer      -Value 1     -Type DWord

# Запуск сессии
logman start etwDNS-Analytics -ets
