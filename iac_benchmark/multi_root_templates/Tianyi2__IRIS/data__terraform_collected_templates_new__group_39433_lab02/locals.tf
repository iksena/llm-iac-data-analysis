locals {
  prefix = "aks4devops"
  location = "eastasia"
}

variable "client_id" {
  description = "Client ID for the Azure provider"
  type        = string
}
variable "client_secret" {
  description = "Client Secret for the Azure provider"
  type        = string
}
variable "subscription_id" {
  description = "Subscription ID for the Azure provider"
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID for the Azure provider"
  type        = string
}