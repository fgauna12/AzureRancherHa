resource "azurerm_network_security_group" "nsg_rancher_subnet" {
  name                = "nsg-rancher"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "AllowHttpAndKubeApi"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443", "6443"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowLoadBalancerProbes"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443", "6443"]
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
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = var.bastion_subnet_cidr
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_rancher_subnet_association" {
  subnet_id                 = azurerm_subnet.rancher_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_rancher_subnet.id
}

resource "azurerm_network_security_group" "nsg_mgnt_subnet" {
  name                = "nsg-mgnt-subnet"
  location            = var.location
  resource_group_name = var.resource_group

    security_rule {
    name                       = "AllowSshRdp"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_bastion_subnet_association" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_mgnt_subnet.id
}
