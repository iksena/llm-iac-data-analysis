variable "name" {
  description = "Name of the ACL"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_memorydb_acl, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_memorydb_acl, region must be a valid AWS region name or null."
  }
}