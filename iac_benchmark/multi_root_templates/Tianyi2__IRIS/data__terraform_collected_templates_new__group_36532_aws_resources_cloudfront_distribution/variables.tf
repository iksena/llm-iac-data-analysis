variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution"
  type        = list(string)
  default     = []
}

variable "anycast_ip_list_id" {
  description = "ID of the Anycast static IP list that is associated with the distribution"
  type        = string
  default     = null
}

variable "comment" {
  description = "Any comments you want to include about the distribution"
  type        = string
  default     = null
}

variable "continuous_deployment_policy_id" {
  description = "Identifier of a continuous deployment policy. This argument should only be set on a production distribution"
  type        = string
  default     = null
}

variable "custom_error_response" {
  description = "One or more custom error response elements"
  type = list(object({
    error_caching_min_ttl = optional(number)
    error_code            = number
    response_code         = optional(number)
    response_page_path    = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for response in var.custom_error_response : (
        response.error_code >= 400 && response.error_code <= 599
      )
    ])
    error_message = "resource_aws_cloudfront_distribution, custom_error_response.error_code must be a 4xx or 5xx HTTP status code."
  }

  validation {
    condition = alltrue([
      for response in var.custom_error_response : (
        (response.response_page_path == null && response.response_code == null) ||
        (response.response_page_path != null && response.response_code != null)
      )
    ])
    error_message = "resource_aws_cloudfront_distribution, custom_error_response when specifying either response_page_path or response_code, both must be set."
  }
}

variable "default_cache_behavior" {
  description = "Default cache behavior for this distribution"
  type = object({
    allowed_methods           = list(string)
    cached_methods            = list(string)
    cache_policy_id           = optional(string)
    compress                  = optional(bool, false)
    default_ttl               = optional(number)
    field_level_encryption_id = optional(string)
    forwarded_values = optional(object({
      query_string            = bool
      headers                 = optional(list(string))
      query_string_cache_keys = optional(list(string))
      cookies = object({
        forward           = string
        whitelisted_names = optional(list(string))
      })
    }))
    lambda_function_association = optional(list(object({
      event_type   = string
      lambda_arn   = string
      include_body = optional(bool, false)
    })), [])
    function_association = optional(list(object({
      event_type   = string
      function_arn = string
    })), [])
    max_ttl                    = optional(number)
    min_ttl                    = optional(number, 0)
    origin_request_policy_id   = optional(string)
    realtime_log_config_arn    = optional(string)
    response_headers_policy_id = optional(string)
    smooth_streaming           = optional(bool)
    target_origin_id           = string
    trusted_key_groups         = optional(list(string))
    trusted_signers            = optional(list(string))
    viewer_protocol_policy     = string
    grpc_config = optional(object({
      enabled = bool
    }))
  })

  validation {
    condition     = contains(["allow-all", "https-only", "redirect-to-https"], var.default_cache_behavior.viewer_protocol_policy)
    error_message = "resource_aws_cloudfront_distribution, default_cache_behavior.viewer_protocol_policy must be one of: allow-all, https-only, redirect-to-https."
  }

  validation {
    condition = alltrue([
      for assoc in var.default_cache_behavior.lambda_function_association : contains(["viewer-request", "origin-request", "viewer-response", "origin-response"], assoc.event_type)
    ])
    error_message = "resource_aws_cloudfront_distribution, default_cache_behavior.lambda_function_association.event_type must be one of: viewer-request, origin-request, viewer-response, origin-response."
  }

  validation {
    condition = alltrue([
      for assoc in var.default_cache_behavior.function_association : contains(["viewer-request", "viewer-response"], assoc.event_type)
    ])
    error_message = "resource_aws_cloudfront_distribution, default_cache_behavior.function_association.event_type must be one of: viewer-request, viewer-response."
  }

  validation {
    condition     = length(var.default_cache_behavior.lambda_function_association) <= 4
    error_message = "resource_aws_cloudfront_distribution, default_cache_behavior.lambda_function_association maximum 4 associations allowed."
  }

  validation {
    condition     = length(var.default_cache_behavior.function_association) <= 2
    error_message = "resource_aws_cloudfront_distribution, default_cache_behavior.function_association maximum 2 associations allowed."
  }

  validation {
    condition = (
      var.default_cache_behavior.cache_policy_id != null || var.default_cache_behavior.forwarded_values != null
    )
    error_message = "resource_aws_cloudfront_distribution, default_cache_behavior either cache_policy_id or forwarded_values must be set."
  }

  validation {
    condition = var.default_cache_behavior.forwarded_values == null || (
      var.default_cache_behavior.forwarded_values.cookies.forward == "whitelist" && length(var.default_cache_behavior.forwarded_values.cookies.whitelisted_names) > 0
    ) || var.default_cache_behavior.forwarded_values.cookies.forward != "whitelist"
    error_message = "resource_aws_cloudfront_distribution, default_cache_behavior.forwarded_values.cookies if forward is whitelist, whitelisted_names must be specified."
  }
}

