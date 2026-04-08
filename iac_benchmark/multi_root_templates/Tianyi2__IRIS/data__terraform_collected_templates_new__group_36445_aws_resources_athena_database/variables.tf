variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of S3 bucket to save the results of the query execution."
  type        = string

  validation {
    condition     = var.bucket != null && var.bucket != ""
    error_message = "resource_aws_athena_database, bucket is required and cannot be empty."
  }
}

variable "name" {
  description = "Name of the database to create."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "resource_aws_athena_database, name is required and cannot be empty."
  }
}

variable "acl_configuration" {
  description = "That an Amazon S3 canned ACL should be set to control ownership of stored query results."
  type = object({
    s3_acl_option = string
  })
  default = null

  validation {
    condition = var.acl_configuration == null || (
      var.acl_configuration != null &&
      var.acl_configuration.s3_acl_option != null &&
      contains(["BUCKET_OWNER_FULL_CONTROL"], var.acl_configuration.s3_acl_option)
    )
    error_message = "resource_aws_athena_database, acl_configuration.s3_acl_option must be 'BUCKET_OWNER_FULL_CONTROL'."
  }
}

variable "comment" {
  description = "Description of the database."
  type        = string
  default     = null
}

variable "encryption_configuration" {
  description = "Encryption key block AWS Athena uses to decrypt the data in S3, such as an AWS Key Management Service (AWS KMS) key."
  type = object({
    encryption_option = string
    kms_key           = optional(string)
  })
  default = null

  validation {
    condition = var.encryption_configuration == null || (
      var.encryption_configuration != null &&
      var.encryption_configuration.encryption_option != null &&
      contains(["SSE_S3", "SSE_KMS", "CSE_KMS"], var.encryption_configuration.encryption_option)
    )
    error_message = "resource_aws_athena_database, encryption_configuration.encryption_option must be one of 'SSE_S3', 'SSE_KMS', 'CSE_KMS'."
  }

  validation {
    condition = var.encryption_configuration == null || (
      var.encryption_configuration != null &&
      (
        (contains(["SSE_KMS", "CSE_KMS"], var.encryption_configuration.encryption_option) &&
        var.encryption_configuration.kms_key != null && var.encryption_configuration.kms_key != "") ||
        (var.encryption_configuration.encryption_option == "SSE_S3")
      )
    )
    error_message = "resource_aws_athena_database, encryption_configuration.kms_key is required for encryption_option 'SSE_KMS' and 'CSE_KMS'."
  }
}

variable "expected_bucket_owner" {
  description = "AWS account ID that you expect to be the owner of the Amazon S3 bucket."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Boolean that indicates all tables should be deleted from the database so that the database can be destroyed without error."
  type        = bool
  default     = false
}

variable "properties" {
  description = "Key-value map of custom metadata properties for the database definition."
  type        = map(string)
  default     = null
}

variable "workgroup" {
  description = "Name of the workgroup."
  type        = string
  default     = null
}