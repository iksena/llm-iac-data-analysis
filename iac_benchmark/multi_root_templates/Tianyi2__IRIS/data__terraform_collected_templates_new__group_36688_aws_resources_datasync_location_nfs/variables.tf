variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "server_hostname" {
  description = "Specifies the IP address or DNS name of the NFS server"
  type        = string

  validation {
    condition     = length(var.server_hostname) > 0
    error_message = "resource_aws_datasync_location_nfs, server_hostname must not be empty."
  }
}

variable "subdirectory" {
  description = "Subdirectory to perform actions as source or destination"
  type        = string

  validation {
    condition     = length(var.subdirectory) > 0
    error_message = "resource_aws_datasync_location_nfs, subdirectory must not be empty."
  }
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location"
  type        = map(string)
  default     = {}
}

variable "mount_options" {
  description = "Configuration block containing mount options used by DataSync to access the NFS Server"
  type = object({
    version = optional(string, "AUTOMATIC")
  })
  default = null

  validation {
    condition     = var.mount_options == null || contains(["AUTOMATIC", "NFS3", "NFS4_0", "NFS4_1"], var.mount_options.version)
    error_message = "resource_aws_datasync_location_nfs, mount_options.version must be one of: AUTOMATIC, NFS3, NFS4_0, NFS4_1."
  }
}

variable "on_prem_config" {
  description = "Configuration block containing information for connecting to the NFS File System"
  type = object({
    agent_arns = list(string)
  })

  validation {
    condition     = length(var.on_prem_config.agent_arns) > 0
    error_message = "resource_aws_datasync_location_nfs, on_prem_config.agent_arns must contain at least one ARN."
  }

  validation {
    condition = alltrue([
      for arn in var.on_prem_config.agent_arns :
      can(regex("^arn:aws:datasync:", arn))
    ])
    error_message = "resource_aws_datasync_location_nfs, on_prem_config.agent_arns must contain valid DataSync agent ARNs."
  }
}