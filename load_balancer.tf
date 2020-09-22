resource "azurerm_public_ip" "pip_lb" {
  name                = "pip-${local.app_name}lb-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"

  domain_name_label = "rancherlabha"

  tags = var.tags
}

resource "azurerm_lb" "lb" {
  name                = "lbe-${local.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip_lb.id
  }

  tags = var.tags
}

# resource "azurerm_lb_probe" "http_probe" {
#   resource_group_name = azurerm_resource_group.resource_group.name
#   loadbalancer_id     = azurerm_lb.lb.id
#   name                = "http"
#   port                = 80
#   protocol = "http"
# }

resource "azurerm_lb_probe" "https_probe" {
  resource_group_name = azurerm_resource_group.resource_group.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "https"
  port                = 443
  protocol = "tcp"
}

resource "azurerm_lb_probe" "kubernetes_api_probe" {
  resource_group_name = azurerm_resource_group.resource_group.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "kubernetes_api_probe"
  port                = 6443
  protocol = "tcp"
}

resource "azurerm_lb_rule" "kubernetes_api_rule" {
  resource_group_name            = azurerm_resource_group.resource_group.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "kube-api-rule"
  protocol                       = "Tcp"
  frontend_port                  = 6443
  backend_port                   = 6443
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id = azurerm_lb_probe.kubernetes_api_probe.id
}