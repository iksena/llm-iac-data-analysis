variable "delegated_admin_account_id" {
  description = "The Organizations member account ID that you want to enable as the IPAM account"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.delegated_admin_account_id))
    error_message = "resource_aws_vpc_ipam_organization_admin_account, delegated_admin_account_id must be a 12-digit AWS account ID."
  }
}