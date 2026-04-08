variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "ARN of the stream consumer."
  type        = string
  default     = null

  validation {
    condition     = var.arn == null || can(regex("^arn:aws:kinesis:[^:]+:[0-9]{12}:stream/.+/consumer/.+$", var.arn))
    error_message = "data_aws_kinesis_stream_consumer, arn must be a valid Kinesis stream consumer ARN."
  }
}

variable "name" {
  description = "Name of the stream consumer."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9_.-]+$", var.name))
    error_message = "data_aws_kinesis_stream_consumer, name must contain only alphanumeric characters, hyphens, underscores, and periods."
  }
}

variable "stream_arn" {
  description = "ARN of the data stream the consumer is registered with."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kinesis:[^:]+:[0-9]{12}:stream/.+$", var.stream_arn))
    error_message = "data_aws_kinesis_stream_consumer, stream_arn must be a valid Kinesis stream ARN."
  }
}