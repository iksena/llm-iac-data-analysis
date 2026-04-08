variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "fsx_filesystem_arn" {
  description = "The Amazon Resource Name (ARN) for the FSx for Lustre file system."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:fsx:", var.fsx_filesystem_arn))
    error_message = "resource_aws_datasync_location_fsx_lustre_file_system, fsx_filesystem_arn must be a valid FSx ARN starting with 'arn:aws:fsx:'."
  }
}

variable "security_group_arns" {
  description = "The Amazon Resource Names (ARNs) of the security groups that are to use to configure the FSx for Lustre file system."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_group_arns == null ? true : alltrue([
      for arn in var.security_group_arns : can(regex("^arn:aws:ec2:", arn))
    ])
    error_message = "resource_aws_datasync_location_fsx_lustre_file_system, security_group_arns must be valid EC2 Security Group ARNs starting with 'arn:aws:ec2:'."
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