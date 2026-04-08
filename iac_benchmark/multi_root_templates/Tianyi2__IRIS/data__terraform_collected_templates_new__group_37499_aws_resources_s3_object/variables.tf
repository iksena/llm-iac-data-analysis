variable "bucket" {
  description = "Name of the bucket to put the file in. Alternatively, an S3 access point ARN can be specified."
  type        = string
}

variable "key" {
  description = "Name of the object once it is in the bucket."
  type        = string
}

variable "acl" {
  description = "Canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, and bucket-owner-full-control."
  type        = string
  default     = null
  validation {
    condition = var.acl == null || contains([
      "private",
      "public-read",
      "public-read-write",
      "aws-exec-read",
      "authenticated-read",
      "bucket-owner-read",
      "bucket-owner-full-control"
    ], var.acl)
    error_message = "resource_aws_s3_object, acl must be one of: private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, bucket-owner-full-control."
  }
}

variable "bucket_key_enabled" {
  description = "Whether or not to use Amazon S3 Bucket Keys for SSE-KMS."
  type        = bool
  default     = null
}

variable "cache_control" {
  description = "Caching behavior along the request/reply chain."
  type        = string
  default     = null
}

variable "checksum_algorithm" {
  description = "Indicates the algorithm used to create the checksum for the object. Valid values: CRC32, CRC32C, CRC64NVME, SHA1, SHA256."
  type        = string
  default     = null
  validation {
    condition = var.checksum_algorithm == null || contains([
      "CRC32",
      "CRC32C",
      "CRC64NVME",
      "SHA1",
      "SHA256"
    ], var.checksum_algorithm)
    error_message = "resource_aws_s3_object, checksum_algorithm must be one of: CRC32, CRC32C, CRC64NVME, SHA1, SHA256."
  }
}

variable "content_base64" {
  description = "Base64-encoded data that will be decoded and uploaded as raw bytes for the object content. Conflicts with source and content."
  type        = string
  default     = null
}

variable "content_disposition" {
  description = "Presentational information for the object."
  type        = string
  default     = null
}

variable "content_encoding" {
  description = "Content encodings that have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field."
  type        = string
  default     = null
}

variable "content_language" {
  description = "Language the content is in e.g., en-US or en-GB."
  type        = string
  default     = null
}

variable "content_type" {
  description = "Standard MIME type describing the format of the object data, e.g., application/octet-stream."
  type        = string
  default     = null
}

variable "content" {
  description = "Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text. Conflicts with source and content_base64."
  type        = string
  default     = null
}

variable "etag" {
  description = "Triggers updates when the value changes. The only meaningful value is filemd5(\"path/to/file\"). This attribute is not compatible with KMS encryption."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to allow the object to be deleted by removing any legal hold on any object version. Default is false. This value should be set to true only if the bucket has S3 object lock enabled."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "ARN of the KMS Key to use for object encryption. If the S3 Bucket has server-side encryption enabled, that value will automatically be used."
  type        = string
  default     = null
}

variable "metadata" {
  description = "Map of keys/values to provision metadata (will be automatically prefixed by x-amz-meta-, note that only lowercase label are currently supported by the AWS Go API)."
  type        = map(string)
  default     = null
}

variable "object_lock_legal_hold_status" {
  description = "Legal hold status that you want to apply to the specified object. Valid values are ON and OFF."
  type        = string
  default     = null
  validation {
    condition = var.object_lock_legal_hold_status == null || contains([
      "ON",
      "OFF"
    ], var.object_lock_legal_hold_status)
    error_message = "resource_aws_s3_object, object_lock_legal_hold_status must be one of: ON, OFF."
  }
}

variable "object_lock_mode" {
  description = "Object lock retention mode that you want to apply to this object. Valid values are GOVERNANCE and COMPLIANCE."
  type        = string
  default     = null
  validation {
    condition = var.object_lock_mode == null || contains([
      "GOVERNANCE",
      "COMPLIANCE"
    ], var.object_lock_mode)
    error_message = "resource_aws_s3_object, object_lock_mode must be one of: GOVERNANCE, COMPLIANCE."
  }
}

variable "object_lock_retain_until_date" {
  description = "Date and time, in RFC3339 format, when this object's object lock will expire."
  type        = string
  default     = null
}

variable "override_provider" {
  description = "Override provider-level configuration options."
  type = object({
    default_tags = optional(object({
      tags = map(string)
    }))
  })
  default = null
}

variable "server_side_encryption" {
  description = "Server-side encryption of the object in S3. Valid values are AES256, aws:kms, aws:kms:dsse, and aws:fsx."
  type        = string
  default     = null
  validation {
    condition = var.server_side_encryption == null || contains([
      "AES256",
      "aws:kms",
      "aws:kms:dsse",
      "aws:fsx"
    ], var.server_side_encryption)
    error_message = "resource_aws_s3_object, server_side_encryption must be one of: AES256, aws:kms, aws:kms:dsse, aws:fsx."
  }
}

variable "source_hash" {
  description = "Triggers updates like etag but useful to address etag encryption limitations. Set using filemd5(\"path/to/source\"). The value is only stored in state and not saved by AWS."
  type        = string
  default     = null
}

variable "source_file" {
  description = "Path to a file that will be read and uploaded as raw bytes for the object content. Conflicts with content and content_base64."
  type        = string
  default     = null
}

variable "storage_class" {
  description = "Storage Class for the object. Defaults to STANDARD."
  type        = string
  default     = "STANDARD"
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the object."
  type        = map(string)
  default     = null
}

variable "website_redirect" {
  description = "Target URL for website redirect."
  type        = string
  default     = null
}