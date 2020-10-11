task GenerateMarkdown {
    Write-Verbose ('[{0:O}] [GENERATEMARKDOWN][START]' -f (get-date))
    $OutputPath = Join-Path $env:BHBuildOutput -ChildPath $env:BHProjectName
    $ModuleBuildPsd1 = Join-Path $OutputPath -ChildPath "$($env:BHProjectName).psd1"

    if (Test-Path -Path $ModuleBuildPsd1) {
        Write-Verbose ('[{0:O}] [GENERATEMARKDOWN] Importing module {1}' -f (get-date), $ModuleBuildPsd1)
        $module = Import-Module -FullyQualifiedName $ModuleBuildPsd1 -Force -PassThru

        try {
            if ($module.ExportedFunctions.Count -eq 0) {
                Write-Verbose ('[{0:O}] [GENERATEMARKDOWN] No functions have been exported for this module. Skipping Markdown generation...' -f (get-date))
                return
            }

            $params = @{
                AlphabeticParamsOrder = $true
                ErrorAction           = 'SilentlyContinue'
                Locale                = 'en-US'
                Module                = $env:BHProjectName
                OutputFolder          = "$OutputPath\Docs\en-US"
                WithModulePage        = $true
            }

            # ErrorAction is set to SilentlyContinue so this
            # command will not overwrite an existing Markdown file.
            Write-Verbose ('[{0:O}] [GENERATEMARKDOWN] Creating new Markdown help for {1}' -f (get-date), $env:BHProjectName)
            $null = New-MarkdownHelp @params
        }
        finally {
            Remove-Module -Name $env:BHProjectName -Force
        }

    } else {
        Write-Verbose ('[{0:O}] [GENERATEMARKDOWN] No module to import' -f (get-date))
    }
    Write-Verbose ('[{0:O}] [GENERATEMARKDOWN][END]' -f (get-date))
}
