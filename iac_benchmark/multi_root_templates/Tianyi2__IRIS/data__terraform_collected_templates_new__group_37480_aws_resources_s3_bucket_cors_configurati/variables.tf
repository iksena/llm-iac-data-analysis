variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]*$", var.bucket))
    error_message = "resource_aws_s3_bucket_cors_configuration, bucket must be a valid S3 bucket name containing only lowercase letters, numbers, dots, and hyphens."
  }
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  type        = string
  default     = null

  validation {
    condition     = var.expected_bucket_owner == null || can(regex("^[0-9]{12}$", var.expected_bucket_owner))
    error_message = "resource_aws_s3_bucket_cors_configuration, expected_bucket_owner must be a 12-digit AWS account ID."
  }
}

variable "cors_rule" {
  description = "Set of origins and methods (cross-origin access that you want to allow). You can configure up to 100 rules."
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    id              = optional(string)
    max_age_seconds = optional(number)
  }))

  validation {
    condition     = length(var.cors_rule) <= 100 && length(var.cors_rule) > 0
    error_message = "resource_aws_s3_bucket_cors_configuration, cors_rule must contain between 1 and 100 rules."
  }

  validation {
    condition = alltrue([
      for rule in var.cors_rule : alltrue([
        for method in rule.allowed_methods : contains(["GET", "PUT", "HEAD", "POST", "DELETE"], method)
      ])
    ])
    error_message = "resource_aws_s3_bucket_cors_configuration, cors_rule allowed_methods must contain only valid HTTP methods: GET, PUT, HEAD, POST, DELETE."
  }

  validation {
    condition = alltrue([
      for rule in var.cors_rule : rule.id == null || length(rule.id) <= 255
    ])
    error_message = "resource_aws_s3_bucket_cors_configuration, cors_rule id cannot be longer than 255 characters."
  }

  validation {
    condition = alltrue([
      for rule in var.cors_rule : rule.max_age_seconds == null || rule.max_age_seconds >= 0
    ])
    error_message = "resource_aws_s3_bucket_cors_configuration, cors_rule max_age_seconds must be a non-negative integer."
  }
}