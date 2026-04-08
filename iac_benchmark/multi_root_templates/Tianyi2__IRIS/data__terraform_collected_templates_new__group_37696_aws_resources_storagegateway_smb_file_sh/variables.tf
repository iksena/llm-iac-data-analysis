variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "gateway_arn" {
  description = "Amazon Resource Name (ARN) of the file gateway."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:storagegateway:", var.gateway_arn))
    error_message = "resource_aws_storagegateway_smb_file_share, gateway_arn must be a valid ARN starting with 'arn:aws:storagegateway:'."
  }
}

variable "location_arn" {
  description = "The ARN of the backed storage used for storing file data."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:s3:", var.location_arn))
    error_message = "resource_aws_storagegateway_smb_file_share, location_arn must be a valid S3 ARN starting with 'arn:aws:s3:'."
  }
}

variable "vpc_endpoint_dns_name" {
  description = "The DNS name of the VPC endpoint for S3 private link."
  type        = string
  default     = null
}

variable "bucket_region" {
  description = "The region of the S3 buck used by the file share. Required when specifying a vpc_endpoint_dns_name."
  type        = string
  default     = null
  validation {
    condition     = var.bucket_region == null || can(regex("^[a-z0-9-]+$", var.bucket_region))
    error_message = "resource_aws_storagegateway_smb_file_share, bucket_region must be a valid AWS region name."
  }
}

variable "role_arn" {
  description = "The ARN of the AWS Identity and Access Management (IAM) role that a file gateway assumes when it accesses the underlying storage."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:iam:", var.role_arn))
    error_message = "resource_aws_storagegateway_smb_file_share, role_arn must be a valid IAM role ARN starting with 'arn:aws:iam:'."
  }
}

variable "admin_user_list" {
  description = "A list of users in the Active Directory that have admin access to the file share. Only valid if authentication is set to ActiveDirectory."
  type        = list(string)
  default     = null
}

variable "authentication" {
  description = "The authentication method that users use to access the file share. Valid values: ActiveDirectory, GuestAccess."
  type        = string
  default     = "ActiveDirectory"
  validation {
    condition     = contains(["ActiveDirectory", "GuestAccess"], var.authentication)
    error_message = "resource_aws_storagegateway_smb_file_share, authentication must be one of: ActiveDirectory, GuestAccess."
  }
}

variable "audit_destination_arn" {
  description = "The Amazon Resource Name (ARN) of the CloudWatch Log Group used for the audit logs."
  type        = string
  default     = null
  validation {
    condition     = var.audit_destination_arn == null || can(regex("^arn:aws:logs:", var.audit_destination_arn))
    error_message = "resource_aws_storagegateway_smb_file_share, audit_destination_arn must be a valid CloudWatch Log Group ARN starting with 'arn:aws:logs:'."
  }
}

variable "default_storage_class" {
  description = "The default storage class for objects put into an Amazon S3 bucket by the file gateway."
  type        = string
  default     = "S3_STANDARD"
  validation {
    condition     = contains(["S3_STANDARD", "S3_REDUCED_REDUNDANCY", "S3_STANDARD_IA", "S3_ONEZONE_IA", "S3_INTELLIGENT_TIERING", "S3_GLACIER", "S3_DEEP_ARCHIVE"], var.default_storage_class)
    error_message = "resource_aws_storagegateway_smb_file_share, default_storage_class must be one of: S3_STANDARD, S3_REDUCED_REDUNDANCY, S3_STANDARD_IA, S3_ONEZONE_IA, S3_INTELLIGENT_TIERING, S3_GLACIER, S3_DEEP_ARCHIVE."
  }
}

variable "file_share_name" {
  description = "The name of the file share. Must be set if an S3 prefix name is set in location_arn."
  type        = string
  default     = null
}

variable "guess_mime_type_enabled" {
  description = "Boolean value that enables guessing of the MIME type for uploaded objects based on file extensions."
  type        = bool
  default     = true
}

variable "invalid_user_list" {
  description = "A list of users in the Active Directory that are not allowed to access the file share. Only valid if authentication is set to ActiveDirectory."
  type        = list(string)
  default     = null
}

variable "kms_encrypted" {
  description = "Boolean value if true to use Amazon S3 server side encryption with your own AWS KMS key, or false to use a key managed by Amazon S3."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "Amazon Resource Name (ARN) for KMS key used for Amazon S3 server side encryption. This value can only be set when kms_encrypted is true."
  type        = string
  default     = null
  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:", var.kms_key_arn))
    error_message = "resource_aws_storagegateway_smb_file_share, kms_key_arn must be a valid KMS key ARN starting with 'arn:aws:kms:'."
  }
}

variable "object_acl" {
  description = "Access Control List permission for S3 objects."
  type        = string
  default     = "private"
  validation {
    condition     = contains(["private", "public-read", "public-read-write", "authenticated-read", "aws-exec-read", "bucket-owner-read", "bucket-owner-full-control"], var.object_acl)
    error_message = "resource_aws_storagegateway_smb_file_share, object_acl must be one of: private, public-read, public-read-write, authenticated-read, aws-exec-read, bucket-owner-read, bucket-owner-full-control."
  }
}

variable "oplocks_enabled" {
  description = "Boolean to indicate Opportunistic lock (oplock) status."
  type        = bool
  default     = true
}

variable "cache_attributes" {
  description = "Refresh cache information."
  type = object({
    cache_stale_timeout_in_seconds = optional(number)
  })
  default = null
  validation {
    condition = var.cache_attributes == null || (
      var.cache_attributes.cache_stale_timeout_in_seconds == null ||
      (var.cache_attributes.cache_stale_timeout_in_seconds >= 300 && var.cache_attributes.cache_stale_timeout_in_seconds <= 2592000)
    )
    error_message = "resource_aws_storagegateway_smb_file_share, cache_stale_timeout_in_seconds must be between 300 and 2,592,000 seconds (5 minutes to 30 days)."
  }
}

variable "read_only" {
  description = "Boolean to indicate write status of file share. File share does not accept writes if true."
  type        = bool
  default     = false
}

variable "requester_pays" {
  description = "Boolean who pays the cost of the request and the data download from the Amazon S3 bucket. Set this value to true if you want the requester to pay instead of the bucket owner."
  type        = bool
  default     = false
}

variable "smb_acl_enabled" {
  description = "Set this value to true to enable ACL (access control list) on the SMB fileshare. Set it to false to map file and directory permissions to the POSIX permissions. This setting applies only to ActiveDirectory authentication type."
  type        = bool
  default     = null
}

variable "case_sensitivity" {
  description = "The case of an object name in an Amazon S3 bucket. For ClientSpecified, the client determines the case sensitivity. For CaseSensitive, the gateway determines the case sensitivity."
  type        = string
  default     = "ClientSpecified"
  validation {
    condition     = contains(["ClientSpecified", "CaseSensitive"], var.case_sensitivity)
    error_message = "resource_aws_storagegateway_smb_file_share, case_sensitivity must be one of: ClientSpecified, CaseSensitive."
  }
}

variable "valid_user_list" {
  description = "A list of users in the Active Directory that are allowed to access the file share. If you need to specify an Active directory group, add '@' before the name of the group. It will be set on Allowed group in AWS console. Only valid if authentication is set to ActiveDirectory."
  type        = list(string)
  default     = null
}

variable "access_based_enumeration" {
  description = "The files and folders on this share will only be visible to users with read access."
  type        = bool
  default     = false
}

variable "notification_policy" {
  description = "The notification policy of the file share."
  type        = string
  default     = "{}"
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "15m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "15m"
  }
}