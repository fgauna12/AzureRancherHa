variable "location" {
  type = string
}

variable "organization_name" {
  type = string
}

variable "app_name" {
  type = string
  default = "rancher"
}

variable "environment" {
  type = string
}

variable "vm_admin_username" {
  type = string
}

variable "mysql_admin_username" {
  type = string
}

variable "mysql_admin_password" {
  type = string
}

variable "rancher_hostname" {
  type = string
}

variable "tags" {
  type = map
  default = {}
}

variable "zones" {
  type = list(string)
  default = ["1", "2"]
}

variable "ssh_public_key_path" {
  type = string
  default = "~/.ssh/azure-keys/rancher-lab.pub"
}

variable "virtual_network_address_space" {
  type = string
  default = "10.0.0.0/16"
}

variable "virtual_network_rancher_subnet" {
  type = string
  default = "10.0.2.0/24"
}

variable "virtual_network_bastion_subnet" {
  type = string
  default = "10.0.4.0/24"
}
 
