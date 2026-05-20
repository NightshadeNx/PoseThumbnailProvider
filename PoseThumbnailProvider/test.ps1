#Requires -RunAsAdministrator

$dll = "$PSScriptRoot\bin\x64\Debug\PoseThumbnailProvider.dll"
$regasm = "$env:windir\Microsoft.NET\Framework64\v4.0.30319\regasm.exe"

Write-Host "Stopping explorer.exe..."
taskkill /f /im explorer.exe 2>$null
Start-Sleep -Milliseconds 500

Write-Host "Unregistering thumbnail provider..."
& $regasm /u $dll 2>$null

Write-Host "Registering thumbnail provider..."
& $regasm /codebase $dll

Write-Host "Setting up registry keys..."
$poseKeyPath = "Registry::HKEY_CLASSES_ROOT\.pose"
if (-not (Test-Path $poseKeyPath))
{
    New-Item -Path $poseKeyPath -Force | Out-Null
    Set-ItemProperty -Path $poseKeyPath -Name "(Default)" -Value "AnamnesisPoFile"
    Write-Host "Created .pose file association"
}
else
{
    Write-Host ".pose file association already exists"
}

$shellExKeyPath = "Registry::HKEY_CLASSES_ROOT\AnamnesisPoFile\ShellEx\{E357FCCD-A995-4576-B01F-234630154E96}"
if (-not (Test-Path $shellExKeyPath))
{
    New-Item -Path $shellExKeyPath -Force | Out-Null
    Set-ItemProperty -Path $shellExKeyPath -Name "(Default)" -Value "{8328811d-cd39-4b96-abab-6e156b5cdcaa}"
    Write-Host "Created ShellEx handler registration"
}
else
{
    Write-Host "ShellEx handler registration already exists"
}

Write-Host "Clearing thumbnail cache..."
Remove-Item "$env:LocalAppData\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue -Verbose

Write-Host "Done. Restarting explorer.exe..."
Start-Process explorer.exe

$debugValue = 0
$poseThumbnailProviderKeyPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\PoseThumbnailProvider"
if (-not (Test-Path $poseThumbnailProviderKeyPath))
{
    New-Item -Path $poseThumbnailProviderKeyPath -Force | Out-Null
}
Set-ItemProperty -Path $poseThumbnailProviderKeyPath -Name "Logging" -Value $debugValue -Type DWord
Write-Host "Created PoseThumbnailProvider registry key with Logging=$debugValue"
