variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "external_id" {
  description = "The SID of a group in the directory connected to the Transfer Server"
  type        = string

  validation {
    condition     = can(regex("^S-[0-9]+-[0-9]+-[0-9]+-[0-9]+-[0-9]+-[0-9]+$", var.external_id))
    error_message = "resource_aws_transfer_access, external_id must be a valid SID format (e.g., S-1-1-12-1234567890-123456789-1234567890-1234)."
  }
}

variable "server_id" {
  description = "The Server ID of the Transfer Server"
  type        = string

  validation {
    condition     = can(regex("^s-[a-zA-Z0-9]+$", var.server_id))
    error_message = "resource_aws_transfer_access, server_id must be a valid Transfer Server ID format (e.g., s-12345678)."
  }
}

variable "home_directory" {
  description = "The landing directory (folder) for a user when they log in to the server using their SFTP client. It should begin with a /."
  type        = string
  default     = null

  validation {
    condition     = var.home_directory == null || can(regex("^/", var.home_directory))
    error_message = "resource_aws_transfer_access, home_directory must begin with a forward slash (/)."
  }
}

variable "home_directory_mappings" {
  description = "Logical directory mappings that specify what S3 paths and keys should be visible to your user and how you want to make them visible."
  type = list(object({
    entry  = string
    target = string
  }))
  default = null
}

variable "home_directory_type" {
  description = "The type of landing directory (folder) you mapped for your users' home directory."
  type        = string
  default     = null

  validation {
    condition     = var.home_directory_type == null || contains(["PATH", "LOGICAL"], var.home_directory_type)
    error_message = "resource_aws_transfer_access, home_directory_type must be either PATH or LOGICAL."
  }
}

variable "policy" {
  description = "An IAM JSON policy document that scopes down user access to portions of their Amazon S3 bucket."
  type        = string
  default     = null
}

variable "posix_profile" {
  description = "Specifies the full POSIX identity, including user ID (Uid), group ID (Gid), and any secondary groups IDs (SecondaryGids), that controls your users' access to your Amazon EFS file systems."
  type = object({
    gid            = number
    uid            = number
    secondary_gids = optional(list(number))
  })
  default = null

  validation {
    condition     = var.posix_profile == null || (var.posix_profile.gid >= 0 && var.posix_profile.uid >= 0)
    error_message = "resource_aws_transfer_access, posix_profile gid and uid must be non-negative numbers."
  }
}

variable "role" {
  description = "Amazon Resource Name (ARN) of an IAM role that allows the service to controls your user's access to your Amazon S3 bucket."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.role))
    error_message = "resource_aws_transfer_access, role must be a valid IAM role ARN."
  }
}