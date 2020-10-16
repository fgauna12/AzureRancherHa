output "rancher_subnet_name" {
    value = local.rancher_subnet_name
}

output "rancher_subnet_id" {
    value = azurerm_subnet.rancher_subnet.id
}

output "bastion_subnet_id" {
    value = azurerm_subnet.bastion_subnet.id
}

output "name" {
    value = local.virtual_network_name
}