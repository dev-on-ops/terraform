terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">= 0.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "azuredevops" {
}
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
}

variable "packer_image_gallery_name" {
  description = "The name of the shared image gallery to store the Packer image."
  type        = string
}

variable "packer_image_definition_name" {
  description = "The name of the image definition in the shared image gallery."
  type        = string
}

resource "azurerm_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_F2"
  instances           = 2

  storage_profile_image_reference {
    id = azurerm_shared_image.example.id
  }

  network_profile {
    # Define network settings here
  }

  extension {
    name                 = "Microsoft.Compute.VMAccessAgent"
    publisher            = "Microsoft.Compute"
    type                 = "VMAccessAgent"
    type_handler_version = "2.0"
    auto_upgrade_minor_version = true

    settings = <<SETTINGS
    {
        "enableAutomaticUpdates": true,
        "protectedSettings": {
            "username": "adminuser",
            "password": "ExamplePassword123"
        }
    }
    SETTINGS
  }

  depends_on = [azurerm_shared_image.example]
}

resource "azuredevops_elastic_pool" "example" {
  name                = "example-pool"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = 2  # Number of agents in the pool
  sku                 = "Standard_D2s_v3"
  virtual_machine_scale_set_id = azurerm_virtual_machine_scale_set.example.id
}
