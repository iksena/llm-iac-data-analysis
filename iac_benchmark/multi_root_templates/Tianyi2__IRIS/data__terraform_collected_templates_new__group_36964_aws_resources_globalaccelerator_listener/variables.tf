variable "accelerator_arn" {
  description = "The Amazon Resource Name (ARN) of your accelerator."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:globalaccelerator::", var.accelerator_arn))
    error_message = "resource_aws_globalaccelerator_listener, accelerator_arn must be a valid Global Accelerator ARN."
  }
}

variable "client_affinity" {
  description = "Direct all requests from a user to the same endpoint. Valid values are NONE, SOURCE_IP."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "SOURCE_IP"], var.client_affinity)
    error_message = "resource_aws_globalaccelerator_listener, client_affinity must be either NONE or SOURCE_IP."
  }
}

variable "protocol" {
  description = "The protocol for the connections from clients to the accelerator. Valid values are TCP, UDP."
  type        = string
  default     = null

  validation {
    condition     = var.protocol == null || contains(["TCP", "UDP"], var.protocol)
    error_message = "resource_aws_globalaccelerator_listener, protocol must be either TCP or UDP."
  }
}

variable "port_range" {
  description = "The list of port ranges for the connections from clients to the accelerator."
  type = object({
    from_port = optional(number)
    to_port   = optional(number)
  })
  default = null

  validation {
    condition = var.port_range == null || (
      var.port_range.from_port == null || (
        var.port_range.from_port >= 1 && var.port_range.from_port <= 65535
      )
    )
    error_message = "resource_aws_globalaccelerator_listener, port_range.from_port must be between 1 and 65535."
  }

  validation {
    condition = var.port_range == null || (
      var.port_range.to_port == null || (
        var.port_range.to_port >= 1 && var.port_range.to_port <= 65535
      )
    )
    error_message = "resource_aws_globalaccelerator_listener, port_range.to_port must be between 1 and 65535."
  }

  validation {
    condition = var.port_range == null || (
      var.port_range.from_port == null || var.port_range.to_port == null ||
      var.port_range.from_port <= var.port_range.to_port
    )
    error_message = "resource_aws_globalaccelerator_listener, port_range.from_port must be less than or equal to port_range.to_port."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource operations."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_globalaccelerator_listener, timeouts.create must be a valid duration format (e.g., 30m, 1h, 300s)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.update))
    error_message = "resource_aws_globalaccelerator_listener, timeouts.update must be a valid duration format (e.g., 30m, 1h, 300s)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_globalaccelerator_listener, timeouts.delete must be a valid duration format (e.g., 30m, 1h, 300s)."
  }
}