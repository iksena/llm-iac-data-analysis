variable "account_id" {
  description = "Account to enable as delegated admin account"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_inspector2_delegated_admin_account, account_id must be a 12-digit AWS account ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_inspector2_delegated_admin_account, region must be a valid AWS region name or null."
  }
}

variable "create_timeout" {
  description = "Timeout for create operation"
  type        = string
  default     = "15m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.create_timeout))
    error_message = "resource_aws_inspector2_delegated_admin_account, create_timeout must be a valid timeout format (e.g., '15m', '1h', '30s')."
  }
}

variable "delete_timeout" {
  description = "Timeout for delete operation"
  type        = string
  default     = "15m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.delete_timeout))
    error_message = "resource_aws_inspector2_delegated_admin_account, delete_timeout must be a valid timeout format (e.g., '15m', '1h', '30s')."
  }
}