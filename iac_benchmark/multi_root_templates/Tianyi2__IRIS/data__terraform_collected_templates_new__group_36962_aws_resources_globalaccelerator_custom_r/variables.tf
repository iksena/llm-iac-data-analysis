variable "accelerator_arn" {
  description = "The Amazon Resource Name (ARN) of a custom routing accelerator"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:globalaccelerator::", var.accelerator_arn))
    error_message = "resource_aws_globalaccelerator_custom_routing_listener, accelerator_arn must be a valid Global Accelerator ARN."
  }
}

variable "port_ranges" {
  description = "The list of port ranges for the connections from clients to the accelerator"
  type = list(object({
    from_port = optional(number)
    to_port   = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for range in var.port_ranges : (
        range.from_port == null || (range.from_port >= 1 && range.from_port <= 65535)
      )
    ])
    error_message = "resource_aws_globalaccelerator_custom_routing_listener, port_ranges from_port must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for range in var.port_ranges : (
        range.to_port == null || (range.to_port >= 1 && range.to_port <= 65535)
      )
    ])
    error_message = "resource_aws_globalaccelerator_custom_routing_listener, port_ranges to_port must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for range in var.port_ranges : (
        range.from_port == null || range.to_port == null || range.from_port <= range.to_port
      )
    ])
    error_message = "resource_aws_globalaccelerator_custom_routing_listener, port_ranges from_port must be less than or equal to to_port."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the custom routing listener"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_globalaccelerator_custom_routing_listener, create_timeout must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}

variable "update_timeout" {
  description = "Timeout for updating the custom routing listener"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.update_timeout))
    error_message = "resource_aws_globalaccelerator_custom_routing_listener, update_timeout must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the custom routing listener"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_globalaccelerator_custom_routing_listener, delete_timeout must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}