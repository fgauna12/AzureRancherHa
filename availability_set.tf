resource "azurerm_availability_set" "availability_set" {
  name                = "avail-${local.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = var.tags
}