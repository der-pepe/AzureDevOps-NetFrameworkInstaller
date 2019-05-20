
function Get-NetCoreSDKVersion
{
  $_installed="0.0"
  dotnet --info | find  "[$Env:ProgramFiles\dotnet\sdk]" | ForEach-Object {
    $newCoreInstalled=$_.split("[")[0].replace("-preview-",".").trim()
    if ([System.Version]$newCoreInstalled -gt [System.Version]$_installed)
    {
      $_installed=$newCoreInstalled
    }
  }
  $_installed
}

function Get-NetFrameworkVersion
{
  $netFwInstalled=(Get-ItemProperty "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\").Release
  $netFwInstalled
}

function Get-NetFrameworkRequired($version)
{
  $_req=0
  switch($version) {
    "4.5"       { $_req=378389; break; }
    "4.5.1"     { $_req=378675; break; }
    "4.5.2"     { $_req=379893; break; }
    "4.6"	    { $_req=393295; break; }
    "4.6.1"	    { $_req=394254; break; }
    "4.6.2"	    { $_req=394802; break; }
    "4.7"	    { $_req=460798; break; }
    "4.7.1"	    { $_req=461308; break; }
    "4.7.2"	    { $_req=461808; break; }
    "4.8"	    { $_req=828040; break; }
    default     { break }
  }
  $_req
}

function Get-NetFrameworkPackage($version)
{
  $_pkg=0
  switch($version) {
    "4.5"       { $_pkg=0;          break; }
    "4.5.1"     { $_pkg=0;          break; }
    "4.5.2"     { $_pkg=0;          break; }
    "4.6"	    { $_pkg=0;          break; }
    "4.6.1"	    { $_pkg=0;          break; }
    "4.6.2"	    { $_pkg=0;          break; }
    "4.7"	    { $_pkg=55168;      break; }
    "4.7.1"	    { $_pkg=56119;      break; }
    "4.7.2"	    { $_pkg=0;          break; }
    "4.8"	    { $_pkg=2088517;    break; }
    default     { break }
  }
  $_pkg
}

function GetAndInstallPackage($packageId, $netver)
{
  $nver=$netver.replace(".","")
  $InstallerPath="$Env:TEMP\ndp$nver-devpack-enu.exe"  
  
  Write-Host "Downloading installer to '$InstallerPath' ..."

  $progressPreference = 'silentlyContinue'
  Invoke-WebRequest -Uri "http://go.microsoft.com/fwlink/?linkid=$packageId" -OutFile "$InstallerPath"
  $progressPreference = 'Continue'

  if ([System.IO.File]::Exists($InstallerPath))
  {
    Write-Host "Installer downloaded"
    Write-Host "Launching installer, please wait..."
    & "$InstallerPath" /q /norestart | Out-null
# TODO: Check exitcode
    Write-Host "Deleting installer"
    Remove-Item $InstallerPath
  }
  else
  {
    Write-Host "Error! Cannot download .NET Framework installer" -ForegroundColor red
    exit 1
  }
}