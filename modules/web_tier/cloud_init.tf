# this apparently got deprecated recently
data "template_file" "cloud_init" {
  template = file("./cloud-init.tmpl.yaml")
  vars = {
    connection_string = var.database_connection_string
    rancher_hostname = var.rancher_hostname
  }
}