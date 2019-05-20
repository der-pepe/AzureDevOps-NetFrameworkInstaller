# ==============================================================================
#    .NET Installer Extension for Azure DevOps v0.4
# ==============================================================================

param (
  [string]$netframework = "4.8",
  [string]$netcore      = "",
  [string]$arch         = "-64",
  [switch]$force        = $false
)

$version="0.4"

# includes
."$PSScriptRoot\functions.ps1"

Write-Host "==============================================================================" -ForegroundColor green
Write-Host " .NET Installer Extension for Azure DevOps v$version" -ForegroundColor green
Write-Host "==============================================================================" -ForegroundColor green
Write-Host ""

Write-Host "Installing .NET Framework v$netframework ..."

$NetFWInstalled=(Get-NetFrameworkVersion)
$NetFWRequired=(Get-NetFrameworkRequired($netframework))

if($NetFWInstalled -lt $NetFWRequired)
{
  Write-Host ".NET Framework installation required"
  $Package=(Get-NetFrameworkPackage($netframework))
  GetAndInstallPackage -packageId $Package -netver $netframework
}
else
{
  Write-Host ".NET Framework v$netframework already installed"
}

Write-Host "Done." -ForegroundColor green
exit 0