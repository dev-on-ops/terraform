provider "azurerm" {
  features {}
}

variable "storage_accounts" {
  description = "A map of objects containing storage account configurations."
  type = map(object({
    resource_group_name      = string
    location                 = string
    storage_account_name     = string
    storage_account_tier     = string
    storage_account_replication_type = string
    containers = map(object({
      public_access_level = string
    }))
  }))
}

resource "azurerm_storage_account" "example" {
  for_each                = var.storage_accounts
  name                     = each.value.storage_account_name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.storage_account_tier
  account_replication_type = each.value.storage_account_replication_type
}

resource "azurerm_storage_container" "example" {
  for_each            = { for name, config in var.storage_accounts : name => config.containers }
  name                = each.key
  storage_account_name = azurerm_storage_account.example[each.key].name
  for_each            = each.value
  container_access_type = each.value.public_access_level
}
