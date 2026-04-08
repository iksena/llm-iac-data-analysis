variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the Permission Set."
  type        = string
  default     = null
}

variable "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance under which the operation will be executed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::instance/", var.instance_arn))
    error_message = "resource_aws_ssoadmin_permission_set, instance_arn must be a valid SSO Instance ARN starting with 'arn:aws:sso:::instance/'."
  }
}

variable "name" {
  description = "The name of the Permission Set."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ssoadmin_permission_set, name cannot be empty."
  }
}

variable "relay_state" {
  description = "The relay state URL used to redirect users within the application during the federation authentication process."
  type        = string
  default     = null

  validation {
    condition     = var.relay_state == null || can(regex("^https?://", var.relay_state))
    error_message = "resource_aws_ssoadmin_permission_set, relay_state must be a valid URL starting with http:// or https://."
  }
}

variable "session_duration" {
  description = "The length of time that the application user sessions are valid in the ISO-8601 standard."
  type        = string
  default     = "PT1H"

  validation {
    condition     = can(regex("^PT[0-9]+[HM]$", var.session_duration))
    error_message = "resource_aws_ssoadmin_permission_set, session_duration must be in ISO-8601 format (e.g., PT1H, PT2H, PT30M)."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}