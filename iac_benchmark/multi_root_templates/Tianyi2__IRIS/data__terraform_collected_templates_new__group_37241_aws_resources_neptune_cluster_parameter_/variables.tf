variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the neptune cluster parameter group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z][a-zA-Z0-9\\-]*$", var.name))
    error_message = "resource_aws_neptune_cluster_parameter_group, name must start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z][a-zA-Z0-9\\-]*$", var.name_prefix))
    error_message = "resource_aws_neptune_cluster_parameter_group, name_prefix must start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "family" {
  description = "The family of the neptune cluster parameter group."
  type        = string

  validation {
    condition     = contains(["neptune1", "neptune1.2", "neptune1.3"], var.family)
    error_message = "resource_aws_neptune_cluster_parameter_group, family must be one of: neptune1, neptune1.2, neptune1.3."
  }
}

variable "description" {
  description = "The description of the neptune cluster parameter group. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"
}

variable "parameter" {
  description = "A list of neptune parameters to apply."
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "pending-reboot")
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.parameter : param.apply_method == null || contains(["immediate", "pending-reboot"], param.apply_method)
    ])
    error_message = "resource_aws_neptune_cluster_parameter_group, parameter apply_method must be either 'immediate' or 'pending-reboot'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}