variable "name" {
  description = "Name of the S3 access point."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_fsx_s3_access_point_attachment, name must not be empty."
  }
}

variable "type" {
  description = "Type of S3 access point. Valid values: OpenZFS."
  type        = string

  validation {
    condition     = contains(["OpenZFS"], var.type)
    error_message = "resource_aws_fsx_s3_access_point_attachment, type must be one of: OpenZFS."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "openzfs_configuration" {
  description = "Configuration to use when creating and attaching an S3 access point to an FSx for OpenZFS volume."
  type = object({
    volume_id = string
    file_system_identity = object({
      type = string
      posix_user = object({
        uid            = number
        gid            = number
        secondary_gids = optional(list(number))
      })
    })
  })

  validation {
    condition     = var.openzfs_configuration.volume_id != null && length(var.openzfs_configuration.volume_id) > 0
    error_message = "resource_aws_fsx_s3_access_point_attachment, volume_id must not be empty."
  }

  validation {
    condition     = contains(["POSIX"], var.openzfs_configuration.file_system_identity.type)
    error_message = "resource_aws_fsx_s3_access_point_attachment, file_system_identity type must be POSIX."
  }

  validation {
    condition     = var.openzfs_configuration.file_system_identity.posix_user.uid >= 0
    error_message = "resource_aws_fsx_s3_access_point_attachment, posix_user uid must be a non-negative number."
  }

  validation {
    condition     = var.openzfs_configuration.file_system_identity.posix_user.gid >= 0
    error_message = "resource_aws_fsx_s3_access_point_attachment, posix_user gid must be a non-negative number."
  }

  validation {
    condition = var.openzfs_configuration.file_system_identity.posix_user.secondary_gids == null || (
      length(var.openzfs_configuration.file_system_identity.posix_user.secondary_gids) == 0 ||
      alltrue([for gid in var.openzfs_configuration.file_system_identity.posix_user.secondary_gids : gid >= 0])
    )
    error_message = "resource_aws_fsx_s3_access_point_attachment, posix_user secondary_gids must be a list of non-negative numbers."
  }
}

variable "s3_access_point" {
  description = "S3 access point configuration."
  type = object({
    policy = string
    vpc_configuration = optional(object({
      vpc_id = string
    }))
  })
  default = null

  validation {
    condition = var.s3_access_point == null || (
      var.s3_access_point.policy != null && length(var.s3_access_point.policy) > 0
    )
    error_message = "resource_aws_fsx_s3_access_point_attachment, s3_access_point policy must not be empty when s3_access_point is specified."
  }

  validation {
    condition = var.s3_access_point == null || var.s3_access_point.vpc_configuration == null || (
      var.s3_access_point.vpc_configuration.vpc_id != null && length(var.s3_access_point.vpc_configuration.vpc_id) > 0
    )
    error_message = "resource_aws_fsx_s3_access_point_attachment, vpc_configuration vpc_id must not be empty when vpc_configuration is specified."
  }
}

variable "timeouts" {
  description = "Timeouts configuration."
  type = object({
    create = optional(string, "15m")
    delete = optional(string, "15m")
  })
  default = {
    create = "15m"
    delete = "15m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_fsx_s3_access_point_attachment, timeouts create must be a valid duration (e.g., 15m, 1h)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_fsx_s3_access_point_attachment, timeouts delete must be a valid duration (e.g., 15m, 1h)."
  }
}