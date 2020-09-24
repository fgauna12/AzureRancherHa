resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "vmss-${var.app_name}001"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Standard_DS2_v2"
  instances           = var.instances
  admin_username      = var.vm_admin_username

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-vmss-${var.app_name}001"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.rancher_subnet.id
    }
  }

  tags = var.tags
}

resource "azurerm_storage_account" "vm_storage_account" {
  name                     = "st${var.app_name}001"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}