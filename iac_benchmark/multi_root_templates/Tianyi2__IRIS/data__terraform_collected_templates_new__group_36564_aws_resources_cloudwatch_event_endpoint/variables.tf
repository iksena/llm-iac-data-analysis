variable "name" {
  description = "The name of the global endpoint"
  type        = string
}

variable "description" {
  description = "A description of the global endpoint"
  type        = string
  default     = null
}

variable "role_arn" {
  description = "The ARN of the IAM role used for replication between event buses"
  type        = string
  default     = null
}

variable "event_buses" {
  description = "The event buses to use. The names of the event buses must be identical in each Region. Exactly two event buses are required"
  type = list(object({
    event_bus_arn = string
  }))

  validation {
    condition     = length(var.event_buses) == 2
    error_message = "resource_aws_cloudwatch_event_endpoint, event_buses must contain exactly two event buses."
  }
}

variable "replication_config" {
  description = "Parameters used for replication"
  type = object({
    state = optional(string, "ENABLED")
  })
  default = null

  validation {
    condition     = var.replication_config == null || contains(["ENABLED", "DISABLED"], var.replication_config.state)
    error_message = "resource_aws_cloudwatch_event_endpoint, replication_config.state must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "routing_config" {
  description = "Parameters used for routing, including the health check and secondary Region"
  type = object({
    failover_config = object({
      primary = object({
        health_check = string
      })
      secondary = object({
        route = string
      })
    })
  })

  validation {
    condition     = var.routing_config.failover_config.primary.health_check != ""
    error_message = "resource_aws_cloudwatch_event_endpoint, routing_config.failover_config.primary.health_check cannot be empty."
  }

  validation {
    condition     = var.routing_config.failover_config.secondary.route != ""
    error_message = "resource_aws_cloudwatch_event_endpoint, routing_config.failover_config.secondary.route cannot be empty."
  }
}