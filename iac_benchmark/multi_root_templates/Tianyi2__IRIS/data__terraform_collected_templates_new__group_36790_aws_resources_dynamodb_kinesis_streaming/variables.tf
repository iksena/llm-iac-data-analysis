variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "approximate_creation_date_time_precision" {
  description = "Toggle for the precision of Kinesis data stream timestamp. Valid values: MILLISECOND and MICROSECOND."
  type        = string
  default     = null

  validation {
    condition     = var.approximate_creation_date_time_precision == null || contains(["MILLISECOND", "MICROSECOND"], var.approximate_creation_date_time_precision)
    error_message = "resource_aws_dynamodb_kinesis_streaming_destination, approximate_creation_date_time_precision must be either 'MILLISECOND' or 'MICROSECOND'."
  }
}

variable "stream_arn" {
  description = "The ARN for a Kinesis data stream. This must exist in the same account and region as the DynamoDB table."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kinesis:", var.stream_arn))
    error_message = "resource_aws_dynamodb_kinesis_streaming_destination, stream_arn must be a valid Kinesis stream ARN."
  }
}

variable "table_name" {
  description = "The name of the DynamoDB table. There can only be one Kinesis streaming destination for a given DynamoDB table."
  type        = string

  validation {
    condition     = length(var.table_name) > 0
    error_message = "resource_aws_dynamodb_kinesis_streaming_destination, table_name cannot be empty."
  }
}