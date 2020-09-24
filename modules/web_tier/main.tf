terraform {
  required_providers {
    azurerm = {
      version = "~> 2.23"
    }
  }
}

locals {
  vm_name = "vm${var.app_name}001"
}
