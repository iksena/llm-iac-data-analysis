variable "administrator_account_id" {
  description = "The AWS account ID for the account that sent the invitation"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.administrator_account_id))
    error_message = "resource_aws_macie2_invitation_accepter, administrator_account_id must be a 12-digit AWS account ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_macie2_invitation_accepter, region must be a valid AWS region format or null."
  }
}