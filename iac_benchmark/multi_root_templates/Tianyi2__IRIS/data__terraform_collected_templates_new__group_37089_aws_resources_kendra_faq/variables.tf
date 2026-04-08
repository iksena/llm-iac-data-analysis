variable "index_id" {
  description = "The identifier of the index for a FAQ"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.index_id))
    error_message = "resource_aws_kendra_faq, index_id must be a valid identifier containing only alphanumeric characters, underscores, and hyphens, and must start with an alphanumeric character."
  }
}

variable "name" {
  description = "The name that should be associated with the FAQ"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 100
    error_message = "resource_aws_kendra_faq, name must be between 1 and 100 characters long."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of a role with permission to access the S3 bucket that contains the FAQs"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_kendra_faq, role_arn must be a valid IAM role ARN."
  }
}

variable "s3_path_bucket" {
  description = "The name of the S3 bucket that contains the file"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.s3_path_bucket)) && length(var.s3_path_bucket) >= 3 && length(var.s3_path_bucket) <= 63
    error_message = "resource_aws_kendra_faq, s3_path_bucket must be a valid S3 bucket name (3-63 characters, lowercase letters, numbers, periods, and hyphens)."
  }
}

variable "s3_path_key" {
  description = "The name of the file"
  type        = string

  validation {
    condition     = length(var.s3_path_key) > 0 && length(var.s3_path_key) <= 1024
    error_message = "resource_aws_kendra_faq, s3_path_key must be between 1 and 1024 characters long."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "The description for a FAQ"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1000
    error_message = "resource_aws_kendra_faq, description must be 1000 characters or less."
  }
}

variable "file_format" {
  description = "The file format used by the input files for the FAQ"
  type        = string
  default     = null

  validation {
    condition     = var.file_format == null || contains(["CSV", "CSV_WITH_HEADER", "JSON"], var.file_format)
    error_message = "resource_aws_kendra_faq, file_format must be one of: CSV, CSV_WITH_HEADER, JSON."
  }
}

variable "language_code" {
  description = "The code for a language. This shows a supported language for the FAQ document"
  type        = string
  default     = null

  validation {
    condition     = var.language_code == null || can(regex("^[a-z]{2}(-[A-Z]{2})?$", var.language_code))
    error_message = "resource_aws_kendra_faq, language_code must be a valid language code (e.g., en, en-US)."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for creating the FAQ"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_kendra_faq, timeouts_create must be a valid timeout format (e.g., 30m, 1h)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the FAQ"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_kendra_faq, timeouts_delete must be a valid timeout format (e.g., 30m, 1h)."
  }
}