provider "azurerm" {
  features {}
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-cluster"
  location            = "East US"
  resource_group_name = "example-resources"
  dns_prefix          = "example-cluster"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_DS2_v2"
    os_disk_size_gb = 30
  }

  network_profile {
    network_plugin = "azure"
  }

  private_cluster_enabled = true

  private_link_enabled = true

  private_link_subnet_id = "ID_OF_PRIVATE_SUBNET"
}

resource "azurerm_kubernetes_cluster_node_pool" "additional_pool" {
  name                  = "additional-pool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.example.id
  node_count            = 3
  vm_size               = "Standard_DS2_v2"
  os_disk_size_gb       = 30
  subnet_id             = "ID_OF_ANOTHER_SUBNET"
}
