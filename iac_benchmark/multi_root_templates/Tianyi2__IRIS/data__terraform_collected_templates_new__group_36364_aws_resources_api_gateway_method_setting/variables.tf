variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "rest_api_id" {
  description = "ID of the REST API"
  type        = string

  validation {
    condition     = length(var.rest_api_id) > 0
    error_message = "resource_aws_api_gateway_method_settings, rest_api_id must not be empty."
  }
}

variable "stage_name" {
  description = "Name of the stage"
  type        = string

  validation {
    condition     = length(var.stage_name) > 0
    error_message = "resource_aws_api_gateway_method_settings, stage_name must not be empty."
  }
}

variable "method_path" {
  description = "Method path defined as {resource_path}/{http_method} for an individual method override, or */* for overriding all methods in the stage"
  type        = string

  validation {
    condition     = length(var.method_path) > 0
    error_message = "resource_aws_api_gateway_method_settings, method_path must not be empty."
  }
}

variable "settings_metrics_enabled" {
  description = "Whether Amazon CloudWatch metrics are enabled for this method"
  type        = bool
  default     = null
}

variable "settings_logging_level" {
  description = "Logging level for this method, which effects the log entries pushed to Amazon CloudWatch Logs"
  type        = string
  default     = null

  validation {
    condition     = var.settings_logging_level == null || can(regex("^(OFF|ERROR|INFO)$", var.settings_logging_level))
    error_message = "resource_aws_api_gateway_method_settings, settings_logging_level must be one of: OFF, ERROR, INFO."
  }
}

variable "settings_data_trace_enabled" {
  description = "Whether data trace logging is enabled for this method, which effects the log entries pushed to Amazon CloudWatch Logs"
  type        = bool
  default     = null
}

variable "settings_throttling_burst_limit" {
  description = "Throttling burst limit"
  type        = number
  default     = null
}

variable "settings_throttling_rate_limit" {
  description = "Throttling rate limit"
  type        = number
  default     = null
}

variable "settings_caching_enabled" {
  description = "Whether responses should be cached and returned for requests"
  type        = bool
  default     = null
}

variable "settings_cache_ttl_in_seconds" {
  description = "Time to live (TTL), in seconds, for cached responses"
  type        = number
  default     = null

  validation {
    condition     = var.settings_cache_ttl_in_seconds == null || var.settings_cache_ttl_in_seconds >= 0
    error_message = "resource_aws_api_gateway_method_settings, settings_cache_ttl_in_seconds must be greater than or equal to 0."
  }
}

variable "settings_cache_data_encrypted" {
  description = "Whether the cached responses are encrypted"
  type        = bool
  default     = null
}

variable "settings_require_authorization_for_cache_control" {
  description = "Whether authorization is required for a cache invalidation request"
  type        = bool
  default     = null
}

variable "settings_unauthorized_cache_control_header_strategy" {
  description = "How to handle unauthorized requests for cache invalidation"
  type        = string
  default     = null

  validation {
    condition     = var.settings_unauthorized_cache_control_header_strategy == null || can(regex("^(FAIL_WITH_403|SUCCEED_WITH_RESPONSE_HEADER|SUCCEED_WITHOUT_RESPONSE_HEADER)$", var.settings_unauthorized_cache_control_header_strategy))
    error_message = "resource_aws_api_gateway_method_settings, settings_unauthorized_cache_control_header_strategy must be one of: FAIL_WITH_403, SUCCEED_WITH_RESPONSE_HEADER, SUCCEED_WITHOUT_RESPONSE_HEADER."
  }
}