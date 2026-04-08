variable "execution_role_arn" {
  description = "ARN for the IAM role that Timestream will assume when running the scheduled query."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.execution_role_arn))
    error_message = "resource_aws_timestreamquery_scheduled_query, execution_role_arn must be a valid IAM role ARN."
  }
}

variable "name" {
  description = "Name of the scheduled query."
  type        = string
  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 256
    error_message = "resource_aws_timestreamquery_scheduled_query, name must be between 1 and 256 characters."
  }
}

variable "query_string" {
  description = "Query string to run. Parameter names can be specified in the query string using the @ character followed by an identifier. The named parameter @scheduled_runtime is reserved and can be used in the query to get the time at which the query is scheduled to run."
  type        = string
  validation {
    condition     = length(var.query_string) > 0 && length(var.query_string) <= 262144
    error_message = "resource_aws_timestreamquery_scheduled_query, query_string must be between 1 and 262144 characters."
  }
}

variable "error_report_configuration" {
  description = "Configuration block for error reporting configuration."
  type = object({
    s3_configuration = object({
      bucket_name       = string
      encryption_option = optional(string)
      object_key_prefix = optional(string)
    })
  })

  validation {
    condition     = length(var.error_report_configuration.s3_configuration.bucket_name) > 0
    error_message = "resource_aws_timestreamquery_scheduled_query, bucket_name cannot be empty."
  }

  validation {
    condition     = var.error_report_configuration.s3_configuration.encryption_option == null || contains(["SSE_S3", "SSE_KMS"], var.error_report_configuration.s3_configuration.encryption_option)
    error_message = "resource_aws_timestreamquery_scheduled_query, encryption_option must be one of: SSE_S3, SSE_KMS."
  }
}

variable "notification_configuration" {
  description = "Configuration block for notification configuration for a scheduled query. A notification is sent by Timestream when a scheduled query is created, its state is updated, or when it is deleted."
  type = object({
    sns_configuration = object({
      topic_arn = string
    })
  })

  validation {
    condition     = can(regex("^arn:aws:sns:[^:]+:[0-9]{12}:.+", var.notification_configuration.sns_configuration.topic_arn))
    error_message = "resource_aws_timestreamquery_scheduled_query, topic_arn must be a valid SNS topic ARN."
  }
}

variable "schedule_configuration" {
  description = "Configuration block for schedule configuration for the query."
  type = object({
    schedule_expression = string
  })

  validation {
    condition     = length(var.schedule_configuration.schedule_expression) > 0
    error_message = "resource_aws_timestreamquery_scheduled_query, schedule_expression cannot be empty."
  }
}

variable "target_configuration" {
  description = "Configuration block for writing the result of a query."
  type = object({
    timestream_configuration = object({
      database_name       = string
      table_name          = string
      time_column         = string
      measure_name_column = optional(string)
      dimension_mapping = list(object({
        dimension_value_type = string
        name                 = string
      }))
      mixed_measure_mapping = optional(object({
        measure_name        = optional(string)
        measure_value_type  = string
        source_column       = optional(string)
        target_measure_name = optional(string)
        multi_measure_attribute_mapping = optional(list(object({
          measure_value_type                  = string
          source_column                       = string
          target_multi_measure_attribute_name = optional(string)
        })))
      }))
      multi_measure_mappings = optional(list(object({
        target_multi_measure_name = optional(string)
        multi_measure_attribute_mapping = list(object({
          measure_value_type                  = string
          source_column                       = string
          target_multi_measure_attribute_name = optional(string)
        }))
      })))
    })
  })

  validation {
    condition     = length(var.target_configuration.timestream_configuration.database_name) > 0
    error_message = "resource_aws_timestreamquery_scheduled_query, database_name cannot be empty."
  }

  validation {
    condition     = length(var.target_configuration.timestream_configuration.table_name) > 0
    error_message = "resource_aws_timestreamquery_scheduled_query, table_name cannot be empty."
  }

  validation {
    condition     = length(var.target_configuration.timestream_configuration.time_column) > 0
    error_message = "resource_aws_timestreamquery_scheduled_query, time_column cannot be empty."
  }

  validation {
    condition = alltrue([
      for dm in var.target_configuration.timestream_configuration.dimension_mapping : dm.dimension_value_type == "VARCHAR"
    ])
    error_message = "resource_aws_timestreamquery_scheduled_query, dimension_value_type must be VARCHAR."
  }

  validation {
    condition = alltrue([
      for dm in var.target_configuration.timestream_configuration.dimension_mapping : length(dm.name) > 0
    ])
    error_message = "resource_aws_timestreamquery_scheduled_query, dimension_mapping name cannot be empty."
  }

  validation {
    condition     = var.target_configuration.timestream_configuration.mixed_measure_mapping == null || contains(["BIGINT", "BOOLEAN", "DOUBLE", "VARCHAR", "MULTI"], var.target_configuration.timestream_configuration.mixed_measure_mapping.measure_value_type)
    error_message = "resource_aws_timestreamquery_scheduled_query, measure_value_type must be one of: BIGINT, BOOLEAN, DOUBLE, VARCHAR, MULTI."
  }

  validation {
    condition = var.target_configuration.timestream_configuration.mixed_measure_mapping == null || var.target_configuration.timestream_configuration.mixed_measure_mapping.multi_measure_attribute_mapping == null || alltrue([
      for attr in var.target_configuration.timestream_configuration.mixed_measure_mapping.multi_measure_attribute_mapping : contains(["BIGINT", "BOOLEAN", "DOUBLE", "VARCHAR", "TIMESTAMP"], attr.measure_value_type)
    ])
    error_message = "resource_aws_timestreamquery_scheduled_query, multi_measure_attribute_mapping measure_value_type must be one of: BIGINT, BOOLEAN, DOUBLE, VARCHAR, TIMESTAMP."
  }

  validation {
    condition = var.target_configuration.timestream_configuration.multi_measure_mappings == null || alltrue([
      for mapping in var.target_configuration.timestream_configuration.multi_measure_mappings : alltrue([
        for attr in mapping.multi_measure_attribute_mapping : contains(["BIGINT", "BOOLEAN", "DOUBLE", "VARCHAR", "TIMESTAMP"], attr.measure_value_type)
      ])
    ])
    error_message = "resource_aws_timestreamquery_scheduled_query, multi_measure_mappings multi_measure_attribute_mapping measure_value_type must be one of: BIGINT, BOOLEAN, DOUBLE, VARCHAR, TIMESTAMP."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "Amazon KMS key used to encrypt the scheduled query resource, at-rest. If not specified, the scheduled query resource will be encrypted with a Timestream owned Amazon KMS key."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags assigned to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for operation timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}
}