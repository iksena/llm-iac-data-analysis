variable "access_role" {
  description = "The IAM Role which provides read and write access to the parent directory of the file location mentioned in the StartFileTransfer request"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.access_role))
    error_message = "resource_aws_transfer_agreement, access_role must be a valid IAM role ARN."
  }
}

variable "base_directory" {
  description = "The landing directory for the files transferred by using the AS2 protocol"
  type        = string

  validation {
    condition     = length(var.base_directory) > 0
    error_message = "resource_aws_transfer_agreement, base_directory cannot be empty."
  }
}

variable "description" {
  description = "The Optional description of the transfer"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 200
    error_message = "resource_aws_transfer_agreement, description must be 200 characters or less."
  }
}

variable "local_profile_id" {
  description = "The unique identifier for the AS2 local profile"
  type        = string

  validation {
    condition     = can(regex("^p-[0-9a-f]{17}$", var.local_profile_id))
    error_message = "resource_aws_transfer_agreement, local_profile_id must be a valid profile ID (p- followed by 17 alphanumeric characters)."
  }
}

variable "partner_profile_id" {
  description = "The unique identifier for the AS2 partner profile"
  type        = string

  validation {
    condition     = can(regex("^p-[0-9a-f]{17}$", var.partner_profile_id))
    error_message = "resource_aws_transfer_agreement, partner_profile_id must be a valid profile ID (p- followed by 17 alphanumeric characters)."
  }
}

variable "server_id" {
  description = "The unique server identifier for the server instance. This is the specific server the agreement uses"
  type        = string

  validation {
    condition     = can(regex("^s-[0-9a-f]{17}$", var.server_id))
    error_message = "resource_aws_transfer_agreement, server_id must be a valid server ID (s- followed by 17 alphanumeric characters)."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_transfer_agreement, tags cannot exceed 50 key-value pairs."
  }
}