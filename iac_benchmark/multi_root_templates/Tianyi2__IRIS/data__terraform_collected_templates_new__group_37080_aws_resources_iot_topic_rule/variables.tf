variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_iot_topic_rule, name must not be empty."
  }
}

variable "description" {
  description = "The description of the rule"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Specifies whether the rule is enabled"
  type        = bool
}

variable "sql" {
  description = "The SQL statement used to query the topic"
  type        = string

  validation {
    condition     = length(var.sql) > 0
    error_message = "resource_aws_iot_topic_rule, sql must not be empty."
  }
}

variable "sql_version" {
  description = "The version of the SQL rules engine to use when evaluating the rule"
  type        = string

  validation {
    condition     = length(var.sql_version) > 0
    error_message = "resource_aws_iot_topic_rule, sql_version must not be empty."
  }
}

variable "cloudwatch_alarm" {
  description = "CloudWatch alarm action configuration"
  type = list(object({
    alarm_name   = string
    role_arn     = string
    state_reason = string
    state_value  = string
  }))
  default = []

  validation {
    condition = alltrue([
      for alarm in var.cloudwatch_alarm : contains(["OK", "ALARM", "INSUFFICIENT_DATA"], alarm.state_value)
    ])
    error_message = "resource_aws_iot_topic_rule, cloudwatch_alarm state_value must be OK, ALARM, or INSUFFICIENT_DATA."
  }
}

variable "cloudwatch_logs" {
  description = "CloudWatch logs action configuration"
  type = list(object({
    batch_mode     = optional(bool)
    log_group_name = string
    role_arn       = string
  }))
  default = []
}

variable "cloudwatch_metric" {
  description = "CloudWatch metric action configuration"
  type = list(object({
    metric_name      = string
    metric_namespace = string
    metric_timestamp = optional(string)
    metric_unit      = string
    metric_value     = string
    role_arn         = string
  }))
  default = []
}

variable "dynamodb" {
  description = "DynamoDB action configuration"
  type = list(object({
    hash_key_field  = string
    hash_key_type   = optional(string, "STRING")
    hash_key_value  = string
    payload_field   = optional(string)
    range_key_field = optional(string)
    range_key_type  = optional(string)
    range_key_value = optional(string)
    operation       = optional(string)
    role_arn        = string
    table_name      = string
  }))
  default = []

  validation {
    condition = alltrue([
      for db in var.dynamodb : db.hash_key_type == null || contains(["STRING", "NUMBER"], db.hash_key_type)
    ])
    error_message = "resource_aws_iot_topic_rule, dynamodb hash_key_type must be STRING or NUMBER."
  }

  validation {
    condition = alltrue([
      for db in var.dynamodb : db.range_key_type == null || contains(["STRING", "NUMBER"], db.range_key_type)
    ])
    error_message = "resource_aws_iot_topic_rule, dynamodb range_key_type must be STRING or NUMBER."
  }

  validation {
    condition = alltrue([
      for db in var.dynamodb : db.operation == null || contains(["INSERT", "UPDATE", "DELETE"], db.operation)
    ])
    error_message = "resource_aws_iot_topic_rule, dynamodb operation must be INSERT, UPDATE, or DELETE."
  }
}

variable "dynamodbv2" {
  description = "DynamoDB v2 action configuration"
  type = list(object({
    put_item = object({
      table_name = string
    })
    role_arn = string
  }))
  default = []
}

variable "elasticsearch" {
  description = "Elasticsearch action configuration"
  type = list(object({
    endpoint = string
    id       = string
    index    = string
    role_arn = string
    type     = string
  }))
  default = []
}

variable "firehose" {
  description = "Kinesis Firehose action configuration"
  type = list(object({
    delivery_stream_name = string
    role_arn             = string
    separator            = optional(string)
    batch_mode           = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for fh in var.firehose : fh.separator == null || contains(["\\n", "\\t", "\\r\\n", ","], fh.separator)
    ])
    error_message = "resource_aws_iot_topic_rule, firehose separator must be \\n, \\t, \\r\\n, or ,."
  }
}

variable "http" {
  description = "HTTP action configuration"
  type = list(object({
    url              = string
    confirmation_url = optional(string)
    http_header = optional(list(object({
      key   = string
      value = string
    })), [])
  }))
  default = []
}

variable "iot_analytics" {
  description = "IoT Analytics action configuration"
  type = list(object({
    channel_name = string
    role_arn     = string
    batch_mode   = optional(bool)
  }))
  default = []
}

variable "iot_events" {
  description = "IoT Events action configuration"
  type = list(object({
    input_name = string
    role_arn   = string
    message_id = optional(string)
    batch_mode = optional(bool)
  }))
  default = []
}

variable "kafka" {
  description = "Kafka action configuration"
  type = list(object({
    client_properties = map(string)
    destination_arn   = string
    header = optional(list(object({
      key   = string
      value = string
    })), [])
    key       = optional(string)
    partition = optional(string)
    topic     = optional(string)
  }))
  default = []
}

variable "kinesis" {
  description = "Kinesis action configuration"
  type = list(object({
    partition_key = optional(string)
    role_arn      = string
    stream_name   = string
  }))
  default = []
}

