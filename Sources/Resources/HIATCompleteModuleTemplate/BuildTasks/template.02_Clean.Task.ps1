task Clean {
    Write-Verbose ('[{0:O}] [CLEAN][START]' -f (get-date))
    Write-Verbose ('[{0:O}] [CLEAN] test if output build directory already exist...' -f (get-date))
    if (Test-Path -Path $env:BHBuildOutput) {
        Write-Verbose ('[{0:O}] [CLEAN] Pre-build module find => Suppress' -f (get-date))
        Remove-Item -Path $env:BHBuildOutput -force -recurse -confirm:$false
    }
    else {
        Write-Verbose ('[{0:O}] [CLEAN] Nothing to do...' -f (get-date))
    }
    Write-Verbose ('[{0:O}] [CLEAN][END]' -f (get-date))
}
