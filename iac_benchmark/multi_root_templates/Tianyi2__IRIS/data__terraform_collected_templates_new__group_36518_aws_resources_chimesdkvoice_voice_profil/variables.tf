variable "name" {
  type        = string
  description = "Name of Voice Profile Domain."

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_chimesdkvoice_voice_profile_domain, name must not be empty."
  }
}

variable "server_side_encryption_configuration" {
  type = object({
    kms_key_arn = string
  })
  description = "Configuration for server side encryption."

  validation {
    condition     = can(regex("^arn:aws:kms:", var.server_side_encryption_configuration.kms_key_arn))
    error_message = "resource_aws_chimesdkvoice_voice_profile_domain, server_side_encryption_configuration.kms_key_arn must be a valid KMS key ARN."
  }
}

variable "description" {
  type        = string
  description = "Description of Voice Profile Domain."
  default     = null
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the resource."
  default     = {}
}

variable "timeouts" {
  type = object({
    create = optional(string, "30s")
    update = optional(string, "30s")
    delete = optional(string, "30s")
  })
  description = "Timeouts for create, update, and delete operations."
  default     = {}

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_chimesdkvoice_voice_profile_domain, timeouts must be valid duration strings (e.g., '30s', '5m', '1h')."
  }
}