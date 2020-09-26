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

Install Rancher server through Helm

