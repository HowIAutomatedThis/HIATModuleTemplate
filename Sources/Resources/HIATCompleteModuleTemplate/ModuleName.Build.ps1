Write-Verbose ('[{0:O}] [INVOKEBUILMODULE][START]' -f (Get-Date))
Write-Verbose ('[{0:O}] [INVOKEBUILMODULE] Import common tasks ...' -f (Get-Date))

Get-ChildItem -Path $env:BHProjectPath\BuildTasks\*.Task.ps1 | ForEach-Object {
    Write-Verbose ('[{0:O}] [INVOKEBUILMODULE] Importing {1}' -f (Get-Date), $_.FullName)
    . $_.FullName
}

Task Default Clean, BuildModule, BuildManifest #, Analyze, UnitTests, GenerateMarkdown, GenerateHelp
Task Build Clean, BuildModule, BuildManifest
#task PSAnalyse Analyze
#task Test build, ImportModule, UnitTests
Task Helpify ImportModule, GenerateMarkdown #, GenerateHelp

Write-Verbose ('[{0:O}] [INVOKEBUILMODULE][END]' -f (Get-Date))