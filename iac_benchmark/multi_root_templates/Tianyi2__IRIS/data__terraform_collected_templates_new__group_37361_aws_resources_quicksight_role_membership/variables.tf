variable "member_name" {
  description = "Name of the group to be added to the role"
  type        = string

  validation {
    condition     = length(var.member_name) > 0
    error_message = "resource_aws_quicksight_role_membership, member_name cannot be empty."
  }
}

variable "role" {
  description = "Role to add the group to"
  type        = string

  validation {
    condition = contains([
      "ADMIN",
      "AUTHOR",
      "READER",
      "ADMIN_PRO",
      "AUTHOR_PRO",
      "READER_PRO"
    ], var.role)
    error_message = "resource_aws_quicksight_role_membership, role must be one of: ADMIN, AUTHOR, READER, ADMIN_PRO, AUTHOR_PRO, READER_PRO."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider"
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_role_membership, aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "namespace" {
  description = "Name of the namespace"
  type        = string
  default     = "default"

  validation {
    condition     = length(var.namespace) > 0
    error_message = "resource_aws_quicksight_role_membership, namespace cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_quicksight_role_membership, region must be a valid AWS region format."
  }
}