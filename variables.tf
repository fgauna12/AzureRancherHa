variable "location" {
  type = string
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
