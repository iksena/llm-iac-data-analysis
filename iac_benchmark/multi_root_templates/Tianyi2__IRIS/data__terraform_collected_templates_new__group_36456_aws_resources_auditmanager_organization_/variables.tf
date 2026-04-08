variable "admin_account_id" {
  description = "Identifier for the organization administrator account"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.admin_account_id))
    error_message = "resource_aws_auditmanager_organization_admin_account_registration, admin_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$|^[a-z]{2}-[a-z]+-[0-9]{1}[a-z]{1}$|^us-gov-[a-z]+-[0-9]{1}$|^cn-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_auditmanager_organization_admin_account_registration, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}