variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "bucket" {
  type        = string
  description = "Name of the bucket."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket)) && length(var.bucket) >= 3 && length(var.bucket) <= 63
    error_message = "resource_aws_s3control_bucket, bucket must be between 3 and 63 characters long and can only contain lowercase letters, numbers, dots, and hyphens, and must start and end with alphanumeric characters."
  }
}

variable "outpost_id" {
  type        = string
  description = "Identifier of the Outpost to contain this bucket."

  validation {
    condition     = var.outpost_id != ""
    error_message = "resource_aws_s3control_bucket, outpost_id cannot be empty."
  }
}

variable "tags" {
  type        = map(string)
  description = "Key-value map of resource tags."
  default     = {}
}