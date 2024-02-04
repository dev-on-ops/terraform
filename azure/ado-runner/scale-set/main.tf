# Stage 3: vmss.tf

provider "azurerm" {
  features {}
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
}
