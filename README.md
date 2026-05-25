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

change directory to terraform

```bash
cd terraform
```

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

# Accessing the VM (If needed)

Retrieve VM Public IP(PUBLIC_IP):

SSH into the VM:

```bash
ssh azureuser@<PUBLIC_IP>
```

---

# Run Ansible Playbook

Move to ansible directory:

```bash
cd ansible
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

# Operational Runbook

## Scenario: VM Is Unreachable

Recommended troubleshooting steps:

1. Verify VM provisioning state in Azure Portal
2. Confirm VM is powered on
3. Verify Public IP is attached correctly
4. Check NSG inbound rules for SSH and HTTP
5. Ensure current public IP matches `allowed_ssh_ip`
6. Test SSH connectivity:
   ```bash
   nc -zv <PUBLIC_IP> 22
   ```
7. Verify subnet and routing configuration
8. Check UFW firewall status on VM
9. Verify SSH service status:
   ```bash
   systemctl status ssh
   ```

---

# Security Considerations

This implementation includes several basic security measures:

- SSH password authentication disabled
- SSH key-based authentication enabled
- SSH access restricted to trusted public IP
- Minimal inbound ports exposed
- UFW firewall enabled
- No secrets committed into repository

---

# Design Decisions

## Why Terraform?

Terraform was selected for Infrastructure-as-Code because it provides:

- declarative infrastructure provisioning
- reusable configuration
- consistent deployments
- easy teardown and recreation

---

## Why Ansible?

Ansible was used for configuration management because it provides:

- agentless automation
- idempotent configuration
- clean separation between infrastructure and OS/application setup

---

## Why Subnet-Level NSG Association?

Initially, the NSG was associated directly with the network interface. After reviewing Checkov findings, the implementation was improved by associating the NSG at subnet level instead.

This provides:
- centralized network security management
- consistent policy enforcement
- easier scalability for future resources within the subnet

---

# Trade-offs and Next Steps

Given additional time, the following improvements would be implemented.

## Infrastructure Improvements

- Configure remote Terraform backend using Azure Storage Account
- Enable Terraform state locking
- Introduce reusable Terraform modules
- Add environment separation (dev/staging/prod)

---

## Security Improvements

- Replace direct public VM exposure with private subnet architecture
- Use Azure Application Gateway or Load Balancer with HTTPS
- Replace public SSH access with Azure Bastion or VPN
- Enable Microsoft Defender for Cloud
- Add monitoring and alerting

---

## Operational Improvements

- Add VM health monitoring script
- Add centralized logging
- Add Ansible linting into CI pipeline
- Add automated backup policies

---

# Checkov Findings and Accepted Trade-offs

Some Checkov findings related to public IP usage and HTTP exposure are intentionally accepted because the homework challenge explicitly requires:

- a public IP
- a reachable nginx web service

SSH access is restricted to a trusted administrative IP using NSG rules.

In production environments, the VM would typically be deployed in a private subnet behind Application Gateway or Load Balancer with HTTPS termination.

---

# Notes

This project was designed as a lightweight demonstration environment focused on simplicity, maintainability, and operational clarity rather than full production-scale implementation.

Infrastructure is intentionally minimal to align with the exercise scope and expected implementation time.

---

# Author

Vithujan Sundaramoorthy