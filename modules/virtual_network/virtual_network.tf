resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-${var.environment}-${var.app_name}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group

  tags = var.tags
}

resource "azurerm_subnet" "rancher_subnet" {
  name                 = "rancher"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]

  service_endpoints = ["Microsoft.Sql"]
}

