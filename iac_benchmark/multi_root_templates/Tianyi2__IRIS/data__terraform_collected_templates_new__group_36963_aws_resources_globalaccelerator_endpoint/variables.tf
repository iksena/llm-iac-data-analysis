variable "listener_arn" {
  description = "The Amazon Resource Name (ARN) of the listener"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:globalaccelerator:", var.listener_arn))
    error_message = "resource_aws_globalaccelerator_endpoint_group, listener_arn must be a valid Global Accelerator listener ARN."
  }
}

variable "endpoint_group_region" {
  description = "The name of the AWS Region where the endpoint group is located"
  type        = string
  default     = null

  validation {
    condition     = var.endpoint_group_region == null || can(regex("^[a-z0-9-]+$", var.endpoint_group_region))
    error_message = "resource_aws_globalaccelerator_endpoint_group, endpoint_group_region must be a valid AWS region name."
  }
}

variable "health_check_interval_seconds" {
  description = "The time—10 seconds or 30 seconds—between each health check for an endpoint. The default value is 30"
  type        = number
  default     = null

  validation {
    condition     = var.health_check_interval_seconds == null || contains([10, 30], var.health_check_interval_seconds)
    error_message = "resource_aws_globalaccelerator_endpoint_group, health_check_interval_seconds must be either 10 or 30 seconds."
  }
}

variable "health_check_path" {
  description = "If the protocol is HTTP/S, then this specifies the path that is the destination for health check targets. The default value is slash (`/`)"
  type        = string
  default     = null

  validation {
    condition     = var.health_check_path == null || can(regex("^/", var.health_check_path))
    error_message = "resource_aws_globalaccelerator_endpoint_group, health_check_path must start with a forward slash."
  }
}

variable "health_check_port" {
  description = "The port that AWS Global Accelerator uses to check the health of endpoints that are part of this endpoint group"
  type        = number
  default     = null

  validation {
    condition     = var.health_check_port == null || (var.health_check_port >= 1 && var.health_check_port <= 65535)
    error_message = "resource_aws_globalaccelerator_endpoint_group, health_check_port must be between 1 and 65535."
  }
}

variable "health_check_protocol" {
  description = "The protocol that AWS Global Accelerator uses to check the health of endpoints that are part of this endpoint group. The default value is TCP"
  type        = string
  default     = null

  validation {
    condition     = var.health_check_protocol == null || contains(["TCP", "HTTP", "HTTPS"], var.health_check_protocol)
    error_message = "resource_aws_globalaccelerator_endpoint_group, health_check_protocol must be one of TCP, HTTP, or HTTPS."
  }
}

variable "threshold_count" {
  description = "The number of consecutive health checks required to set the state of a healthy endpoint to unhealthy, or to set an unhealthy endpoint to healthy. The default value is 3"
  type        = number
  default     = null

  validation {
    condition     = var.threshold_count == null || (var.threshold_count >= 1 && var.threshold_count <= 10)
    error_message = "resource_aws_globalaccelerator_endpoint_group, threshold_count must be between 1 and 10."
  }
}

variable "traffic_dial_percentage" {
  description = "The percentage of traffic to send to an AWS Region. Additional traffic is distributed to other endpoint groups for this listener. The default value is 100"
  type        = number
  default     = null

  validation {
    condition     = var.traffic_dial_percentage == null || (var.traffic_dial_percentage >= 0 && var.traffic_dial_percentage <= 100)
    error_message = "resource_aws_globalaccelerator_endpoint_group, traffic_dial_percentage must be between 0 and 100."
  }
}

variable "endpoint_configuration" {
  description = "The list of endpoint objects"
  type = list(object({
    attachment_arn                 = optional(string)
    client_ip_preservation_enabled = optional(bool)
    endpoint_id                    = optional(string)
    weight                         = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.endpoint_configuration :
      config.weight == null || (config.weight >= 0 && config.weight <= 255)
    ])
    error_message = "resource_aws_globalaccelerator_endpoint_group, endpoint_configuration weight must be between 0 and 255."
  }

  validation {
    condition = alltrue([
      for config in var.endpoint_configuration :
      config.attachment_arn == null || can(regex("^arn:aws:globalaccelerator:", config.attachment_arn))
    ])
    error_message = "resource_aws_globalaccelerator_endpoint_group, endpoint_configuration attachment_arn must be a valid Global Accelerator attachment ARN."
  }
}

variable "port_override" {
  description = "Override specific listener ports used to route traffic to endpoints that are part of this endpoint group"
  type = list(object({
    endpoint_port = number
    listener_port = number
  }))
  default = []

  validation {
    condition = alltrue([
      for override in var.port_override :
      override.endpoint_port >= 1 && override.endpoint_port <= 65535
    ])
    error_message = "resource_aws_globalaccelerator_endpoint_group, port_override endpoint_port must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for override in var.port_override :
      override.listener_port >= 1 && override.listener_port <= 65535
    ])
    error_message = "resource_aws_globalaccelerator_endpoint_group, port_override listener_port must be between 1 and 65535."
  }
}