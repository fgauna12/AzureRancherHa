# AzureRancherHa
A reference architecture for running Rancher using k3s on Azure with availability zones


## Pre-Requisites
1. Terraform
2. Azure CLI
3. Helm
4. Kubectl

> :warning: The Terraform state file will be local. Don't commit it to source control.


## Getting Started

```bash

$ export TF_VAR_mysql_admin_password="[SOME PASSWORD]"

$ terraform init

$ terraform plan

$ terrafom apply

```

See known issues below for MYSQL firewall

Download the kubeconfig file to your workstation.

scp adminuser@[ip address]:/etc/rancher/k3s/k3s.yaml ~/.kube/config


## Known Issues

First time you run, you will have to ssh to get added to the trusted hosts list. Then run `terraform apply` again

Have to manually (portal) add a firewall rule to the database to allow traffic from the subnet. Also will force you to add a service endpoint from the subnet.


