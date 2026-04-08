variable "name" {
  description = "The name of the application, must be unique within your account"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 100
    error_message = "resource_aws_elastic_beanstalk_application, name must be between 1 and 100 characters."
  }
}

variable "description" {
  description = "Short description of the application"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of tags for the Elastic Beanstalk Application"
  type        = map(string)
  default     = {}
}

variable "appversion_lifecycle" {
  description = "Application version lifecycle configuration"
  type = object({
    service_role          = string
    max_count             = optional(number)
    max_age_in_days       = optional(number)
    delete_source_from_s3 = optional(bool, false)
  })
  default = null

  validation {
    condition = var.appversion_lifecycle == null || (
      var.appversion_lifecycle.max_count == null ||
      var.appversion_lifecycle.max_age_in_days == null
    )
    error_message = "resource_aws_elastic_beanstalk_application, appversion_lifecycle cannot have both max_count and max_age_in_days set simultaneously."
  }

  validation {
    condition = var.appversion_lifecycle == null || (
      var.appversion_lifecycle.service_role != null &&
      length(var.appversion_lifecycle.service_role) > 0
    )
    error_message = "resource_aws_elastic_beanstalk_application, appversion_lifecycle service_role is required when appversion_lifecycle is configured."
  }

  validation {
    condition = var.appversion_lifecycle == null || (
      var.appversion_lifecycle.max_count == null ||
      (var.appversion_lifecycle.max_count >= 1 && var.appversion_lifecycle.max_count <= 1000)
    )
    error_message = "resource_aws_elastic_beanstalk_application, appversion_lifecycle max_count must be between 1 and 1000."
  }

  validation {
    condition = var.appversion_lifecycle == null || (
      var.appversion_lifecycle.max_age_in_days == null ||
      (var.appversion_lifecycle.max_age_in_days >= 1 && var.appversion_lifecycle.max_age_in_days <= 180)
    )
    error_message = "resource_aws_elastic_beanstalk_application, appversion_lifecycle max_age_in_days must be between 1 and 180 days."
  }
}