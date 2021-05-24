# Terraform hands-on repository

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

## Challenge 2

### Authenticate to Azure

To create infrastructure in Azure, Terraform needs to be authenticated against Azure. To sign in to Azure, run the Azure CLI `login` command:

```bash
az login
```

Then sign in with your account credentials in the browser.

### Create the initial configuration

## Bonus
