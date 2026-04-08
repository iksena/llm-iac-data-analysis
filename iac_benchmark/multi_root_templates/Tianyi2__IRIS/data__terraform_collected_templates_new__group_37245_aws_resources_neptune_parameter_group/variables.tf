variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Neptune parameter group."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.name))
    error_message = "resource_aws_neptune_parameter_group, name must start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.name_prefix))
    error_message = "resource_aws_neptune_parameter_group, name_prefix must start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "family" {
  description = "The family of the Neptune parameter group."
  type        = string

  validation {
    condition     = var.family != null && var.family != ""
    error_message = "resource_aws_neptune_parameter_group, family is required and cannot be empty."
  }
}

variable "description" {
  description = "The description of the Neptune parameter group. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"
}

variable "parameter" {
  description = "A list of Neptune parameters to apply."
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "pending-reboot")
  }))
  default = null

  validation {
    condition = var.parameter == null || alltrue([
      for p in var.parameter : p.name != null && p.name != ""
    ])
    error_message = "resource_aws_neptune_parameter_group, parameter name is required and cannot be empty."
  }

  validation {
    condition = var.parameter == null || alltrue([
      for p in var.parameter : p.value != null
    ])
    error_message = "resource_aws_neptune_parameter_group, parameter value is required."
  }

  validation {
    condition = var.parameter == null || alltrue([
      for p in var.parameter : p.apply_method == null || contains(["immediate", "pending-reboot"], p.apply_method)
    ])
    error_message = "resource_aws_neptune_parameter_group, parameter apply_method must be either 'immediate' or 'pending-reboot'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}