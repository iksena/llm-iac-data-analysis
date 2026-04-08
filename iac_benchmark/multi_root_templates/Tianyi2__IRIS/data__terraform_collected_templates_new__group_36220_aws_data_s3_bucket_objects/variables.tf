variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Lists object keys in this S3 bucket. Alternatively, an S3 access point ARN can be specified."
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "data_aws_s3_bucket_objects, bucket must not be empty."
  }
}

variable "prefix" {
  description = "Limits results to object keys with this prefix."
  type        = string
  default     = null
}

variable "delimiter" {
  description = "Character used to group keys."
  type        = string
  default     = null
}

variable "encoding_type" {
  description = "Encodes keys using this method (none or url)."
  type        = string
  default     = null

  validation {
    condition     = var.encoding_type == null || var.encoding_type == "url"
    error_message = "data_aws_s3_bucket_objects, encoding_type must be null or 'url'."
  }
}

variable "max_keys" {
  description = "Maximum object keys to return."
  type        = number
  default     = 1000

  validation {
    condition     = var.max_keys > 0
    error_message = "data_aws_s3_bucket_objects, max_keys must be greater than 0."
  }
}

variable "start_after" {
  description = "Returns key names lexicographically after a specific object key in your bucket."
  type        = string
  default     = null
}

variable "fetch_owner" {
  description = "Boolean specifying whether to populate the owner list."
  type        = bool
  default     = false
}