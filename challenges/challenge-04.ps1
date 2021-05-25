. (Join-Path $PSScriptRoot common.ps1)

$stac = az storage account list --query "[?contains(name, '0terraform0dev0stac')]" `
| ConvertFrom-Json

$tags = $stac
| Select-Object -expand Tags

Push-Location (Join-Path $PSScriptRoot './../src/terraform')
$outputPresent = (terraform output stac_resource_id) -match '\/subscriptions\/[\w-]+\/resourceGroups\/[\w-]+\/providers\/Microsoft\.Storage\/storageAccounts'
(terraform output stac_resource_id)
Pop-Location

Test-Challenge `
    -Challenge 4 `
    -Success (($tags.Purpose -eq 'Demo') `
        -and ((Get-Content (Join-Path $PSScriptRoot './../src/terraform/main.tf') -raw) -notmatch '\"purpose\"\s*=\s*\"demo\"') `
        -and $outputPresent)
