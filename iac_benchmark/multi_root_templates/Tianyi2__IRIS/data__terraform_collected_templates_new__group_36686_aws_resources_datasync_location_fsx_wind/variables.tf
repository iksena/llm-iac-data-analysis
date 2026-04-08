variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "fsx_filesystem_arn" {
  description = "The Amazon Resource Name (ARN) for the FSx for Windows file system."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:fsx:", var.fsx_filesystem_arn))
    error_message = "resource_aws_datasync_location_fsx_windows_file_system, fsx_filesystem_arn must be a valid FSx ARN starting with 'arn:aws:fsx:'."
  }
}

variable "password" {
  description = "The password of the user who has the permissions to access files and folders in the FSx for Windows file system."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.password) > 0
    error_message = "resource_aws_datasync_location_fsx_windows_file_system, password cannot be empty."
  }
}

variable "user" {
  description = "The user who has the permissions to access files and folders in the FSx for Windows file system."
  type        = string

  validation {
    condition     = length(var.user) > 0
    error_message = "resource_aws_datasync_location_fsx_windows_file_system, user cannot be empty."
  }
}

variable "domain" {
  description = "The name of the Windows domain that the FSx for Windows server belongs to."
  type        = string
  default     = null
}

variable "security_group_arns" {
  description = "The Amazon Resource Names (ARNs) of the security groups that are to use to configure the FSx for Windows file system."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_group_arns == null || alltrue([
      for arn in var.security_group_arns : can(regex("^arn:aws:ec2:", arn))
    ])
    error_message = "resource_aws_datasync_location_fsx_windows_file_system, security_group_arns must be valid EC2 security group ARNs starting with 'arn:aws:ec2:'."
  }
}

variable "subdirectory" {
  description = "Subdirectory to perform actions as source or destination."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location."
  type        = map(string)
  default     = {}
}