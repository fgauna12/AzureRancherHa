resource "azurerm_public_ip" "pip_lb" {
  name                = "pip-${var.app_name}lb-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku = "Standard"

  domain_name_label = "rancherlabha"

  tags = var.tags
}

resource "azurerm_lb" "lb" {
  name                = "lbe-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"


  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip_lb.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "vmss-backend-address-pool"
}

resource "azurerm_lb_probe" "http_probe" {
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "http"
  port                = 80
  protocol            = "tcp"
}

resource "azurerm_lb_rule" "http_rule" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.http_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_pool.id
}


resource "azurerm_lb_probe" "https_probe" {
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "https"
  port                = 443
  protocol            = "tcp"
}


resource "azurerm_lb_rule" "https_rule" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "https-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.https_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_pool.id
}

resource "azurerm_lb_probe" "kubernetes_api_probe" {
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "kubernetes_api_probe"
  port                = 6443
  protocol            = "tcp"
}

resource "azurerm_lb_rule" "kubernetes_api_rule" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "kube-api-rule"
  protocol                       = "Tcp"
  frontend_port                  = 6443
  backend_port                   = 6443
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.kubernetes_api_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_pool.id
}
