. (Join-Path $PSScriptRoot common.ps1)

Test-Challenge `
    -Challenge 2 `
    -Success ((Test-Path (Join-Path $PSScriptRoot './../src/terraform/main.tf')) `
        -and (Test-Path (Join-Path $PSScriptRoot './../src/terraform/.terraform.lock.hcl')) `
        -and (Test-Path (Join-Path $PSScriptRoot './../src/terraform/terraform.tfstate')))