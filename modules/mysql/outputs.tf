output "server_name" {
    value = azurerm_mysql_server.mysql.name
}

output "fqdn" {
    value = azurerm_mysql_server.mysql.fqdn
}