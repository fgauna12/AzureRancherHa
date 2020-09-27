resource "azurerm_network_security_group" "nsg_rancher_subnet" {
  name                = "nsg-rancher"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "AllowHttp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["80","443"]
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowKubernetesApi"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6443"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSshRdp"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["22","3389"]
    source_address_prefix      = var.bastion_subnet_cidr
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_rancher_subnet_association" {
  subnet_id                 = azurerm_subnet.rancher_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_rancher_subnet.id
}