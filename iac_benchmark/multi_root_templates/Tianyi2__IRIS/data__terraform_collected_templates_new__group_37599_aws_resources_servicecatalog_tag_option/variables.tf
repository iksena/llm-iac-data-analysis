variable "key" {
  description = "Tag option key"
  type        = string

  validation {
    condition     = length(var.key) > 0
    error_message = "resource_aws_servicecatalog_tag_option, key must be a non-empty string."
  }
}

variable "value" {
  description = "Tag option value"
  type        = string

  validation {
    condition     = length(var.value) > 0
    error_message = "resource_aws_servicecatalog_tag_option, value must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "active" {
  description = "Whether tag option is active"
  type        = bool
  default     = true

  validation {
    condition     = can(var.active)
    error_message = "resource_aws_servicecatalog_tag_option, active must be a boolean value."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "3m")
    read   = optional(string, "10m")
    update = optional(string, "3m")
    delete = optional(string, "3m")
  })
  default = {
    create = "3m"
    read   = "10m"
    update = "3m"
    delete = "3m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.read)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_servicecatalog_tag_option, timeouts must be valid duration strings (e.g., '3m', '10s', '1h')."
  }
}