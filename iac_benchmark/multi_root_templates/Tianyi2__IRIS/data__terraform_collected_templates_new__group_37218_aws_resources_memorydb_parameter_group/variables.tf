variable "family" {
  description = "The engine version that the parameter group can be used with"
  type        = string

  validation {
    condition     = can(regex("^memorydb_redis[0-9]+$", var.family))
    error_message = "resource_aws_memorydb_parameter_group, family must be a valid MemoryDB Redis family (e.g., memorydb_redis6, memorydb_redis7)."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the parameter group"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-z][a-z0-9-]*$", var.name))
    error_message = "resource_aws_memorydb_parameter_group, name must start with a lowercase letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-z][a-z0-9-]*$", var.name_prefix))
    error_message = "resource_aws_memorydb_parameter_group, name_prefix must start with a lowercase letter and contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = !(var.name != null && var.name_prefix != null)
    error_message = "resource_aws_memorydb_parameter_group, name_prefix conflicts with name. Only one can be specified."
  }
}

variable "description" {
  description = "Description for the parameter group"
  type        = string
  default     = "Managed by Terraform"
}

variable "parameter" {
  description = "Set of MemoryDB parameters to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = []

  validation {
    condition     = alltrue([for p in var.parameter : p.name != null && p.name != ""])
    error_message = "resource_aws_memorydb_parameter_group, parameter name cannot be null or empty."
  }

  validation {
    condition     = alltrue([for p in var.parameter : p.value != null && p.value != ""])
    error_message = "resource_aws_memorydb_parameter_group, parameter value cannot be null or empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}