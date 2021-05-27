. (Join-Path $PSScriptRoot common.ps1)


$userName = az sql server list --query '[].administratorLogin' -o tsv
$userValid = (-not [string]::IsNullOrEmpty($userName)) -and ($userName.ToLower() -ceq $userName)


$keyVaultName = az keyvault list `
| ConvertFrom-Json `
| Where-Object name -like '*-terraform-kv' `
| Select-Object -ExpandProperty name

$dbuser = az keyvault secret show --name "dbuser" --vault-name $keyVaultName --query "value"
$dbpwd = az keyvault secret show --name "dbpwd" --vault-name $keyVaultName --query "value"


Test-Challenge `
    -Challenge 5 `
    -Success ($userValid `
        -and ((-not [string]::IsNullOrEmpty($dbuser)) -and (-not [string]::IsNullOrEmpty($dbpwd))) `
        -and ((Get-Content (Join-Path $PSScriptRoot './../src/terraform/main.tf') -raw) -match 'resource\s*"random_password"')) `
