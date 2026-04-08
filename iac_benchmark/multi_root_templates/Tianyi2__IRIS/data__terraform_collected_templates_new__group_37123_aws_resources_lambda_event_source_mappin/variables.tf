variable "function_name" {
  description = "Name or ARN of the Lambda function that will be subscribing to events"
  type        = string
}

variable "amazon_managed_kafka_event_source_config" {
  description = "Additional configuration block for Amazon Managed Kafka sources"
  type = object({
    consumer_group_id = optional(string)
  })
  default = null

  validation {
    condition = var.amazon_managed_kafka_event_source_config == null || (
      var.amazon_managed_kafka_event_source_config.consumer_group_id == null ||
      (length(var.amazon_managed_kafka_event_source_config.consumer_group_id) >= 1 &&
      length(var.amazon_managed_kafka_event_source_config.consumer_group_id) <= 200)
    )
    error_message = "resource_aws_lambda_event_source_mapping, amazon_managed_kafka_event_source_config.consumer_group_id must be between 1 and 200 characters."
  }
}

variable "batch_size" {
  description = "Largest number of records that Lambda will retrieve from your event source at the time of invocation"
  type        = number
  default     = null
}

variable "bisect_batch_on_function_error" {
  description = "Whether to split the batch in two and retry if the function returns an error"
  type        = bool
  default     = false
}

variable "destination_config" {
  description = "Destination for failed records"
  type = object({
    on_failure = optional(object({
      destination_arn = string
    }))
  })
  default = null
}

variable "document_db_event_source_config" {
  description = "Configuration settings for a DocumentDB event source"
  type = object({
    collection_name = optional(string)
    database_name   = string
    full_document   = optional(string)
  })
  default = null

  validation {
    condition = var.document_db_event_source_config == null || (
      var.document_db_event_source_config.full_document == null ||
      contains(["UpdateLookup", "Default"], var.document_db_event_source_config.full_document)
    )
    error_message = "resource_aws_lambda_event_source_mapping, document_db_event_source_config.full_document must be either 'UpdateLookup' or 'Default'."
  }
}

variable "enabled" {
  description = "Whether the mapping is enabled"
  type        = bool
  default     = true
}

variable "event_source_arn" {
  description = "Event source ARN - required for Kinesis stream, DynamoDB stream, SQS queue, MQ broker, MSK cluster or DocumentDB change stream"
  type        = string
  default     = null
}

variable "filter_criteria" {
  description = "Criteria to use for event filtering"
  type = object({
    filter = optional(list(object({
      pattern = optional(string)
    })))
  })
  default = null

  validation {
    condition = var.filter_criteria == null || (
      var.filter_criteria.filter == null ||
      length(var.filter_criteria.filter) <= 5
    )
    error_message = "resource_aws_lambda_event_source_mapping, filter_criteria.filter can contain at most 5 filters."
  }

  validation {
    condition = var.filter_criteria == null || (
      var.filter_criteria.filter == null ||
      alltrue([
        for f in var.filter_criteria.filter : f.pattern == null || length(f.pattern) <= 4096
      ])
    )
    error_message = "resource_aws_lambda_event_source_mapping, filter_criteria.filter.pattern must be up to 4096 characters."
  }
}

variable "function_response_types" {
  description = "List of current response type enums applied to the event source mapping"
  type        = list(string)
  default     = null

  validation {
    condition = var.function_response_types == null || (
      alltrue([
        for type in var.function_response_types : contains(["ReportBatchItemFailures"], type)
      ])
    )
    error_message = "resource_aws_lambda_event_source_mapping, function_response_types must contain only 'ReportBatchItemFailures'."
  }
}

variable "kms_key_arn" {
  description = "ARN of the KMS customer managed key that Lambda uses to encrypt your function's filter criteria"
  type        = string
  default     = null
}

variable "maximum_batching_window_in_seconds" {
  description = "Maximum amount of time to gather records before invoking the function, in seconds (between 0 and 300)"
  type        = number
  default     = null

  validation {
    condition = var.maximum_batching_window_in_seconds == null || (
      var.maximum_batching_window_in_seconds >= 0 && var.maximum_batching_window_in_seconds <= 300
    )
    error_message = "resource_aws_lambda_event_source_mapping, maximum_batching_window_in_seconds must be between 0 and 300."
  }
}

variable "maximum_record_age_in_seconds" {
  description = "Maximum age of a record that Lambda sends to a function for processing"
  type        = number
  default     = null

  validation {
    condition = var.maximum_record_age_in_seconds == null || (
      var.maximum_record_age_in_seconds == -1 ||
      (var.maximum_record_age_in_seconds >= 60 && var.maximum_record_age_in_seconds <= 604800)
    )
    error_message = "resource_aws_lambda_event_source_mapping, maximum_record_age_in_seconds must be either -1 or between 60 and 604800."
  }
}

variable "maximum_retry_attempts" {
  description = "Maximum number of times to retry when the function returns an error"
  type        = number
  default     = null

  validation {
    condition = var.maximum_retry_attempts == null || (
      var.maximum_retry_attempts >= -1 && var.maximum_retry_attempts <= 10000
    )
    error_message = "resource_aws_lambda_event_source_mapping, maximum_retry_attempts must be between -1 and 10000."
  }
}

