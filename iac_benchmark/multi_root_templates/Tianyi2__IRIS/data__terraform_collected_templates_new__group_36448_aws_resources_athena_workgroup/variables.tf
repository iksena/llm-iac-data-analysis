variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the workgroup"
  type        = string
}

variable "description" {
  description = "Description of the workgroup"
  type        = string
  default     = null
}

variable "state" {
  description = "State of the workgroup. Valid values are DISABLED or ENABLED"
  type        = string
  default     = "ENABLED"
  validation {
    condition     = contains(["DISABLED", "ENABLED"], var.state)
    error_message = "resource_aws_athena_workgroup, state must be either DISABLED or ENABLED."
  }
}

variable "tags" {
  description = "Key-value map of resource tags for the workgroup"
  type        = map(string)
  default     = null
}

variable "force_destroy" {
  description = "Option to delete the workgroup and its contents even if the workgroup contains any named queries"
  type        = bool
  default     = false
}

variable "configuration" {
  description = "Configuration block with various settings for the workgroup"
  type = object({
    bytes_scanned_cutoff_per_query     = optional(number)
    enforce_workgroup_configuration    = optional(bool, true)
    execution_role                     = optional(string)
    publish_cloudwatch_metrics_enabled = optional(bool, true)
    requester_pays_enabled             = optional(bool, false)
    engine_version = optional(object({
      selected_engine_version = optional(string, "AUTO")
    }))
    identity_center_configuration = optional(object({
      enable_identity_center       = optional(bool)
      identity_center_instance_arn = optional(string)
    }))
    result_configuration = optional(object({
      expected_bucket_owner = optional(string)
      output_location       = optional(string)
      acl_configuration = optional(object({
        s3_acl_option = string
      }))
      encryption_configuration = optional(object({
        encryption_option = string
        kms_key_arn       = optional(string)
      }))
    }))
  })
  default = null

  validation {
    condition     = var.configuration == null || var.configuration.bytes_scanned_cutoff_per_query == null || var.configuration.bytes_scanned_cutoff_per_query >= 10485760
    error_message = "resource_aws_athena_workgroup, bytes_scanned_cutoff_per_query must be at least 10485760."
  }

  validation {
    condition     = var.configuration == null || var.configuration.result_configuration == null || var.configuration.result_configuration.acl_configuration == null || contains(["BUCKET_OWNER_FULL_CONTROL"], var.configuration.result_configuration.acl_configuration.s3_acl_option)
    error_message = "resource_aws_athena_workgroup, s3_acl_option must be BUCKET_OWNER_FULL_CONTROL."
  }

  validation {
    condition     = var.configuration == null || var.configuration.result_configuration == null || var.configuration.result_configuration.encryption_configuration == null || contains(["SSE_S3", "SSE_KMS", "CSE_KMS"], var.configuration.result_configuration.encryption_configuration.encryption_option)
    error_message = "resource_aws_athena_workgroup, encryption_option must be one of SSE_S3, SSE_KMS, or CSE_KMS."
  }
}