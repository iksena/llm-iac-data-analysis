variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_group_membership, aws_account_id must be a 12-digit AWS account ID or null."
  }
}

variable "group_name" {
  description = "The name of the group in which the member will be added."
  type        = string

  validation {
    condition     = length(var.group_name) > 0
    error_message = "resource_aws_quicksight_group_membership, group_name cannot be empty."
  }
}

variable "member_name" {
  description = "The name of the member to add to the group."
  type        = string

  validation {
    condition     = length(var.member_name) > 0
    error_message = "resource_aws_quicksight_group_membership, member_name cannot be empty."
  }
}

variable "namespace" {
  description = "The namespace that you want the user to be a part of. Defaults to 'default'."
  type        = string
  default     = "default"

  validation {
    condition     = length(var.namespace) > 0
    error_message = "resource_aws_quicksight_group_membership, namespace cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}[a-z]$", var.region)) || can(regex("^us-gov-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^cn-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_quicksight_group_membership, region must be a valid AWS region identifier or null."
  }
}