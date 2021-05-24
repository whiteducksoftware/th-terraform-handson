$region = 'germanywestcentral'

Get-Content ./attendees.csv | ConvertFrom-Csv | ForEach-Object {
    
    $resourceGroupName = 'rg-{0}-terraform-dev' -f $_.short

    # Create a resource group.
    az group create --name $resourceGroupName --location $region
    
    # Assign contributor right for the student
    az role assignment create --assignee $_.id --role "Contributor" --resource-group $resourceGroupName

}