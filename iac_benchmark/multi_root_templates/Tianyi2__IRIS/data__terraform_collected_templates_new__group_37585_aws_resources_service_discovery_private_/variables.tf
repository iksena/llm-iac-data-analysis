variable "region" {
  type        = string
  default     = null
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "name" {
  type        = string
  description = "The name of the namespace."

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_service_discovery_private_dns_namespace, name cannot be empty."
  }
}

variable "vpc" {
  type        = string
  description = "The ID of VPC that you want to associate the namespace with."

  validation {
    condition     = length(var.vpc) > 0 && can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc))
    error_message = "resource_aws_service_discovery_private_dns_namespace, vpc must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "description" {
  type        = string
  default     = null
  description = "The description that you specify for the namespace when you create it."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the namespace."
}