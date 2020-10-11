function ImportModule {
    param(
        [string]$path,
        [switch]$PassThru
    )


    if (-not(Test-Path -Path $path)) {
        "Cannot find [$path]."
        Write-Error -Message "Could not find module manifest [$path]"
    }
    else {
        $file = Get-Item $path
        $name = $file.BaseName

        $loaded = Get-Module -Name $name -All -ErrorAction Ignore
        if ($loaded) {
            "Unloading Module [$name] from a previous import..."
            $loaded | Remove-Module -Force
        }

        "Importing Module [$name] from [$($file.fullname)]..."
        Import-Module -Name $file.fullname -Force -PassThru:$PassThru
    }
}

task ImportModule {
    $OutputPath = Join-Path $env:BHBuildOutput -ChildPath $env:BHProjectName
    $ModuleBuildPsd1 = Join-Path $OutputPath -ChildPath "$($env:BHProjectName).psd1"

    Write-Verbose ('[{0:O}] [IMPORTMODULE][START]' -f (get-date))
    if (test-path -Path $ModuleBuildPsd1) {
        Write-Output ('[{0:O}] [IMPORTMODULE] Importing module {1}' -f (get-date), $ModuleBuildPsd1)
        ImportModule -Path $ModuleBuildPsd1
    } else {
        Write-Verbose ('[{0:O}] No module to import' -f (get-date))
    }
    Write-Verbose ('[{0:O}] [IMPORTMODULE][END]' -f (get-date))
}

