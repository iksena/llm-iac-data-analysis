variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "inline_policy" {
  description = "The IAM inline policy to attach to a Permission Set."
  type        = string

  validation {
    condition     = length(var.inline_policy) > 0
    error_message = "resource_aws_ssoadmin_permission_set_inline_policy, inline_policy must not be empty."
  }
}

variable "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance under which the operation will be executed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::instance/ssoins-[0-9a-f]+$", var.instance_arn))
    error_message = "resource_aws_ssoadmin_permission_set_inline_policy, instance_arn must be a valid SSO Instance ARN."
  }
}

variable "permission_set_arn" {
  description = "The Amazon Resource Name (ARN) of the Permission Set."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::permissionSet/.+$", var.permission_set_arn))
    error_message = "resource_aws_ssoadmin_permission_set_inline_policy, permission_set_arn must be a valid Permission Set ARN."
  }
}