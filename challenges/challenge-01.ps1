. (Join-Path $PSScriptRoot common.ps1)

Test-Challenge `
    -Challenge 1 `
    -Success (((terraform -version) -join ' ' -match 'v0.15.4') `
        -and (code --list-extensions) -join '' -match 'hashicorp\.terraform' `
        -and ((az version --output json | ConvertFrom-Json).'azure-cli' -ge [Version]'2.23.0'))