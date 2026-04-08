variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Lists object keys in this S3 bucket. Alternatively, an S3 access point ARN can be specified"
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "data_s3_objects, bucket cannot be empty."
  }
}

variable "prefix" {
  description = "Limits results to object keys with this prefix"
  type        = string
  default     = null
}

variable "delimiter" {
  description = "Character used to group keys"
  type        = string
  default     = null
}

variable "encoding_type" {
  description = "Encodes keys using this method (besides none, only \"url\" can be used)"
  type        = string
  default     = null

  validation {
    condition     = var.encoding_type == null || var.encoding_type == "url"
    error_message = "data_s3_objects, encoding_type must be null or \"url\"."
  }
}

variable "max_keys" {
  description = "Maximum object keys to return"
  type        = number
  default     = 1000

  validation {
    condition     = var.max_keys > 0
    error_message = "data_s3_objects, max_keys must be greater than 0."
  }
}

variable "start_after" {
  description = "Returns key names lexicographically after a specific object key in your bucket"
  type        = string
  default     = null
}

variable "fetch_owner" {
  description = "Boolean specifying whether to populate the owner list"
  type        = bool
  default     = false
}

variable "request_payer" {
  description = "Confirms that the requester knows that they will be charged for the request. If included, the only valid value is requester."
  type        = string
  default     = null

  validation {
    condition     = var.request_payer == null || var.request_payer == "requester"
    error_message = "data_s3_objects, request_payer must be null or \"requester\"."
  }
}