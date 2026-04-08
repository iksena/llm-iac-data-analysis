variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "agent_arns" {
  description = "A list of DataSync Agent ARNs with which this location will be associated"
  type        = list(string)
  validation {
    condition     = length(var.agent_arns) > 0
    error_message = "resource_aws_datasync_location_smb, agent_arns must contain at least one ARN."
  }
}

variable "domain" {
  description = "The name of the Windows domain the SMB server belongs to"
  type        = string
  default     = null
}

variable "mount_options" {
  description = "Configuration block containing mount options used by DataSync to access the SMB Server"
  type = object({
    version = optional(string, "AUTOMATIC")
  })
  default = null
  validation {
    condition     = var.mount_options == null || contains(["AUTOMATIC", "SMB2", "SMB3"], var.mount_options.version)
    error_message = "resource_aws_datasync_location_smb, mount_options.version must be one of: AUTOMATIC, SMB2, SMB3."
  }
}

variable "password" {
  description = "The password of the user who can mount the share and has file permissions in the SMB"
  type        = string
  sensitive   = true
}

variable "server_hostname" {
  description = "Specifies the IP address or DNS name of the SMB server"
  type        = string
  validation {
    condition     = length(var.server_hostname) > 0
    error_message = "resource_aws_datasync_location_smb, server_hostname cannot be empty."
  }
}

variable "subdirectory" {
  description = "Subdirectory to perform actions as source or destination"
  type        = string
  validation {
    condition     = length(var.subdirectory) > 0
    error_message = "resource_aws_datasync_location_smb, subdirectory cannot be empty."
  }
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location"
  type        = map(string)
  default     = {}
}

variable "user" {
  description = "The user who can mount the share and has file and folder permissions in the SMB share"
  type        = string
  validation {
    condition     = length(var.user) > 0
    error_message = "resource_aws_datasync_location_smb, user cannot be empty."
  }
}