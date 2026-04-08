variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_aws_memorydb_subnet_group, region must not be empty when provided."
  }
}

variable "name" {
  type        = string
  description = "Name of the subnet group."

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_memorydb_subnet_group, name must not be empty."
  }
}