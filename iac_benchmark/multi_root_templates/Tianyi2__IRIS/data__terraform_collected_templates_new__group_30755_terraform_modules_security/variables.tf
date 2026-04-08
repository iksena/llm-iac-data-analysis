variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  
  validation {
    condition     = length(var.name_prefix) >= 2 && length(var.name_prefix) <= 10
    error_message = "Name prefix must be between 2 and 10 characters."
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

variable "vnet_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "private_endpoints_subnet_id" {
  description = "ID of the private endpoints subnet"
  type        = string
}

# Security configuration variables
variable "allow_public_access" {
  description = "Allow public network access to Key Vault"
  type        = bool
  default     = false
}

variable "allowed_ip_ranges" {
  description = "List of allowed IP ranges for Key Vault access"
  type        = list(string)
  default     = []
}

variable "allowed_subnet_ids" {
  description = "List of allowed subnet IDs for Key Vault access"
  type        = list(string)
  default     = []
}

variable "enable_purge_protection" {
  description = "Enable purge protection for Key Vault"
  type        = bool
  default     = false # Set to true for production
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted items"
  type        = number
  default     = 7
  
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention must be between 7 and 90 days."
  }
}

variable "database_fqdn" {
  description = "Fully qualified domain name of the Azure SQL server (e.g., server.database.windows.net)"
  type        = string
  default     = "placeholder.database.windows.net"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
