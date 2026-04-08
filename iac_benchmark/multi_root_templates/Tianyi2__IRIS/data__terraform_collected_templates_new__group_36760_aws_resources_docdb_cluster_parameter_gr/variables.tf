variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the DocumentDB cluster parameter group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || var.name_prefix == null
    error_message = "resource_aws_docdb_cluster_parameter_group, name conflicts with name_prefix. Only one can be specified."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "family" {
  description = "The family of the DocumentDB cluster parameter group."
  type        = string

  validation {
    condition     = var.family != null && var.family != ""
    error_message = "resource_aws_docdb_cluster_parameter_group, family is required and cannot be empty."
  }
}

variable "description" {
  description = "The description of the DocumentDB cluster parameter group. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"
}

variable "parameter" {
  description = "A list of DocumentDB parameters to apply. Setting parameters to system default values may show a difference on imported resources."
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "pending-reboot")
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.parameter : param.name != null && param.name != ""
    ])
    error_message = "resource_aws_docdb_cluster_parameter_group, parameter name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for param in var.parameter : param.value != null && param.value != ""
    ])
    error_message = "resource_aws_docdb_cluster_parameter_group, parameter value is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for param in var.parameter : param.apply_method == null || contains(["immediate", "pending-reboot"], param.apply_method)
    ])
    error_message = "resource_aws_docdb_cluster_parameter_group, parameter apply_method must be either 'immediate' or 'pending-reboot'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}