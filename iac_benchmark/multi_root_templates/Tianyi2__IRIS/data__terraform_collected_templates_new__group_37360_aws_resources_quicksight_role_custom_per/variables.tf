variable "custom_permissions_name" {
  description = "Custom permissions profile name"
  type        = string

  validation {
    condition     = length(var.custom_permissions_name) > 0
    error_message = "resource_aws_quicksight_role_custom_permission, custom_permissions_name must not be empty."
  }
}

variable "role" {
  description = "Role. Valid values are ADMIN, AUTHOR, READER, ADMIN_PRO, AUTHOR_PRO, and READER_PRO"
  type        = string

  validation {
    condition     = contains(["ADMIN", "AUTHOR", "READER", "ADMIN_PRO", "AUTHOR_PRO", "READER_PRO"], var.role)
    error_message = "resource_aws_quicksight_role_custom_permission, role must be one of: ADMIN, AUTHOR, READER, ADMIN_PRO, AUTHOR_PRO, READER_PRO."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider"
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_role_custom_permission, aws_account_id must be a 12-digit number when specified."
  }
}

variable "namespace" {
  description = "Namespace containing the role. Defaults to default"
  type        = string
  default     = null

  validation {
    condition     = var.namespace == null || length(var.namespace) > 0
    error_message = "resource_aws_quicksight_role_custom_permission, namespace must not be empty when specified."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "resource_aws_quicksight_role_custom_permission, region must not be empty when specified."
  }
}