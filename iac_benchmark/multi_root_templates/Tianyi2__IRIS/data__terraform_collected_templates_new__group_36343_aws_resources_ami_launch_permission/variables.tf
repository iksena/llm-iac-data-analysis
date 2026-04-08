variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_id" {
  description = "AWS account ID for the launch permission."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_ami_launch_permission, account_id must be a 12-digit AWS account ID."
  }
}

variable "group" {
  description = "Name of the group for the launch permission. Valid values: \"all\"."
  type        = string
  default     = null

  validation {
    condition     = var.group == null || var.group == "all"
    error_message = "resource_aws_ami_launch_permission, group must be \"all\" if specified."
  }
}

variable "image_id" {
  description = "ID of the AMI."
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-f]{8}$|^ami-[0-9a-f]{17}$", var.image_id))
    error_message = "resource_aws_ami_launch_permission, image_id must be a valid AMI ID (ami-xxxxxxxx or ami-xxxxxxxxxxxxxxxxx)."
  }
}

variable "organization_arn" {
  description = "ARN of an organization for the launch permission."
  type        = string
  default     = null

  validation {
    condition     = var.organization_arn == null || can(regex("^arn:aws:organizations::[0-9]{12}:organization/o-[0-9a-z]{10,32}$", var.organization_arn))
    error_message = "resource_aws_ami_launch_permission, organization_arn must be a valid AWS Organizations ARN."
  }
}

variable "organizational_unit_arn" {
  description = "ARN of an organizational unit for the launch permission."
  type        = string
  default     = null

  validation {
    condition     = var.organizational_unit_arn == null || can(regex("^arn:aws:organizations::[0-9]{12}:ou/o-[0-9a-z]{10,32}/ou-[0-9a-z]{8,32}$", var.organizational_unit_arn))
    error_message = "resource_aws_ami_launch_permission, organizational_unit_arn must be a valid AWS Organizational Unit ARN."
  }
}