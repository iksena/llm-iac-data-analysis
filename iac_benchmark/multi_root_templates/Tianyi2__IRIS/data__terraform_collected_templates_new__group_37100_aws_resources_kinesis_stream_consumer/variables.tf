variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the stream consumer."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.name)) && length(var.name) >= 1 && length(var.name) <= 128
    error_message = "resource_aws_kinesis_stream_consumer, name must be between 1 and 128 characters and contain only alphanumeric characters, hyphens, underscores, and periods."
  }
}

variable "stream_arn" {
  description = "Amazon Resource Name (ARN) of the data stream the consumer is registered with."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kinesis:[a-z0-9-]+:[0-9]{12}:stream/.+$", var.stream_arn))
    error_message = "resource_aws_kinesis_stream_consumer, stream_arn must be a valid Kinesis stream ARN."
  }
}