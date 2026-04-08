variable "account_alias" {
  description = "The account alias"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.account_alias)) && length(var.account_alias) >= 3 && length(var.account_alias) <= 63
    error_message = "resource_aws_iam_account_alias, account_alias must be 3-63 characters long, start and end with alphanumeric characters, and contain only lowercase letters, numbers, and hyphens."
  }
}