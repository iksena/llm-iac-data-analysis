variable "name_prefix" {
  description = "Prefix for resource names in dev environment"
  type        = string
  default     = "dev-learn"
}

variable "location" {
  description = "Azure region for dev environment"
  type        = string
  default     = "West US 2"
}

variable "vnet_address_space" {
  description = "Address space for dev VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aks_subnet_cidr" {
  description = "CIDR block for the AKS subnet in dev"
  type        = string
  default     = "10.0.1.0/24"
}

variable "database_subnet_cidr" {
  description = "CIDR block for the database subnet in dev"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_endpoints_subnet_cidr" {
  description = "CIDR block for the private endpoints subnet in dev"
  type        = string
  default     = "10.0.3.0/24"
}

variable "app_gateway_subnet_cidr" {
  description = "CIDR block for the Application Gateway subnet in dev"
  type        = string
  default     = "10.0.4.0/24"
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS cluster"
  type        = string
  default     = null # Uses latest supported version
}

variable "enable_monitoring" {
  description = "Enable Azure Monitor for containers and security monitoring"
  type        = bool
  default     = true # Enable by default for security monitoring
}

variable "database_admin_principal" {
  description = "Principal name for Azure SQL Server Azure AD admin"
  type        = string
  default     = "admin@example.com" # Replace with actual admin email in production
}

variable "aks_admin_principal_id" {
  description = "Azure AD principal ID granted AKS admin access"
  type        = string
  default     = "d5e63695-ea02-4219-9447-d0345b5ac50c" # Replace with your principal ID as needed
}

variable "tags" {
  description = "Tags for dev environment resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "azure-enterprise-learning"
    ManagedBy   = "terraform"
  }
}
