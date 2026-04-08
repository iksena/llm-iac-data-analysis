variable "name" {
  type        = string
  description = "A unique name to identify the response headers policy."
}

variable "comment" {
  type        = string
  description = "A comment to describe the response headers policy. The comment cannot be longer than 128 characters."
  default     = null

  validation {
    condition     = var.comment == null ? true : length(var.comment) <= 128
    error_message = "resource_aws_cloudfront_response_headers_policy, comment must be no longer than 128 characters."
  }
}

variable "cors_config" {
  type = object({
    access_control_allow_credentials = bool
    access_control_allow_headers     = list(string)
    access_control_allow_methods     = list(string)
    access_control_allow_origins     = list(string)
    access_control_expose_headers    = optional(list(string))
    access_control_max_age_sec       = optional(number)
    origin_override                  = bool
  })
  description = "A configuration for a set of HTTP response headers that are used for Cross-Origin Resource Sharing (CORS)."
  default     = null

  validation {
    condition = var.cors_config == null ? true : alltrue([
      for method in var.cors_config.access_control_allow_methods :
      contains(["GET", "POST", "OPTIONS", "PUT", "DELETE", "HEAD", "ALL"], method)
    ])
    error_message = "resource_aws_cloudfront_response_headers_policy, access_control_allow_methods must be one of: GET, POST, OPTIONS, PUT, DELETE, HEAD, ALL."
  }
}

variable "custom_headers_config" {
  type = object({
    items = optional(list(object({
      header   = string
      override = bool
      value    = string
    })))
  })
  description = "Object that contains an attribute items that contains a list of custom headers."
  default     = null
}

variable "remove_headers_config" {
  type = object({
    items = optional(list(object({
      header = string
    })))
  })
  description = "A configuration for a set of HTTP headers to remove from the HTTP response."
  default     = null
}

variable "security_headers_config" {
  type = object({
    content_security_policy = optional(object({
      content_security_policy = string
      override                = bool
    }))
    content_type_options = optional(object({
      override = bool
    }))
    frame_options = optional(object({
      frame_option = string
      override     = bool
    }))
    referrer_policy = optional(object({
      referrer_policy = string
      override        = bool
    }))
    strict_transport_security = optional(object({
      access_control_max_age_sec = number
      include_subdomains         = optional(bool)
      override                   = bool
      preload                    = optional(bool)
    }))
    xss_protection = optional(object({
      mode_block = optional(bool)
      override   = bool
      protection = bool
      report_uri = optional(string)
    }))
  })
  description = "A configuration for a set of security-related HTTP response headers."
  default     = null

  validation {
    condition = var.security_headers_config == null ? true : (
      var.security_headers_config.frame_options == null ? true :
      contains(["DENY", "SAMEORIGIN"], var.security_headers_config.frame_options.frame_option)
    )
    error_message = "resource_aws_cloudfront_response_headers_policy, frame_option must be either DENY or SAMEORIGIN."
  }

  validation {
    condition = var.security_headers_config == null ? true : (
      var.security_headers_config.referrer_policy == null ? true :
      contains([
        "no-referrer",
        "no-referrer-when-downgrade",
        "origin",
        "origin-when-cross-origin",
        "same-origin",
        "strict-origin",
        "strict-origin-when-cross-origin",
        "unsafe-url"
      ], var.security_headers_config.referrer_policy.referrer_policy)
    )
    error_message = "resource_aws_cloudfront_response_headers_policy, referrer_policy must be one of: no-referrer, no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url."
  }

  validation {
    condition = var.security_headers_config == null ? true : (
      var.security_headers_config.xss_protection == null ? true : (
        var.security_headers_config.xss_protection.mode_block == true ? var.security_headers_config.xss_protection.report_uri == null : true
      )
    )
    error_message = "resource_aws_cloudfront_response_headers_policy, report_uri cannot be specified when mode_block is true."
  }
}

variable "server_timing_headers_config" {
  type = object({
    enabled       = bool
    sampling_rate = number
  })
  description = "A configuration for enabling the Server-Timing header in HTTP responses sent from CloudFront."
  default     = null

  validation {
    condition     = var.server_timing_headers_config == null ? true : (var.server_timing_headers_config.sampling_rate >= 0.0 && var.server_timing_headers_config.sampling_rate <= 100.0)
    error_message = "resource_aws_cloudfront_response_headers_policy, sampling_rate must be between 0.0 and 100.0 inclusive."
  }
}