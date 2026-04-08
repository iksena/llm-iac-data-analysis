variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the DB parameter group"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string

  validation {
    condition     = var.family != null && var.family != ""
    error_message = "resource_aws_db_parameter_group, family is required and cannot be empty."
  }
}

variable "description" {
  description = "The description of the DB parameter group"
  type        = string
  default     = "Managed by Terraform"
}

variable "parameter" {
  description = "The DB parameters to apply"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.parameter : param.name != null && param.name != ""
    ])
    error_message = "resource_aws_db_parameter_group, parameter name is required for all parameters and cannot be empty."
  }

  validation {
    condition = alltrue([
      for param in var.parameter : param.value != null && param.value != ""
    ])
    error_message = "resource_aws_db_parameter_group, parameter value is required for all parameters and cannot be empty."
  }

  validation {
    condition = alltrue([
      for param in var.parameter : contains(["immediate", "pending-reboot"], param.apply_method)
    ])
    error_message = "resource_aws_db_parameter_group, parameter apply_method must be either 'immediate' or 'pending-reboot'."
  }
}

variable "skip_destroy" {
  description = "Set to true if you do not wish the parameter group to be deleted at destroy time"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}