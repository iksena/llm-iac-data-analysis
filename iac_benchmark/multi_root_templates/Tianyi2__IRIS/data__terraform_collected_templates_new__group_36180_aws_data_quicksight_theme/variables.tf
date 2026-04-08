variable "theme_id" {
  description = "Identifier of the theme."
  type        = string

  validation {
    condition     = can(regex("^[\\w\\-_]+(\\.[\\w\\-_]+)*$", var.theme_id))
    error_message = "data_aws_quicksight_theme, theme_id must be a valid theme identifier containing only alphanumeric characters, hyphens, underscores, and periods."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "data_aws_quicksight_theme, aws_account_id must be a valid 12-digit AWS account ID or null."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_quicksight_theme, region must be a valid AWS region identifier or null."
  }
}