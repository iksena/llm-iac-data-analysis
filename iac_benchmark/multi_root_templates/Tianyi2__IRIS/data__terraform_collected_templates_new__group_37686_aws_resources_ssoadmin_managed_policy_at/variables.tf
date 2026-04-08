variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance under which the operation will be executed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::instance/[a-zA-Z0-9-]+$", var.instance_arn))
    error_message = "resource_aws_ssoadmin_managed_policy_attachment, instance_arn must be a valid SSO instance ARN."
  }
}

variable "managed_policy_arn" {
  description = "The IAM managed policy Amazon Resource Name (ARN) to be attached to the Permission Set."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::(aws|[0-9]{12}):policy/[a-zA-Z0-9/_+=,.-]+$", var.managed_policy_arn))
    error_message = "resource_aws_ssoadmin_managed_policy_attachment, managed_policy_arn must be a valid IAM policy ARN."
  }
}

variable "permission_set_arn" {
  description = "The Amazon Resource Name (ARN) of the Permission Set."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::permissionSet/[a-zA-Z0-9-]+/[a-zA-Z0-9-]+$", var.permission_set_arn))
    error_message = "resource_aws_ssoadmin_managed_policy_attachment, permission_set_arn must be a valid SSO permission set ARN."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the managed policy attachment."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_create))
    error_message = "resource_aws_ssoadmin_managed_policy_attachment, timeouts_create must be a valid timeout format (e.g., '10m', '30s', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the managed policy attachment."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_delete))
    error_message = "resource_aws_ssoadmin_managed_policy_attachment, timeouts_delete must be a valid timeout format (e.g., '10m', '30s', '1h')."
  }
}