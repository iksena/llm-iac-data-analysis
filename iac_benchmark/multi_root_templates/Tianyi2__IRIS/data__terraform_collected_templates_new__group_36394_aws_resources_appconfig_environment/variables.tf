variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_id" {
  description = "AppConfig application ID. Must be between 4 and 7 characters in length."
  type        = string

  validation {
    condition     = length(var.application_id) >= 4 && length(var.application_id) <= 7
    error_message = "resource_aws_appconfig_environment, application_id must be between 4 and 7 characters in length."
  }
}

variable "name" {
  description = "Name for the environment. Must be between 1 and 64 characters in length."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "resource_aws_appconfig_environment, name must be between 1 and 64 characters in length."
  }
}

variable "description" {
  description = "Description of the environment. Can be at most 1024 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_appconfig_environment, description can be at most 1024 characters."
  }
}

variable "monitor" {
  description = "Set of Amazon CloudWatch alarms to monitor during the deployment process. Maximum of 5."
  type = list(object({
    alarm_arn      = string
    alarm_role_arn = optional(string)
  }))
  default = []

  validation {
    condition     = length(var.monitor) <= 5
    error_message = "resource_aws_appconfig_environment, monitor can have a maximum of 5 blocks."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}