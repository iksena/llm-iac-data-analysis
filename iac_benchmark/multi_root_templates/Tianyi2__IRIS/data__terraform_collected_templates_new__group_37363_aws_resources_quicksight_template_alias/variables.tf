variable "alias_name" {
  description = "Display name of the template alias."
  type        = string

  validation {
    condition     = length(var.alias_name) > 0
    error_message = "resource_aws_quicksight_template_alias, alias_name must be a non-empty string."
  }
}

variable "template_id" {
  description = "ID of the template."
  type        = string

  validation {
    condition     = length(var.template_id) > 0
    error_message = "resource_aws_quicksight_template_alias, template_id must be a non-empty string."
  }
}

variable "template_version_number" {
  description = "Version number of the template."
  type        = number

  validation {
    condition     = var.template_version_number > 0
    error_message = "resource_aws_quicksight_template_alias, template_version_number must be a positive number."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_template_alias, aws_account_id must be a 12-digit AWS account ID or null."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_quicksight_template_alias, region must be a valid AWS region identifier or null."
  }
}