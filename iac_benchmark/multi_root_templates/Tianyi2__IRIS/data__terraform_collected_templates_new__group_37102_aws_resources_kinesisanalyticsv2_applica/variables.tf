variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the application."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_kinesisanalyticsv2_application, name must not be empty."
  }
}

variable "runtime_environment" {
  description = "The runtime environment for the application."
  type        = string

  validation {
    condition = contains([
      "SQL-1_0", "FLINK-1_6", "FLINK-1_8", "FLINK-1_11",
      "FLINK-1_13", "FLINK-1_15", "FLINK-1_18", "FLINK-1_19"
    ], var.runtime_environment)
    error_message = "resource_aws_kinesisanalyticsv2_application, runtime_environment must be one of: SQL-1_0, FLINK-1_6, FLINK-1_8, FLINK-1_11, FLINK-1_13, FLINK-1_15, FLINK-1_18, FLINK-1_19."
  }
}

variable "service_execution_role" {
  description = "The ARN of the IAM role used by the application to access Kinesis data streams, Kinesis Data Firehose delivery streams, Amazon S3 objects, and other external resources."
  type        = string

  validation {
    condition     = length(var.service_execution_role) > 0
    error_message = "resource_aws_kinesisanalyticsv2_application, service_execution_role must not be empty."
  }

  validation {
    condition     = can(regex("^arn:aws:iam::", var.service_execution_role))
    error_message = "resource_aws_kinesisanalyticsv2_application, service_execution_role must be a valid IAM role ARN."
  }
}

