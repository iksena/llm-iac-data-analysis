variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the Kinesis Analytics Application."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.name))
    error_message = "resource_aws_kinesis_analytics_application, name must contain only alphanumeric characters, hyphens, underscores, and periods."
  }
}

variable "code" {
  description = "SQL Code to transform input data, and generate output."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the application."
  type        = string
  default     = null
}

variable "cloudwatch_logging_options" {
  description = "The CloudWatch log stream options to monitor application errors."
  type = object({
    log_stream_arn = string
    role_arn       = string
  })
  default = null

  validation {
    condition = var.cloudwatch_logging_options == null ? true : (
      can(regex("^arn:aws:logs:", var.cloudwatch_logging_options.log_stream_arn)) &&
      can(regex("^arn:aws:iam:", var.cloudwatch_logging_options.role_arn))
    )
    error_message = "resource_aws_kinesis_analytics_application, cloudwatch_logging_options log_stream_arn must be a valid CloudWatch Log Stream ARN and role_arn must be a valid IAM Role ARN."
  }
}

variable "inputs" {
  description = "Input configuration of the application."
  type = object({
    name_prefix = string
    schema = object({
      record_encoding = optional(string)
      record_columns = list(object({
        name     = string
        sql_type = string
        mapping  = optional(string)
      }))
      record_format = object({
        record_format_type = string
        mapping_parameters = optional(object({
          csv = optional(object({
            record_column_delimiter = string
            record_row_delimiter    = string
          }))
          json = optional(object({
            record_row_path = string
          }))
        }))
      })
    })
    kinesis_firehose = optional(object({
      resource_arn = string
      role_arn     = string
    }))
    kinesis_stream = optional(object({
      resource_arn = string
      role_arn     = string
    }))
    parallelism = optional(object({
      count = number
    }))
    processing_configuration = optional(object({
      lambda = object({
        resource_arn = string
        role_arn     = string
      })
    }))
    starting_position_configuration = optional(object({
      starting_position = string
    }))
  })
  default = null

  validation {
    condition = var.inputs == null ? true : (
      var.inputs.schema.record_format.record_format_type == null ? true :
      contains(["CSV", "JSON"], var.inputs.schema.record_format.record_format_type)
    )
    error_message = "resource_aws_kinesis_analytics_application, inputs schema record_format_type must be either CSV or JSON."
  }

  validation {
    condition = var.inputs == null ? true : (
      var.inputs.starting_position_configuration == null ? true :
      contains(["LAST_STOPPED_POINT", "NOW", "TRIM_HORIZON"], var.inputs.starting_position_configuration.starting_position)
    )
    error_message = "resource_aws_kinesis_analytics_application, inputs starting_position must be one of LAST_STOPPED_POINT, NOW, or TRIM_HORIZON."
  }

  validation {
    condition = var.inputs == null ? true : (
      var.inputs.kinesis_firehose != null && var.inputs.kinesis_stream != null ? false : true
    )
    error_message = "resource_aws_kinesis_analytics_application, inputs kinesis_firehose and kinesis_stream are mutually exclusive."
  }

  validation {
    condition = var.inputs == null ? true : (
      var.inputs.parallelism == null ? true : var.inputs.parallelism.count > 0
    )
    error_message = "resource_aws_kinesis_analytics_application, inputs parallelism count must be greater than 0."
  }
}

variable "outputs" {
  description = "Output destination configuration of the application. You can have a maximum of 3 destinations configured."
  type = list(object({
    name = string
    schema = object({
      record_format_type = string
    })
    kinesis_firehose = optional(object({
      resource_arn = string
      role_arn     = string
    }))
    kinesis_stream = optional(object({
      resource_arn = string
      role_arn     = string
    }))
    lambda = optional(object({
      resource_arn = string
      role_arn     = string
    }))
  }))
  default = null

  validation {
    condition     = var.outputs == null ? true : length(var.outputs) <= 3
    error_message = "resource_aws_kinesis_analytics_application, outputs can have a maximum of 3 destinations configured."
  }

  validation {
    condition = var.outputs == null ? true : alltrue([
      for output in var.outputs : contains(["CSV", "JSON"], output.schema.record_format_type)
    ])
    error_message = "resource_aws_kinesis_analytics_application, outputs schema record_format_type must be either CSV or JSON."
  }

  validation {
    condition = var.outputs == null ? true : alltrue([
      for output in var.outputs : (
        output.kinesis_firehose != null && output.kinesis_stream != null ? false : true
      )
    ])
    error_message = "resource_aws_kinesis_analytics_application, outputs kinesis_firehose and kinesis_stream are mutually exclusive."
  }
}

variable "reference_data_sources" {
  description = "An S3 Reference Data Source for the application."
  type = object({
    table_name = string
    schema = object({
      record_encoding = optional(string)
      record_columns = list(object({
        name     = string
        sql_type = string
        mapping  = optional(string)
      }))
      record_format = object({
        record_format_type = string
        mapping_parameters = optional(object({
          csv = optional(object({
            record_column_delimiter = string
            record_row_delimiter    = string
          }))
          json = optional(object({
            record_row_path = string
          }))
        }))
      })
    })
    s3 = optional(object({
      bucket_arn = string
      file_key   = string
      role_arn   = string
    }))
  })
  default = null

  validation {
    condition = var.reference_data_sources == null ? true : (
      var.reference_data_sources.schema.record_format.record_format_type == null ? true :
      contains(["CSV", "JSON"], var.reference_data_sources.schema.record_format.record_format_type)
    )
    error_message = "resource_aws_kinesis_analytics_application, reference_data_sources schema record_format_type must be either CSV or JSON."
  }

  validation {
    condition = var.reference_data_sources == null ? true : (
      var.reference_data_sources.s3 == null ? true :
      can(regex("^arn:aws:s3:", var.reference_data_sources.s3.bucket_arn))
    )
    error_message = "resource_aws_kinesis_analytics_application, reference_data_sources s3 bucket_arn must be a valid S3 bucket ARN."
  }
}

variable "start_application" {
  description = "Whether to start or stop the Kinesis Analytics Application. To start an application, an input with a defined starting_position must be configured."
  type        = bool
  default     = null
}

variable "tags" {
  description = "Key-value map of tags for the Kinesis Analytics Application."
  type        = map(string)
  default     = {}
}