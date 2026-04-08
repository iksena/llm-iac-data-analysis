variable "account_id" {
  description = "The AWS account ID to associate with AWS Firewall Manager as the AWS Firewall Manager administrator account. This can be an AWS Organizations master account or a member account. Defaults to the current account. Must be configured to perform drift detection."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_fms_admin_account, account_id must be a valid 12-digit AWS account ID."
  }
}

variable "timeout_create" {
  description = "Timeout for creating the FMS admin account association"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_create))
    error_message = "resource_aws_fms_admin_account, timeout_create must be a valid timeout duration (e.g., '30m', '1h')."
  }
}

variable "timeout_delete" {
  description = "Timeout for deleting the FMS admin account association"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_delete))
    error_message = "resource_aws_fms_admin_account, timeout_delete must be a valid timeout duration (e.g., '10m', '1h')."
  }
}