variable "name" {
  description = "Name of the flow"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_appflow_flow, name must not be empty."
  }
}

variable "description" {
  description = "Description of the flow you want to create"
  type        = string
  default     = null
}

variable "kms_arn" {
  description = "ARN (Amazon Resource Name) of the Key Management Service (KMS) key you provide for encryption"
  type        = string
  default     = null

  validation {
    condition     = var.kms_arn == null || can(regex("^arn:aws:kms:", var.kms_arn))
    error_message = "resource_aws_appflow_flow, kms_arn must be a valid KMS ARN format starting with 'arn:aws:kms:' or null."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "destination_flow_config" {
  description = "A Destination Flow Config that controls how Amazon AppFlow places data in the destination connector"
  type = object({
    connector_type         = string
    api_version            = optional(string)
    connector_profile_name = optional(string)
    destination_connector_properties = object({
      custom_connector = optional(object({
        entity_name          = string
        custom_properties    = optional(map(string))
        id_field_names       = optional(list(string))
        write_operation_type = optional(string)
        error_handling_config = optional(object({
          bucket_name                     = optional(string)
          bucket_prefix                   = optional(string)
          fail_on_first_destination_error = optional(bool)
        }))
      }))
      customer_profiles = optional(object({
        domain_name      = string
        object_type_name = optional(string)
      }))
      event_bridge = optional(object({
        object = string
        error_handling_config = optional(object({
          bucket_name                     = optional(string)
          bucket_prefix                   = optional(string)
          fail_on_first_destination_error = optional(bool)
        }))
      }))
      honeycode = optional(object({
        object = string
        error_handling_config = optional(object({
          bucket_name                     = optional(string)
          bucket_prefix                   = optional(string)
          fail_on_first_destination_error = optional(bool)
        }))
      }))
      marketo = optional(object({
        object = string
        error_handling_config = optional(object({
          bucket_name                     = optional(string)
          bucket_prefix                   = optional(string)
          fail_on_first_destination_error = optional(bool)
        }))
      }))
      redshift = optional(object({
        intermediate_bucket_name = string
        object                   = string
        bucket_prefix            = optional(string)
        error_handling_config = optional(object({
          bucket_name                     = optional(string)
          bucket_prefix                   = optional(string)
          fail_on_first_destination_error = optional(bool)
        }))
      }))
      s3 = optional(object({
        bucket_name   = string
        bucket_prefix = optional(string)
        s3_output_format_config = optional(object({
          file_type                   = optional(string)
          preserve_source_data_typing = optional(bool)
          aggregation_config = optional(object({
            aggregation_type = optional(string)
            target_file_size = optional(number)
          }))
          prefix_config = optional(object({
            prefix_format    = optional(string)
            prefix_type      = optional(string)
            prefix_hierarchy = optional(list(string))
          }))
        }))
      }))
      salesforce = optional(object({
        object               = string
        id_field_names       = optional(list(string))
        write_operation_type = optional(string)
        data_transfer_api    = optional(string)
        error_handling_config = optional(object({
          bucket_name                     = optional(string)
          bucket_prefix                   = optional(string)
          fail_on_first_destination_error = optional(bool)
        }))
      }))
      sapo_data = optional(object({
        object_path     = string
        id_field_names  = optional(list(string))
        write_operation = optional(string)
        error_handling_config = optional(object({
          bucket_name                     = optional(string)
          bucket_prefix                   = optional(string)
          fail_on_first_destination_error = optional(bool)
        }))
        success_response_handling_config = optional(object({
          bucket_name   = optional(string)
          bucket_prefix = optional(string)
        }))
      }))
      snowflake = optional(object({
        intermediate_bucket_name = string
        object                   = string
        bucket_prefix            = optional(string)
        error_handling_config = optional(object({
          bucket_name                     = optional(string)
          bucket_prefix                   = optional(string)
          fail_on_first_destination_error = optional(bool)
        }))
      }))
      upsolver = optional(object({
        bucket_name   = string
        bucket_prefix = optional(string)
        s3_output_format_config = optional(object({
          file_type = optional(string)
          aggregation_config = optional(object({
            aggregation_type = optional(string)
            target_file_size = optional(number)
          }))
          prefix_config = optional(object({
            prefix_format    = optional(string)
            prefix_type      = optional(string)
            prefix_hierarchy = optional(list(string))
          }))
        }))
      }))
      zendesk = optional(object({
        object               = string
        id_field_names       = optional(list(string))
        write_operation_type = optional(string)
        error_handling_config = optional(object({
          bucket_name                     = optional(string)
          bucket_prefix                   = optional(string)
          fail_on_first_destination_error = optional(bool)
        }))
      }))
    })
  })

  validation {
    condition = contains([
      "Salesforce", "Singular", "Slack", "Redshift", "S3", "Marketo", "Googleanalytics",
      "Zendesk", "Servicenow", "Datadog", "Trendmicro", "Snowflake", "Dynatrace",
      "Infornexus", "Amplitude", "Veeva", "EventBridge", "LookoutMetrics", "Upsolver",
      "Honeycode", "CustomerProfiles", "SAPOData", "CustomConnector"
    ], var.destination_flow_config.connector_type)
    error_message = "resource_aws_appflow_flow, destination_flow_config.connector_type must be one of: Salesforce, Singular, Slack, Redshift, S3, Marketo, Googleanalytics, Zendesk, Servicenow, Datadog, Trendmicro, Snowflake, Dynatrace, Infornexus, Amplitude, Veeva, EventBridge, LookoutMetrics, Upsolver, Honeycode, CustomerProfiles, SAPOData, CustomConnector."
  }

  validation {
    condition = var.destination_flow_config.destination_connector_properties.custom_connector == null || (
      var.destination_flow_config.destination_connector_properties.custom_connector.write_operation_type == null ||
      contains(["INSERT", "UPSERT", "UPDATE", "DELETE"], var.destination_flow_config.destination_connector_properties.custom_connector.write_operation_type)
    )
    error_message = "resource_aws_appflow_flow, destination_flow_config.destination_connector_properties.custom_connector.write_operation_type must be one of: INSERT, UPSERT, UPDATE, DELETE."
  }

  validation {
    condition = var.destination_flow_config.destination_connector_properties.s3 == null || (
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config == null ||
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.file_type == null ||
      contains(["CSV", "JSON", "PARQUET"], var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.file_type)
    )
    error_message = "resource_aws_appflow_flow, destination_flow_config.destination_connector_properties.s3.s3_output_format_config.file_type must be one of: CSV, JSON, PARQUET."
  }

  validation {
    condition = var.destination_flow_config.destination_connector_properties.s3 == null || (
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config == null ||
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.aggregation_config == null ||
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.aggregation_config.aggregation_type == null ||
      contains(["None", "SingleFile"], var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.aggregation_config.aggregation_type)
    )
    error_message = "resource_aws_appflow_flow, destination_flow_config.destination_connector_properties.s3.s3_output_format_config.aggregation_config.aggregation_type must be one of: None, SingleFile."
  }

  validation {
    condition = var.destination_flow_config.destination_connector_properties.s3 == null || (
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config == null ||
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.prefix_config == null ||
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.prefix_config.prefix_format == null ||
      contains(["YEAR", "MONTH", "DAY", "HOUR", "MINUTE"], var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.prefix_config.prefix_format)
    )
    error_message = "resource_aws_appflow_flow, destination_flow_config.destination_connector_properties.s3.s3_output_format_config.prefix_config.prefix_format must be one of: YEAR, MONTH, DAY, HOUR, MINUTE."
  }

  validation {
    condition = var.destination_flow_config.destination_connector_properties.s3 == null || (
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config == null ||
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.prefix_config == null ||
      var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.prefix_config.prefix_type == null ||
      contains(["FILENAME", "PATH", "PATH_AND_FILENAME"], var.destination_flow_config.destination_connector_properties.s3.s3_output_format_config.prefix_config.prefix_type)
    )
    error_message = "resource_aws_appflow_flow, destination_flow_config.destination_connector_properties.s3.s3_output_format_config.prefix_config.prefix_type must be one of: FILENAME, PATH, PATH_AND_FILENAME."
  }

  validation {
    condition = var.destination_flow_config.destination_connector_properties.salesforce == null || (
      var.destination_flow_config.destination_connector_properties.salesforce.write_operation_type == null ||
      contains(["INSERT", "UPSERT", "UPDATE", "DELETE"], var.destination_flow_config.destination_connector_properties.salesforce.write_operation_type)
    )
    error_message = "resource_aws_appflow_flow, destination_flow_config.destination_connector_properties.salesforce.write_operation_type must be one of: INSERT, UPSERT, UPDATE, DELETE."
  }

  validation {
    condition = var.destination_flow_config.destination_connector_properties.sapo_data == null || (
      var.destination_flow_config.destination_connector_properties.sapo_data.write_operation == null ||
      contains(["INSERT", "UPSERT", "UPDATE", "DELETE"], var.destination_flow_config.destination_connector_properties.sapo_data.write_operation)
    )
    error_message = "resource_aws_appflow_flow, destination_flow_config.destination_connector_properties.sapo_data.write_operation must be one of: INSERT, UPSERT, UPDATE, DELETE."
  }

  validation {
    condition = var.destination_flow_config.destination_connector_properties.upsolver == null || (
      var.destination_flow_config.destination_connector_properties.upsolver.bucket_name == null ||
      can(regex("^upsolver-appflow", var.destination_flow_config.destination_connector_properties.upsolver.bucket_name))
    )
    error_message = "resource_aws_appflow_flow, destination_flow_config.destination_connector_properties.upsolver.bucket_name must begin with 'upsolver-appflow'."
  }

  validation {
    condition = var.destination_flow_config.destination_connector_properties.upsolver == null || (
      var.destination_flow_config.destination_connector_properties.upsolver.s3_output_format_config == null ||
      var.destination_flow_config.destination_connector_properties.upsolver.s3_output_format_config.file_type == null ||
      contains(["CSV", "JSON", "PARQUET"], var.destination_flow_config.destination_connector_properties.upsolver.s3_output_format_config.file_type)
    )
    error_message = "resource_aws_appflow_flow, destination_flow_config.destination_connector_properties.upsolver.s3_output_format_config.file_type must be one of: CSV, JSON, PARQUET."
  }

  validation {
    condition = var.destination_flow_config.destination_connector_properties.zendesk == null || (
      var.destination_flow_config.destination_connector_properties.zendesk.write_operation_type == null ||
      contains(["INSERT", "UPSERT", "UPDATE", "DELETE"], var.destination_flow_config.destination_connector_properties.zendesk.write_operation_type)
    )
    error_message = "resource_aws_appflow_flow, destination_flow_config.destination_connector_properties.zendesk.write_operation_type must be one of: INSERT, UPSERT, UPDATE, DELETE."
  }
}

variable "source_flow_config" {
  description = "The Source Flow Config that controls how Amazon AppFlow retrieves data from the source connector"
  type = object({
    connector_type         = string
    api_version            = optional(string)
    connector_profile_name = optional(string)
    source_connector_properties = object({
      amplitude = optional(object({
        object = string
      }))
      custom_connector = optional(object({
        entity_name       = string
        custom_properties = optional(map(string))
      }))
      datadog = optional(object({
        object = string
      }))
      dynatrace = optional(object({
        object = string
      }))
      google_analytics = optional(object({
        object = string
      }))
      infor_nexus = optional(object({
        object = string
      }))
      marketo = optional(object({
        object = string
      }))
      s3 = optional(object({
        bucket_name   = string
        bucket_prefix = optional(string)
        s3_input_format_config = optional(object({
          s3_input_file_type = optional(string)
        }))
      }))
      salesforce = optional(object({
        object                      = string
        enable_dynamic_field_update = optional(bool)
        include_deleted_records     = optional(bool)
        data_transfer_api           = optional(string)
      }))
      sapo_data = optional(object({
        object_path = string
        pagination_config = optional(object({
          max_page_size = optional(number)
        }))
        parallelism_config = optional(object({
          max_parallelism = optional(number)
        }))
      }))
      service_now = optional(object({
        object = string
      }))
      singular = optional(object({
        object = string
      }))
      slack = optional(object({
        object = string
      }))
      trend_micro = optional(object({
        object = string
      }))
      veeva = optional(object({
        object               = string
        document_type        = optional(string)
        include_all_versions = optional(bool)
        include_renditions   = optional(bool)
        include_source_files = optional(bool)
      }))
      zendesk = optional(object({
        object = string
      }))
    })
    incremental_pull_config = optional(object({
      datetime_type_field_name = optional(string)
    }))
  })

  validation {
    condition = contains([
      "Salesforce", "Singular", "Slack", "Redshift", "S3", "Marketo", "Googleanalytics",
      "Zendesk", "Servicenow", "Datadog", "Trendmicro", "Snowflake", "Dynatrace",
      "Infornexus", "Amplitude", "Veeva", "EventBridge", "LookoutMetrics", "Upsolver",
      "Honeycode", "CustomerProfiles", "SAPOData", "CustomConnector"
    ], var.source_flow_config.connector_type)
    error_message = "resource_aws_appflow_flow, source_flow_config.connector_type must be one of: Salesforce, Singular, Slack, Redshift, S3, Marketo, Googleanalytics, Zendesk, Servicenow, Datadog, Trendmicro, Snowflake, Dynatrace, Infornexus, Amplitude, Veeva, EventBridge, LookoutMetrics, Upsolver, Honeycode, CustomerProfiles, SAPOData, CustomConnector."
  }

  validation {
    condition = var.source_flow_config.source_connector_properties.s3 == null || (
      var.source_flow_config.source_connector_properties.s3.s3_input_format_config == null ||
      var.source_flow_config.source_connector_properties.s3.s3_input_format_config.s3_input_file_type == null ||
      contains(["CSV", "JSON"], var.source_flow_config.source_connector_properties.s3.s3_input_format_config.s3_input_file_type)
    )
    error_message = "resource_aws_appflow_flow, source_flow_config.source_connector_properties.s3.s3_input_format_config.s3_input_file_type must be one of: CSV, JSON."
  }
}

variable "task" {
  description = "A Task that Amazon AppFlow performs while transferring the data in the flow run"
  type = list(object({
    source_fields     = list(string)
    task_type         = string
    destination_field = optional(string)
    task_properties   = optional(map(string))
    connector_operator = optional(object({
      amplitude        = optional(string)
      custom_connector = optional(string)
      datadog          = optional(string)
      dynatrace        = optional(string)
      google_analytics = optional(string)
      infor_nexus      = optional(string)
      marketo          = optional(string)
      s3               = optional(string)
      salesforce       = optional(string)
      sapo_data        = optional(string)
      service_now      = optional(string)
      singular         = optional(string)
      slack            = optional(string)
      trendmicro       = optional(string)
      veeva            = optional(string)
      zendesk          = optional(string)
    }))
  }))

  validation {
    condition     = length(var.task) > 0
    error_message = "resource_aws_appflow_flow, task must contain at least one item."
  }

  validation {
    condition = alltrue([
      for task in var.task : contains([
        "Arithmetic", "Filter", "Map", "Map_all", "Mask", "Merge", "Passthrough", "Truncate", "Validate"
      ], task.task_type)
    ])
    error_message = "resource_aws_appflow_flow, task.task_type must be one of: Arithmetic, Filter, Map, Map_all, Mask, Merge, Passthrough, Truncate, Validate."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.amplitude == null ||
        contains(["BETWEEN"], task.connector_operator.amplitude)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.amplitude must be: BETWEEN."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.custom_connector == null ||
        contains([
          "PROJECTION", "LESS_THAN", "GREATER_THAN", "CONTAINS", "BETWEEN", "LESS_THAN_OR_EQUAL_TO",
          "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO", "ADDITION", "MULTIPLICATION",
          "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.custom_connector)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.custom_connector must be one of: PROJECTION, LESS_THAN, GREATER_THAN, CONTAINS, BETWEEN, LESS_THAN_OR_EQUAL_TO, GREATER_THAN_OR_EQUAL_TO, EQUAL_TO, NOT_EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.datadog == null ||
        contains([
          "PROJECTION", "BETWEEN", "EQUAL_TO", "ADDITION", "MULTIPLICATION", "DIVISION",
          "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.datadog)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.datadog must be one of: PROJECTION, BETWEEN, EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.dynatrace == null ||
        contains([
          "PROJECTION", "BETWEEN", "EQUAL_TO", "ADDITION", "MULTIPLICATION", "DIVISION",
          "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.dynatrace)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.dynatrace must be one of: PROJECTION, BETWEEN, EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.google_analytics == null ||
        contains(["PROJECTION", "BETWEEN"], task.connector_operator.google_analytics)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.google_analytics must be one of: PROJECTION, BETWEEN."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.infor_nexus == null ||
        contains([
          "PROJECTION", "BETWEEN", "EQUAL_TO", "ADDITION", "MULTIPLICATION", "DIVISION",
          "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.infor_nexus)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.infor_nexus must be one of: PROJECTION, BETWEEN, EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.marketo == null ||
        contains([
          "PROJECTION", "BETWEEN", "EQUAL_TO", "ADDITION", "MULTIPLICATION", "DIVISION",
          "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.marketo)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.marketo must be one of: PROJECTION, BETWEEN, EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.s3 == null ||
        contains([
          "PROJECTION", "LESS_THAN", "GREATER_THAN", "BETWEEN", "LESS_THAN_OR_EQUAL_TO",
          "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO", "ADDITION", "MULTIPLICATION",
          "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.s3)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.s3 must be one of: PROJECTION, LESS_THAN, GREATER_THAN, BETWEEN, LESS_THAN_OR_EQUAL_TO, GREATER_THAN_OR_EQUAL_TO, EQUAL_TO, NOT_EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.salesforce == null ||
        contains([
          "PROJECTION", "LESS_THAN", "GREATER_THAN", "CONTAINS", "BETWEEN", "LESS_THAN_OR_EQUAL_TO",
          "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO", "ADDITION", "MULTIPLICATION",
          "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.salesforce)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.salesforce must be one of: PROJECTION, LESS_THAN, GREATER_THAN, CONTAINS, BETWEEN, LESS_THAN_OR_EQUAL_TO, GREATER_THAN_OR_EQUAL_TO, EQUAL_TO, NOT_EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.sapo_data == null ||
        contains([
          "PROJECTION", "LESS_THAN", "GREATER_THAN", "CONTAINS", "BETWEEN", "LESS_THAN_OR_EQUAL_TO",
          "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO", "ADDITION", "MULTIPLICATION",
          "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.sapo_data)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.sapo_data must be one of: PROJECTION, LESS_THAN, GREATER_THAN, CONTAINS, BETWEEN, LESS_THAN_OR_EQUAL_TO, GREATER_THAN_OR_EQUAL_TO, EQUAL_TO, NOT_EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.service_now == null ||
        contains([
          "PROJECTION", "LESS_THAN", "GREATER_THAN", "CONTAINS", "BETWEEN", "LESS_THAN_OR_EQUAL_TO",
          "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO", "ADDITION", "MULTIPLICATION",
          "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.service_now)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.service_now must be one of: PROJECTION, LESS_THAN, GREATER_THAN, CONTAINS, BETWEEN, LESS_THAN_OR_EQUAL_TO, GREATER_THAN_OR_EQUAL_TO, EQUAL_TO, NOT_EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.singular == null ||
        contains([
          "PROJECTION", "EQUAL_TO", "ADDITION", "MULTIPLICATION", "DIVISION",
          "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.singular)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.singular must be one of: PROJECTION, EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.slack == null ||
        contains([
          "PROJECTION", "LESS_THAN", "GREATER_THAN", "BETWEEN", "LESS_THAN_OR_EQUAL_TO",
          "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "ADDITION", "MULTIPLICATION", "DIVISION",
          "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.slack)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.slack must be one of: PROJECTION, LESS_THAN, GREATER_THAN, BETWEEN, LESS_THAN_OR_EQUAL_TO, GREATER_THAN_OR_EQUAL_TO, EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.trendmicro == null ||
        contains([
          "PROJECTION", "EQUAL_TO", "ADDITION", "MULTIPLICATION", "DIVISION",
          "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.trendmicro)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.trendmicro must be one of: PROJECTION, EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.veeva == null ||
        contains([
          "PROJECTION", "LESS_THAN", "GREATER_THAN", "CONTAINS", "BETWEEN", "LESS_THAN_OR_EQUAL_TO",
          "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO", "ADDITION", "MULTIPLICATION",
          "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.veeva)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.veeva must be one of: PROJECTION, LESS_THAN, GREATER_THAN, CONTAINS, BETWEEN, LESS_THAN_OR_EQUAL_TO, GREATER_THAN_OR_EQUAL_TO, EQUAL_TO, NOT_EQUAL_TO, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }

  validation {
    condition = alltrue([
      for task in var.task : task.connector_operator == null || (
        task.connector_operator.zendesk == null ||
        contains([
          "PROJECTION", "GREATER_THAN", "ADDITION", "MULTIPLICATION", "DIVISION",
          "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL",
          "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
        ], task.connector_operator.zendesk)
      )
    ])
    error_message = "resource_aws_appflow_flow, task.connector_operator.zendesk must be one of: PROJECTION, GREATER_THAN, ADDITION, MULTIPLICATION, DIVISION, SUBTRACTION, MASK_ALL, MASK_FIRST_N, MASK_LAST_N, VALIDATE_NON_NULL, VALIDATE_NON_ZERO, VALIDATE_NON_NEGATIVE, VALIDATE_NUMERIC, NO_OP."
  }
}

variable "trigger_config" {
  description = "A Trigger that determine how and when the flow runs"
  type = object({
    trigger_type = string
    trigger_properties = optional(object({
      scheduled = optional(object({
        schedule_expression  = string
        data_pull_mode       = optional(string)
        first_execution_from = optional(string)
        schedule_end_time    = optional(string)
        schedule_offset      = optional(number)
        schedule_start_time  = optional(string)
        timezone             = optional(string)
      }))
    }))
  })

  validation {
    condition     = contains(["Scheduled", "Event", "OnDemand"], var.trigger_config.trigger_type)
    error_message = "resource_aws_appflow_flow, trigger_config.trigger_type must be one of: Scheduled, Event, OnDemand."
  }

  validation {
    condition = var.trigger_config.trigger_properties == null || (
      var.trigger_config.trigger_properties.scheduled == null ||
      var.trigger_config.trigger_properties.scheduled.data_pull_mode == null ||
      contains(["Incremental", "Complete"], var.trigger_config.trigger_properties.scheduled.data_pull_mode)
    )
    error_message = "resource_aws_appflow_flow, trigger_config.trigger_properties.scheduled.data_pull_mode must be one of: Incremental, Complete."
  }

  validation {
    condition = var.trigger_config.trigger_properties == null || (
      var.trigger_config.trigger_properties.scheduled == null ||
      var.trigger_config.trigger_properties.scheduled.schedule_offset == null ||
      var.trigger_config.trigger_properties.scheduled.schedule_offset <= 36000
    )
    error_message = "resource_aws_appflow_flow, trigger_config.trigger_properties.scheduled.schedule_offset maximum value is 36000."
  }
}

variable "metadata_catalog_config" {
  description = "A Catalog that determines the configuration that Amazon AppFlow uses when it catalogs the data that's transferred by the associated flow"
  type = object({
    glue_data_catalog = optional(object({
      database_name = string
      role_arn      = string
      table_prefix  = string
    }))
  })
  default = null

  validation {
    condition = var.metadata_catalog_config == null || (
      var.metadata_catalog_config.glue_data_catalog == null ||
      can(regex("^arn:aws:iam:", var.metadata_catalog_config.glue_data_catalog.role_arn))
    )
    error_message = "resource_aws_appflow_flow, metadata_catalog_config.glue_data_catalog.role_arn must be a valid IAM role ARN format starting with 'arn:aws:iam:'."
  }
}