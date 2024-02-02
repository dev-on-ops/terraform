# resources/main.tf

provider "azurerm" {
  # Configure the Azure provider here
}

variable "resource_group_name" {
  description = "Name of the resource group where resources will be created"
}

variable "location" {
  description = "Azure region where resources will be created"
}

variable "shared_image_gallery_name" {
  description = "Name of the shared image gallery"
}

variable "image_publisher" {
  description = "Publisher of the image to use for the VM scale set"
}

variable "image_offer" {
  description = "Offer of the image to use for the VM scale set"
}

variable "image_sku" {
  description = "SKU of the image to use for the VM scale set"
}

variable "vm_scale_set_name" {
  description = "Name of the virtual machine scale set"
}

resource "azurerm_shared_image_gallery" "sig" {
  name                = var.shared_image_gallery_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_shared_image" "shared_image" {
  name                = "shared-image"
  gallery_name        = azurerm_shared_image_gallery.sig.name
  resource_group_name = azurerm_shared_image_gallery.sig.resource_group_name
  location            = var.location
  os_type             = "Linux"
  os_state            = "Generalized"

  # You can customize image creation options here, such as managed_image_name, image_publisher, image_offer, image_sku, etc.
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = var.vm_scale_set_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_DS1_v2"
  instances           = 1

  virtual_machine_profile {
    storage_image_reference {
      id = azurerm_shared_image.shared_image.id
    }

    network_interface {
      name    = "nic"
      primary = true
    }
  }
}
