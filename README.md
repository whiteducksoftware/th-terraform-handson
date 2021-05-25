# Terraform hands-on repository

## Prerequisites

- [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1)
- [Visual Studio Code](https://code.visualstudio.com/)

## Challenge 1 - Install Tools

### Install Terraform

To use Terraform, you will need to install it. HashiCorp distributes Terraform as a pre-compiled binary package.
To pass this challenge, you will need to download and install the most recent version of Terraform.

> 💡 Make sure that the terraform binary is **up-to-date** and available on your **PATH**. You might have to **restart** vscode.

### Enable Terraform tab completion (optional)

If you use either Zsh or Bash, you can [enable tab completion](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started#enable-tab-completion).

### Install the Terraform Visual Studio Code Extension

Install the [Terraform Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)

> 💡 You can install extensions using the VSCode CLI: `code --install-extension HashiCorp.terraform`

### Install the Azure CLI

The Azure CLI is a set of commands used to create and manage Azure resources. You will use the Azure CLI to authenticate with Azure later.
See: [Install the Azure CLI](https://docs.microsoft.com/de-de/cli/azure/install-azure-cli?WT.mc_id=AZ-MVP-5003203)

> 💡 Ensure you have installed the latest version of the Azure CLI

### Verify

You can verify whether you passed the first challenge by running the `Test challenge X` VSCode Task.

> 💡 You can run your task through Quick Open (<kbd>Ctrl</kbd>+<kbd>P</kbd>) by typing 'task', Space and the command name. In this case `Test challenge 1`

## Challenge 2 - Initial Configuration

### Authenticate to Azure

To create infrastructure in Azure, Terraform needs to be authenticated against Azure. To sign in to Azure, run the Azure CLI `login` command:

```bash
az login
```

Then sign in with your account credentials in the browser.

### Create the initial configuration

Inside the `src/terraform` directory, create a new file called `main.tf` and paste the configuration below:

```terraform
terraform {
  required_version = ">= 0.15.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

locals {
  initials = "mus" # must be lower case
  owner    = "Max Mustermann"
}

provider "azurerm" {
  skip_provider_registration = true
  features {
  }
}

data "azurerm_resource_group" "rg" {
  name = "rg-${local.initials}-terraform-dev"
}

resource "azurerm_storage_account" "stac" {
  name                     = "${local.initials}0terraform0dev0stac"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

```

Then adjust the `locals` accordingly.

> 💡 Terraform is able to import existing infrastructure to bring it under Terraform management. This can be done using the `terraform import` command. In this hands-on the resource groups are precreated and we could import it using `terraform import azurerm_resource_group.rg (az group list --query "[?contains(name, '-terraform-dev')].{id:id}" --output tsv)`

### Initialize the configuration

Initialize terraform by running the following command inside the `src/terraform` directory:

```terraform
terraform init
```

The output should look like this:

```
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching ">= 2.26.0"...
- Installing hashicorp/azurerm v2.60.0...
- Installed hashicorp/azurerm v2.60.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Plan the Terraform run

Terraform needs to generate an execution plan before it can create infrastructure. You can generate the plan using the following command:

```bash
terraform plan
```

Take time to look at the plan with care and understand it.

### Apply the Terraform configuration

If the execution plan matches our desired state, you can **apply** it using the following command:

```bash
terraform apply
```

The output shows the execution plan again and will prompt you for approval before proceeding. If everything looks fine, type `yes` at the confirmation prompt to proceed.

(az storage account list --query "[?contains(name, '0terraform0dev0stac')]" | ConvertFrom-Json).Length -gt 0

# Ideen

IDEAS
DATA
OUTPUT
INPUT
RANDOM Provider z. b. Storage Account
EVTL. lower function

## Bonus

Migrate the State to Azure
SQL Database + Key Vault + Connection Strings
