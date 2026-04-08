variable "admin_account_id" {
  description = "The AWS account identifier of the account to designate as the Security Hub administrator account"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.admin_account_id))
    error_message = "resource_aws_securityhub_organization_admin_account, admin_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_securityhub_organization_admin_account, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}