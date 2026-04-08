variable "folder_id" {
  description = "Identifier for the folder"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.folder_id))
    error_message = "resource_aws_quicksight_folder, folder_id must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "name" {
  description = "Display name for the folder"
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_quicksight_folder, name must not be empty."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider"
  type        = string
  default     = null
  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_folder, aws_account_id must be a 12-digit number if provided."
  }
}

variable "folder_type" {
  description = "The type of folder. By default, it is SHARED"
  type        = string
  default     = "SHARED"
  validation {
    condition     = contains(["SHARED"], var.folder_type)
    error_message = "resource_aws_quicksight_folder, folder_type must be one of: SHARED."
  }
}

variable "parent_folder_arn" {
  description = "The Amazon Resource Name (ARN) for the parent folder. If not set, creates a root-level folder"
  type        = string
  default     = null
  validation {
    condition     = var.parent_folder_arn == null || can(regex("^arn:aws[a-z\\-]*:quicksight:", var.parent_folder_arn))
    error_message = "resource_aws_quicksight_folder, parent_folder_arn must be a valid QuickSight folder ARN if provided."
  }
}

variable "permissions" {
  description = "A set of resource permissions on the folder. Maximum of 64 items"
  type = list(object({
    actions   = list(string)
    principal = string
  }))
  default = []
  validation {
    condition     = length(var.permissions) <= 64
    error_message = "resource_aws_quicksight_folder, permissions cannot exceed 64 items."
  }
  validation {
    condition = alltrue([
      for perm in var.permissions : length(perm.actions) > 0
    ])
    error_message = "resource_aws_quicksight_folder, permissions actions list must not be empty."
  }
  validation {
    condition = alltrue([
      for perm in var.permissions : can(regex("^arn:aws[a-z\\-]*:", perm.principal))
    ])
    error_message = "resource_aws_quicksight_folder, permissions principal must be a valid ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_quicksight_folder, region must be a valid AWS region format if provided."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_quicksight_folder, tags keys must be between 1 and 128 characters."
  }
  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_quicksight_folder, tags values must be between 0 and 256 characters."
  }
}