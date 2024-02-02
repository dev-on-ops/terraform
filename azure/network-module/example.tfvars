network_config = {
  example_network1 = {
    resource_group_name  = "example-rg1"
    location             = "East US"
    virtual_network_name = "example-vnet1"
    address_space        = ["10.0.0.0/16"]
    subnets = [
      {
        name           = "subnet1"
        address_prefix = "10.0.1.0/24"
      },
      {
        name           = "subnet2"
        address_prefix = "10.0.2.0/24"
      },
    ]
  },
  example_network2 = {
    resource_group_name  = "example-rg2"
    location             = "West US"
    virtual_network_name = "example-vnet2"
    address_space        = ["10.1.0.0/16"]
    subnets = [
      {
        name           = "subnet3"
        address_prefix = "10.1.1.0/24"
      },
      {
        name           = "subnet4"
        address_prefix = "10.1.2.0/24"
      },
    ]
  }
}
