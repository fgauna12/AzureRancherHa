terraform {
  required_providers {
    azurerm = {
      version = "~> 2.23"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
    app_name = "rancherlabha"
    database_name = "rancher"
    resource_group_name = "rg-${local.app_name}-${var.environment}-001"
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_group_name
  location =  var.location

  tags = var.tags
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-${var.environment}-${local.app_name}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = var.tags
}

resource "azurerm_subnet" "main_subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefix       = "10.0.2.0/24" 

  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_storage_account" "vm_storage_account" {
  name                     = "st${local.app_name}001"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}