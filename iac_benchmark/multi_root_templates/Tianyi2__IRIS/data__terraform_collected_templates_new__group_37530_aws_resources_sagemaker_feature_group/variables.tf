variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "feature_group_name" {
  description = "The name of the Feature Group. The name must be unique within an AWS Region in an AWS account."
  type        = string
  validation {
    condition     = length(var.feature_group_name) > 0
    error_message = "resource_aws_sagemaker_feature_group, feature_group_name cannot be empty."
  }
}

variable "record_identifier_feature_name" {
  description = "The name of the Feature whose value uniquely identifies a Record defined in the Feature Store. Only the latest record per identifier value will be stored in the Online Store."
  type        = string
  validation {
    condition     = length(var.record_identifier_feature_name) > 0
    error_message = "resource_aws_sagemaker_feature_group, record_identifier_feature_name cannot be empty."
  }
}

variable "event_time_feature_name" {
  description = "The name of the feature that stores the EventTime of a Record in a Feature Group."
  type        = string
  validation {
    condition     = length(var.event_time_feature_name) > 0
    error_message = "resource_aws_sagemaker_feature_group, event_time_feature_name cannot be empty."
  }
}

variable "description" {
  description = "A free-form description of a Feature Group."
  type        = string
  default     = null
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM execution role used to persist data into the Offline Store if an offline_store_config is provided."
  type        = string
  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_sagemaker_feature_group, role_arn must be a valid IAM role ARN."
  }
}

variable "feature_definition" {
  description = "A list of Feature names and types."
  type = list(object({
    feature_name = string
    feature_type = string
  }))
  default = []
  validation {
    condition = alltrue([
      for fd in var.feature_definition :
      contains(["Integral", "Fractional", "String"], fd.feature_type)
    ])
    error_message = "resource_aws_sagemaker_feature_group, feature_definition feature_type must be one of: Integral, Fractional, String."
  }
  validation {
    condition = alltrue([
      for fd in var.feature_definition :
      !contains(["is_deleted", "write_time", "api_invocation_time"], fd.feature_name)
    ])
    error_message = "resource_aws_sagemaker_feature_group, feature_definition feature_name cannot be: is_deleted, write_time, api_invocation_time."
  }
}

variable "offline_store_config" {
  description = "The Offline Feature Store Configuration."
  type = object({
    disable_glue_table_creation = optional(bool)
    s3_storage_config = object({
      kms_key_id             = optional(string)
      s3_uri                 = string
      resolved_output_s3_uri = optional(string)
    })
    data_catalog_config = optional(object({
      catalog    = optional(string)
      database   = optional(string)
      table_name = optional(string)
    }))
    table_format = optional(string)
  })
  default = null
  validation {
    condition = var.offline_store_config == null || (
      var.offline_store_config != null &&
      var.offline_store_config.s3_storage_config != null &&
      length(var.offline_store_config.s3_storage_config.s3_uri) > 0
    )
    error_message = "resource_aws_sagemaker_feature_group, offline_store_config s3_storage_config.s3_uri is required when offline_store_config is provided."
  }
  validation {
    condition     = var.offline_store_config == null || var.offline_store_config.table_format == null || contains(["Glue", "Iceberg"], var.offline_store_config.table_format)
    error_message = "resource_aws_sagemaker_feature_group, offline_store_config table_format must be one of: Glue, Iceberg."
  }
}

variable "online_store_config" {
  description = "The Online Feature Store Configuration."
  type = object({
    enable_online_store = optional(bool)
    security_config = optional(object({
      kms_key_id = optional(string)
    }))
    storage_type = optional(string)
    ttl_duration = optional(object({
      unit  = optional(string)
      value = optional(number)
    }))
  })
  default = null
  validation {
    condition     = var.online_store_config == null || var.online_store_config.storage_type == null || contains(["Standard", "InMemory"], var.online_store_config.storage_type)
    error_message = "resource_aws_sagemaker_feature_group, online_store_config storage_type must be one of: Standard, InMemory."
  }
  validation {
    condition     = var.online_store_config == null || var.online_store_config.ttl_duration == null || var.online_store_config.ttl_duration.unit == null || contains(["Seconds", "Minutes", "Hours", "Days", "Weeks"], var.online_store_config.ttl_duration.unit)
    error_message = "resource_aws_sagemaker_feature_group, online_store_config ttl_duration.unit must be one of: Seconds, Minutes, Hours, Days, Weeks."
  }
}

variable "tags" {
  description = "Map of resource tags for the resource."
  type        = map(string)
  default     = {}
}