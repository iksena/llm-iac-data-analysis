variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "exclusive_end_time" {
  description = "The exclusive date and time that specifies when the stream ends. If you don't define this parameter, the stream runs indefinitely until you cancel it. It must be in ISO 8601 date and time format and in Universal Coordinated Time (UTC). For example: '2019-06-13T21:36:34Z'."
  type        = string
  default     = null

  validation {
    condition     = var.exclusive_end_time == null || can(formatdate("2006-01-02T15:04:05Z", var.exclusive_end_time))
    error_message = "resource_aws_qldb_stream, exclusive_end_time must be in ISO 8601 date and time format and in Universal Coordinated Time (UTC). For example: '2019-06-13T21:36:34Z'."
  }
}

variable "inclusive_start_time" {
  description = "The inclusive start date and time from which to start streaming journal data. This parameter must be in ISO 8601 date and time format and in Universal Coordinated Time (UTC). For example: '2019-06-13T21:36:34Z'. This cannot be in the future and must be before exclusive_end_time. If you provide a value that is before the ledger's CreationDateTime, QLDB effectively defaults it to the ledger's CreationDateTime."
  type        = string

  validation {
    condition     = can(formatdate("2006-01-02T15:04:05Z", var.inclusive_start_time))
    error_message = "resource_aws_qldb_stream, inclusive_start_time must be in ISO 8601 date and time format and in Universal Coordinated Time (UTC). For example: '2019-06-13T21:36:34Z'."
  }
}

variable "ledger_name" {
  description = "The name of the QLDB ledger."
  type        = string

  validation {
    condition     = length(var.ledger_name) > 0
    error_message = "resource_aws_qldb_stream, ledger_name must not be empty."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role that grants QLDB permissions for a journal stream to write data records to a Kinesis Data Streams resource."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_qldb_stream, role_arn must be a valid IAM role ARN."
  }
}

variable "stream_name" {
  description = "The name that you want to assign to the QLDB journal stream. User-defined names can help identify and indicate the purpose of a stream. Your stream name must be unique among other active streams for a given ledger. Stream names have the same naming constraints as ledger names, as defined in the Amazon QLDB Developer Guide."
  type        = string

  validation {
    condition     = length(var.stream_name) > 0
    error_message = "resource_aws_qldb_stream, stream_name must not be empty."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "kinesis_configuration" {
  description = "The configuration settings of the Kinesis Data Streams destination for your stream request."
  type = object({
    aggregation_enabled = optional(bool, true)
    stream_arn          = string
  })

  validation {
    condition     = var.kinesis_configuration.stream_arn != null && can(regex("^arn:aws:kinesis:", var.kinesis_configuration.stream_arn))
    error_message = "resource_aws_qldb_stream, kinesis_configuration.stream_arn must be a valid Kinesis Data Streams ARN."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the QLDB stream."
  type        = string
  default     = "8m"
}

variable "delete_timeout" {
  description = "Timeout for deleting the QLDB stream."
  type        = string
  default     = "5m"
}