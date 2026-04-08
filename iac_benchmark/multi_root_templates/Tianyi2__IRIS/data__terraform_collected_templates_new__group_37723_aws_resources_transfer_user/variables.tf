variable "server_id" {
  description = "The Server ID of the Transfer Server (e.g., s-12345678)"
  type        = string

  validation {
    condition     = can(regex("^s-[a-f0-9]{8,17}$", var.server_id))
    error_message = "resource_aws_transfer_user, server_id must be a valid AWS Transfer Server ID starting with 's-' followed by 8-17 alphanumeric characters."
  }
}

variable "user_name" {
  description = "The name used for log in to your SFTP server"
  type        = string

  validation {
    condition     = length(var.user_name) >= 3 && length(var.user_name) <= 100
    error_message = "resource_aws_transfer_user, user_name must be between 3 and 100 characters long."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.user_name))
    error_message = "resource_aws_transfer_user, user_name can only contain alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "role" {
  description = "Amazon Resource Name (ARN) of an IAM role that allows the service to control your user's access to your Amazon S3 bucket"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.role))
    error_message = "resource_aws_transfer_user, role must be a valid IAM role ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "home_directory" {
  description = "The landing directory (folder) for a user when they log in to the server using their SFTP client. It should begin with a /"
  type        = string
  default     = null

  validation {
    condition     = var.home_directory == null || can(regex("^/.*", var.home_directory))
    error_message = "resource_aws_transfer_user, home_directory must begin with a forward slash (/)."
  }
}

variable "home_directory_mappings" {
  description = "Logical directory mappings that specify what S3 paths and keys should be visible to your user and how you want to make them visible"
  type = list(object({
    entry  = string
    target = string
  }))
  default = []

  validation {
    condition = alltrue([
      for mapping in var.home_directory_mappings :
      mapping.entry != null && mapping.target != null
    ])
    error_message = "resource_aws_transfer_user, home_directory_mappings entry and target are required for each mapping."
  }

  validation {
    condition = alltrue([
      for mapping in var.home_directory_mappings :
      can(regex("^/.*", mapping.entry))
    ])
    error_message = "resource_aws_transfer_user, home_directory_mappings entry must begin with a forward slash (/)."
  }

  validation {
    condition = alltrue([
      for mapping in var.home_directory_mappings :
      can(regex("^/.*", mapping.target))
    ])
    error_message = "resource_aws_transfer_user, home_directory_mappings target must begin with a forward slash (/)."
  }
}

variable "home_directory_type" {
  description = "The type of landing directory (folder) you mapped for your users' home directory. Valid values are PATH and LOGICAL"
  type        = string
  default     = null

  validation {
    condition     = var.home_directory_type == null || contains(["PATH", "LOGICAL"], var.home_directory_type)
    error_message = "resource_aws_transfer_user, home_directory_type must be either 'PATH' or 'LOGICAL'."
  }
}

variable "policy" {
  description = "An IAM JSON policy document that scopes down user access to portions of their Amazon S3 bucket"
  type        = string
  default     = null

  validation {
    condition     = var.policy == null || can(jsondecode(var.policy))
    error_message = "resource_aws_transfer_user, policy must be a valid JSON document."
  }
}

variable "posix_profile" {
  description = "Specifies the full POSIX identity, including user ID (Uid), group ID (Gid), and any secondary groups IDs (SecondaryGids), that controls your users' access to your Amazon EFS file systems"
  type = object({
    gid            = number
    uid            = number
    secondary_gids = optional(list(number))
  })
  default = null

  validation {
    condition     = var.posix_profile == null || (var.posix_profile.gid >= 0 && var.posix_profile.gid <= 4294967294)
    error_message = "resource_aws_transfer_user, posix_profile gid must be between 0 and 4294967294."
  }

  validation {
    condition     = var.posix_profile == null || (var.posix_profile.uid >= 0 && var.posix_profile.uid <= 4294967294)
    error_message = "resource_aws_transfer_user, posix_profile uid must be between 0 and 4294967294."
  }

  validation {
    condition = var.posix_profile == null || var.posix_profile.secondary_gids == null || alltrue([
      for gid in var.posix_profile.secondary_gids :
      gid >= 0 && gid <= 4294967294
    ])
    error_message = "resource_aws_transfer_user, posix_profile secondary_gids must be between 0 and 4294967294."
  }

  validation {
    condition     = var.posix_profile == null || var.posix_profile.secondary_gids == null || length(var.posix_profile.secondary_gids) <= 16
    error_message = "resource_aws_transfer_user, posix_profile secondary_gids can have at most 16 entries."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "delete_timeout" {
  description = "Timeout for delete operation"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_transfer_user, delete_timeout must be a valid duration (e.g., '10m', '1h', '30s')."
  }
}