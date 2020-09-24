variable "cloud_init_file" {
  type = string
  default = "cloud-init.tmpl.yaml"
}

variable "app_name" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type = map
}

variable "database_connection_string" {
  type = string
}

variable "rancher_hostname" {
  type = string
}

variable "vm_admin_username" {
  type = string
}