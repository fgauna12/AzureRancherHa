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

variable "instances" {
  type = number
}

variable "rancher_subnet_id" {
  type = string
}

variable "cloud_init_file" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "ssh_public_key_path" {
  type = string
  default = "~/.ssh/azure-keys/rancher-lab.pub"
}