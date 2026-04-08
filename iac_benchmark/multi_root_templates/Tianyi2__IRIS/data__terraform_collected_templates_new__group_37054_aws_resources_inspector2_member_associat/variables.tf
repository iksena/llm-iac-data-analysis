variable "account_id" {
  description = "ID of the account to associate"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_inspector2_member_association, account_id must be a 12-digit AWS account ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_inspector2_member_association, region must be a valid AWS region name."
  }
}