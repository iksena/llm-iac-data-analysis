variable "listener_arn" {
  description = "The Amazon Resource Name (ARN) of the custom routing listener."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:globalaccelerator::", var.listener_arn))
    error_message = "resource_aws_globalaccelerator_custom_routing_endpoint_group, listener_arn must be a valid Global Accelerator listener ARN."
  }
}

variable "destination_configuration" {
  description = "The port ranges and protocols for all endpoints in a custom routing endpoint group to accept client traffic on."
  type = list(object({
    from_port = number
    to_port   = number
    protocols = list(string)
  }))

  validation {
    condition = alltrue([
      for config in var.destination_configuration : config.from_port >= 1 && config.from_port <= 65535
    ])
    error_message = "resource_aws_globalaccelerator_custom_routing_endpoint_group, from_port must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for config in var.destination_configuration : config.to_port >= 1 && config.to_port <= 65535
    ])
    error_message = "resource_aws_globalaccelerator_custom_routing_endpoint_group, to_port must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for config in var.destination_configuration : config.from_port <= config.to_port
    ])
    error_message = "resource_aws_globalaccelerator_custom_routing_endpoint_group, from_port must be less than or equal to to_port."
  }

  validation {
    condition = alltrue([
      for config in var.destination_configuration : alltrue([
        for protocol in config.protocols : contains(["TCP", "UDP"], protocol)
      ])
    ])
    error_message = "resource_aws_globalaccelerator_custom_routing_endpoint_group, protocols must be either TCP or UDP."
  }
}

variable "endpoint_configuration" {
  description = "The list of endpoint objects."
  type = list(object({
    endpoint_id = optional(string)
  }))
  default = []
}

variable "endpoint_group_region" {
  description = "The name of the AWS Region where the custom routing endpoint group is located."
  type        = string
  default     = null

  validation {
    condition     = var.endpoint_group_region == null ? true : can(regex("^[a-z0-9-]+$", var.endpoint_group_region))
    error_message = "resource_aws_globalaccelerator_custom_routing_endpoint_group, endpoint_group_region must be a valid AWS region name."
  }
}

variable "timeouts" {
  description = "Configuration options for operation timeouts."
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_globalaccelerator_custom_routing_endpoint_group, timeouts must be in format like '30m', '1h', or '3600s'."
  }
}