variable "index_id" {
  description = "Identifier of the index for a block list"
  type        = string

  validation {
    condition     = length(var.index_id) > 0
    error_message = "resource_aws_kendra_query_suggestions_block_list, index_id cannot be empty."
  }
}

variable "name" {
  description = "Name for the block list"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_kendra_query_suggestions_block_list, name cannot be empty."
  }
}

variable "role_arn" {
  description = "IAM (Identity and Access Management) role used to access the block list text file in S3"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::\\d{12}:role/", var.role_arn))
    error_message = "resource_aws_kendra_query_suggestions_block_list, role_arn must be a valid IAM role ARN."
  }
}

variable "source_s3_path_bucket" {
  description = "Name of the S3 bucket that contains the file"
  type        = string

  validation {
    condition     = length(var.source_s3_path_bucket) > 0
    error_message = "resource_aws_kendra_query_suggestions_block_list, source_s3_path_bucket cannot be empty."
  }
}

variable "source_s3_path_key" {
  description = "Name of the file"
  type        = string

  validation {
    condition     = length(var.source_s3_path_key) > 0
    error_message = "resource_aws_kendra_query_suggestions_block_list, source_s3_path_key cannot be empty."
  }
}

variable "description" {
  description = "Description for a block list"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Create timeout"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_create))
    error_message = "resource_aws_kendra_query_suggestions_block_list, timeouts_create must be a valid duration format (e.g., 30m, 1h)."
  }
}

variable "timeouts_update" {
  description = "Update timeout"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_update))
    error_message = "resource_aws_kendra_query_suggestions_block_list, timeouts_update must be a valid duration format (e.g., 30m, 1h)."
  }
}

variable "timeouts_delete" {
  description = "Delete timeout"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_delete))
    error_message = "resource_aws_kendra_query_suggestions_block_list, timeouts_delete must be a valid duration format (e.g., 30m, 1h)."
  }
}