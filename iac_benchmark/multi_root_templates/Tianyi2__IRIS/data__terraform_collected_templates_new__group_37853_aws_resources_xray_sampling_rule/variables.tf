variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "rule_name" {
  description = "The name of the sampling rule"
  type        = string

  validation {
    condition     = var.rule_name != ""
    error_message = "resource_aws_xray_sampling_rule, rule_name cannot be empty."
  }
}

variable "resource_arn" {
  description = "Matches the ARN of the AWS resource on which the service runs"
  type        = string

  validation {
    condition     = var.resource_arn != ""
    error_message = "resource_aws_xray_sampling_rule, resource_arn cannot be empty."
  }
}

variable "priority" {
  description = "The priority of the sampling rule"
  type        = number

  validation {
    condition     = var.priority >= 1 && var.priority <= 10000
    error_message = "resource_aws_xray_sampling_rule, priority must be between 1 and 10000."
  }
}

variable "fixed_rate" {
  description = "The percentage of matching requests to instrument, after the reservoir is exhausted"
  type        = number

  validation {
    condition     = var.fixed_rate >= 0.0 && var.fixed_rate <= 1.0
    error_message = "resource_aws_xray_sampling_rule, fixed_rate must be between 0.0 and 1.0."
  }
}

variable "reservoir_size" {
  description = "A fixed number of matching requests to instrument per second, prior to applying the fixed rate"
  type        = number

  validation {
    condition     = var.reservoir_size >= 0
    error_message = "resource_aws_xray_sampling_rule, reservoir_size must be greater than or equal to 0."
  }
}

variable "service_name" {
  description = "Matches the name that the service uses to identify itself in segments"
  type        = string

  validation {
    condition     = var.service_name != ""
    error_message = "resource_aws_xray_sampling_rule, service_name cannot be empty."
  }
}

variable "service_type" {
  description = "Matches the origin that the service uses to identify its type in segments"
  type        = string

  validation {
    condition     = var.service_type != ""
    error_message = "resource_aws_xray_sampling_rule, service_type cannot be empty."
  }
}

variable "host" {
  description = "Matches the hostname from a request URL"
  type        = string

  validation {
    condition     = var.host != ""
    error_message = "resource_aws_xray_sampling_rule, host cannot be empty."
  }
}

variable "http_method" {
  description = "Matches the HTTP method of a request"
  type        = string

  validation {
    condition     = var.http_method != ""
    error_message = "resource_aws_xray_sampling_rule, http_method cannot be empty."
  }
}

variable "url_path" {
  description = "Matches the path from a request URL"
  type        = string

  validation {
    condition     = var.url_path != ""
    error_message = "resource_aws_xray_sampling_rule, url_path cannot be empty."
  }
}

variable "rule_version" {
  description = "The version of the sampling rule format"
  type        = number

  validation {
    condition     = var.rule_version == 1
    error_message = "resource_aws_xray_sampling_rule, rule_version must be 1."
  }
}

variable "attributes" {
  description = "Matches attributes derived from the request"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}