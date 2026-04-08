variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the DB cluster."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:rds:", var.resource_arn))
    error_message = "resource_aws_rds_cluster_activity_stream, resource_arn must be a valid RDS cluster ARN starting with 'arn:aws:rds:'."
  }
}

variable "mode" {
  description = "Specifies the mode of the database activity stream. Database events such as a change or access generate an activity stream event. The database session can handle these events either synchronously or asynchronously."
  type        = string

  validation {
    condition     = contains(["sync", "async"], var.mode)
    error_message = "resource_aws_rds_cluster_activity_stream, mode must be either 'sync' or 'async'."
  }
}

variable "kms_key_id" {
  description = "The AWS KMS key identifier for encrypting messages in the database activity stream. The AWS KMS key identifier is the key ARN, key ID, alias ARN, or alias name for the KMS key."
  type        = string

  validation {
    condition     = length(var.kms_key_id) > 0
    error_message = "resource_aws_rds_cluster_activity_stream, kms_key_id cannot be empty."
  }
}

variable "engine_native_audit_fields_included" {
  description = "Specifies whether the database activity stream includes engine-native audit fields. This option only applies to an Oracle DB instance. By default, no engine-native audit fields are included."
  type        = bool
  default     = false
}