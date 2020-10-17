output "public_ip" {
    value = module.web_tier.public_ip
}

output "bastion_public_ip" {
    value = module.bastion.bastion_public_ip
}