terraform {
  required_providers {
    azurerm = {
      version = "~> 2.23"
    }
  }
}

locals {
  virtual_network_name = "vnet-${var.environment}-${var.app_name}"
  rancher_subnet_name = "rancher"
}