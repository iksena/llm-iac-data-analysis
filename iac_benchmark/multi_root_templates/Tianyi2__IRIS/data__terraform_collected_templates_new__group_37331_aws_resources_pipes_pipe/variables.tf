variable "role_arn" {
  description = "ARN of the role that allows the pipe to send data to the target"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::\\d{12}:role/.+$", var.role_arn))
    error_message = "resource_aws_pipes_pipe, role_arn must be a valid IAM role ARN."
  }
}

variable "source_arn" {
  description = "Source resource of the pipe. This field typically requires an ARN. However, when using a self-managed Kafka cluster, use 'smk://' followed by the bootstrap server's address"
  type        = string

  validation {
    condition     = can(regex("^(arn:aws[a-zA-Z-]*:|smk://)", var.source_arn))
    error_message = "resource_aws_pipes_pipe, source_arn must be a valid ARN or start with 'smk://' for self-managed Kafka."
  }
}

variable "target" {
  description = "Target resource of the pipe (typically an ARN)"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:", var.target))
    error_message = "resource_aws_pipes_pipe, target must be a valid ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "description" {
  description = "A description of the pipe. At most 512 characters"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 512
    error_message = "resource_aws_pipes_pipe, description must be at most 512 characters."
  }
}

variable "desired_state" {
  description = "The state the pipe should be in. One of: RUNNING, STOPPED"
  type        = string
  default     = null

  validation {
    condition     = var.desired_state == null || contains(["RUNNING", "STOPPED"], var.desired_state)
    error_message = "resource_aws_pipes_pipe, desired_state must be one of: RUNNING, STOPPED."
  }
}

variable "enrichment" {
  description = "Enrichment resource of the pipe (typically an ARN)"
  type        = string
  default     = null

  validation {
    condition     = var.enrichment == null || can(regex("^arn:aws[a-zA-Z-]*:", var.enrichment))
    error_message = "resource_aws_pipes_pipe, enrichment must be a valid ARN."
  }
}

variable "enrichment_parameters" {
  description = "Parameters to configure enrichment for your pipe"
  type = object({
    input_template = optional(string)
    http_parameters = optional(object({
      header_parameters       = optional(map(string))
      path_parameter_values   = optional(list(string))
      query_string_parameters = optional(map(string))
    }))
  })
  default = null

  validation {
    condition = var.enrichment_parameters == null || (
      var.enrichment_parameters.input_template == null ||
      length(var.enrichment_parameters.input_template) <= 8192
    )
    error_message = "resource_aws_pipes_pipe, enrichment_parameters.input_template must be at most 8192 characters."
  }
}

variable "kms_key_identifier" {
  description = "Identifier of the AWS KMS customer managed key for EventBridge to use. Can be ARN, KeyId, key alias, or key alias ARN"
  type        = string
  default     = null
}

variable "log_configuration" {
  description = "Logging configuration settings for the pipe"
  type = object({
    level                  = string
    include_execution_data = optional(list(string))
    cloudwatch_logs_log_destination = optional(object({
      log_group_arn = string
    }))
    firehose_log_destination = optional(object({
      delivery_stream_arn = string
    }))
    s3_log_destination = optional(object({
      bucket_name   = string
      bucket_owner  = string
      output_format = optional(string)
      prefix        = optional(string)
    }))
  })
  default = null

  validation {
    condition     = var.log_configuration == null || contains(["OFF", "ERROR", "INFO", "TRACE"], var.log_configuration.level)
    error_message = "resource_aws_pipes_pipe, log_configuration.level must be one of: OFF, ERROR, INFO, TRACE."
  }

  validation {
    condition = var.log_configuration == null || (
      var.log_configuration.include_execution_data == null ||
      alltrue([for item in var.log_configuration.include_execution_data : item == "ALL"])
    )
    error_message = "resource_aws_pipes_pipe, log_configuration.include_execution_data values must be 'ALL'."
  }

  validation {
    condition = var.log_configuration == null || (
      var.log_configuration.s3_log_destination == null ||
      var.log_configuration.s3_log_destination.output_format == null ||
      contains(["json", "plain", "w3c"], var.log_configuration.s3_log_destination.output_format)
    )
    error_message = "resource_aws_pipes_pipe, log_configuration.s3_log_destination.output_format must be one of: json, plain, w3c."
  }

  validation {
    condition = var.log_configuration == null || (
      var.log_configuration.cloudwatch_logs_log_destination == null ||
      can(regex("^arn:aws[a-zA-Z-]*:logs:", var.log_configuration.cloudwatch_logs_log_destination.log_group_arn))
    )
    error_message = "resource_aws_pipes_pipe, log_configuration.cloudwatch_logs_log_destination.log_group_arn must be a valid CloudWatch log group ARN."
  }

  validation {
    condition = var.log_configuration == null || (
      var.log_configuration.firehose_log_destination == null ||
      can(regex("^arn:aws[a-zA-Z-]*:firehose:", var.log_configuration.firehose_log_destination.delivery_stream_arn))
    )
    error_message = "resource_aws_pipes_pipe, log_configuration.firehose_log_destination.delivery_stream_arn must be a valid Firehose delivery stream ARN."
  }
}

