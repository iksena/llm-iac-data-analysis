variable "bucket" {
  description = "Name of the bucket to put the file in"
  type        = string
}

variable "key" {
  description = "Name of the object once it is in the bucket"
  type        = string
}

variable "source_key" {
  description = "Specifies the source object for the copy operation"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "acl" {
  description = "Canned ACL to apply"
  type        = string
  default     = null
  validation {
    condition     = var.acl == null || contains(["private", "public-read", "public-read-write", "authenticated-read", "aws-exec-read", "bucket-owner-read", "bucket-owner-full-control"], var.acl)
    error_message = "resource_aws_s3_object_copy, acl must be one of: private, public-read, public-read-write, authenticated-read, aws-exec-read, bucket-owner-read, bucket-owner-full-control."
  }
}

variable "cache_control" {
  description = "Specifies caching behavior along the request/reply chain"
  type        = string
  default     = null
}

variable "checksum_algorithm" {
  description = "Indicates the algorithm used to create the checksum for the object"
  type        = string
  default     = null
  validation {
    condition     = var.checksum_algorithm == null || contains(["CRC32", "CRC32C", "CRC64NVME", "SHA1", "SHA256"], var.checksum_algorithm)
    error_message = "resource_aws_s3_object_copy, checksum_algorithm must be one of: CRC32, CRC32C, CRC64NVME, SHA1, SHA256."
  }
}

variable "content_disposition" {
  description = "Specifies presentational information for the object"
  type        = string
  default     = null
}

variable "content_encoding" {
  description = "Specifies what content encodings have been applied to the object"
  type        = string
  default     = null
}

variable "content_language" {
  description = "Language the content is in"
  type        = string
  default     = null
}

variable "content_type" {
  description = "Standard MIME type describing the format of the object data"
  type        = string
  default     = null
}

variable "copy_if_match" {
  description = "Copies the object if its entity tag (ETag) matches the specified tag"
  type        = string
  default     = null
}

variable "copy_if_modified_since" {
  description = "Copies the object if it has been modified since the specified time"
  type        = string
  default     = null
}

variable "copy_if_none_match" {
  description = "Copies the object if its entity tag (ETag) is different than the specified ETag"
  type        = string
  default     = null
}

variable "copy_if_unmodified_since" {
  description = "Copies the object if it hasn't been modified since the specified time"
  type        = string
  default     = null
}

variable "customer_algorithm" {
  description = "Specifies the algorithm to use to when encrypting the object"
  type        = string
  default     = null
}

variable "customer_key" {
  description = "Specifies the customer-provided encryption key for Amazon S3"
  type        = string
  default     = null
}

variable "customer_key_md5" {
  description = "Specifies the 128-bit MD5 digest of the encryption key"
  type        = string
  default     = null
}

variable "expected_bucket_owner" {
  description = "Account id of the expected destination bucket owner"
  type        = string
  default     = null
}

variable "expected_source_bucket_owner" {
  description = "Account id of the expected source bucket owner"
  type        = string
  default     = null
}

variable "expires" {
  description = "Date and time at which the object is no longer cacheable"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Allow the object to be deleted by removing any legal hold on any object version"
  type        = bool
  default     = false
}

variable "grant" {
  description = "Configuration block for header grants"
  type = list(object({
    permissions = list(string)
    type        = string
    email       = optional(string)
    id          = optional(string)
    uri         = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([
      for g in var.grant : contains(["CanonicalUser", "Group", "AmazonCustomerByEmail"], g.type)
    ])
    error_message = "resource_aws_s3_object_copy, grant type must be one of: CanonicalUser, Group, AmazonCustomerByEmail."
  }
  validation {
    condition = alltrue([
      for g in var.grant : alltrue([
        for p in g.permissions : contains(["READ", "READ_ACP", "WRITE_ACP", "FULL_CONTROL"], p)
      ])
    ])
    error_message = "resource_aws_s3_object_copy, grant permissions must contain only: READ, READ_ACP, WRITE_ACP, FULL_CONTROL."
  }
  validation {
    condition = alltrue([
      for g in var.grant : (
        g.type == "AmazonCustomerByEmail" ? g.email != null :
        g.type == "CanonicalUser" ? g.id != null :
        g.type == "Group" ? g.uri != null : false
      )
    ])
    error_message = "resource_aws_s3_object_copy, grant requires email for AmazonCustomerByEmail, id for CanonicalUser, or uri for Group."
  }
}

variable "kms_encryption_context" {
  description = "Specifies the AWS KMS Encryption Context to use for object encryption"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "Specifies the AWS KMS Key ARN to use for object encryption"
  type        = string
  default     = null
}

variable "metadata" {
  description = "Map of keys/values to provision metadata"
  type        = map(string)
  default     = null
}

variable "metadata_directive" {
  description = "Specifies whether the metadata is copied from the source object or replaced"
  type        = string
  default     = null
  validation {
    condition     = var.metadata_directive == null || contains(["COPY", "REPLACE"], var.metadata_directive)
    error_message = "resource_aws_s3_object_copy, metadata_directive must be one of: COPY, REPLACE."
  }
}

variable "object_lock_legal_hold_status" {
  description = "The legal hold status that you want to apply to the specified object"
  type        = string
  default     = null
  validation {
    condition     = var.object_lock_legal_hold_status == null || contains(["ON", "OFF"], var.object_lock_legal_hold_status)
    error_message = "resource_aws_s3_object_copy, object_lock_legal_hold_status must be one of: ON, OFF."
  }
}

variable "object_lock_mode" {
  description = "Object lock retention mode that you want to apply to this object"
  type        = string
  default     = null
  validation {
    condition     = var.object_lock_mode == null || contains(["GOVERNANCE", "COMPLIANCE"], var.object_lock_mode)
    error_message = "resource_aws_s3_object_copy, object_lock_mode must be one of: GOVERNANCE, COMPLIANCE."
  }
}

variable "object_lock_retain_until_date" {
  description = "Date and time when this object's object lock will expire"
  type        = string
  default     = null
}

variable "request_payer" {
  description = "Confirms that the requester knows that they will be charged for the request"
  type        = string
  default     = null
  validation {
    condition     = var.request_payer == null || var.request_payer == "requester"
    error_message = "resource_aws_s3_object_copy, request_payer must be 'requester' if specified."
  }
}

variable "server_side_encryption" {
  description = "Specifies server-side encryption of the object in S3"
  type        = string
  default     = null
  validation {
    condition     = var.server_side_encryption == null || contains(["AES256", "aws:kms"], var.server_side_encryption)
    error_message = "resource_aws_s3_object_copy, server_side_encryption must be one of: AES256, aws:kms."
  }
}

variable "source_customer_algorithm" {
  description = "Specifies the algorithm to use when decrypting the source object"
  type        = string
  default     = null
}

variable "source_customer_key" {
  description = "Specifies the customer-provided encryption key for Amazon S3 to decrypt the source object"
  type        = string
  default     = null
}

variable "source_customer_key_md5" {
  description = "Specifies the 128-bit MD5 digest of the encryption key"
  type        = string
  default     = null
}

variable "storage_class" {
  description = "Specifies the desired storage class for the object"
  type        = string
  default     = "STANDARD"
}

variable "tagging_directive" {
  description = "Specifies whether the object tag-set are copied from the source object or replaced"
  type        = string
  default     = null
  validation {
    condition     = var.tagging_directive == null || contains(["COPY", "REPLACE"], var.tagging_directive)
    error_message = "resource_aws_s3_object_copy, tagging_directive must be one of: COPY, REPLACE."
  }
}

variable "tags" {
  description = "Map of tags to assign to the object"
  type        = map(string)
  default     = null
}

variable "website_redirect" {
  description = "Specifies a target URL for website redirect"
  type        = string
  default     = null
}

variable "override_provider" {
  description = "Override the provider default_tags configuration block"
  type = object({
    default_tags = optional(object({
      tags = map(string)
    }))
  })
  default = null
}