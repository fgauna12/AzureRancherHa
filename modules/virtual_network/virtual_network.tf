resource "azurerm_virtual_network" "virtual_network" {
  name                = local.virtual_network_name
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group

  tags = var.tags
}

resource "azurerm_subnet" "rancher_subnet" {
  name                 = local.rancher_subnet_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.rancher_subnet_cidr]

  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = local.bastion_subnet_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.bastion_subnet_cidr]
}

