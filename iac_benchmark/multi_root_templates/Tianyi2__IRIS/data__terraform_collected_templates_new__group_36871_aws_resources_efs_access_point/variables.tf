variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "file_system_id" {
  description = "ID of the file system for which the access point is intended"
  type        = string
}

variable "posix_user" {
  description = "Operating system user and group applied to all file system requests made using the access point"
  type = object({
    gid            = number
    secondary_gids = optional(list(number))
    uid            = number
  })
  default = null

  validation {
    condition = var.posix_user != null ? (
      var.posix_user.gid >= 0 && var.posix_user.gid <= 4294967295 &&
      var.posix_user.uid >= 0 && var.posix_user.uid <= 4294967295
    ) : true
    error_message = "resource_aws_efs_access_point, posix_user gid and uid must be between 0 and 4294967295."
  }

  validation {
    condition = var.posix_user != null && var.posix_user.secondary_gids != null ? alltrue([
      for gid in var.posix_user.secondary_gids : gid >= 0 && gid <= 4294967295
    ]) : true
    error_message = "resource_aws_efs_access_point, posix_user secondary_gids must be between 0 and 4294967295."
  }
}

variable "root_directory" {
  description = "Directory on the Amazon EFS file system that the access point provides access to"
  type = object({
    creation_info = optional(object({
      owner_gid   = number
      owner_uid   = number
      permissions = string
    }))
    path = optional(string)
  })
  default = null

  validation {
    condition = var.root_directory != null && var.root_directory.path != null ? (
      length(split("/", trimprefix(var.root_directory.path, "/"))) <= 4
    ) : true
    error_message = "resource_aws_efs_access_point, root_directory path can have up to four subdirectories."
  }

  validation {
    condition = var.root_directory != null && var.root_directory.path != null ? (
      can(regex("^/", var.root_directory.path))
    ) : true
    error_message = "resource_aws_efs_access_point, root_directory path must start with /."
  }

  validation {
    condition = var.root_directory != null && var.root_directory.creation_info != null ? (
      var.root_directory.creation_info.owner_gid >= 0 && var.root_directory.creation_info.owner_gid <= 4294967295 &&
      var.root_directory.creation_info.owner_uid >= 0 && var.root_directory.creation_info.owner_uid <= 4294967295
    ) : true
    error_message = "resource_aws_efs_access_point, root_directory creation_info owner_gid and owner_uid must be between 0 and 4294967295."
  }

  validation {
    condition = var.root_directory != null && var.root_directory.creation_info != null ? (
      can(regex("^[0-7]{3,4}$", var.root_directory.creation_info.permissions))
    ) : true
    error_message = "resource_aws_efs_access_point, root_directory creation_info permissions must be an octal number (3-4 digits)."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}