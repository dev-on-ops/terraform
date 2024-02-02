# networks/main.tf

provider "azurerm" {
  # Configure the Azure provider here
}

locals {
  network_configs = var.network_config
}
locals {
  virtual_network_peerings = flatten([
    for source_network_name, source_network_config in local.network_config : [
      for target_network_name, target_network_config in local.network_config : 
      # Exclude self-peering and existing peerings
      if source_network_name != target_network_name &&
         !contains(target_network_config.peered_with, source_network_name) : {
        source_virtual_network_name    = source_network_config.virtual_network_name
        source_resource_group_name     = source_network_config.resource_group_name
        target_virtual_network_name    = target_network_config.virtual_network_name
        target_resource_group_name     = target_network_config.resource_group_name
        source_address_space           = source_network_config.address_space
        target_address_space           = target_network_config.address_space
        source_to_target_direction     = "bidirectional"
      }
    ]
  ])
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


# Assuming you already have virtual networks created

resource "azurerm_virtual_network_peering" "peering" {
  for_each = {
    for peering in local.virtual_network_peerings : "${peering.source_virtual_network_name}-${peering.target_virtual_network_name}" => peering
  }

  name                         = each.value.source_virtual_network_name != each.value.target_virtual_network_name ? "to-${each.value.target_virtual_network_name}" : null
  resource_group_name          = each.value.source_resource_group_name
  virtual_network_name         = each.value.source_virtual_network_name
  remote_virtual_network_id    = azurerm_virtual_network.target[each.value.target_virtual_network_name].id
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
  allow_virtual_network_access = true
  source_network_security_group_id = null
  remote_network_security_group_id = null
}


locals {
  # Create a list of all network names
  network_names = keys(local.network_config)

  # Create peerings between all networks
  virtual_network_peerings = [
    for source_network_name in local.network_names : 
    for target_network_name in local.network_names :
    if source_network_name != target_network_name : {
      source_virtual_network_name    = local.network_config[source_network_name].virtual_network_name
      source_resource_group_name     = local.network_config[source_network_name].resource_group_name
      target_virtual_network_name    = local.network_config[target_network_name].virtual_network_name
      target_resource_group_name     = local.network_config[target_network_name].resource_group_name
      source_address_space           = local.network_config[source_network_name].address_space
      target_address_space           = local.network_config[target_network_name].address_space
      source_to_target_direction     = "bidirectional"
    }
  ]
}


resource "azurerm_virtual_network_peering" "network_peerings" {
  for_each = { for idx, peering in local.virtual_network_peerings : idx => peering }

  name                         = each.value.source_virtual_network_name != each.value.target_virtual_network_name ? "to-${each.value.target_virtual_network_name}" : null
  resource_group_name          = each.value.source_resource_group_name
  virtual_network_name         = each.value.source_virtual_network_name
  remote_virtual_network_id    = azurerm_virtual_network.target[each.value.target_virtual_network_name].id
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
  allow_virtual_network_access = true
  source_network_security_group_id = null
  remote_network_security_group_id = null
}
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "example" {
  name                = "example-firewall"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  public_ip_address_id = azurerm_public_ip.example.id
}

#############
provider "azurerm" {
  features {}
}

variable "network_config" {
  description = "Configuration for each virtual network"
  type = map(object({
    resource_group_name  = string
    location             = string
    address_space        = list(string)
    subnets              = map(string)
    create_firewall      = bool // Added boolean value for Azure Firewall creation
  }))
  default = {}
}

resource "azurerm_public_ip" "firewall" {
  for_each            = { for name, config in var.network_config : name => config if config.create_firewall }
  name                = "firewall-pubip-${each.key}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  for_each                = { for name, config in var.network_config : name => config if config.create_firewall }
  name                    = "firewall-${each.key}"
  location                = each.value.location
  resource_group_name     = each.value.resource_group_name
  public_ip_address_id    = azurerm_public_ip.firewall[each.key].id
}

resource "azurerm_firewall_network_rule_collection" "firewall_inbound" {
  for_each                = { for name, config in var.network_config : name => config if config.create_firewall }
  name                    = "firewall-inbound-${each.key}"
  resource_group_name     = each.value.resource_group_name
  firewall_name           = azurerm_firewall.firewall[each.key].name

  rule {
    name                     = "AllowAll"
    priority                 = 100
    action                   = "Allow"
    source_address_prefix    = "*"
    destination_address_prefix = "*"
    destination_port_ranges = ["*"]
    protocol                 = "*"
  }
}

resource "azurerm_firewall_network_rule_collection" "firewall_outbound" {
  for_each                = { for name, config in var.network_config : name => config if config.create_firewall }
  name                    = "firewall-outbound-${each.key}"
  resource_group_name     = each.value.resource_group_name
  firewall_name           = azurerm_firewall.firewall[each.key].name

  rule {
    name                     = "AllowInternetOutbound"
    priority                 = 100
    action                   = "Allow"
    source_address_prefix    = "VirtualNetwork"
    destination_address_prefix = "*"
    destination_port_ranges = ["*"]
    protocol                 = "*"
  }
}

output "firewall_ids" {
  value = azurerm_firewall.firewall[*].id
}

##################
provider "azurerm" {
  features {}
}

variable "network_config" {
  description = "Configuration for each virtual network"
  type = map(object({
    resource_group_name  = string
    location             = string
    address_space        = list(string)
    subnets              = map(object({
      address_prefix     = string
    }))
    create_firewall      = bool
  }))
  default = {}
}

locals {
  subnet_route_table_associations = flatten([
    for network_name, network_info in var.network_config : [
      for subnet_name, subnet_info in network_info.subnets : {
        network_name         = network_name
        subnet_name          = subnet_name
        route_table_name     = network_info.create_firewall ? "firewall-route-table-${network_name}-${subnet_name}" : null
      } if network_info.create_firewall
    ]
  ])
}

resource "azurerm_virtual_network" "example" {
  for_each             = var.network_config
  name                 = each.key
  location             = each.value.location
  resource_group_name  = each.value.resource_group_name
  address_space        = each.value.address_space
}

resource "azurerm_subnet" "example" {
  for_each              = { for subnet in local.subnet_route_table_associations : subnet.subnet_name => subnet }
  name                  = each.value.subnet_name
  resource_group_name   = var.network_config[local.subnet_route_table_associations[each.key].network_name].resource_group_name
  virtual_network_name  = azurerm_virtual_network.example[local.subnet_route_table_associations[each.key].network_name].name
  address_prefix        = var.network_config[local.subnet_route_table_associations[each.key].network_name].subnets[each.key].address_prefix
}

resource "azurerm_route_table_association" "example" {
  for_each              = { for subnet in local.subnet_route_table_associations : subnet.subnet_name => subnet }
  subnet_id             = azurerm_subnet.example[each.key].id
  route_table_id        = each.value.route_table_name != null ? azurerm_route_table.example[each.value.route_table_name].id : null
}

resource "azurerm_route_table" "example" {
  for_each              = { for subnet in local.subnet_route_table_associations : subnet.subnet_name => subnet if subnet.route_table_name != null }
  name                  = each.value.route_table_name
  resource_group_name   = var.network_config[local.subnet_route_table_associations[each.key].network_name].resource_group_name
  location              = var.network_config[local.subnet_route_table_associations[each.key].network_name].location

  route {
    name                = "default"
    address_prefix      = "0.0.0.0/0"
    next_hop_type       = "Internet"
  }
}
