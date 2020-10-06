﻿[CmdletBinding()]
param(
    [parameter(Position = 0)]
    $Task = 'Default',
    # Bootstrap dependencies
    [switch]$Bootstrap
)

Clear-Host
Write-Verbose ('[{0:O}] [BUILD][START]' -f (get-date))

# Bootstrap dependencies
if ($Bootstrap.IsPresent) {
    Write-Verbose ('[{0:O}] [BUILD] Installing module dependencies...' -f (get-date))
    Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    if ((Test-Path -Path ./requirements.psd1)) {
        if (-not (Get-Module -Name PSDepend -ListAvailable)) {
            Install-Module -Name PSDepend -Repository PSGallery -Scope CurrentUser -Force
        }
        Import-Module -Name PSDepend -Verbose:$false
        Invoke-PSDepend -Path './requirements.psd1' -Install -Force -WarningAction SilentlyContinue
    }
    else {
        Write-Warning ('[{0:O}] No [requirements.psd1] found. Skipping build dependency installation.' -f (get-date))
    }
}

Write-Verbose ('[{0:O}] [BUILD] Build Environment variable...' -f (get-date))
if (!(Get-ChildItem Env:BH*)) {
    Write-Verbose ('[{0:O}] [BUILD] Set Build Environment variable...' -f (get-date))
    Set-BuildEnvironment
}
else {
    Write-Verbose ('[{0:O}] [BUILD] Build Environment variable already set..' -f (get-date))
}