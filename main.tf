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
  app_name            = "rancher"
  mysql_server_name   = local.app_name
  database_name       = "rancher"
  location            = "eastus"
  environment         = "prod"
  address_space       = "10.0.0.0/16"
  rancher_subnet_cidr = "10.0.2.0/24"
  bastion_subnet_cidr = "10.0.4.0/24"
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
  address_space       = local.address_space
  rancher_subnet_cidr = local.rancher_subnet_cidr
  bastion_subnet_cidr = local.bastion_subnet_cidr

  tags                = var.tags
}

module "mysql" {
  source = "./modules/mysql"

  server_name          = local.mysql_server_name
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

  app_name                   = local.app_name
  resource_group             = azurerm_resource_group.resource_group.name
  environment                = var.environment
  location                   = var.location
  database_connection_string = "mysql://${var.mysql_admin_username}@${module.mysql.server_name}:${var.mysql_admin_password}@tcp(${module.mysql.fqdn}:3306)/${local.database_name}?tls=true"
  rancher_hostname           = var.rancher_hostname
  instances                  = 2
  rancher_subnet_id          = module.virtual_network.rancher_subnet_id
  cloud_init_file            = file("./cloud-init.tmpl.yaml")
  vm_admin_username          = var.vm_admin_username
  zones = var.zones

  tags                       = var.tags
}


resource "azurerm_mysql_virtual_network_rule" "mysql_allow_rancher_subnet" {
  name                = "mysql-vnet-rule"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = module.mysql.server_name
  subnet_id           = module.virtual_network.rancher_subnet_id
}

module "bastion" {
  source = "./modules/bastion"

  resource_group    = azurerm_resource_group.resource_group.name
  vm_admin_username = var.vm_admin_username
  environment       = var.environment
  location          = var.location
  subnet_id         = module.virtual_network.bastion_subnet_id

  tags              = var.tags
}
