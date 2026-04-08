variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the listener. A listener name must be unique within a service"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.name)) && !can(regex("--", var.name))
    error_message = "resource_aws_vpclattice_listener, name must contain only lowercase letters, numbers, and hyphens. Cannot start or end with hyphen, or have consecutive hyphens."
  }
}

variable "port" {
  description = "Listener port. Defaults to 80 for HTTP and 443 for HTTPS"
  type        = number
  default     = null

  validation {
    condition     = var.port == null || (var.port >= 1 && var.port <= 65535)
    error_message = "resource_aws_vpclattice_listener, port must be between 1 and 65535."
  }
}

variable "protocol" {
  description = "Protocol for the listener"
  type        = string

  validation {
    condition     = contains(["HTTP", "HTTPS", "TLS_PASSTHROUGH"], var.protocol)
    error_message = "resource_aws_vpclattice_listener, protocol must be one of: HTTP, HTTPS, TLS_PASSTHROUGH."
  }
}

variable "service_arn" {
  description = "Amazon Resource Name (ARN) of the VPC Lattice service"
  type        = string
  default     = null
}

variable "service_identifier" {
  description = "ID of the VPC Lattice service"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "default_action" {
  description = "Default action block for the default listener rule"
  type = object({
    fixed_response = optional(object({
      status_code = number
    }))
    forward = optional(object({
      target_groups = list(object({
        target_group_identifier = string
        weight                  = optional(number, 100)
      }))
    }))
  })

  validation {
    condition = (
      var.default_action.fixed_response != null && var.default_action.forward == null
      ) || (
      var.default_action.fixed_response == null && var.default_action.forward != null
    )
    error_message = "resource_aws_vpclattice_listener, default_action must specify exactly one of fixed_response or forward."
  }

  validation {
    condition = var.default_action.forward == null || (
      var.default_action.forward != null && length(var.default_action.forward.target_groups) > 0
    )
    error_message = "resource_aws_vpclattice_listener, default_action forward must include at least one target_groups block."
  }
}

