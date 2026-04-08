variable "analysis_id" {
  description = "Identifier for the analysis."
  type        = string

  validation {
    condition     = length(var.analysis_id) > 0
    error_message = "data_aws_quicksight_analysis, analysis_id must not be empty."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "data_aws_quicksight_analysis, aws_account_id must be a 12-digit AWS account ID or null."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_quicksight_analysis, region must be a valid AWS region format or null."
  }
}