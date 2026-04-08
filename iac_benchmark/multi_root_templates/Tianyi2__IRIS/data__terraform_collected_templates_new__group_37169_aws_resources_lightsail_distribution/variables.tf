variable "bundle_id" {
  description = "Bundle ID to use for the distribution"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.bundle_id))
    error_message = "resource_aws_lightsail_distribution, bundle_id must be a valid bundle ID."
  }
}

variable "name" {
  description = "Name of the distribution"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_lightsail_distribution, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "origin_name" {
  description = "Name of the origin resource"
  type        = string

  validation {
    condition     = length(var.origin_name) > 0
    error_message = "resource_aws_lightsail_distribution, origin_name cannot be empty."
  }
}

variable "origin_region_name" {
  description = "AWS Region name of the origin resource"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.origin_region_name))
    error_message = "resource_aws_lightsail_distribution, origin_region_name must be a valid AWS region name."
  }
}

variable "origin_protocol_policy" {
  description = "Protocol that your Amazon Lightsail distribution uses when establishing a connection with your origin to pull content"
  type        = string
  default     = null
}

variable "default_cache_behavior" {
  description = "Cache behavior of the distribution"
  type        = string

  validation {
    condition     = contains(["cache", "dont-cache"], var.default_cache_behavior)
    error_message = "resource_aws_lightsail_distribution, default_cache_behavior must be either 'cache' or 'dont-cache'."
  }
}

variable "cache_behaviors" {
  description = "Per-path cache behavior of the distribution"
  type = list(object({
    behavior = string
    path     = string
  }))
  default = []

  validation {
    condition = alltrue([
      for cb in var.cache_behaviors : contains(["cache", "dont-cache"], cb.behavior)
    ])
    error_message = "resource_aws_lightsail_distribution, cache_behaviors behavior must be either 'cache' or 'dont-cache'."
  }

  validation {
    condition = alltrue([
      for cb in var.cache_behaviors : length(cb.path) > 0
    ])
    error_message = "resource_aws_lightsail_distribution, cache_behaviors path cannot be empty."
  }
}

variable "cache_behavior_settings" {
  description = "Cache behavior settings of the distribution"
  type = object({
    allowed_http_methods = optional(string)
    cached_http_methods  = optional(string)
    default_ttl          = optional(number)
    maximum_ttl          = optional(number)
    minimum_ttl          = optional(number)
    forwarded_cookies = optional(object({
      option             = optional(string)
      cookies_allow_list = optional(list(string))
    }))
    forwarded_headers = optional(object({
      option             = optional(string)
      headers_allow_list = optional(list(string))
    }))
    forwarded_query_strings = optional(object({
      option                     = optional(bool)
      query_strings_allowed_list = optional(list(string))
    }))
  })
  default = null

  validation {
    condition = var.cache_behavior_settings == null || (
      var.cache_behavior_settings.forwarded_cookies == null ||
      var.cache_behavior_settings.forwarded_cookies.option == null ||
      contains(["all", "none", "allow-list"], var.cache_behavior_settings.forwarded_cookies.option)
    )
    error_message = "resource_aws_lightsail_distribution, cache_behavior_settings forwarded_cookies option must be 'all', 'none', or 'allow-list'."
  }

  validation {
    condition = var.cache_behavior_settings == null || (
      var.cache_behavior_settings.forwarded_headers == null ||
      var.cache_behavior_settings.forwarded_headers.option == null ||
      contains(["default", "allow-list", "all"], var.cache_behavior_settings.forwarded_headers.option)
    )
    error_message = "resource_aws_lightsail_distribution, cache_behavior_settings forwarded_headers option must be 'default', 'allow-list', or 'all'."
  }

  validation {
    condition = var.cache_behavior_settings == null || (
      var.cache_behavior_settings.default_ttl == null ||
      var.cache_behavior_settings.default_ttl >= 0
    )
    error_message = "resource_aws_lightsail_distribution, cache_behavior_settings default_ttl must be greater than or equal to 0."
  }

  validation {
    condition = var.cache_behavior_settings == null || (
      var.cache_behavior_settings.maximum_ttl == null ||
      var.cache_behavior_settings.maximum_ttl >= 0
    )
    error_message = "resource_aws_lightsail_distribution, cache_behavior_settings maximum_ttl must be greater than or equal to 0."
  }

  validation {
    condition = var.cache_behavior_settings == null || (
      var.cache_behavior_settings.minimum_ttl == null ||
      var.cache_behavior_settings.minimum_ttl >= 0
    )
    error_message = "resource_aws_lightsail_distribution, cache_behavior_settings minimum_ttl must be greater than or equal to 0."
  }
}

variable "certificate_name" {
  description = "Name of the SSL/TLS certificate attached to the distribution"
  type        = string
  default     = null
}

variable "ip_address_type" {
  description = "IP address type of the distribution"
  type        = string
  default     = "dualstack"

  validation {
    condition     = contains(["dualstack", "ipv4"], var.ip_address_type)
    error_message = "resource_aws_lightsail_distribution, ip_address_type must be either 'dualstack' or 'ipv4'."
  }
}

variable "is_enabled" {
  description = "Whether the distribution is enabled"
  type        = bool
  default     = true
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags for the Lightsail Distribution"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts"
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
}