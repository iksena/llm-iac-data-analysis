variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "alias" {
  description = "The name of the role alias."
  type        = string

  validation {
    condition     = length(var.alias) > 0
    error_message = "resource_aws_iot_role_alias, alias must not be empty."
  }
}

variable "role_arn" {
  description = "The identity of the role to which the alias refers."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/", var.role_arn))
    error_message = "resource_aws_iot_role_alias, role_arn must be a valid IAM role ARN."
  }
}

variable "credential_duration" {
  description = "The duration of the credential, in seconds. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 900 seconds (15 minutes) to 43200 seconds (12 hours)."
  type        = number
  default     = null

  validation {
    condition     = var.credential_duration == null || (var.credential_duration >= 900 && var.credential_duration <= 43200)
    error_message = "resource_aws_iot_role_alias, credential_duration must be between 900 and 43200 seconds."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}
}