variable "application_configuration" {
  description = "The application's configuration."
  type = object({
    application_code_configuration = optional(object({
      code_content_type = string
      code_content = optional(object({
        s3_content_location = optional(object({
          bucket_arn     = string
          file_key       = string
          object_version = optional(string)
        }))
        text_content = optional(string)
      }))
    }))
    application_snapshot_configuration = optional(object({
      snapshots_enabled = bool
    }))
    environment_properties = optional(object({
      property_group = list(object({
        property_group_id = string
        property_map      = map(string)
      }))
    }))
    flink_application_configuration = optional(object({
      checkpoint_configuration = optional(object({
        configuration_type            = string
        checkpointing_enabled         = optional(bool)
        checkpoint_interval           = optional(number)
        min_pause_between_checkpoints = optional(number)
      }))
      monitoring_configuration = optional(object({
        configuration_type = string
        log_level          = optional(string)
        metrics_level      = optional(string)
      }))
      parallelism_configuration = optional(object({
        configuration_type   = string
        auto_scaling_enabled = optional(bool)
        parallelism          = optional(number)
        parallelism_per_kpu  = optional(number)
      }))
    }))
    run_configuration = optional(object({
      application_restore_configuration = optional(object({
        application_restore_type = string
        snapshot_name            = optional(string)
      }))
      flink_run_configuration = optional(object({
        allow_non_restored_state = optional(bool)
      }))
    }))
    sql_application_configuration = optional(object({
      input = optional(list(object({
        input_schema = object({
          record_column = list(object({
            name     = string
            sql_type = string
            mapping  = optional(string)
          }))
          record_format = object({
            record_format_type = string
            mapping_parameters = object({
              csv_mapping_parameters = optional(object({
                record_column_delimiter = string
                record_row_delimiter    = string
              }))
              json_mapping_parameters = optional(object({
                record_row_path = string
              }))
            })
          })
          record_encoding = optional(string)
        })
        name_prefix = string
        input_parallelism = optional(object({
          count = optional(number)
        }))
        input_processing_configuration = optional(object({
          input_lambda_processor = object({
            resource_arn = string
          })
        }))
        input_starting_position_configuration = optional(object({
          input_starting_position = string
        }))
        kinesis_firehose_input = optional(object({
          resource_arn = string
        }))
        kinesis_streams_input = optional(object({
          resource_arn = string
        }))
      })))
      output = optional(list(object({
        destination_schema = object({
          record_format_type = string
        })
        name = string
        kinesis_firehose_output = optional(object({
          resource_arn = string
        }))
        kinesis_streams_output = optional(object({
          resource_arn = string
        }))
        lambda_output = optional(object({
          resource_arn = string
        }))
      })))
      reference_data_source = optional(list(object({
        reference_schema = object({
          record_column = list(object({
            name     = string
            sql_type = string
            mapping  = optional(string)
          }))
          record_format = object({
            record_format_type = string
            mapping_parameters = object({
              csv_mapping_parameters = optional(object({
                record_column_delimiter = string
                record_row_delimiter    = string
              }))
              json_mapping_parameters = optional(object({
                record_row_path = string
              }))
            })
          })
          record_encoding = optional(string)
        })
        s3_reference_data_source = object({
          bucket_arn = string
          file_key   = string
        })
        table_name = string
      })))
    }))
    vpc_configuration = optional(object({
      security_group_ids = list(string)
      subnet_ids         = list(string)
    }))
  })
  default = null

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.application_code_configuration != null &&
      var.application_configuration.application_code_configuration.code_content_type != null &&
      contains(["PLAINTEXT", "ZIPFILE"], var.application_configuration.application_code_configuration.code_content_type)
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.application_code_configuration.code_content_type must be PLAINTEXT or ZIPFILE when application_configuration is specified."
  }

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.flink_application_configuration == null ||
      var.application_configuration.flink_application_configuration.checkpoint_configuration == null ||
      contains(["CUSTOM", "DEFAULT"], var.application_configuration.flink_application_configuration.checkpoint_configuration.configuration_type)
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.flink_application_configuration.checkpoint_configuration.configuration_type must be CUSTOM or DEFAULT."
  }

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.flink_application_configuration == null ||
      var.application_configuration.flink_application_configuration.monitoring_configuration == null ||
      contains(["CUSTOM", "DEFAULT"], var.application_configuration.flink_application_configuration.monitoring_configuration.configuration_type)
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.flink_application_configuration.monitoring_configuration.configuration_type must be CUSTOM or DEFAULT."
  }

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.flink_application_configuration == null ||
      var.application_configuration.flink_application_configuration.monitoring_configuration == null ||
      var.application_configuration.flink_application_configuration.monitoring_configuration.log_level == null ||
      contains(["DEBUG", "ERROR", "INFO", "WARN"], var.application_configuration.flink_application_configuration.monitoring_configuration.log_level)
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.flink_application_configuration.monitoring_configuration.log_level must be DEBUG, ERROR, INFO, or WARN."
  }

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.flink_application_configuration == null ||
      var.application_configuration.flink_application_configuration.monitoring_configuration == null ||
      var.application_configuration.flink_application_configuration.monitoring_configuration.metrics_level == null ||
      contains(["APPLICATION", "OPERATOR", "PARALLELISM", "TASK"], var.application_configuration.flink_application_configuration.monitoring_configuration.metrics_level)
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.flink_application_configuration.monitoring_configuration.metrics_level must be APPLICATION, OPERATOR, PARALLELISM, or TASK."
  }

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.flink_application_configuration == null ||
      var.application_configuration.flink_application_configuration.parallelism_configuration == null ||
      contains(["CUSTOM", "DEFAULT"], var.application_configuration.flink_application_configuration.parallelism_configuration.configuration_type)
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.flink_application_configuration.parallelism_configuration.configuration_type must be CUSTOM or DEFAULT."
  }

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.run_configuration == null ||
      var.application_configuration.run_configuration.application_restore_configuration == null ||
      contains(["RESTORE_FROM_CUSTOM_SNAPSHOT", "RESTORE_FROM_LATEST_SNAPSHOT", "SKIP_RESTORE_FROM_SNAPSHOT"], var.application_configuration.run_configuration.application_restore_configuration.application_restore_type)
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.run_configuration.application_restore_configuration.application_restore_type must be RESTORE_FROM_CUSTOM_SNAPSHOT, RESTORE_FROM_LATEST_SNAPSHOT, or SKIP_RESTORE_FROM_SNAPSHOT."
  }

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.sql_application_configuration == null ||
      var.application_configuration.sql_application_configuration.input == null ||
      alltrue([
        for input in var.application_configuration.sql_application_configuration.input :
        input.input_starting_position_configuration == null ||
        contains(["LAST_STOPPED_POINT", "NOW", "TRIM_HORIZON"], input.input_starting_position_configuration.input_starting_position)
      ])
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.sql_application_configuration.input.input_starting_position_configuration.input_starting_position must be LAST_STOPPED_POINT, NOW, or TRIM_HORIZON."
  }

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.sql_application_configuration == null ||
      var.application_configuration.sql_application_configuration.input == null ||
      alltrue([
        for input in var.application_configuration.sql_application_configuration.input :
        contains(["CSV", "JSON"], input.input_schema.record_format.record_format_type)
      ])
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.sql_application_configuration.input.input_schema.record_format.record_format_type must be CSV or JSON."
  }

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.sql_application_configuration == null ||
      var.application_configuration.sql_application_configuration.output == null ||
      alltrue([
        for output in var.application_configuration.sql_application_configuration.output :
        contains(["CSV", "JSON"], output.destination_schema.record_format_type)
      ])
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.sql_application_configuration.output.destination_schema.record_format_type must be CSV or JSON."
  }

  validation {
    condition = var.application_configuration == null || (
      var.application_configuration.sql_application_configuration == null ||
      var.application_configuration.sql_application_configuration.reference_data_source == null ||
      alltrue([
        for ref in var.application_configuration.sql_application_configuration.reference_data_source :
        contains(["CSV", "JSON"], ref.reference_schema.record_format.record_format_type)
      ])
    )
    error_message = "resource_aws_kinesisanalyticsv2_application, application_configuration.sql_application_configuration.reference_data_source.reference_schema.record_format.record_format_type must be CSV or JSON."
  }
}

variable "application_mode" {
  description = "The application's mode."
  type        = string
  default     = null

  validation {
    condition     = var.application_mode == null || contains(["STREAMING", "INTERACTIVE"], var.application_mode)
    error_message = "resource_aws_kinesisanalyticsv2_application, application_mode must be STREAMING or INTERACTIVE."
  }
}

variable "cloudwatch_logging_options" {
  description = "A CloudWatch log stream to monitor application configuration errors."
  type = object({
    log_stream_arn = string
  })
  default = null

  validation {
    condition     = var.cloudwatch_logging_options == null || can(regex("^arn:aws:logs:", var.cloudwatch_logging_options.log_stream_arn))
    error_message = "resource_aws_kinesisanalyticsv2_application, cloudwatch_logging_options.log_stream_arn must be a valid CloudWatch log stream ARN."
  }
}

variable "description" {
  description = "A summary description of the application."
  type        = string
  default     = null
}

variable "force_stop" {
  description = "Whether to force stop an unresponsive Flink-based application."
  type        = bool
  default     = null
}

variable "start_application" {
  description = "Whether to start or stop the application."
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the application."
  type        = map(string)
  default     = {}
}