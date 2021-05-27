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

### Verify Challange 1

You can verify whether you passed the first challenge by running the `Test challenge 1` VSCode Task.

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
      version = ">= 2.60.0"
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
  account_replication_type = "GRS"
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

### Verify Challange 2

Verify whether you passed the second challenge by running the `Test challenge 2` VSCode Task.

## Challange 3 - Change the configuration

In this challange you will modify the infrastructure you have created previously. Terraform builds an execution plan by comparing your desired state as described in the configuration to the current state, which is saved in the `terraform.tfstate` file.

### Add a tag to the storage account and change the SKU

Modify the `main.tf` configuration so that the storage account contains the following two [tags](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources?WT.mc_id=AZ-MVP-5003203):

- `Environment`: **DEV**
- `Purpose`: **Handson**

> 💡 You will find samples how to create tags within the [Terraform Azure Provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs). You can also make use of the auto completion that comes with the Terraform VSCode extension. It is realy simple!

Now change the storage account `account_replication_type` from `GRS` to `LRS`.

### Plan Terraform configuration change and apply it

This time you will use `-out` parameter to write the terraform plan to a file (e. g. `terraform plan -out tf.plan`). Take your time to study the execution plan before you apply the changes using `terraform apply tf.plan`!

### Verify Challange 3

Verify whether you passed the third challenge by running the `Test challenge 3` VSCode Task.

## Challange 4 - Input and Output Variables

### Introduce an input variable

Hardcoding values in your configuration is not a long-term pattern for success. In this challenge you will introduce input variables and use it within your configuration (`main.tf`). Your task is to make the value of the `Purpose` storage account tag variable and pass the value `Demo` to it when you apply the changes with `terraform plan`.

> 💡 Read more about [Input Variables](https://www.terraform.io/docs/language/values/variables.html) and [Variable Definitions](https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files)

### Introduce an output variable

You also want to declare an output variable `stac_resource_id` that returns the storage account **resource id**.

> 💡 Read more about [Output Variables](https://www.terraform.io/docs/language/values/outputs.html)

Don't forget to `apply` your changes before you verify the challenge!

### Verify Challange 4

Verify whether you passed the fourth challenge by running the `Test challenge 4` VSCode Task.

## Challange 5 - functions and random provider

In this challenge, you must provision an **Azure SQL Database**. You will use the Terraform [random_password provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) to generate the `administrator_login_password`. The name of the `administrator_login` must be in lowercase. To achieve that, you will use the [`lower` string Function](https://www.terraform.io/docs/language/functions/lower.html).

> 💡 You can find an example of how to create an MS SQL Database [here.](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)

Furthermore you will deploy an **Azure KeyVault** with the name `<INITIALS>-terraform-kv` (e. g. `abc-terraform-kv`) and add two **secrets** to it:

- **Name**: `dbuser` . **Value**: Name of the SQL user
- **Name**: `dbpwd` . **Value**: The corresponding password
  > 💡 You will need to set some permissions to _set_ the secret and _get_ it.

### Verify Challange 5

Verify whether you passed the last challenge by running the `Test challenge 5` VSCode Task.

## Bonus - Migrate the State to Azure storage account

Here you are on your own 🐱‍👤
