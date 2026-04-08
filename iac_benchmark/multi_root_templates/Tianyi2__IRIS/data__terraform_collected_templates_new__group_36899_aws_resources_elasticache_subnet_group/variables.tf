variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_elasticache_subnet_group, region must be a valid AWS region format."
  }
}

variable "name" {
  description = "Name for the cache subnet group. ElastiCache converts this name to lowercase."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "resource_aws_elasticache_subnet_group, name must contain only alphanumeric characters and hyphens."
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_elasticache_subnet_group, name must be between 1 and 255 characters in length."
  }
}

variable "description" {
  description = "Description for the cache subnet group. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"

  validation {
    condition     = length(var.description) <= 255
    error_message = "resource_aws_elasticache_subnet_group, description must not exceed 255 characters in length."
  }
}

variable "subnet_ids" {
  description = "List of VPC Subnet IDs for the cache subnet group."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_elasticache_subnet_group, subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition     = alltrue([for id in var.subnet_ids : can(regex("^subnet-[a-zA-Z0-9]+$", id))])
    error_message = "resource_aws_elasticache_subnet_group, subnet_ids must contain valid subnet IDs starting with 'subnet-'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) <= 128 && length(v) <= 256])
    error_message = "resource_aws_elasticache_subnet_group, tags keys must not exceed 128 characters and values must not exceed 256 characters."
  }
}