# Rancher 2.4+ with High Availability on Azure

:warning: This solution will no longer be needed when Rancher 2.5 is labelled "stable". With Rancher 2.5, you can host Rancher on any managed cluster like AKS. AKS supports availability zones as well.

A reference architecture for running Rancher using k3s on Azure with availability zones on Azure.
The goal is to follow best practices for Azure and Rancher. This architecture assumes a [hub/spoke Rancher](https://rancher.com/docs/rancher/v2.x/en/best-practices/deployment-strategies/) topology.

![Diagram of Rancher using a HA set-up on Azure](docs/rancher_ha_azure.png)

## Pre-Requisites
1. Terraform
2. Azure CLI
3. Helm
4. Kubectl

> :warning: The Terraform state file will be local. Don't commit it to source control.

## Features

- Uses a virtual machine scale - [Here's the differences of a VM scale set vs individual VMs](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview#differences-between-virtual-machines-and-scale-sets). Scale set is associated with the load balancer.
- Deploys a sample virtual network - Also deploys two subnets: one for management and one for rancher server.
- Use of Network Security Groups - Attaches network security groups to the subnets. SSH/RDP is only allowed on the management subnet.
- Creates two public IPs - One for the load balancer and one for the bastion box.
- Uses Azure Standard Load Balancer - Standard load balancer can be associated with an availability zone. 
  - :warning: Standard load balancers are secure by default. Meaning, backend pools will only work if the subnet has an NSG attached.
- Creates a MySQL server - The MySQL server is used by k3s as the control plane storage in lieu of etcd. 
  - Also creates a firewall rule so that access to the database is only allowed from the virtual network and therefore not from the public internet.
- Creates a bastion box (aka "jump box") - Admins have to SSH into the bastion box to SSH into the rancher server hosts.
- Uses Terraform to provision all of it.

## Getting Started

Generate a key pair to provision the virtual machine scale set. 
[TODO] - It'd be nice to store the key pair + passphrase on an Azure Key Vault. 

```bash
$ ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "[some email]" \
    -f ~/.ssh/azure-keys/rancher-lab \
    -N [some passphrase]

```

Once key pair is generated, configure a MySQL admin password to create the database server. It cannot be changed later. Create an environment variable so that you don't accidently commit it to source control.
[TODO] - It'd be nice to store the password in a key vault as well.

```
$ export TF_VAR_mysql_admin_password="[SOME PASSWORD]"
```

Change any of the Terraform variables. Here's the current list. 

Now you're ready to plan.
```
$ terraform init

$ terraform plan

```
It will show you what's going to be created. Create the infrastructure using `apply`. Say "yes" on the prompt if everything looks fine.

```
$ terrafom apply
```

After some time, you will see the infracture being created. It will output the Public IP of the load balancer.

Go to your DNS provider and add an A record to the public IP.

SSH into the bastion box. From the bastion box, ssh into one of the control plane nodes. You can get the private IP for one of the nodes by using the Azure portal. Navigate to the _virtual machine scale set_, _click on instance view_, copy the private IP from the top right.

Once in the node, verify that k3s is running. 

``` bash
$ systemctl status k3s.service
```

After some time, the scale set instances should report _Healthy_ too. 

Exit the node. 
From the bastion box, install kubectl and Helm 3. Install Rancher through the Helm chart. The easiest certificate option is through self-signed certificate with cert-manager but that should only be used in prototype scenarios.

Once Rancher is deployed, after a few minutes you can access the Rancher UI using the public IP or the custom domain.


## Variables

| Variable             | Description                                                                                 | Required | Example                             |
|----------------------|---------------------------------------------------------------------------------------------|---------:|-------------------------------------|
| location             | The Azure region to deploy to                                                               |    yes   | `eastus`                            |
| organization_name    | The name of the company. Will be used to create unique FQDNs for resources like MySQL |    yes   | `mycompany`                              |
| app_name          | The name of the app. Will default to `rancher` |    No   | `rancher`                              |
| environment          | The name of the environment. To be used in generating the names of resources via convention |    yes   | `prod`                              |
| vm_admin_username    | The name of the admin username for the virtual machine scale sets.                          |    yes   | `mycompanyadmin`                    |
| mysql_admin_username | The name of the MySQL username for the MySQL PaaS database to be used by k3s                |    yes   | `mycompanyadmin`                    |
| mysql_admin_password | The password of the MySQL admin                                                             |    yes   | `password123`                       |
| rancher_hostname     | The hostname to be used by Rancher                                                          |    yes   | `rancher.mycompanydomain.com`       |
| tags                 | A map of the Azure tags to use                                                              |    No    | `{ "department"  = "engineering" }` |
| zones                | The list of azure availability zones to use                                                 |    No    | `["1", "2"]`                        |
| ssh_public_key_path  | The key to the SSH public key to use to provision the basion and virtual machine scale sets |    No    | `~/.ssh/azure-keys/rancher-lab`     |
| virtual_network_address_space  | The address space of the virtual network to create. A CIDR block. |    No    | `10.0.0.0/16`     |
| virtual_network_rancher_subnet  | The address space of the rancher subnet. A CIDR block. |    No    | `10.0.2.0/24`     |
| virtual_network_bastion_subnet  | The address space of the bastion subnet. A CIDR block. |    No    | `10.0.4.0/24`     |