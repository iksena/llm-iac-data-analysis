variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance under which the operation will be executed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::instance/", var.instance_arn))
    error_message = "resource_aws_ssoadmin_customer_managed_policy_attachment, instance_arn must be a valid SSO Instance ARN starting with 'arn:aws:sso:::instance/'."
  }
}

variable "permission_set_arn" {
  description = "The Amazon Resource Name (ARN) of the Permission Set."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::permissionSet/", var.permission_set_arn))
    error_message = "resource_aws_ssoadmin_customer_managed_policy_attachment, permission_set_arn must be a valid Permission Set ARN starting with 'arn:aws:sso:::permissionSet/'."
  }
}

variable "customer_managed_policy_reference_name" {
  description = "Name of the customer managed IAM Policy to be attached."
  type        = string

  validation {
    condition     = length(var.customer_managed_policy_reference_name) >= 1 && length(var.customer_managed_policy_reference_name) <= 128
    error_message = "resource_aws_ssoadmin_customer_managed_policy_attachment, customer_managed_policy_reference_name must be between 1 and 128 characters."
  }

  validation {
    condition     = can(regex("^[\\w+=,.@-]+$", var.customer_managed_policy_reference_name))
    error_message = "resource_aws_ssoadmin_customer_managed_policy_attachment, customer_managed_policy_reference_name must contain only alphanumeric characters and the following: +=,.@-."
  }
}

variable "customer_managed_policy_reference_path" {
  description = "The path to the IAM policy to be attached. The default is /."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$", var.customer_managed_policy_reference_path)) || var.customer_managed_policy_reference_path == "/"
    error_message = "resource_aws_ssoadmin_customer_managed_policy_attachment, customer_managed_policy_reference_path must start and end with '/' or be exactly '/'."
  }

  validation {
    condition     = length(var.customer_managed_policy_reference_path) >= 1 && length(var.customer_managed_policy_reference_path) <= 512
    error_message = "resource_aws_ssoadmin_customer_managed_policy_attachment, customer_managed_policy_reference_path must be between 1 and 512 characters."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_ssoadmin_customer_managed_policy_attachment, timeouts_create must be a valid timeout format (e.g., '10m', '1h', '30s')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operation."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_ssoadmin_customer_managed_policy_attachment, timeouts_delete must be a valid timeout format (e.g., '10m', '1h', '30s')."
  }
}