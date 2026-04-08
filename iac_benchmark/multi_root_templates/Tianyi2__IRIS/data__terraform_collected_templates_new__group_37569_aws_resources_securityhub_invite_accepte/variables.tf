variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_securityhub_invite_accepter, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "master_id" {
  type        = string
  description = "The account ID of the master Security Hub account whose invitation you're accepting."

  validation {
    condition     = can(regex("^[0-9]{12}$", var.master_id))
    error_message = "resource_aws_securityhub_invite_accepter, master_id must be a valid 12-digit AWS account ID."
  }
}