variable "default_root_object" {
  description = "Object that you want CloudFront to return when an end user requests the root URL"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content"
  type        = bool
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution"
  type        = bool
  default     = null
}

variable "http_version" {
  description = "Maximum HTTP version to support on the distribution"
  type        = string
  default     = "http2"

  validation {
    condition     = contains(["http1.1", "http2", "http2and3", "http3"], var.http_version)
    error_message = "resource_aws_cloudfront_distribution, http_version must be one of: http1.1, http2, http2and3, http3."
  }
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution"
  type = object({
    bucket          = string
    include_cookies = optional(bool, false)
    prefix          = optional(string)
  })
  default = null
}

variable "ordered_cache_behavior" {
  description = "Ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence"
  type = list(object({
    path_pattern              = string
    allowed_methods           = list(string)
    cached_methods            = list(string)
    cache_policy_id           = optional(string)
    compress                  = optional(bool, false)
    default_ttl               = optional(number)
    field_level_encryption_id = optional(string)
    forwarded_values = optional(object({
      query_string            = bool
      headers                 = optional(list(string))
      query_string_cache_keys = optional(list(string))
      cookies = object({
        forward           = string
        whitelisted_names = optional(list(string))
      })
    }))
    lambda_function_association = optional(list(object({
      event_type   = string
      lambda_arn   = string
      include_body = optional(bool, false)
    })), [])
    function_association = optional(list(object({
      event_type   = string
      function_arn = string
    })), [])
    max_ttl                    = optional(number)
    min_ttl                    = optional(number, 0)
    origin_request_policy_id   = optional(string)
    realtime_log_config_arn    = optional(string)
    response_headers_policy_id = optional(string)
    smooth_streaming           = optional(bool)
    target_origin_id           = string
    trusted_key_groups         = optional(list(string))
    trusted_signers            = optional(list(string))
    viewer_protocol_policy     = string
    grpc_config = optional(object({
      enabled = bool
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for behavior in var.ordered_cache_behavior : contains(["allow-all", "https-only", "redirect-to-https"], behavior.viewer_protocol_policy)
    ])
    error_message = "resource_aws_cloudfront_distribution, ordered_cache_behavior.viewer_protocol_policy must be one of: allow-all, https-only, redirect-to-https."
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_cache_behavior : alltrue([
        for assoc in behavior.lambda_function_association : contains(["viewer-request", "origin-request", "viewer-response", "origin-response"], assoc.event_type)
      ])
    ])
    error_message = "resource_aws_cloudfront_distribution, ordered_cache_behavior.lambda_function_association.event_type must be one of: viewer-request, origin-request, viewer-response, origin-response."
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_cache_behavior : alltrue([
        for assoc in behavior.function_association : contains(["viewer-request", "viewer-response"], assoc.event_type)
      ])
    ])
    error_message = "resource_aws_cloudfront_distribution, ordered_cache_behavior.function_association.event_type must be one of: viewer-request, viewer-response."
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_cache_behavior : length(behavior.lambda_function_association) <= 4
    ])
    error_message = "resource_aws_cloudfront_distribution, ordered_cache_behavior.lambda_function_association maximum 4 associations allowed."
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_cache_behavior : length(behavior.function_association) <= 2
    ])
    error_message = "resource_aws_cloudfront_distribution, ordered_cache_behavior.function_association maximum 2 associations allowed."
  }
}

