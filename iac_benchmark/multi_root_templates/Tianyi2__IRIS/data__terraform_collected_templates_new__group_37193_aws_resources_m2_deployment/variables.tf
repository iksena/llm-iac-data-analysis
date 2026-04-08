variable "environment_id" {
  description = "Environment to deploy application to."
  type        = string

  validation {
    condition     = length(var.environment_id) > 0
    error_message = "resource_aws_m2_deployment, environment_id must not be empty."
  }
}

variable "application_id" {
  description = "Application to deploy."
  type        = string

  validation {
    condition     = length(var.application_id) > 0
    error_message = "resource_aws_m2_deployment, application_id must not be empty."
  }
}

variable "application_version" {
  description = "Version to application to deploy"
  type        = number

  validation {
    condition     = var.application_version > 0
    error_message = "resource_aws_m2_deployment, application_version must be a positive integer."
  }
}

variable "start" {
  description = "Start the application once deployed."
  type        = bool
  default     = true

  validation {
    condition     = can(var.start)
    error_message = "resource_aws_m2_deployment, start must be a boolean value."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "60m")
    update = optional(string, "60m")
    delete = optional(string, "60m")
  })
  default = {
    create = "60m"
    update = "60m"
    delete = "60m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_m2_deployment, timeouts must be valid duration strings (e.g., '60m', '1h', '30s')."
  }
}