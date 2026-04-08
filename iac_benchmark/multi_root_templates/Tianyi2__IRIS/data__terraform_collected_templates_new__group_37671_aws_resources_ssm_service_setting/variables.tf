variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "setting_id" {
  description = "ID of the service setting. Valid values are shown in the AWS documentation."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ssm:", var.setting_id))
    error_message = "resource_aws_ssm_service_setting, setting_id must be a valid SSM service setting ARN starting with 'arn:aws:ssm:'."
  }
}

variable "setting_value" {
  description = "Value of the service setting."
  type        = string

  validation {
    condition     = length(var.setting_value) > 0
    error_message = "resource_aws_ssm_service_setting, setting_value cannot be empty."
  }
}