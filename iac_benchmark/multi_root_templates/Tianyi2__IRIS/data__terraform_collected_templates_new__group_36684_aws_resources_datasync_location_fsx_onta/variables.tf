
variable "security_group_arns" {
  description = "The security groups that provide access to your file system's preferred subnet"
  type        = list(string)

  validation {
    condition     = length(var.security_group_arns) > 0
    error_message = "resource_aws_datasync_location_fsx_ontap_file_system, security_group_arns must contain at least one security group ARN"
  }

  validation {
    condition = alltrue([
      for arn in var.security_group_arns : can(regex("^arn:aws:ec2:", arn))
    ])
    error_message = "resource_aws_datasync_location_fsx_ontap_file_system, security_group_arns must contain valid security group ARNs starting with 'arn:aws:ec2:'"
  }
}

variable "storage_virtual_machine_arn" {
  description = "The ARN of the SVM in your file system where you want to copy data to or from"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:fsx:.*:storage-virtual-machine/", var.storage_virtual_machine_arn))
    error_message = "resource_aws_datasync_location_fsx_ontap_file_system, storage_virtual_machine_arn must be a valid SVM ARN containing 'storage-virtual-machine/'"
  }
}

variable "protocol" {
  description = "The data transfer protocol that DataSync uses to access your Amazon FSx file system"
  type = object({
    nfs = optional(object({
      mount_options = optional(object({
        version = optional(string, "NFS3")
      }))
    }))
    smb = optional(object({
      domain   = string
      password = string
      user     = string
      mount_options = optional(object({
        version = optional(string, "AUTOMATIC")
      }))
    }))
  })

  validation {
    condition = (
      (var.protocol.nfs != null && var.protocol.smb == null) ||
      (var.protocol.nfs == null && var.protocol.smb != null)
    )
    error_message = "resource_aws_datasync_location_fsx_ontap_file_system, protocol must specify exactly one of 'nfs' or 'smb', not both"
  }

  validation {
    condition = var.protocol.nfs == null || (
      var.protocol.nfs.mount_options == null ||
      var.protocol.nfs.mount_options.version == null ||
      contains(["NFS3"], var.protocol.nfs.mount_options.version)
    )
    error_message = "resource_aws_datasync_location_fsx_ontap_file_system, protocol.nfs.mount_options.version must be 'NFS3'"
  }

  validation {
    condition = var.protocol.smb == null || (
      var.protocol.smb.mount_options == null ||
      var.protocol.smb.mount_options.version == null ||
      contains(["AUTOMATIC", "SMB3", "SMB2", "SMB2_0"], var.protocol.smb.mount_options.version)
    )
    error_message = "resource_aws_datasync_location_fsx_ontap_file_system, protocol.smb.mount_options.version must be one of: AUTOMATIC, SMB3, SMB2, SMB2_0"
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "subdirectory" {
  description = "Path to the file share in the SVM where you'll copy your data"
  type        = string
  default     = null

  validation {
    condition = var.subdirectory == null || (
      can(regex("^/", var.subdirectory)) &&
      (
        can(regex("^/vol[0-9]+$", var.subdirectory)) ||
        can(regex("^/vol[0-9]+/", var.subdirectory)) ||
        can(regex("^/[a-zA-Z0-9_-]+$", var.subdirectory))
      )
    )
    error_message = "resource_aws_datasync_location_fsx_ontap_file_system, subdirectory must be a valid path starting with '/' (e.g., /vol1, /vol1/tree1, or share1)"
  }
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location"
  type        = map(string)
  default     = {}
}