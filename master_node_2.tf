resource "azurerm_network_interface" "nic2" {
  name                = "nic-vnet-${var.environment}-${local.app_name}2"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "public" 
    subnet_id                     = azurerm_subnet.main_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip2.id
  }  

  tags = var.tags
}

resource "azurerm_public_ip" "pip2" {
  name                    = "pip-${local.app_name}2-${var.environment}"
  location                = azurerm_resource_group.resource_group.location
  resource_group_name     = azurerm_resource_group.resource_group.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30  

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "${var.vm_name}2"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  size                = "Standard_DS2_v2"
  admin_username      = var.vm_admin_username
  network_interface_ids = [
    azurerm_network_interface.nic2.id,
  ]

  custom_data = base64encode(data.template_file.cloud_init.rendered)
  availability_set_id = azurerm_availability_set.availability_set.id

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm_storage_account.primary_blob_endpoint
  }

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = var.tags
}