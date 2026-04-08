variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "rest_api_id" {
  description = "ID of the associated REST API"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.rest_api_id))
    error_message = "resource_aws_api_gateway_stage, rest_api_id must be a valid API Gateway REST API ID containing only lowercase letters and numbers."
  }
}

variable "stage_name" {
  description = "Name of the stage"
  type        = string

  validation {
    condition     = length(var.stage_name) > 0 && length(var.stage_name) <= 128
    error_message = "resource_aws_api_gateway_stage, stage_name must be between 1 and 128 characters long."
  }
}

variable "deployment_id" {
  description = "ID of the deployment that the stage points to"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.deployment_id))
    error_message = "resource_aws_api_gateway_stage, deployment_id must be a valid API Gateway deployment ID containing only lowercase letters and numbers."
  }
}

variable "access_log_settings" {
  description = "Enables access logs for the API stage"
  type = object({
    destination_arn = string
    format          = string
  })
  default = null

  validation {
    condition = var.access_log_settings == null || (
      can(regex("^arn:aws", var.access_log_settings.destination_arn)) &&
      length(var.access_log_settings.format) > 0
    )
    error_message = "resource_aws_api_gateway_stage, access_log_settings destination_arn must be a valid ARN and format must not be empty."
  }
}

variable "cache_cluster_enabled" {
  description = "Whether a cache cluster is enabled for the stage"
  type        = bool
  default     = null
}

variable "cache_cluster_size" {
  description = "Size of the cache cluster for the stage, if enabled"
  type        = string
  default     = null

  validation {
    condition = var.cache_cluster_size == null || contains([
      "0.5", "1.6", "6.1", "13.5", "28.4", "58.2", "118", "237"
    ], var.cache_cluster_size)
    error_message = "resource_aws_api_gateway_stage, cache_cluster_size must be one of: 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118, 237."
  }
}

variable "canary_settings" {
  description = "Configuration settings of a canary deployment"
  type = object({
    deployment_id            = string
    percent_traffic          = optional(number)
    stage_variable_overrides = optional(map(string))
    use_stage_cache          = optional(bool)
  })
  default = null

  validation {
    condition = var.canary_settings == null || (
      can(regex("^[a-z0-9]+$", var.canary_settings.deployment_id)) &&
      (var.canary_settings.percent_traffic == null || (
        var.canary_settings.percent_traffic >= 0.0 && var.canary_settings.percent_traffic <= 100.0
      ))
    )
    error_message = "resource_aws_api_gateway_stage, canary_settings deployment_id must be a valid deployment ID and percent_traffic must be between 0.0 and 100.0."
  }
}

variable "client_certificate_id" {
  description = "Identifier of a client certificate for the stage"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the stage"
  type        = string
  default     = null
}

variable "documentation_version" {
  description = "Version of the associated API documentation"
  type        = string
  default     = null
}

variable "variables" {
  description = "Map that defines the stage variables"
  type        = map(string)
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = null
}

variable "xray_tracing_enabled" {
  description = "Whether active tracing with X-ray is enabled"
  type        = bool
  default     = false
}