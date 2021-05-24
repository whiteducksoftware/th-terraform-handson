. (Join-Path $PSScriptRoot common.ps1)

Test-Challange -Challange 1 -Success ((terraform -version) -join ' ' -match 'v0.15.4')