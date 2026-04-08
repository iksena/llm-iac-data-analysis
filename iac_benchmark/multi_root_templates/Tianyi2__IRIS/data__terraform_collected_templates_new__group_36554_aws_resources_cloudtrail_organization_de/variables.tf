variable "account_id" {
  description = "An organization member account ID that you want to designate as a delegated administrator."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_cloudtrail_organization_delegated_admin_account, account_id must be a valid 12-digit AWS account ID."
  }
}