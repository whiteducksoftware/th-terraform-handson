. (Join-Path $PSScriptRoot common.ps1)

$stac = az storage account list --query "[?contains(name, '0terraform0dev0stac')]" `
| ConvertFrom-Json

$tags = $stac
| Select-Object -expand Tags
    
Test-Challenge `
    -Challenge 3 `
    -Success (($tags.Environment -eq 'DEV') `
        -and (-not [string]::IsNullOrEmpty($tags.Purpose)) `
        -and $stac.sku.name -eq 'Standard_LRS')
