# networks/main.tf

provider "azurerm" {
  # Configure the Azure provider here
}

locals {
  network_configs = var.network_config
}

resource "azurerm_resource_group" "rg" {
  for_each = local.network_configs

  name     = each.value.resource_group_name
  location = each.value.location
}

resource "azurerm_virtual_network" "vnet" {
  for_each = local.network_configs

  name                = each.value.virtual_network_name
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = each.value.location
  address_space       = each.value.address_space
}

resource "azurerm_subnet" "subnet" {
  for_each = { for k, v in local.network_configs : k => v.subnets }

  count               = length(each.value)
  name                = each.value[count.index].name
  resource_group_name = azurerm_resource_group.rg[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes    = [each.value[count.index].address_prefix]
}
