variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the account setting to set."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ecs_account_setting_default, name must be a non-empty string."
  }
}

variable "value" {
  description = "State of the setting."
  type        = string

  validation {
    condition     = length(var.value) > 0
    error_message = "resource_aws_ecs_account_setting_default, value must be a non-empty string."
  }
}