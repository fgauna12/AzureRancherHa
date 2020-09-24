output "public_ips" {
    value = module.web_tier.public_ips
}

output "private_ips" {
    value = module.web_tier.private_ips
}

output "mysql_fqdn" {
    value = module.mysql.fqdn
}

output "public_ips2" {
    value = module.web_tier.public_ips2
}

output "private_ips2" {
    value = module.web_tier.private_ips2
}