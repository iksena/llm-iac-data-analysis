variable "name" {
  type        = string
  description = "Unique name used to identify the cache policy."
}

variable "min_ttl" {
  type        = number
  description = "Minimum amount of time, in seconds, that objects should remain in the CloudFront cache before a new request is sent to the origin to check for updates."
  validation {
    condition     = var.min_ttl >= 0
    error_message = "resource_aws_cloudfront_cache_policy, min_ttl must be greater than or equal to 0."
  }
}

variable "max_ttl" {
  type        = number
  description = "Maximum amount of time, in seconds, that objects stay in the CloudFront cache before CloudFront sends another request to the origin to see if the object has been updated."
  default     = null
  validation {
    condition     = var.max_ttl == null || var.max_ttl >= 0
    error_message = "resource_aws_cloudfront_cache_policy, max_ttl must be greater than or equal to 0."
  }
}

variable "default_ttl" {
  type        = number
  description = "Amount of time, in seconds, that objects are allowed to remain in the CloudFront cache before CloudFront sends a new request to the origin server to check if the object has been updated."
  default     = null
  validation {
    condition     = var.default_ttl == null || var.default_ttl >= 0
    error_message = "resource_aws_cloudfront_cache_policy, default_ttl must be greater than or equal to 0."
  }
}

variable "comment" {
  type        = string
  description = "Description for the cache policy."
  default     = null
}

variable "enable_accept_encoding_brotli" {
  type        = bool
  description = "Flag determines whether the Accept-Encoding HTTP header is included in the cache key and in requests that CloudFront sends to the origin."
  default     = null
}

variable "enable_accept_encoding_gzip" {
  type        = bool
  description = "Whether the Accept-Encoding HTTP header is included in the cache key and in requests sent to the origin by CloudFront."
  default     = null
}

variable "cookie_behavior" {
  type        = string
  description = "Whether any cookies in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin."
  validation {
    condition     = contains(["none", "whitelist", "allExcept", "all"], var.cookie_behavior)
    error_message = "resource_aws_cloudfront_cache_policy, cookie_behavior must be one of: none, whitelist, allExcept, all."
  }
}

variable "cookies" {
  type = object({
    items = list(string)
  })
  description = "Object that contains a list of cookie names."
  default     = null
}

variable "header_behavior" {
  type        = string
  description = "Whether any HTTP headers are included in the cache key and automatically included in requests that CloudFront sends to the origin."
  validation {
    condition     = contains(["none", "whitelist"], var.header_behavior)
    error_message = "resource_aws_cloudfront_cache_policy, header_behavior must be one of: none, whitelist."
  }
}

variable "headers" {
  type = object({
    items = list(string)
  })
  description = "Object contains a list of header names."
  default     = null
}

variable "query_string_behavior" {
  type        = string
  description = "Whether URL query strings in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin."
  validation {
    condition     = contains(["none", "whitelist", "allExcept", "all"], var.query_string_behavior)
    error_message = "resource_aws_cloudfront_cache_policy, query_string_behavior must be one of: none, whitelist, allExcept, all."
  }
}

variable "query_strings" {
  type = object({
    items = list(string)
  })
  description = "Configuration parameter that contains a list of query string names."
  default     = null
}