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

variable "address_space" {
  type = string
  default = "10.0.0.0/16"
}

variable "rancher_subnet_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "bastion_subnet_cidr" {
  type = string
  default = "10.0.4.0/24"
}

