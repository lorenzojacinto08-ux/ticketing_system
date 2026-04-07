# Starts Flask in the background and opens the browser (Windows).
$ErrorActionPreference = "Stop"
$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $Root

$py = Join-Path $Root "venv\Scripts\python.exe"
if (-not (Test-Path $py)) {
    $py = (Get-Command python -ErrorAction SilentlyContinue).Source
    if (-not $py) {
        Write-Host "Python not found. Run scripts\setup_windows.bat first."
        exit 1
    }
}

$port = if ($env:PORT) { [int]$env:PORT } else { 5000 }
$url = "http://127.0.0.1:$port/"

$inUse = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
if ($inUse) {
    Start-Process $url
    exit 0
}

$p = Start-Process -FilePath $py -ArgumentList "app.py" -WorkingDirectory $Root -WindowStyle Hidden -PassThru
$p.Id | Out-File -FilePath (Join-Path $Root ".ticketing_server.pid") -Encoding ascii -NoNewline

for ($i = 0; $i -lt 60; $i++) {
    $ready = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if ($ready) { break }
    Start-Sleep -Milliseconds 100
}

Start-Process $url
