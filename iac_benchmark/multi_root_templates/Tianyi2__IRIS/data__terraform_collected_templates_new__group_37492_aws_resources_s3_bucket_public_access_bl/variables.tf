variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "S3 Bucket to which this Public Access Block configuration should be applied."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket)) || can(regex("^[a-z0-9]{1,63}$", var.bucket))
    error_message = "resource_aws_s3_bucket_public_access_block, bucket must be a valid S3 bucket name."
  }
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket. Defaults to false."
  type        = bool
  default     = false
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false."
  type        = bool
  default     = false
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false."
  type        = bool
  default     = false
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false."
  type        = bool
  default     = false
}

variable "skip_destroy" {
  description = "Whether to retain the public access block upon destruction. If set to true, the resource is simply removed from state instead."
  type        = bool
  default     = false
}