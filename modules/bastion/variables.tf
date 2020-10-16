variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "vm_admin_username" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "tags" {
  type = map
}

variable "ssh_public_key_path" {
  type = string
  default = "~/.ssh/azure-keys/rancher-lab.pub"
}
