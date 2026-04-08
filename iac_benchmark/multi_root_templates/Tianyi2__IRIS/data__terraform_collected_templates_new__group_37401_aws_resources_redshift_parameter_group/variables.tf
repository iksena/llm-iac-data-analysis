variable "name" {
  description = "The name of the Redshift parameter group"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "resource_aws_redshift_parameter_group, name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "family" {
  description = "The family of the Redshift parameter group"
  type        = string

  validation {
    condition     = contains(["redshift-1.0"], var.family)
    error_message = "resource_aws_redshift_parameter_group, family must be a valid Redshift parameter group family."
  }
}

variable "description" {
  description = "The description of the Redshift parameter group"
  type        = string
  default     = "Managed by Terraform"

  validation {
    condition     = length(var.description) <= 255
    error_message = "resource_aws_redshift_parameter_group, description must be 255 characters or less."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "parameters" {
  description = "A list of Redshift parameters to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.parameters : can(regex("^[a-zA-Z0-9_]+$", param.name))
    ])
    error_message = "resource_aws_redshift_parameter_group, parameters must have valid parameter names containing only letters, numbers, and underscores."
  }

  validation {
    condition = alltrue([
      for param in var.parameters : length(param.value) > 0
    ])
    error_message = "resource_aws_redshift_parameter_group, parameters must have non-empty values."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_redshift_parameter_group, tags cannot exceed 50 key-value pairs."
  }
}