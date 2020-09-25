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
  app_name      = "rancher"
  database_name = "rancher"
  location      = "eastus"
  environment   = "prod"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${local.app_name}-${var.environment}-001"
  location = var.location

  tags = var.tags
}

module "virtual_network" {
  source = "./modules/virtual_network"

  app_name            = local.app_name
  resource_group      = azurerm_resource_group.resource_group.name
  environment         = var.environment
  location            = var.location
  address_space       = "10.0.0.0/16"
  rancher_subnet_cidr = "10.0.2.0/24"

  tags = var.tags
}

module "mysql" {
  source = "./modules/mysql"

  server_name          = local.app_name
  database_name        = local.database_name
  resource_group       = azurerm_resource_group.resource_group.name
  environment          = var.environment
  location             = var.location
  mysql_admin_username = var.mysql_admin_username
  mysql_admin_password = var.mysql_admin_password

  tags = var.tags
}

module "web_tier" {
  source = "./modules/web_tier"

  tags                           = var.tags
  app_name                       = local.app_name
  resource_group                 = azurerm_resource_group.resource_group.name
  environment                    = var.environment
  location                       = var.location
  database_connection_string     = "mysql://${var.mysql_admin_username}@${module.mysql.server_name}:${var.mysql_admin_password}@tcp(${module.mysql.fqdn}:3306)/${local.database_name}?tls=true"
  rancher_hostname               = var.rancher_hostname
  instances                      = 2
  virtual_network_name           = module.virtual_network.name
  rancher_subnet_name            = module.virtual_network.rancher_subnet_name
  virtual_network_resource_group = azurerm_resource_group.resource_group.name

  vm_admin_username = var.vm_admin_username
}

# resource "azurerm_mysql_firewall_rule" "mysql_allow_rancher_server" {
#   name                = "rancher_server"
#   resource_group_name = azurerm_resource_group.example.name
#   server_name         = azurerm_mysql_server.example.name
#   start_ip_address    = "0.0.0.0"
#   end_ip_address      = "0.0.0.0"
# }
