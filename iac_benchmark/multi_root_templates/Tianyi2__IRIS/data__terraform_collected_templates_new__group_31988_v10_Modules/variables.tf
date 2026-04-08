variable "resource_group_name" {
  description = "Name of resource group"
  type        = string
  default     = "WebServices"
}

variable "resource_location" {
  description = "Location of resources"
  type        = string
}

variable "network_name" {
  description = "Name of network"
  type        = string
  default     = "WebServicesNetwork"
}

variable "subnet_name" {
  description = "Name of subnet"
  type        = string
  default     = "WebServicesSubnet"
}

variable "resource_name" {
  description = "Name of vm"
  type        = string
}

variable "resource_size" {
  description = "Size of vm"
  type        = string
}

variable "vm_disk_size" {
  description = "Size of vm disk"
  type        = string
  default     = "32"
}

variable "vm_disk_type" {
  description = "Type of vm disk"
  type        = string
  default     = "Standard_LRS"
}

variable "vm_sku" {
  description = "Size of vm"
  type        = string
  default     = "2019-Datacenter-smalldisk"
}

variable "resource_instance_count" {
  description = "Number of vms to deploy"
  type        = string
}

variable "vm_fault_domain" {
  description = "Number of fault domains for VM"
  type        = string
  default     = 2
}

variable "admin_username" {
  description = "Desired username for the provisioned resources"
  type        = string
  default     = "Wesley"
}

variable "vm_environment" {
  description = "Environment of vm"
  type        = string
  default     = "Production"
}

variable "network_address" {
  description = "Network address space"
  type        = string
}