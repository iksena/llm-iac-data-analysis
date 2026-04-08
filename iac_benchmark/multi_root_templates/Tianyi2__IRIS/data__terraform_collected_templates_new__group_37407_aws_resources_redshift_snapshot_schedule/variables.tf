variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "identifier" {
  description = "The snapshot schedule identifier. If omitted, Terraform will assign a random, unique identifier."
  type        = string
  default     = null

  validation {
    condition     = var.identifier == null ? true : can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.identifier))
    error_message = "resource_aws_redshift_snapshot_schedule, identifier must start with a letter, contain only lowercase letters, numbers, and hyphens, and end with a letter or number."
  }
}

variable "identifier_prefix" {
  description = "Creates a unique identifier beginning with the specified prefix. Conflicts with identifier."
  type        = string
  default     = null

  validation {
    condition     = var.identifier_prefix == null ? true : can(regex("^[a-z][a-z0-9-]*$", var.identifier_prefix))
    error_message = "resource_aws_redshift_snapshot_schedule, identifier_prefix must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "description" {
  description = "The description of the snapshot schedule."
  type        = string
  default     = null

  validation {
    condition     = var.description == null ? true : length(var.description) <= 255
    error_message = "resource_aws_redshift_snapshot_schedule, description must be 255 characters or less."
  }
}

variable "definitions" {
  description = "The definition of the snapshot schedule. The definition is made up of schedule expressions, for example cron(30 12 *) or rate(12 hours)."
  type        = list(string)
  default     = null

  validation {
    condition     = var.definitions == null ? true : length(var.definitions) > 0
    error_message = "resource_aws_redshift_snapshot_schedule, definitions must contain at least one schedule expression."
  }

  validation {
    condition = var.definitions == null ? true : alltrue([
      for def in var.definitions : can(regex("^(cron|rate)\\(.+\\)$", def))
    ])
    error_message = "resource_aws_redshift_snapshot_schedule, definitions must be valid schedule expressions starting with 'cron(' or 'rate(' and ending with ')'."
  }
}

variable "force_destroy" {
  description = "Whether to destroy all associated clusters with this snapshot schedule on deletion. Must be enabled and applied before attempting deletion."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}