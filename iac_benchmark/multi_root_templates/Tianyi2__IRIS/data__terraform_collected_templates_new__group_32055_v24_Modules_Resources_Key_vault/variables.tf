# Required resource variables
variable "resource_name" {
  description = "Desired name for the provisioned resources"
  type        = string
}

variable "resource_group_name" {
  description = "Desired resource group name for the provisioned resources"
  type        = string
}

variable "resource_location" {
  description = "Desired location for the provisioned resources"
  type        = string
}

variable "resource_instance_count" {
  description = "Number of instance secrets"
  type        = string
}

variable "resource_secret" {
  description = "Resource secret to store in vault"
  type        = any
}