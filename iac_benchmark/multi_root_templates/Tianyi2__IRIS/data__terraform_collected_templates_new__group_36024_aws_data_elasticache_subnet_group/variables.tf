variable "name" {
  type        = string
  description = "Name of the subnet group"

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_elasticache_subnet_group, name must not be empty."
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  default     = null
}