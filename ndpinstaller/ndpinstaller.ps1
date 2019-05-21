# ==============================================================================
#    .NET Installer Extension for Azure DevOps v1.0
# ==============================================================================

param (
  [string]$netframework = "4.8",
  [string]$netcore      = "",
  [string]$arch         = "-64",
  [switch]$force        = $false
)

$version="1.0"

# includes
."$PSScriptRoot\functions.ps1"

Write-Host "==============================================================================" -ForegroundColor green
Write-Host " .NET Installer Extension for Azure DevOps v$version" -ForegroundColor green
Write-Host "==============================================================================" -ForegroundColor green
Write-Host ""

Write-Host "Checking for .NET Framework v$netframework availability ..."

$NetFWInstalled=(Get-NetFrameworkVersion)
$NetFWRequired=(Get-NetFrameworkRequired($netframework))

if($NetFWInstalled -lt $NetFWRequired)
{
  Write-Host ".NET Framework installation required"
  $Package=(Get-NetFrameworkPackage($netframework))
  Write-Host "Installing .NET Framework v$netframework ..."
  $_res=(GetAndInstallPackage -packageId $Package -netver $netframework)
  if ($_res)
  {
    Write-Host "Done." -ForegroundColor green
    exit 0
  } else {
    Write-Host "Error." -ForegroundColor red
    exit 1
  }
}
else
{
  Write-Host ".NET Framework v$netframework already installed"
  exit 0
}