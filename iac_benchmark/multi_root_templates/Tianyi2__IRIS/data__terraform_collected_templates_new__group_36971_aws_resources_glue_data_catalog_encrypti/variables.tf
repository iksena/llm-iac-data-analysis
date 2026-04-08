variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "catalog_id" {
  description = "The ID of the Data Catalog to set the security configuration for. If none is provided, the AWS account ID is used by default."
  type        = string
  default     = null
}

variable "data_catalog_encryption_settings" {
  description = "The security configuration to set."
  type = object({
    connection_password_encryption = object({
      return_connection_password_encrypted = bool
      aws_kms_key_id                       = optional(string)
    })
    encryption_at_rest = object({
      catalog_encryption_mode         = string
      catalog_encryption_service_role = optional(string)
      sse_aws_kms_key_id              = optional(string)
    })
  })

  validation {
    condition     = contains(["DISABLED", "SSE-KMS", "SSE-KMS-WITH-SERVICE-ROLE"], var.data_catalog_encryption_settings.encryption_at_rest.catalog_encryption_mode)
    error_message = "resource_aws_glue_data_catalog_encryption_settings, catalog_encryption_mode must be one of: DISABLED, SSE-KMS, SSE-KMS-WITH-SERVICE-ROLE."
  }

  validation {
    condition     = can(regex("^arn:aws:kms:", var.data_catalog_encryption_settings.connection_password_encryption.aws_kms_key_id)) || var.data_catalog_encryption_settings.connection_password_encryption.aws_kms_key_id == null
    error_message = "resource_aws_glue_data_catalog_encryption_settings, aws_kms_key_id must be a valid KMS key ARN when specified."
  }

  validation {
    condition     = can(regex("^arn:aws:iam::", var.data_catalog_encryption_settings.encryption_at_rest.catalog_encryption_service_role)) || var.data_catalog_encryption_settings.encryption_at_rest.catalog_encryption_service_role == null
    error_message = "resource_aws_glue_data_catalog_encryption_settings, catalog_encryption_service_role must be a valid IAM role ARN when specified."
  }

  validation {
    condition     = can(regex("^arn:aws:kms:", var.data_catalog_encryption_settings.encryption_at_rest.sse_aws_kms_key_id)) || var.data_catalog_encryption_settings.encryption_at_rest.sse_aws_kms_key_id == null
    error_message = "resource_aws_glue_data_catalog_encryption_settings, sse_aws_kms_key_id must be a valid KMS key ARN when specified."
  }
}