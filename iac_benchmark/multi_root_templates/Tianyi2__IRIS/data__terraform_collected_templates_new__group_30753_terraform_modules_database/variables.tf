variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "private_endpoints_subnet_id" {
  description = "ID of the private endpoints subnet"
  type        = string
}

variable "admin_principal_name" {
  description = "Principal name for Azure AD admin"
  type        = string
  default     = "admin@example.com"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