variable "origin" {
  description = "One or more origins for this distribution"
  type = list(object({
    domain_name                 = string
    origin_id                   = string
    connection_attempts         = optional(number, 3)
    connection_timeout          = optional(number, 10)
    origin_access_control_id    = optional(string)
    origin_path                 = optional(string)
    response_completion_timeout = optional(number)
    custom_header = optional(list(object({
      name  = string
      value = string
    })), [])
    custom_origin_config = optional(object({
      http_port                = number
      https_port               = number
      origin_protocol_policy   = string
      origin_ssl_protocols     = list(string)
      origin_keepalive_timeout = optional(number, 5)
      origin_read_timeout      = optional(number, 30)
    }))
    origin_shield = optional(object({
      enabled              = bool
      origin_shield_region = optional(string)
    }))
    s3_origin_config = optional(object({
      origin_access_identity = string
    }))
    vpc_origin_config = optional(object({
      vpc_origin_id            = string
      origin_keepalive_timeout = optional(number, 5)
      origin_read_timeout      = optional(number, 30)
    }))
  }))

  validation {
    condition     = length(var.origin) > 0
    error_message = "resource_aws_cloudfront_distribution, origin at least one origin must be specified."
  }

  validation {
    condition = alltrue([
      for origin in var.origin : origin.connection_attempts >= 1 && origin.connection_attempts <= 3
    ])
    error_message = "resource_aws_cloudfront_distribution, origin.connection_attempts must be between 1-3."
  }

  validation {
    condition = alltrue([
      for origin in var.origin : origin.connection_timeout >= 1 && origin.connection_timeout <= 10
    ])
    error_message = "resource_aws_cloudfront_distribution, origin.connection_timeout must be between 1-10."
  }

  validation {
    condition = alltrue([
      for origin in var.origin : origin.custom_origin_config == null || contains(["http-only", "https-only", "match-viewer"], origin.custom_origin_config.origin_protocol_policy)
    ])
    error_message = "resource_aws_cloudfront_distribution, origin.custom_origin_config.origin_protocol_policy must be one of: http-only, https-only, match-viewer."
  }

  validation {
    condition = alltrue([
      for origin in var.origin : origin.custom_origin_config == null || alltrue([
        for protocol in origin.custom_origin_config.origin_ssl_protocols : contains(["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"], protocol)
      ])
    ])
    error_message = "resource_aws_cloudfront_distribution, origin.custom_origin_config.origin_ssl_protocols must contain valid SSL/TLS protocols: SSLv3, TLSv1, TLSv1.1, TLSv1.2."
  }

  validation {
    condition = alltrue([
      for origin in var.origin : origin.vpc_origin_config == null || (origin.vpc_origin_config.origin_keepalive_timeout >= 1 && origin.vpc_origin_config.origin_keepalive_timeout <= 60)
    ])
    error_message = "resource_aws_cloudfront_distribution, origin.vpc_origin_config.origin_keepalive_timeout must be between 1-60 seconds."
  }

  validation {
    condition = alltrue([
      for origin in var.origin : origin.vpc_origin_config == null || (origin.vpc_origin_config.origin_read_timeout >= 1 && origin.vpc_origin_config.origin_read_timeout <= 60)
    ])
    error_message = "resource_aws_cloudfront_distribution, origin.vpc_origin_config.origin_read_timeout must be between 1-60 seconds."
  }

  validation {
    condition = alltrue([
      for origin in var.origin : origin.response_completion_timeout == null || origin.response_completion_timeout == 0 || (
        origin.custom_origin_config == null || origin.response_completion_timeout >= origin.custom_origin_config.origin_read_timeout
      )
    ])
    error_message = "resource_aws_cloudfront_distribution, origin.response_completion_timeout must be greater than or equal to origin_read_timeout when specified."
  }
}

variable "origin_group" {
  description = "One or more origin_group for this distribution"
  type = list(object({
    origin_id = string
    failover_criteria = object({
      status_codes = list(number)
    })
    member = list(object({
      origin_id = string
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for group in var.origin_group : length(group.member) == 2
    ])
    error_message = "resource_aws_cloudfront_distribution, origin_group.member you must specify exactly two members."
  }
}

variable "price_class" {
  description = "Price class for this distribution"
  type        = string
  default     = null

  validation {
    condition     = var.price_class == null || contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "resource_aws_cloudfront_distribution, price_class must be one of: PriceClass_All, PriceClass_200, PriceClass_100."
  }
}

variable "restrictions" {
  description = "The restriction configuration for this distribution"
  type = object({
    geo_restriction = object({
      restriction_type = string
      locations        = list(string)
    })
  })

  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.restrictions.geo_restriction.restriction_type)
    error_message = "resource_aws_cloudfront_distribution, restrictions.geo_restriction.restriction_type must be one of: none, whitelist, blacklist."
  }

  validation {
    condition = (
      var.restrictions.geo_restriction.restriction_type == "none" && length(var.restrictions.geo_restriction.locations) == 0
    ) || var.restrictions.geo_restriction.restriction_type != "none"
    error_message = "resource_aws_cloudfront_distribution, restrictions.geo_restriction.locations must be empty when restriction_type is none."
  }
}

variable "staging" {
  description = "A Boolean that indicates whether this is a staging distribution"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type = object({
    acm_certificate_arn            = optional(string)
    cloudfront_default_certificate = optional(bool)
    iam_certificate_id             = optional(string)
    minimum_protocol_version       = optional(string, "TLSv1")
    ssl_support_method             = optional(string)
  })

  validation {
    condition = (
      (var.viewer_certificate.acm_certificate_arn != null ? 1 : 0) +
      (var.viewer_certificate.cloudfront_default_certificate == true ? 1 : 0) +
      (var.viewer_certificate.iam_certificate_id != null ? 1 : 0) == 1
    )
    error_message = "resource_aws_cloudfront_distribution, viewer_certificate exactly one of acm_certificate_arn, cloudfront_default_certificate, or iam_certificate_id must be specified."
  }

  validation {
    condition = (
      var.viewer_certificate.acm_certificate_arn == null && var.viewer_certificate.iam_certificate_id == null
    ) || var.viewer_certificate.ssl_support_method != null
    error_message = "resource_aws_cloudfront_distribution, viewer_certificate.ssl_support_method is required when using custom certificates."
  }

  validation {
    condition     = var.viewer_certificate.ssl_support_method == null || contains(["vip", "sni-only", "static-ip"], var.viewer_certificate.ssl_support_method)
    error_message = "resource_aws_cloudfront_distribution, viewer_certificate.ssl_support_method must be one of: vip, sni-only, static-ip."
  }
}

variable "web_acl_id" {
  description = "Unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution"
  type        = string
  default     = null
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform"
  type        = bool
  default     = false
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed"
  type        = bool
  default     = true
}