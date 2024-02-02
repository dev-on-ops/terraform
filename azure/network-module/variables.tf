# networks/variables.tf

variable "network_config" {
  description = "Map containing the configuration for the virtual network and subnets"
  type        = map(object({
    resource_group_name  = string
    location             = string
    virtual_network_name = string
    address_space        = list(string)
    subnets              = list(object({
      name           = string
      address_prefix = string
    }))
  }))
}
