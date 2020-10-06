Write-Verbose ('[{0:O}] [INVOKEBUILMODULE][START]' -f (get-date))
Write-Verbose ('[{0:O}] [INVOKEBUILMODULE] Import common tasks ...' -f (get-date))

Get-ChildItem -Path $env:BHProjectPath\BuildTasks\*.Task.ps1 | ForEach-Object {
    Write-Verbose ('[{0:O}] [INVOKEBUILMODULE] Importing {1}' -f (get-date), $_.FullName)
    . $_.FullName
}

task Default Clean, BuildModule, BuildManifest, Analyze, UnitTests, GenerateMarkdown, GenerateHelp
task Build Clean, BuildModule, BuildManifest
task PSAnalyse Analyze
task Test build, ImportModule, UnitTests
task Helpify ImportModule, GenerateMarkdown, GenerateHelp

Write-Verbose ('[{0:O}] [INVOKEBUILMODULE][END]' -f (get-date))