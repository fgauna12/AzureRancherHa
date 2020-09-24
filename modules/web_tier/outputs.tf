output "public_ips" {
    value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "private_ips" {
    value = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "public_ips2" {
    value = azurerm_linux_virtual_machine.vm2.public_ip_address
}

output "private_ips2" {
    value = azurerm_linux_virtual_machine.vm2.private_ip_address
}