variable "name" {
  description = "Name of the pipe. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "source_parameters" {
  description = "Parameters to configure a source for the pipe"
  type = object({
    filter_criteria = optional(object({
      filter = optional(list(object({
        pattern = string
      })))
    }))
    activemq_broker_parameters = optional(object({
      batch_size                         = optional(number)
      maximum_batching_window_in_seconds = optional(number)
      queue_name                         = string
      credentials = object({
        basic_auth = string
      })
    }))
    dynamodb_stream_parameters = optional(object({
      batch_size                         = optional(number)
      maximum_batching_window_in_seconds = optional(number)
      maximum_record_age_in_seconds      = optional(number)
      maximum_retry_attempts             = optional(number)
      on_partial_batch_item_failure      = optional(string)
      parallelization_factor             = optional(number)
      starting_position                  = optional(string)
      dead_letter_config = optional(object({
        arn = optional(string)
      }))
    }))
    kinesis_stream_parameters = optional(object({
      batch_size                         = optional(number)
      maximum_batching_window_in_seconds = optional(number)
      maximum_record_age_in_seconds      = optional(number)
      maximum_retry_attempts             = optional(number)
      on_partial_batch_item_failure      = optional(string)
      parallelization_factor             = optional(number)
      starting_position                  = string
      starting_position_timestamp        = optional(string)
      dead_letter_config = optional(object({
        arn = optional(string)
      }))
    }))
    managed_streaming_kafka_parameters = optional(object({
      batch_size                         = optional(number)
      consumer_group_id                  = optional(string)
      maximum_batching_window_in_seconds = optional(number)
      starting_position                  = optional(string)
      topic_name                         = string
      credentials = optional(object({
        client_certificate_tls_auth = optional(string)
        sasl_scram_512_auth         = optional(string)
      }))
    }))
    rabbitmq_broker_parameters = optional(object({
      batch_size                         = optional(number)
      maximum_batching_window_in_seconds = optional(number)
      queue_name                         = string
      virtual_host                       = optional(string)
      credentials = object({
        basic_auth = string
      })
    }))
    self_managed_kafka_parameters = optional(object({
      additional_bootstrap_servers       = optional(list(string))
      batch_size                         = optional(number)
      consumer_group_id                  = optional(string)
      maximum_batching_window_in_seconds = optional(number)
      server_root_ca_certificate         = optional(string)
      starting_position                  = optional(string)
      topic_name                         = string
      credentials = optional(object({
        basic_auth                  = optional(string)
        client_certificate_tls_auth = optional(string)
        sasl_scram_256_auth         = optional(string)
        sasl_scram_512_auth         = optional(string)
      }))
      vpc = optional(object({
        security_groups = optional(list(string))
        subnets         = optional(list(string))
      }))
    }))
    sqs_queue_parameters = optional(object({
      batch_size                         = optional(number)
      maximum_batching_window_in_seconds = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.filter_criteria == null ||
      var.source_parameters.filter_criteria.filter == null ||
      length(var.source_parameters.filter_criteria.filter) <= 5
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.filter_criteria.filter can have at most 5 event patterns."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.filter_criteria == null ||
      var.source_parameters.filter_criteria.filter == null ||
      alltrue([for f in var.source_parameters.filter_criteria.filter : length(f.pattern) <= 4096])
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.filter_criteria.filter.pattern must be at most 4096 characters."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.activemq_broker_parameters == null ||
      var.source_parameters.activemq_broker_parameters.batch_size == null ||
      var.source_parameters.activemq_broker_parameters.batch_size <= 10000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.activemq_broker_parameters.batch_size must be at most 10000."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.activemq_broker_parameters == null ||
      var.source_parameters.activemq_broker_parameters.maximum_batching_window_in_seconds == null ||
      var.source_parameters.activemq_broker_parameters.maximum_batching_window_in_seconds <= 300
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.activemq_broker_parameters.maximum_batching_window_in_seconds must be at most 300."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.activemq_broker_parameters == null ||
      length(var.source_parameters.activemq_broker_parameters.queue_name) <= 1000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.activemq_broker_parameters.queue_name must be at most 1000 characters."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.dynamodb_stream_parameters == null ||
      var.source_parameters.dynamodb_stream_parameters.batch_size == null ||
      var.source_parameters.dynamodb_stream_parameters.batch_size <= 10000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.dynamodb_stream_parameters.batch_size must be at most 10000."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.dynamodb_stream_parameters == null ||
      var.source_parameters.dynamodb_stream_parameters.maximum_batching_window_in_seconds == null ||
      var.source_parameters.dynamodb_stream_parameters.maximum_batching_window_in_seconds <= 300
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.dynamodb_stream_parameters.maximum_batching_window_in_seconds must be at most 300."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.dynamodb_stream_parameters == null ||
      var.source_parameters.dynamodb_stream_parameters.maximum_record_age_in_seconds == null ||
      var.source_parameters.dynamodb_stream_parameters.maximum_record_age_in_seconds <= 604800
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.dynamodb_stream_parameters.maximum_record_age_in_seconds must be at most 604800."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.dynamodb_stream_parameters == null ||
      var.source_parameters.dynamodb_stream_parameters.maximum_retry_attempts == null ||
      var.source_parameters.dynamodb_stream_parameters.maximum_retry_attempts <= 10000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.dynamodb_stream_parameters.maximum_retry_attempts must be at most 10000."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.dynamodb_stream_parameters == null ||
      var.source_parameters.dynamodb_stream_parameters.on_partial_batch_item_failure == null ||
      var.source_parameters.dynamodb_stream_parameters.on_partial_batch_item_failure == "AUTOMATIC_BISECT"
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.dynamodb_stream_parameters.on_partial_batch_item_failure must be AUTOMATIC_BISECT."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.dynamodb_stream_parameters == null ||
      var.source_parameters.dynamodb_stream_parameters.parallelization_factor == null ||
      var.source_parameters.dynamodb_stream_parameters.parallelization_factor <= 10
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.dynamodb_stream_parameters.parallelization_factor must be at most 10."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.dynamodb_stream_parameters == null ||
      var.source_parameters.dynamodb_stream_parameters.starting_position == null ||
      contains(["TRIM_HORIZON", "LATEST"], var.source_parameters.dynamodb_stream_parameters.starting_position)
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.dynamodb_stream_parameters.starting_position must be one of: TRIM_HORIZON, LATEST."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.kinesis_stream_parameters == null ||
      var.source_parameters.kinesis_stream_parameters.batch_size == null ||
      var.source_parameters.kinesis_stream_parameters.batch_size <= 10000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.kinesis_stream_parameters.batch_size must be at most 10000."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.kinesis_stream_parameters == null ||
      var.source_parameters.kinesis_stream_parameters.maximum_batching_window_in_seconds == null ||
      var.source_parameters.kinesis_stream_parameters.maximum_batching_window_in_seconds <= 300
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.kinesis_stream_parameters.maximum_batching_window_in_seconds must be at most 300."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.kinesis_stream_parameters == null ||
      var.source_parameters.kinesis_stream_parameters.maximum_record_age_in_seconds == null ||
      var.source_parameters.kinesis_stream_parameters.maximum_record_age_in_seconds <= 604800
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.kinesis_stream_parameters.maximum_record_age_in_seconds must be at most 604800."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.kinesis_stream_parameters == null ||
      var.source_parameters.kinesis_stream_parameters.maximum_retry_attempts == null ||
      var.source_parameters.kinesis_stream_parameters.maximum_retry_attempts <= 10000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.kinesis_stream_parameters.maximum_retry_attempts must be at most 10000."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.kinesis_stream_parameters == null ||
      var.source_parameters.kinesis_stream_parameters.on_partial_batch_item_failure == null ||
      var.source_parameters.kinesis_stream_parameters.on_partial_batch_item_failure == "AUTOMATIC_BISECT"
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.kinesis_stream_parameters.on_partial_batch_item_failure must be AUTOMATIC_BISECT."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.kinesis_stream_parameters == null ||
      var.source_parameters.kinesis_stream_parameters.parallelization_factor == null ||
      var.source_parameters.kinesis_stream_parameters.parallelization_factor <= 10
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.kinesis_stream_parameters.parallelization_factor must be at most 10."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.kinesis_stream_parameters == null ||
      contains(["TRIM_HORIZON", "LATEST", "AT_TIMESTAMP"], var.source_parameters.kinesis_stream_parameters.starting_position)
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.kinesis_stream_parameters.starting_position must be one of: TRIM_HORIZON, LATEST, AT_TIMESTAMP."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.managed_streaming_kafka_parameters == null ||
      var.source_parameters.managed_streaming_kafka_parameters.batch_size == null ||
      var.source_parameters.managed_streaming_kafka_parameters.batch_size <= 10000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.managed_streaming_kafka_parameters.batch_size must be at most 10000."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.managed_streaming_kafka_parameters == null ||
      var.source_parameters.managed_streaming_kafka_parameters.consumer_group_id == null ||
      length(var.source_parameters.managed_streaming_kafka_parameters.consumer_group_id) <= 200
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.managed_streaming_kafka_parameters.consumer_group_id must be at most 200 characters."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.managed_streaming_kafka_parameters == null ||
      var.source_parameters.managed_streaming_kafka_parameters.maximum_batching_window_in_seconds == null ||
      var.source_parameters.managed_streaming_kafka_parameters.maximum_batching_window_in_seconds <= 300
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.managed_streaming_kafka_parameters.maximum_batching_window_in_seconds must be at most 300."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.managed_streaming_kafka_parameters == null ||
      var.source_parameters.managed_streaming_kafka_parameters.starting_position == null ||
      contains(["TRIM_HORIZON", "LATEST"], var.source_parameters.managed_streaming_kafka_parameters.starting_position)
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.managed_streaming_kafka_parameters.starting_position must be one of: TRIM_HORIZON, LATEST."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.managed_streaming_kafka_parameters == null ||
      length(var.source_parameters.managed_streaming_kafka_parameters.topic_name) <= 249
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.managed_streaming_kafka_parameters.topic_name must be at most 249 characters."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.rabbitmq_broker_parameters == null ||
      var.source_parameters.rabbitmq_broker_parameters.batch_size == null ||
      var.source_parameters.rabbitmq_broker_parameters.batch_size <= 10000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.rabbitmq_broker_parameters.batch_size must be at most 10000."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.rabbitmq_broker_parameters == null ||
      var.source_parameters.rabbitmq_broker_parameters.maximum_batching_window_in_seconds == null ||
      var.source_parameters.rabbitmq_broker_parameters.maximum_batching_window_in_seconds <= 300
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.rabbitmq_broker_parameters.maximum_batching_window_in_seconds must be at most 300."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.rabbitmq_broker_parameters == null ||
      length(var.source_parameters.rabbitmq_broker_parameters.queue_name) <= 1000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.rabbitmq_broker_parameters.queue_name must be at most 1000 characters."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.rabbitmq_broker_parameters == null ||
      var.source_parameters.rabbitmq_broker_parameters.virtual_host == null ||
      length(var.source_parameters.rabbitmq_broker_parameters.virtual_host) <= 200
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.rabbitmq_broker_parameters.virtual_host must be at most 200 characters."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.self_managed_kafka_parameters == null ||
      var.source_parameters.self_managed_kafka_parameters.additional_bootstrap_servers == null ||
      length(var.source_parameters.self_managed_kafka_parameters.additional_bootstrap_servers) <= 2
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.self_managed_kafka_parameters.additional_bootstrap_servers can have at most 2 items."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.self_managed_kafka_parameters == null ||
      var.source_parameters.self_managed_kafka_parameters.additional_bootstrap_servers == null ||
      alltrue([for server in var.source_parameters.self_managed_kafka_parameters.additional_bootstrap_servers : length(server) <= 300])
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.self_managed_kafka_parameters.additional_bootstrap_servers items must be at most 300 characters each."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.self_managed_kafka_parameters == null ||
      var.source_parameters.self_managed_kafka_parameters.batch_size == null ||
      var.source_parameters.self_managed_kafka_parameters.batch_size <= 10000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.self_managed_kafka_parameters.batch_size must be at most 10000."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.self_managed_kafka_parameters == null ||
      var.source_parameters.self_managed_kafka_parameters.consumer_group_id == null ||
      length(var.source_parameters.self_managed_kafka_parameters.consumer_group_id) <= 200
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.self_managed_kafka_parameters.consumer_group_id must be at most 200 characters."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.self_managed_kafka_parameters == null ||
      var.source_parameters.self_managed_kafka_parameters.maximum_batching_window_in_seconds == null ||
      var.source_parameters.self_managed_kafka_parameters.maximum_batching_window_in_seconds <= 300
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.self_managed_kafka_parameters.maximum_batching_window_in_seconds must be at most 300."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.self_managed_kafka_parameters == null ||
      var.source_parameters.self_managed_kafka_parameters.starting_position == null ||
      contains(["TRIM_HORIZON", "LATEST"], var.source_parameters.self_managed_kafka_parameters.starting_position)
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.self_managed_kafka_parameters.starting_position must be one of: TRIM_HORIZON, LATEST."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.self_managed_kafka_parameters == null ||
      length(var.source_parameters.self_managed_kafka_parameters.topic_name) <= 249
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.self_managed_kafka_parameters.topic_name must be at most 249 characters."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.self_managed_kafka_parameters == null ||
      var.source_parameters.self_managed_kafka_parameters.vpc == null ||
      var.source_parameters.self_managed_kafka_parameters.vpc.security_groups == null ||
      length(var.source_parameters.self_managed_kafka_parameters.vpc.security_groups) <= 5
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.self_managed_kafka_parameters.vpc.security_groups can have at most 5 items."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.self_managed_kafka_parameters == null ||
      var.source_parameters.self_managed_kafka_parameters.vpc == null ||
      var.source_parameters.self_managed_kafka_parameters.vpc.subnets == null ||
      length(var.source_parameters.self_managed_kafka_parameters.vpc.subnets) <= 16
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.self_managed_kafka_parameters.vpc.subnets can have at most 16 items."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.sqs_queue_parameters == null ||
      var.source_parameters.sqs_queue_parameters.batch_size == null ||
      var.source_parameters.sqs_queue_parameters.batch_size <= 10000
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.sqs_queue_parameters.batch_size must be at most 10000."
  }

  validation {
    condition = var.source_parameters == null || (
      var.source_parameters.sqs_queue_parameters == null ||
      var.source_parameters.sqs_queue_parameters.maximum_batching_window_in_seconds == null ||
      var.source_parameters.sqs_queue_parameters.maximum_batching_window_in_seconds <= 300
    )
    error_message = "resource_aws_pipes_pipe, source_parameters.sqs_queue_parameters.maximum_batching_window_in_seconds must be at most 300."
  }
}

variable "target_parameters" {
  description = "Parameters to configure a target for your pipe"
  type = object({
    input_template = optional(string)
    batch_job_parameters = optional(object({
      job_definition = string
      job_name       = string
      array_properties = optional(object({
        size = optional(number)
      }))
      container_overrides = optional(object({
        command       = optional(list(string))
        instance_type = optional(string)
        environment = optional(list(object({
          name  = optional(string)
          value = optional(string)
        })))
        resource_requirement = optional(list(object({
          type  = optional(string)
          value = optional(string)
        })))
      }))
      depends_on = optional(list(object({
        job_id = optional(string)
        type   = optional(string)
      })))
      parameters = optional(map(string))
      retry_strategy = optional(object({
        attempts = optional(number)
      }))
    }))
    cloudwatch_logs_parameters = optional(object({
      log_stream_name = optional(string)
      timestamp       = optional(string)
    }))
    ecs_task_parameters = optional(object({
      task_definition_arn = optional(string)
      task_count          = optional(number)
      launch_type         = optional(string)
      network_configuration = optional(object({
        aws_vpc_configuration = optional(object({
          subnets          = optional(list(string))
          security_groups  = optional(list(string))
          assign_public_ip = optional(string)
        }))
      }))
      platform_version = optional(string)
      group            = optional(string)
      capacity_provider_strategy = optional(list(object({
        capacity_provider = optional(string)
        weight            = optional(number)
        base              = optional(number)
      })))
      enable_ecs_managed_tags = optional(bool)
      enable_execute_command  = optional(bool)
      placement_constraint = optional(list(object({
        type       = optional(string)
        expression = optional(string)
      })))
      placement_strategy = optional(list(object({
        type  = optional(string)
        field = optional(string)
      })))
      propagate_tags = optional(string)
      reference_id   = optional(string)
      tags           = optional(map(string))
      overrides = optional(object({
        container_override = optional(list(object({
          name               = optional(string)
          command            = optional(list(string))
          cpu                = optional(number)
          memory             = optional(number)
          memory_reservation = optional(number)
          environment = optional(list(object({
            name  = optional(string)
            value = optional(string)
          })))
          environment_file = optional(list(object({
            value = optional(string)
            type  = optional(string)
          })))
          resource_requirement = optional(list(object({
            value = optional(string)
            type  = optional(string)
          })))
        })))
        cpu                = optional(string)
        memory             = optional(string)
        task_role_arn      = optional(string)
        execution_role_arn = optional(string)
        ephemeral_storage = optional(object({
          size_in_gib = number
        }))
        inference_accelerator_override = optional(list(object({
          device_name = optional(string)
          device_type = optional(string)
        })))
      }))
    }))
    eventbridge_event_bus_parameters = optional(object({
      detail_type = optional(string)
      endpoint_id = optional(string)
      resources   = optional(list(string))
      source      = optional(string)
      time        = optional(string)
    }))
    http_parameters = optional(object({
      header_parameters       = optional(map(string))
      path_parameter_values   = optional(list(string))
      query_string_parameters = optional(map(string))
    }))
    kinesis_stream_parameters = optional(object({
      partition_key = string
    }))
    lambda_function_parameters = optional(object({
      invocation_type = optional(string)
    }))
    redshift_data_parameters = optional(object({
      database           = string
      db_user            = optional(string)
      secret_manager_arn = optional(string)
      sqls               = optional(list(string))
      statement_name     = optional(string)
      with_event         = optional(bool)
    }))
    sagemaker_pipeline_parameters = optional(object({
      pipeline_parameter = optional(list(object({
        name  = optional(string)
        value = optional(string)
      })))
    }))
    sqs_queue_parameters = optional(object({
      message_deduplication_id = optional(string)
      message_group_id         = optional(string)
    }))
    step_function_state_machine_parameters = optional(object({
      invocation_type = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.input_template == null ||
      length(var.target_parameters.input_template) <= 8192
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.input_template must be at most 8192 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.batch_job_parameters == null ||
      length(var.target_parameters.batch_job_parameters.job_name) <= 128
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.batch_job_parameters.job_name must be at most 128 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.batch_job_parameters == null ||
      var.target_parameters.batch_job_parameters.array_properties == null ||
      var.target_parameters.batch_job_parameters.array_properties.size == null ||
      (var.target_parameters.batch_job_parameters.array_properties.size >= 2 &&
      var.target_parameters.batch_job_parameters.array_properties.size <= 10000)
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.batch_job_parameters.array_properties.size must be between 2 and 10000."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.batch_job_parameters == null ||
      var.target_parameters.batch_job_parameters.depends_on == null ||
      length(var.target_parameters.batch_job_parameters.depends_on) <= 20
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.batch_job_parameters.depends_on can have at most 20 items."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.batch_job_parameters == null ||
      var.target_parameters.batch_job_parameters.depends_on == null ||
      alltrue([for dep in var.target_parameters.batch_job_parameters.depends_on :
      dep.type == null || contains(["N_TO_N", "SEQUENTIAL"], dep.type)])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.batch_job_parameters.depends_on.type must be one of: N_TO_N, SEQUENTIAL."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.batch_job_parameters == null ||
      var.target_parameters.batch_job_parameters.retry_strategy == null ||
      var.target_parameters.batch_job_parameters.retry_strategy.attempts == null ||
      var.target_parameters.batch_job_parameters.retry_strategy.attempts <= 10
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.batch_job_parameters.retry_strategy.attempts must be at most 10."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.batch_job_parameters == null ||
      var.target_parameters.batch_job_parameters.container_overrides == null ||
      var.target_parameters.batch_job_parameters.container_overrides.resource_requirement == null ||
      alltrue([for req in var.target_parameters.batch_job_parameters.container_overrides.resource_requirement :
      req.type == null || contains(["GPU", "MEMORY", "VCPU"], req.type)])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.batch_job_parameters.container_overrides.resource_requirement.type must be one of: GPU, MEMORY, VCPU."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.launch_type == null ||
      contains(["EC2", "FARGATE", "EXTERNAL"], var.target_parameters.ecs_task_parameters.launch_type)
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.launch_type must be one of: EC2, FARGATE, EXTERNAL."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.group == null ||
      length(var.target_parameters.ecs_task_parameters.group) <= 255
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.group must be at most 255 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.network_configuration == null ||
      var.target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration == null ||
      var.target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration.assign_public_ip == null ||
      contains(["ENABLED", "DISABLED"], var.target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration.assign_public_ip)
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration.assign_public_ip must be one of: ENABLED, DISABLED."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.network_configuration == null ||
      var.target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration == null ||
      var.target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration.security_groups == null ||
      length(var.target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration.security_groups) <= 5
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration.security_groups can have at most 5 items."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.network_configuration == null ||
      var.target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration == null ||
      var.target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration.subnets == null ||
      length(var.target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration.subnets) <= 16
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.network_configuration.aws_vpc_configuration.subnets can have at most 16 items."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.capacity_provider_strategy == null ||
      alltrue([for strategy in var.target_parameters.ecs_task_parameters.capacity_provider_strategy :
      strategy.base == null || strategy.base <= 100000])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.capacity_provider_strategy.base must be at most 100000."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.capacity_provider_strategy == null ||
      alltrue([for strategy in var.target_parameters.ecs_task_parameters.capacity_provider_strategy :
      strategy.capacity_provider == null || length(strategy.capacity_provider) <= 255])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.capacity_provider_strategy.capacity_provider must be at most 255 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.capacity_provider_strategy == null ||
      alltrue([for strategy in var.target_parameters.ecs_task_parameters.capacity_provider_strategy :
      strategy.weight == null || strategy.weight <= 1000])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.capacity_provider_strategy.weight must be at most 1000."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.placement_constraint == null ||
      length(var.target_parameters.ecs_task_parameters.placement_constraint) <= 10
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.placement_constraint can have at most 10 items."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.placement_constraint == null ||
      alltrue([for constraint in var.target_parameters.ecs_task_parameters.placement_constraint :
      constraint.type == null || contains(["distinctInstance", "memberOf"], constraint.type)])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.placement_constraint.type must be one of: distinctInstance, memberOf."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.placement_constraint == null ||
      alltrue([for constraint in var.target_parameters.ecs_task_parameters.placement_constraint :
      constraint.expression == null || length(constraint.expression) <= 2000])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.placement_constraint.expression must be at most 2000 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.placement_strategy == null ||
      length(var.target_parameters.ecs_task_parameters.placement_strategy) <= 5
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.placement_strategy can have at most 5 items."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.placement_strategy == null ||
      alltrue([for strategy in var.target_parameters.ecs_task_parameters.placement_strategy :
      strategy.type == null || contains(["random", "spread", "binpack"], strategy.type)])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.placement_strategy.type must be one of: random, spread, binpack."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.placement_strategy == null ||
      alltrue([for strategy in var.target_parameters.ecs_task_parameters.placement_strategy :
      strategy.field == null || length(strategy.field) <= 255])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.placement_strategy.field must be at most 255 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.propagate_tags == null ||
      var.target_parameters.ecs_task_parameters.propagate_tags == "TASK_DEFINITION"
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.propagate_tags must be TASK_DEFINITION."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.reference_id == null ||
      length(var.target_parameters.ecs_task_parameters.reference_id) <= 1024
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.reference_id must be at most 1024 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.overrides == null ||
      var.target_parameters.ecs_task_parameters.overrides.ephemeral_storage == null ||
      var.target_parameters.ecs_task_parameters.overrides.ephemeral_storage.size_in_gib >= 21 &&
      var.target_parameters.ecs_task_parameters.overrides.ephemeral_storage.size_in_gib <= 200
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.overrides.ephemeral_storage.size_in_gib must be between 21 and 200."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.overrides == null ||
      var.target_parameters.ecs_task_parameters.overrides.container_override == null ||
      alltrue([for override in var.target_parameters.ecs_task_parameters.overrides.container_override :
        override.environment_file == null ||
      alltrue([for file in override.environment_file : file.type == null || file.type == "s3"])])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.overrides.container_override.environment_file.type must be s3."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.ecs_task_parameters == null ||
      var.target_parameters.ecs_task_parameters.overrides == null ||
      var.target_parameters.ecs_task_parameters.overrides.container_override == null ||
      alltrue([for override in var.target_parameters.ecs_task_parameters.overrides.container_override :
        override.resource_requirement == null ||
        alltrue([for req in override.resource_requirement :
      req.type == null || contains(["GPU", "InferenceAccelerator"], req.type)])])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.ecs_task_parameters.overrides.container_override.resource_requirement.type must be one of: GPU, InferenceAccelerator."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.eventbridge_event_bus_parameters == null ||
      var.target_parameters.eventbridge_event_bus_parameters.detail_type == null ||
      length(var.target_parameters.eventbridge_event_bus_parameters.detail_type) <= 128
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.eventbridge_event_bus_parameters.detail_type must be at most 128 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.eventbridge_event_bus_parameters == null ||
      var.target_parameters.eventbridge_event_bus_parameters.source == null ||
      length(var.target_parameters.eventbridge_event_bus_parameters.source) <= 256
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.eventbridge_event_bus_parameters.source must be at most 256 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.lambda_function_parameters == null ||
      var.target_parameters.lambda_function_parameters.invocation_type == null ||
      contains(["REQUEST_RESPONSE", "FIRE_AND_FORGET"], var.target_parameters.lambda_function_parameters.invocation_type)
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.lambda_function_parameters.invocation_type must be one of: REQUEST_RESPONSE, FIRE_AND_FORGET."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.redshift_data_parameters == null ||
      var.target_parameters.redshift_data_parameters.sqls == null ||
      alltrue([for sql in var.target_parameters.redshift_data_parameters.sqls : length(sql) <= 100000])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.redshift_data_parameters.sqls items must be at most 100000 characters each."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.sagemaker_pipeline_parameters == null ||
      var.target_parameters.sagemaker_pipeline_parameters.pipeline_parameter == null ||
      alltrue([for param in var.target_parameters.sagemaker_pipeline_parameters.pipeline_parameter :
      param.name == null || length(param.name) <= 256])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.sagemaker_pipeline_parameters.pipeline_parameter.name must be at most 256 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.sagemaker_pipeline_parameters == null ||
      var.target_parameters.sagemaker_pipeline_parameters.pipeline_parameter == null ||
      alltrue([for param in var.target_parameters.sagemaker_pipeline_parameters.pipeline_parameter :
      param.value == null || length(param.value) <= 1024])
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.sagemaker_pipeline_parameters.pipeline_parameter.value must be at most 1024 characters."
  }

  validation {
    condition = var.target_parameters == null || (
      var.target_parameters.step_function_state_machine_parameters == null ||
      var.target_parameters.step_function_state_machine_parameters.invocation_type == null ||
      contains(["REQUEST_RESPONSE", "FIRE_AND_FORGET"], var.target_parameters.step_function_state_machine_parameters.invocation_type)
    )
    error_message = "resource_aws_pipes_pipe, target_parameters.step_function_state_machine_parameters.invocation_type must be one of: REQUEST_RESPONSE, FIRE_AND_FORGET."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}