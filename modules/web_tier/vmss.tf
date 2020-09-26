resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "vmss-${var.app_name}001"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Standard_DS2_v2"
  instances           = var.instances
  admin_username      = var.vm_admin_username
  upgrade_mode        = "Automatic"
  health_probe_id     = azurerm_lb_probe.http_probe.id
  custom_data         = base64encode(data.template_file.cloud_init.rendered)

  automatic_os_upgrade_policy {
    disable_automatic_rollback  = false
    enable_automatic_os_upgrade = true
  }

  automatic_instance_repair {
    enabled      = true
    grace_period = "PT30M"
  }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 50
    max_unhealthy_instance_percent          = 50
    max_unhealthy_upgraded_instance_percent = 50
    pause_time_between_batches              = "PT1M"
  }

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file("~/.ssh/azure-keys/rancher-lab.pub")
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
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.rancher_subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
    }
  }

  tags = var.tags
}
