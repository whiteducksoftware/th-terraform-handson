. (Join-Path $PSScriptRoot common.ps1)



$userName = az sql server list --query '[].administratorLogin' -o tsv
$userValid = (-not [string]::IsNullOrEmpty($userName)) -and ($userName.ToLower() -ceq $userName)


Test-Challenge `
    -Challenge 5 `
    -Success ($userValid `
        -and ((Get-Content (Join-Path $PSScriptRoot './../src/terraform/main.tf') -raw) -match 'resource\s*"random_password"')) `