variable "metrics_config" {
  description = "CloudWatch metrics configuration of the event source"
  type = object({
    metrics = list(string)
  })
  default = null

  validation {
    condition = var.metrics_config == null || (
      alltrue([
        for metric in var.metrics_config.metrics : contains(["EventCount"], metric)
      ])
    )
    error_message = "resource_aws_lambda_event_source_mapping, metrics_config.metrics must contain only 'EventCount'."
  }
}

variable "parallelization_factor" {
  description = "Number of batches to process from each shard concurrently"
  type        = number
  default     = null

  validation {
    condition = var.parallelization_factor == null || (
      var.parallelization_factor >= 1 && var.parallelization_factor <= 10
    )
    error_message = "resource_aws_lambda_event_source_mapping, parallelization_factor must be between 1 and 10."
  }
}

variable "provisioned_poller_config" {
  description = "Event poller configuration for the event source"
  type = object({
    maximum_pollers = optional(number)
    minimum_pollers = optional(number)
  })
  default = null

  validation {
    condition = var.provisioned_poller_config == null || (
      var.provisioned_poller_config.maximum_pollers == null ||
      (var.provisioned_poller_config.maximum_pollers >= 1 && var.provisioned_poller_config.maximum_pollers <= 2000)
    )
    error_message = "resource_aws_lambda_event_source_mapping, provisioned_poller_config.maximum_pollers must be between 1 and 2000."
  }

  validation {
    condition = var.provisioned_poller_config == null || (
      var.provisioned_poller_config.minimum_pollers == null ||
      (var.provisioned_poller_config.minimum_pollers >= 1 && var.provisioned_poller_config.minimum_pollers <= 200)
    )
    error_message = "resource_aws_lambda_event_source_mapping, provisioned_poller_config.minimum_pollers must be between 1 and 200."
  }
}

variable "queues" {
  description = "Name of the Amazon MQ broker destination queue to consume"
  type        = list(string)
  default     = null

  validation {
    condition     = var.queues == null || length(var.queues) == 1
    error_message = "resource_aws_lambda_event_source_mapping, queues must contain exactly one queue name."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "scaling_config" {
  description = "Scaling configuration of the event source"
  type = object({
    maximum_concurrency = optional(number)
  })
  default = null

  validation {
    condition = var.scaling_config == null || (
      var.scaling_config.maximum_concurrency == null ||
      var.scaling_config.maximum_concurrency >= 2
    )
    error_message = "resource_aws_lambda_event_source_mapping, scaling_config.maximum_concurrency must be greater than or equal to 2."
  }
}

variable "self_managed_event_source" {
  description = "For Self Managed Kafka sources, the location of the self managed cluster"
  type = object({
    endpoints = map(string)
  })
  default = null
}

variable "self_managed_kafka_event_source_config" {
  description = "Additional configuration block for Self Managed Kafka sources"
  type = object({
    consumer_group_id = optional(string)
  })
  default = null

  validation {
    condition = var.self_managed_kafka_event_source_config == null || (
      var.self_managed_kafka_event_source_config.consumer_group_id == null ||
      (length(var.self_managed_kafka_event_source_config.consumer_group_id) >= 1 &&
      length(var.self_managed_kafka_event_source_config.consumer_group_id) <= 200)
    )
    error_message = "resource_aws_lambda_event_source_mapping, self_managed_kafka_event_source_config.consumer_group_id must be between 1 and 200 characters."
  }
}

variable "source_access_configuration" {
  description = "For Self Managed Kafka sources, the access configuration for the source"
  type = list(object({
    type = string
    uri  = string
  }))
  default = null
}

variable "starting_position" {
  description = "Position in the stream where AWS Lambda should start reading"
  type        = string
  default     = null

  validation {
    condition = var.starting_position == null || (
      contains(["AT_TIMESTAMP", "LATEST", "TRIM_HORIZON"], var.starting_position)
    )
    error_message = "resource_aws_lambda_event_source_mapping, starting_position must be one of 'AT_TIMESTAMP', 'LATEST', or 'TRIM_HORIZON'."
  }
}

variable "starting_position_timestamp" {
  description = "Timestamp in RFC3339 format of the data record which to start reading when using starting_position set to AT_TIMESTAMP"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the object"
  type        = map(string)
  default     = null
}

variable "topics" {
  description = "Name of the Kafka topics"
  type        = list(string)
  default     = null
}

variable "tumbling_window_in_seconds" {
  description = "Duration in seconds of a processing window for AWS Lambda streaming analytics"
  type        = number
  default     = null

  validation {
    condition = var.tumbling_window_in_seconds == null || (
      var.tumbling_window_in_seconds >= 1 && var.tumbling_window_in_seconds <= 900
    )
    error_message = "resource_aws_lambda_event_source_mapping, tumbling_window_in_seconds must be between 1 and 900 seconds."
  }
}