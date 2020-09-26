# this apparently got deprecated recently
data "template_file" "cloud_init" {
  template = var.cloud_init_file
  vars = {
    connection_string = var.database_connection_string
    rancher_hostname  = var.rancher_hostname
    rancher_ext_ip    = azurerm_public_ip.pip_lb.ip_address
    username          = var.vm_admin_username
  }
}