variable "lambda" {
  description = "Lambda action configuration"
  type = list(object({
    function_arn = string
  }))
  default = []
}

variable "republish" {
  description = "Republish action configuration"
  type = list(object({
    role_arn = string
    topic    = string
    qos      = optional(number, 0)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.republish : contains([0, 1], r.qos)
    ])
    error_message = "resource_aws_iot_topic_rule, republish qos must be 0 or 1."
  }
}

variable "s3" {
  description = "S3 action configuration"
  type = list(object({
    bucket_name = string
    canned_acl  = optional(string)
    key         = string
    role_arn    = string
  }))
  default = []
}

variable "sns" {
  description = "SNS action configuration"
  type = list(object({
    message_format = string
    role_arn       = string
    target_arn     = string
  }))
  default = []

  validation {
    condition = alltrue([
      for sns in var.sns : contains(["JSON", "RAW"], sns.message_format)
    ])
    error_message = "resource_aws_iot_topic_rule, sns message_format must be JSON or RAW."
  }
}

variable "sqs" {
  description = "SQS action configuration"
  type = list(object({
    queue_url  = string
    role_arn   = string
    use_base64 = bool
  }))
  default = []
}

variable "step_functions" {
  description = "Step Functions action configuration"
  type = list(object({
    execution_name_prefix = optional(string)
    state_machine_name    = string
    role_arn              = string
  }))
  default = []
}

variable "timestream" {
  description = "Timestream action configuration"
  type = list(object({
    database_name = string
    dimension = list(object({
      name  = string
      value = string
    }))
    role_arn   = string
    table_name = string
    timestamp = optional(object({
      unit  = string
      value = string
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for ts in var.timestream : ts.timestamp == null || contains(["SECONDS", "MILLISECONDS", "MICROSECONDS", "NANOSECONDS"], ts.timestamp.unit)
    ])
    error_message = "resource_aws_iot_topic_rule, timestream timestamp unit must be SECONDS, MILLISECONDS, MICROSECONDS, or NANOSECONDS."
  }
}

variable "error_action" {
  description = "Error action configuration"
  type = object({
    cloudwatch_alarm = optional(list(object({
      alarm_name   = string
      role_arn     = string
      state_reason = string
      state_value  = string
    })), [])
    cloudwatch_logs = optional(list(object({
      batch_mode     = optional(bool)
      log_group_name = string
      role_arn       = string
    })), [])
    cloudwatch_metric = optional(list(object({
      metric_name      = string
      metric_namespace = string
      metric_timestamp = optional(string)
      metric_unit      = string
      metric_value     = string
      role_arn         = string
    })), [])
    dynamodb = optional(list(object({
      hash_key_field  = string
      hash_key_type   = optional(string, "STRING")
      hash_key_value  = string
      payload_field   = optional(string)
      range_key_field = optional(string)
      range_key_type  = optional(string)
      range_key_value = optional(string)
      operation       = optional(string)
      role_arn        = string
      table_name      = string
    })), [])
    dynamodbv2 = optional(list(object({
      put_item = object({
        table_name = string
      })
      role_arn = string
    })), [])
    elasticsearch = optional(list(object({
      endpoint = string
      id       = string
      index    = string
      role_arn = string
      type     = string
    })), [])
    firehose = optional(list(object({
      delivery_stream_name = string
      role_arn             = string
      separator            = optional(string)
      batch_mode           = optional(bool)
    })), [])
    http = optional(list(object({
      url              = string
      confirmation_url = optional(string)
      http_header = optional(list(object({
        key   = string
        value = string
      })), [])
    })), [])
    iot_analytics = optional(list(object({
      channel_name = string
      role_arn     = string
      batch_mode   = optional(bool)
    })), [])
    iot_events = optional(list(object({
      input_name = string
      role_arn   = string
      message_id = optional(string)
      batch_mode = optional(bool)
    })), [])
    kafka = optional(list(object({
      client_properties = map(string)
      destination_arn   = string
      header = optional(list(object({
        key   = string
        value = string
      })), [])
      key       = optional(string)
      partition = optional(string)
      topic     = optional(string)
    })), [])
    kinesis = optional(list(object({
      partition_key = optional(string)
      role_arn      = string
      stream_name   = string
    })), [])
    lambda = optional(list(object({
      function_arn = string
    })), [])
    republish = optional(list(object({
      role_arn = string
      topic    = string
      qos      = optional(number, 0)
    })), [])
    s3 = optional(list(object({
      bucket_name = string
      canned_acl  = optional(string)
      key         = string
      role_arn    = string
    })), [])
    sns = optional(list(object({
      message_format = string
      role_arn       = string
      target_arn     = string
    })), [])
    sqs = optional(list(object({
      queue_url  = string
      role_arn   = string
      use_base64 = bool
    })), [])
    step_functions = optional(list(object({
      execution_name_prefix = optional(string)
      state_machine_name    = string
      role_arn              = string
    })), [])
    timestream = optional(list(object({
      database_name = string
      dimension = list(object({
        name  = string
        value = string
      }))
      role_arn   = string
      table_name = string
      timestamp = optional(object({
        unit  = string
        value = string
      }))
    })), [])
  })
  default = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}