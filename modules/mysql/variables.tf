variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "server_name" {
  type = string
}

variable "database_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type = map
}

variable "mysql_admin_username" {
  type = string
}

variable "mysql_admin_password" {
  type = string
}