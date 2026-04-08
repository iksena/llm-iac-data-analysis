variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the ElastiCache parameter group."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_elasticache_parameter_group, name cannot be empty."
  }
}

variable "family" {
  description = "The family of the ElastiCache parameter group."
  type        = string

  validation {
    condition     = length(var.family) > 0
    error_message = "resource_aws_elasticache_parameter_group, family cannot be empty."
  }
}

variable "description" {
  description = "The description of the ElastiCache parameter group. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"
}

variable "parameter" {
  description = "A list of ElastiCache parameters to apply."
  type = list(object({
    name  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for p in var.parameter : length(p.name) > 0
    ])
    error_message = "resource_aws_elasticache_parameter_group, parameter name cannot be empty."
  }

  validation {
    condition = alltrue([
      for p in var.parameter : length(p.value) > 0
    ])
    error_message = "resource_aws_elasticache_parameter_group, parameter value cannot be empty."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}