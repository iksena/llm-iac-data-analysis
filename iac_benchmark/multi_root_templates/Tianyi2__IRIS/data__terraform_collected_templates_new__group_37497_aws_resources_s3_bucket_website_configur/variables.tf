variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket."
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_s3_bucket_website_configuration, bucket must not be empty."
  }
}

variable "error_document" {
  description = "Name of the error document for the website. Conflicts with redirect_all_requests_to."
  type = object({
    key = string
  })
  default = null

  validation {
    condition     = var.error_document == null || (var.error_document != null && length(var.error_document.key) > 0)
    error_message = "resource_aws_s3_bucket_website_configuration, error_document.key must not be empty when error_document is specified."
  }
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  type        = string
  default     = null
}

variable "index_document" {
  description = "Name of the index document for the website. Required if redirect_all_requests_to is not specified."
  type = object({
    suffix = string
  })
  default = null

  validation {
    condition     = var.index_document == null || (var.index_document != null && length(var.index_document.suffix) > 0 && !strcontains(var.index_document.suffix, "/"))
    error_message = "resource_aws_s3_bucket_website_configuration, index_document.suffix must not be empty and must not include a slash character."
  }
}

variable "redirect_all_requests_to" {
  description = "Redirect behavior for every request to this bucket's website endpoint. Required if index_document is not specified. Conflicts with error_document, index_document, and routing_rule."
  type = object({
    host_name = string
    protocol  = optional(string)
  })
  default = null

  validation {
    condition     = var.redirect_all_requests_to == null || (var.redirect_all_requests_to != null && length(var.redirect_all_requests_to.host_name) > 0)
    error_message = "resource_aws_s3_bucket_website_configuration, redirect_all_requests_to.host_name must not be empty when redirect_all_requests_to is specified."
  }

  validation {
    condition     = var.redirect_all_requests_to == null || var.redirect_all_requests_to.protocol == null || contains(["http", "https"], var.redirect_all_requests_to.protocol)
    error_message = "resource_aws_s3_bucket_website_configuration, redirect_all_requests_to.protocol must be either 'http' or 'https'."
  }
}

variable "routing_rule" {
  description = "List of rules that define when a redirect is applied and the redirect behavior. Conflicts with redirect_all_requests_to and routing_rules."
  type = list(object({
    condition = optional(object({
      http_error_code_returned_equals = optional(string)
      key_prefix_equals               = optional(string)
    }))
    redirect = object({
      host_name               = optional(string)
      http_redirect_code      = optional(string)
      protocol                = optional(string)
      replace_key_prefix_with = optional(string)
      replace_key_with        = optional(string)
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.routing_rule :
      rule.condition == null || (
        rule.condition.http_error_code_returned_equals != null ||
        rule.condition.key_prefix_equals != null
      )
    ])
    error_message = "resource_aws_s3_bucket_website_configuration, routing_rule condition must specify either http_error_code_returned_equals or key_prefix_equals."
  }

  validation {
    condition = alltrue([
      for rule in var.routing_rule :
      rule.redirect.protocol == null || contains(["http", "https"], rule.redirect.protocol)
    ])
    error_message = "resource_aws_s3_bucket_website_configuration, routing_rule redirect.protocol must be either 'http' or 'https'."
  }

  validation {
    condition = alltrue([
      for rule in var.routing_rule :
      !(rule.redirect.replace_key_prefix_with != null && rule.redirect.replace_key_with != null)
    ])
    error_message = "resource_aws_s3_bucket_website_configuration, routing_rule redirect.replace_key_prefix_with conflicts with replace_key_with."
  }
}

variable "routing_rules" {
  description = "JSON array containing routing rules describing redirect behavior and when redirects are applied. Conflicts with routing_rule and redirect_all_requests_to."
  type        = string
  default     = null
}