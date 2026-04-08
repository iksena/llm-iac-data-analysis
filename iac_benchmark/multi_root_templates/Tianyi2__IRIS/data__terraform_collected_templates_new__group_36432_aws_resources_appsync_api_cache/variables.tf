variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "api_id" {
  description = "GraphQL API ID."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.api_id))
    error_message = "resource_aws_appsync_api_cache, api_id must be a valid API ID."
  }
}

variable "api_caching_behavior" {
  description = "Caching behavior. Valid values are FULL_REQUEST_CACHING and PER_RESOLVER_CACHING."
  type        = string

  validation {
    condition     = contains(["FULL_REQUEST_CACHING", "PER_RESOLVER_CACHING"], var.api_caching_behavior)
    error_message = "resource_aws_appsync_api_cache, api_caching_behavior must be either FULL_REQUEST_CACHING or PER_RESOLVER_CACHING."
  }
}

variable "type" {
  description = "Cache instance type. Valid values are SMALL, MEDIUM, LARGE, XLARGE, LARGE_2X, LARGE_4X, LARGE_8X, LARGE_12X, T2_SMALL, T2_MEDIUM, R4_LARGE, R4_XLARGE, R4_2XLARGE, R4_4XLARGE, R4_8XLARGE."
  type        = string

  validation {
    condition = contains([
      "SMALL", "MEDIUM", "LARGE", "XLARGE", "LARGE_2X", "LARGE_4X", "LARGE_8X", "LARGE_12X",
      "T2_SMALL", "T2_MEDIUM", "R4_LARGE", "R4_XLARGE", "R4_2XLARGE", "R4_4XLARGE", "R4_8XLARGE"
    ], var.type)
    error_message = "resource_aws_appsync_api_cache, type must be one of: SMALL, MEDIUM, LARGE, XLARGE, LARGE_2X, LARGE_4X, LARGE_8X, LARGE_12X, T2_SMALL, T2_MEDIUM, R4_LARGE, R4_XLARGE, R4_2XLARGE, R4_4XLARGE, R4_8XLARGE."
  }
}

variable "ttl" {
  description = "TTL in seconds for cache entries."
  type        = number

  validation {
    condition     = var.ttl > 0
    error_message = "resource_aws_appsync_api_cache, ttl must be greater than 0."
  }
}

variable "at_rest_encryption_enabled" {
  description = "At-rest encryption flag for cache. You cannot update this setting after creation."
  type        = bool
  default     = null
}

variable "transit_encryption_enabled" {
  description = "Transit encryption flag when connecting to cache. You cannot update this setting after creation."
  type        = bool
  default     = null
}