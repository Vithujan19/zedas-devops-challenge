# ZEDAS DevOps Homework Challenge

## Overview

This project provisions a minimal and repeatable Azure-based demo customer environment using Infrastructure-as-Code and configuration management principles.

The environment includes:

- Azure Resource Group
- Virtual Network and Subnet
- Network Security Group (NSG)
- Ubuntu 22.04 Linux Virtual Machine
- Docker installation
- Containerized `nginx:alpine` web application
- GitHub Actions CI pipeline for Terraform validation and security checks

The goal of this implementation is to demonstrate clean infrastructure provisioning, security-conscious configuration, automation practices, and operational documentation.

---

# Architecture

```text
Internet
   |
Public IP
   |
Network Security Group
   |
Ubuntu 22.04 VM
   |
Docker Engine
   |
nginx:alpine container
```

---

# Repository Structure

```text
.
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── outputs.tf
│
├── ansible/
│   ├── inventory.ini
│   ├── ansible.cfg
│   └── playbook.yml
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── .gitignore
└── README.md
```

---

# Technologies Used

- Terraform
- Ansible
- GitHub Actions
- Microsoft Azure
- Docker
- Ubuntu 22.04 LTS

---

# Prerequisites

Before deployment, ensure the following tools are installed:

- Terraform
- Azure CLI
- Ansible
- Git
- SSH key pair

---

# Azure Authentication

Login to Azure before running Terraform:

```bash
az login
```

Verify the correct subscription

---

# SSH Key Preparation

Generate SSH key if not already available:

```bash
ssh-keygen -t rsa -b 4096
```

Default public key path:

```text
~/.ssh/id_rsa.pub
```

---

# Deployment Steps

## 1. Clone Repository

```bash
git clone https://github.com/Vithujan19/zedas-devops-challenge.git
cd zedas-devops-challenge
```

---

## 2. Configure Terraform Variables

Update values inside `terraform.tfvars`:

```hcl
customer_name   = "zedas-demo"
az_region       = "germanywestcentral"
vm_size         = "Standard_B1s"
admin_username  = "zedasadmin"
public_key_path = "~/.ssh/id_rsa.pub"
allowed_ssh_ip  = "YOUR_PUBLIC_IP/32"
environment     = "dev"
```

Replace `YOUR_PUBLIC_IP` with your current public IP address.

---

## 3. Initialize Terraform

```bash
terraform init
```

---

## 4. Validate Terraform Configuration

```bash
terraform validate
```

---

## 5. Review Execution Plan

```bash
terraform plan -var-file="terraform.tfvars"
```

---

## 6. Deploy Infrastructure

```bash
terraform apply -var-file="terraform.tfvars"
```

Type:

```text
yes
```

when prompted.

---

# Accessing the VM

Retrieve outputs:

```bash
terraform output
```

SSH into the VM:

```bash
ssh azureuser@<PUBLIC_IP>
```

---

# Run Ansible Playbook

Move to ansible directory:

```bash
cd ../ansible
```

Update `inventory.ini` with VM public IP.

Run playbook:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

---

# Verify nginx Deployment

Open browser:

```text
http://<PUBLIC_IP>
```

You should see the default nginx welcome page.

---

# CI Pipeline

GitHub Actions workflow automatically runs on pull requests and pushes to `main`.

Checks included:

- `terraform fmt -check`
- `terraform validate`
- `tflint`
- `checkov` security scan

Workflow location:

```text
.github/workflows/ci.yml
```

---

# Destroying Infrastructure

To avoid unnecessary Azure costs, destroy resources after testing.

From `terraform/` directory:

```bash
terraform destroy -var-file="terraform.tfvars"
```

Type:

```text
yes
```

when prompted.

---

# Notes

This project was designed as a lightweight demonstration environment focused on simplicity, maintainability, and operational clarity rather than full production-scale implementation.

Infrastructure is intentionally minimal to align with the exercise scope and expected implementation time.

---

# Author

Vithujan Sundaramoorthy