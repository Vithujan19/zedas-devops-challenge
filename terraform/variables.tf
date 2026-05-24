variable "customer_name" {
  type        = string
  description = "The name of the logistics/railway customer (used for naming resources)"
}

variable "az_region" {
  type        = string
  default     = "germanywestcentral"
  description = "The Azure region for the deployment"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1s"
  description = "The low-cost SKU size for the demo Linux VM"
}

variable "admin_username" {
  type        = string
  default     = "zedasadmin"
  description = "Admin username for the VM"
}

variable "public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to the SSH public key for VM access"
}

variable "allowed_ssh_ip" {
  type        = string
  description = "Your current public IP address to lock down SSH access (CIDR format, e.g., 203.0.113.50/32)"
}