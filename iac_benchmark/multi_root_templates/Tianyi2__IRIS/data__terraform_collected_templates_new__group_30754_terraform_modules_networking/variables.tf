variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  validation {
    condition     = length(var.name_prefix) <= 10
    error_message = "Name prefix must be 10 characters or less."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aks_subnet_cidr" {
  description = "CIDR block for the AKS subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "database_subnet_cidr" {
  description = "CIDR block for the database subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_endpoints_subnet_cidr" {
  description = "CIDR block for the private endpoints subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "app_gateway_subnet_cidr" {
  description = "CIDR block for the Application Gateway subnet (referenced in NSG rules)"
  type        = string
  default     = "10.0.4.0/24"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
