# Stage 1: shared_image_gallery.tf

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

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_shared_image_gallery" "example" {
  name                = var.packer_image_gallery_name
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
}

resource "azurerm_shared_image" "example" {
  name                = var.packer_image_definition_name
  resource_group_name = azurerm_resource_group.example.name
  gallery_name        = azurerm_shared_image_gallery.example.name
  location            = var.location
}
