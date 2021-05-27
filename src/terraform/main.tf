terraform {
  required_version = ">= 0.15.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}



variable "purpose" {
  type = string
}

locals {
  initials = "mbr" # must be lower case
  owner    = "Martin Brandl"
}

provider "azurerm" {
  skip_provider_registration = true
  features {
  }
}

resource "random_password" "password" {
  length  = 16
  special = true
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
  tags = {
    "Environment" = "DEV"
    "Purpose"     = var.purpose
  }
}

output "stac_resource_id" {
  value     = azurerm_storage_account.stac.id
  sensitive = false
}

resource "azurerm_mssql_server" "sql" {
  name                         = "mbr-sql-server"
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = data.azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = lower("MArtin")
  administrator_login_password = random_password.password.result
}

resource "azurerm_key_vault" "kv" {
  name                        = "mbr-terraform-kv"
  resource_group_name         = data.azurerm_resource_group.rg.name
  location                    = data.azurerm_resource_group.rg.location
  enabled_for_disk_encryption = true
  # tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault_secret" "kv_db_name" {
  name         = "sql_name"
  value        = azurerm_mssql_server.sql.administrator_login
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "kv_db_password" {
  name         = "sql_pwd"
  value        = azurerm_mssql_server.sql.administrator_login_password
  key_vault_id = azurerm_key_vault.kv.id
}
