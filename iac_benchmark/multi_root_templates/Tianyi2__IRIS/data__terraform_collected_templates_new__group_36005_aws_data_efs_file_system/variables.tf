variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_efs_file_system, region must be a valid AWS region identifier or null."
  }
}

variable "file_system_id" {
  description = "ID that identifies the file system (e.g., fs-ccfc0d65)."
  type        = string
  default     = null

  validation {
    condition     = var.file_system_id == null || can(regex("^fs-[0-9a-f]{8,40}$", var.file_system_id))
    error_message = "data_aws_efs_file_system, file_system_id must be a valid EFS file system ID (e.g., fs-ccfc0d65) or null."
  }
}

variable "creation_token" {
  description = "Restricts the list to the file system with this creation token."
  type        = string
  default     = null

  validation {
    condition     = var.creation_token == null || length(var.creation_token) <= 64
    error_message = "data_aws_efs_file_system, creation_token must be 64 characters or fewer or null."
  }
}

variable "tags" {
  description = "Restricts the list to the file system with these tags."
  type        = map(string)
  default     = null

  validation {
    condition     = var.tags == null || (length(var.tags) <= 50 && alltrue([for k, v in var.tags : length(k) <= 128 && length(v) <= 256]))
    error_message = "data_aws_efs_file_system, tags must contain at most 50 key-value pairs, with keys up to 128 characters and values up to 256 characters, or be null."
  }
}