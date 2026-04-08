variable "api_id" {
  description = "API identifier"
  type        = string
}

variable "name" {
  description = "Name of the stage"
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 128
    error_message = "resource_aws_apigatewayv2_stage, name must be between 1 and 128 characters in length."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "access_log_settings" {
  description = "Settings for logging access in this stage"
  type = object({
    destination_arn = string
    format          = string
  })
  default = null
}

variable "auto_deploy" {
  description = "Whether updates to an API automatically trigger a new deployment"
  type        = bool
  default     = false
}

variable "client_certificate_id" {
  description = "Identifier of a client certificate for the stage"
  type        = string
  default     = null
}

variable "default_route_settings" {
  description = "Default route settings for the stage"
  type = object({
    data_trace_enabled       = optional(bool, false)
    detailed_metrics_enabled = optional(bool, false)
    logging_level            = optional(string, "OFF")
    throttling_burst_limit   = optional(number)
    throttling_rate_limit    = optional(number)
  })
  default = null

  validation {
    condition = var.default_route_settings == null || (
      var.default_route_settings.logging_level == null ||
      contains(["ERROR", "INFO", "OFF"], var.default_route_settings.logging_level)
    )
    error_message = "resource_aws_apigatewayv2_stage, default_route_settings.logging_level must be one of: ERROR, INFO, OFF."
  }
}

variable "deployment_id" {
  description = "Deployment identifier of the stage"
  type        = string
  default     = null
}

variable "description" {
  description = "Description for the stage"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_apigatewayv2_stage, description must be less than or equal to 1024 characters in length."
  }
}

variable "route_settings" {
  description = "Route settings for the stage"
  type = list(object({
    route_key                = string
    data_trace_enabled       = optional(bool, false)
    detailed_metrics_enabled = optional(bool, false)
    logging_level            = optional(string, "OFF")
    throttling_burst_limit   = optional(number)
    throttling_rate_limit    = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for route in var.route_settings : (
        route.logging_level == null ||
        contains(["ERROR", "INFO", "OFF"], route.logging_level)
      )
    ])
    error_message = "resource_aws_apigatewayv2_stage, route_settings.logging_level must be one of: ERROR, INFO, OFF."
  }
}

variable "stage_variables" {
  description = "Map that defines the stage variables for the stage"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Map of tags to assign to the stage"
  type        = map(string)
  default     = {}
}