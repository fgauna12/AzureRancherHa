resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-${var.environment}-${var.app_name}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group

  tags = var.tags
}

resource "azurerm_subnet" "main_subnet" {
  name                 = "subnet1"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefix       = "10.0.2.0/24" 

  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_storage_account" "vm_storage_account" {
  name                     = "st${var.app_name}001"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}