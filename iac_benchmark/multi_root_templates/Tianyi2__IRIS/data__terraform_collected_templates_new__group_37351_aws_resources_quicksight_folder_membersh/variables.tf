variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "Identifier for the folder."
  type        = string

  validation {
    condition     = can(regex("^.+$", var.folder_id))
    error_message = "resource_aws_quicksight_folder_membership, folder_id must be a non-empty string."
  }
}

variable "member_id" {
  description = "ID of the asset (the dashboard, analysis, or dataset)."
  type        = string

  validation {
    condition     = can(regex("^.+$", var.member_id))
    error_message = "resource_aws_quicksight_folder_membership, member_id must be a non-empty string."
  }
}

variable "member_type" {
  description = "Type of the member. Valid values are ANALYSIS, DASHBOARD, and DATASET."
  type        = string

  validation {
    condition     = contains(["ANALYSIS", "DASHBOARD", "DATASET"], var.member_type)
    error_message = "resource_aws_quicksight_folder_membership, member_type must be one of: ANALYSIS, DASHBOARD, DATASET."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}