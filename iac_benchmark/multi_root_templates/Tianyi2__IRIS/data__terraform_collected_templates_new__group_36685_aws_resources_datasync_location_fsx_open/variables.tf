variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "fsx_filesystem_arn" {
  description = "The Amazon Resource Name (ARN) for the FSx for OpenZfs file system."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-z0-9-]*:fsx:[a-z0-9-]+:[0-9]{12}:file-system/fs-[a-z0-9]+$", var.fsx_filesystem_arn))
    error_message = "resource_aws_datasync_location_fsx_openzfs_file_system, fsx_filesystem_arn must be a valid FSx file system ARN."
  }
}

variable "security_group_arns" {
  description = "The Amazon Resource Names (ARNs) of the security groups that are to use to configure the FSx for openzfs file system."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_group_arns == null ? true : alltrue([
      for arn in var.security_group_arns : can(regex("^arn:aws[a-z0-9-]*:ec2:[a-z0-9-]+:[0-9]{12}:security-group/sg-[a-z0-9]+$", arn))
    ])
    error_message = "resource_aws_datasync_location_fsx_openzfs_file_system, security_group_arns must contain valid security group ARNs."
  }
}

variable "subdirectory" {
  description = "Subdirectory to perform actions as source or destination. Must start with `/fsx`."
  type        = string
  default     = null

  validation {
    condition     = var.subdirectory == null ? true : can(regex("^/fsx", var.subdirectory))
    error_message = "resource_aws_datasync_location_fsx_openzfs_file_system, subdirectory must start with '/fsx'."
  }
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location."
  type        = map(string)
  default     = {}
}

variable "protocol_nfs_mount_options_version" {
  description = "The specific NFS version that you want DataSync to use for mounting your NFS share."
  type        = string
  default     = "AUTOMATIC"

  validation {
    condition     = contains(["AUTOMATIC", "NFS3", "NFS4_0", "NFS4_1"], var.protocol_nfs_mount_options_version)
    error_message = "resource_aws_datasync_location_fsx_openzfs_file_system, protocol_nfs_mount_options_version must be one of: AUTOMATIC, NFS3, NFS4_0, NFS4_1."
  }
}