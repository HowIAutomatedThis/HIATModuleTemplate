task BuildManifest {
    Write-Verbose ('[{0:O}] [BUILDMANIDEST][START]' -f (get-date))
    $OutputPath = Join-Path $env:BHBuildOutput -ChildPath $env:BHProjectName
    $ModuleBuildPsd1 = Join-Path $OutputPath -ChildPath "$($env:BHProjectName).psd1"

    Write-Verbose ('[{0:O}] [BUILDMANIFEST] Adding functions to export...' -f (get-date))
    $FunctionsToExport = (Get-ChildItem -Path (Join-Path $env:BHProjectPath -ChildPath "Sources\Functions\Public") -Filter *.ps1 | Sort-Object Name)

    if ($FunctionsToExport) {
        Copy-Item -Path (Get-PSModuleManifest) -Destination $ModuleBuildPsd1
        Update-ModuleManifest -Path $ModuleBuildPsd1 -FunctionsToExport $FunctionsToExport
    } else {
        Write-Verbose ('[{0:O}] No functions to export' -f (get-date))
    }

    Write-Verbose ('[{0:O}] [BUILDMANIDEST][END]' -f (get-date))
}