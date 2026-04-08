variable "name" {
  description = "Unique name to identify the origin request policy"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cloudfront_origin_request_policy, name must not be empty."
  }
}

variable "comment" {
  description = "Comment to describe the origin request policy"
  type        = string
  default     = null
}

variable "cookies_config" {
  description = "Object that determines whether any cookies in viewer requests (and if so, which cookies) are included in the origin request key and automatically included in requests that CloudFront sends to the origin"
  type = object({
    cookie_behavior = string
    cookies = optional(object({
      items = list(string)
    }))
  })

  validation {
    condition     = contains(["none", "whitelist", "all", "allExcept"], var.cookies_config.cookie_behavior)
    error_message = "resource_aws_cloudfront_origin_request_policy, cookies_config.cookie_behavior must be one of: none, whitelist, all, allExcept."
  }

  validation {
    condition = (
      var.cookies_config.cookie_behavior == "none" ? var.cookies_config.cookies == null :
      contains(["whitelist", "allExcept"], var.cookies_config.cookie_behavior) ? var.cookies_config.cookies != null :
      true
    )
    error_message = "resource_aws_cloudfront_origin_request_policy, cookies_config.cookies is required when cookie_behavior is 'whitelist' or 'allExcept', and must be null when cookie_behavior is 'none'."
  }

  validation {
    condition = (
      var.cookies_config.cookies != null ?
      length(var.cookies_config.cookies.items) > 0 :
      true
    )
    error_message = "resource_aws_cloudfront_origin_request_policy, cookies_config.cookies.items must not be empty when cookies is specified."
  }
}

variable "headers_config" {
  description = "Object that determines whether any HTTP headers (and if so, which headers) are included in the origin request key and automatically included in requests that CloudFront sends to the origin"
  type = object({
    header_behavior = string
    headers = optional(object({
      items = list(string)
    }))
  })

  validation {
    condition     = contains(["none", "whitelist", "allViewer", "allViewerAndWhitelistCloudFront", "allExcept"], var.headers_config.header_behavior)
    error_message = "resource_aws_cloudfront_origin_request_policy, headers_config.header_behavior must be one of: none, whitelist, allViewer, allViewerAndWhitelistCloudFront, allExcept."
  }

  validation {
    condition = (
      var.headers_config.header_behavior == "none" ? var.headers_config.headers == null :
      contains(["whitelist", "allViewerAndWhitelistCloudFront", "allExcept"], var.headers_config.header_behavior) ? var.headers_config.headers != null :
      true
    )
    error_message = "resource_aws_cloudfront_origin_request_policy, headers_config.headers is required when header_behavior is 'whitelist', 'allViewerAndWhitelistCloudFront', or 'allExcept', and must be null when header_behavior is 'none'."
  }

  validation {
    condition = (
      var.headers_config.headers != null ?
      length(var.headers_config.headers.items) > 0 :
      true
    )
    error_message = "resource_aws_cloudfront_origin_request_policy, headers_config.headers.items must not be empty when headers is specified."
  }
}

variable "query_strings_config" {
  description = "Object that determines whether any URL query strings in viewer requests (and if so, which query strings) are included in the origin request key and automatically included in requests that CloudFront sends to the origin"
  type = object({
    query_string_behavior = string
    query_strings = optional(object({
      items = list(string)
    }))
  })

  validation {
    condition     = contains(["none", "whitelist", "all", "allExcept"], var.query_strings_config.query_string_behavior)
    error_message = "resource_aws_cloudfront_origin_request_policy, query_strings_config.query_string_behavior must be one of: none, whitelist, all, allExcept."
  }

  validation {
    condition = (
      var.query_strings_config.query_string_behavior == "none" ? var.query_strings_config.query_strings == null :
      contains(["whitelist", "allExcept"], var.query_strings_config.query_string_behavior) ? var.query_strings_config.query_strings != null :
      true
    )
    error_message = "resource_aws_cloudfront_origin_request_policy, query_strings_config.query_strings is required when query_string_behavior is 'whitelist' or 'allExcept', and must be null when query_string_behavior is 'none'."
  }

  validation {
    condition = (
      var.query_strings_config.query_strings != null ?
      length(var.query_strings_config.query_strings.items) > 0 :
      true
    )
    error_message = "resource_aws_cloudfront_origin_request_policy, query_strings_config.query_strings.items must not be empty when query_strings is specified."
  }
}