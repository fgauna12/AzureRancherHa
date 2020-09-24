# this apparently got deprecated recently
data "template_file" "cloud_init" {
  template = file("./cloud-init.tmpl.yaml")
  vars = {
    connection_string = var.database_connection_string
    rancher_hostname = var.rancher_hostname
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-vnet-${var.environment}-${var.app_name}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "public" 
    subnet_id                     = azurerm_subnet.main_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }  

  tags = var.tags
}

resource "azurerm_public_ip" "pip" {
  name                    = "pip-${var.app_name}-${var.environment}"
  location                = var.location
  resource_group_name     = var.resource_group
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30  

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = local.vm_name
  resource_group_name = var.resource_group
  location            = var.location
  size                = "Standard_DS2_v2"
  admin_username      = var.vm_admin_username
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  custom_data = base64encode(data.template_file.cloud_init.rendered)
  availability_set_id = azurerm_availability_set.availability_set.id

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