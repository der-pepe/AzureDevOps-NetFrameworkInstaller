<#
  .NET Framework Installer for Azure DevOps pipeline
#>

$InstallerPath="$Env:TEMP\ndp48-devpack-enu.exe"

Write-Host "=============================================================" -ForegroundColor green
Write-Host " .NET Framework 4.8 Installer" -ForegroundColor green
Write-Host "=============================================================" -ForegroundColor green
Write-Host ""

Write-Host "Downloading installer..."
$progressPreference = 'silentlyContinue'
Invoke-WebRequest -Uri "http://go.microsoft.com/fwlink/?linkid=2088517" -OutFile $InstallerPath
$progressPreference = 'Continue'

if ([System.IO.File]::Exists($InstallerPath))
{
  Write-Host "Installer downloaded"
  Write-Host "Launching installer"
  & "$Env:TEMP\ndp48-devpack-enu.exe" /q /norestart | Out-null
  
  Write-Host "Deleting installer"
  Remove-Item $InstallerPath
  Write-Host "Done!"
  exit 0
}
else
{
  Write-Host "Error! Cannot download .NET Framework installer" -ForegroundColor red
  exit 1
}

