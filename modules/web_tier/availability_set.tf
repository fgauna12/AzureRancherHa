resource "azurerm_availability_set" "availability_set" {
  name                = "avail-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group

  tags = var.tags
}