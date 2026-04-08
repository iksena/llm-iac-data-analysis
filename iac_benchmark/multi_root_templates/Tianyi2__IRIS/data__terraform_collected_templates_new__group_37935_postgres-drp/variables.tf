variable "project_prefix" {
  type        = string
  description = "Project prefix"
}

variable "environment" {
  type        = string
  description = "Project environment"
}

variable "primary_location" {
  type        = string
  description = "Primary location for deploying Azure services"
}

variable "secondary_location" {
  type        = string
  description = "Secondary location for deploying Azure services"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the environment services"
}

variable "db_admin_login" {
  type = string
  description = "Admin username for database"
  sensitive = true
}

variable "db_admin_password" {
  type = string
  description = "Admin password for database"
  sensitive = true
}

variable "db" {
  description = "Azure Container App service configuration"
  type = object({
    name = string
    sku = string
    version = string
    storage_size = number
  })
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID"
  sensitive = true
}