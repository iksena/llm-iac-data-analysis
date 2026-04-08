variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "access_point_arn" {
  description = "Specifies the Amazon Resource Name (ARN) of the access point that DataSync uses to access the Amazon EFS file system."
  type        = string
  default     = null
}

variable "efs_file_system_arn" {
  description = "Amazon Resource Name (ARN) of EFS File System."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:elasticfilesystem:", var.efs_file_system_arn))
    error_message = "resource_aws_datasync_location_efs, efs_file_system_arn must be a valid EFS ARN."
  }
}

variable "file_system_access_role_arn" {
  description = "Specifies an Identity and Access Management (IAM) role that DataSync assumes when mounting the Amazon EFS file system."
  type        = string
  default     = null

  validation {
    condition     = var.file_system_access_role_arn == null || can(regex("^arn:aws:iam::", var.file_system_access_role_arn))
    error_message = "resource_aws_datasync_location_efs, file_system_access_role_arn must be a valid IAM role ARN."
  }
}

variable "in_transit_encryption" {
  description = "Specifies whether you want DataSync to use TLS encryption when transferring data to or from your Amazon EFS file system. Valid values are NONE and TLS1_2."
  type        = string
  default     = null

  validation {
    condition     = var.in_transit_encryption == null || contains(["NONE", "TLS1_2"], var.in_transit_encryption)
    error_message = "resource_aws_datasync_location_efs, in_transit_encryption must be either NONE or TLS1_2."
  }
}

variable "subdirectory" {
  description = "Subdirectory to perform actions as source or destination. Default /."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/", var.subdirectory))
    error_message = "resource_aws_datasync_location_efs, subdirectory must start with a forward slash (/)."
  }
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location."
  type        = map(string)
  default     = {}
}

variable "ec2_config" {
  description = "Configuration block containing EC2 configurations for connecting to the EFS File System."
  type = object({
    security_group_arns = list(string)
    subnet_arn          = string
  })

  validation {
    condition = alltrue([
      for arn in var.ec2_config.security_group_arns : can(regex("^arn:aws:ec2:", arn))
    ])
    error_message = "resource_aws_datasync_location_efs, security_group_arns must contain valid EC2 security group ARNs."
  }

  validation {
    condition     = can(regex("^arn:aws:ec2:", var.ec2_config.subnet_arn))
    error_message = "resource_aws_datasync_location_efs, subnet_arn must be a valid EC2 subnet ARN."
  }

  validation {
    condition     = length(var.ec2_config.security_group_arns) > 0
    error_message = "resource_aws_datasync_location_efs, security_group_arns must contain at least one security group ARN."
  }
}