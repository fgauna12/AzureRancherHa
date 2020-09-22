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

resource "azurerm_public_ip" "pip" {
  name                    = "pip-${local.app_name}-${var.environment}"
  location                = azurerm_resource_group.resource_group.location
  resource_group_name     = azurerm_resource_group.resource_group.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30  

  tags = var.tags
}

resource "azurerm_subnet" "main_subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-vnet-${var.environment}-${local.app_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "public" 
    subnet_id                     = azurerm_subnet.main_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }  

  tags = var.tags
}

resource "azurerm_storage_account" "vm_storage_account" {
  name                     = "st${local.app_name}001"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

data "template_file" "cloud_init" {
  template = file("./cloud-init.tmpl.yaml")
  vars = {
    mysql_connection_string = "mysql://${var.mysql_admin_username}@${azurerm_mysql_server.mysql.name}:${var.mysql_admin_password}@tcp(${azurerm_mysql_server.mysql.fqdn}:3306)/${local.database_name}"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  size                = "Standard_DS2_v2"
  admin_username      = var.vm_admin_username
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  custom_data = base64encode(data.template_file.cloud_init.rendered)

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm_storage_account.primary_blob_endpoint
  }

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = var.tags
}