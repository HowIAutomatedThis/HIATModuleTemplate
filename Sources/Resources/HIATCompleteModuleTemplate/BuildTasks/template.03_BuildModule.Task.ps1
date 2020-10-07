task BuildModule {
    Write-Verbose ('[{0:O}] [BUILDMODULE][START]' -f (get-date))
    Write-Verbose ('[{0:O}] BUILD] Creating output path for {1}' -f (get-date), $env:BHProjectName)

    $Enums = Get-ChildItem -Path (Join-Path $env:BHProjectPath -ChildPath "Sources\Enums") -Filter *.ps1 | Sort-Object Name
    $Classes = Get-ChildItem -Path (Join-Path $env:BHProjectPath -ChildPath "Sources\Classes") -Filter *.ps1 | Sort-Object Name
    $PrivateFunctions = Get-ChildItem -Path (Join-Path $env:BHProjectPath -ChildPath "Sources\Functions\Private") -Filter *.ps1 | Sort-Object Name
    $PublicFunctions = Get-ChildItem -Path (Join-Path $env:BHProjectPath -ChildPath "Sources\Functions\Public") -Filter *.ps1 | Sort-Object Name
    $RessourcesPath = Join-Path $env:BHProjectPath -ChildPath "Sources\Ressources\"
    $OutputPath = Join-Path $env:BHBuildOutput -ChildPath $env:BHProjectName
    $ModuleBuildPsm1 = Join-Path $OutputPath -ChildPath "$($env:BHProjectName).psm1"
    $MainPSM1Contents = @()


    New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null

    Write-Verbose ('[{0:O}] [BUILD] Loading all sources files' -f (get-date))
    foreach ($Object in ($Enums, $Classes, $PrivateFunctions, $PublicFunctions)) {
        if ($object) {
            $MainPSM1Contents += $Object
        }
    }

    if ($MainPSM1Contents) {
        Write-Verbose ('[{0:O}] [BUILDMODULE] building main psm1' -f (get-date))
        $Date = Get-Date
        "#Generated at $($Date)" | Out-File -FilePath $ModuleBuildPsm1 -Encoding utf8 -Append
        Foreach ($file in $MainPSM1Contents) {
            Get-Content $File.FullName | Out-File -FilePath $ModuleBuildPsm1 -Encoding utf8 -Append
        }

        if (Test-Path -Path $RessourcesPath) {
            Write-Verbose ('[{0:O}] [BUILDMODULE] Add ressources to Module' -f (get-date))
            $RessourcesList = Get-ChildItem -Path $RessourcesPath

            foreach ($ressources in $RessourcesList) {
                $PathRessources = $RessourcesPath + $ressources.Name
                $DestinationPath = $OutputPath + "\Ressources\" + $ressources.Name
                Copy-Item -Path $PathRessources -Destination $DestinationPath -Force -Recurse -Confirm:$false
            }
            Write-Verbose ('[{0:O}] [BUILDMODULE] All ressources add to Module' -f (get-date))
        }
    }
    else {
        Write-Warning ('[{0:O}] Nothing to compile' -f (get-date))
    }
    Write-Verbose ('[{0:O}] [BUILDMODULE][END]' -f (get-date))
}
