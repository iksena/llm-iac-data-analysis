variable "name" {
  description = "The unique name to identify this real-time log configuration"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cloudfront_realtime_log_config, name must not be empty."
  }
}

variable "sampling_rate" {
  description = "The sampling rate for this real-time log configuration. The sampling rate determines the percentage of viewer requests that are represented in the real-time log data. An integer between 1 and 100, inclusive"
  type        = number

  validation {
    condition     = var.sampling_rate >= 1 && var.sampling_rate <= 100
    error_message = "resource_aws_cloudfront_realtime_log_config, sampling_rate must be an integer between 1 and 100, inclusive."
  }
}

variable "fields" {
  description = "The fields that are included in each real-time log record"
  type        = list(string)

  validation {
    condition     = length(var.fields) > 0
    error_message = "resource_aws_cloudfront_realtime_log_config, fields must contain at least one field."
  }
}

variable "endpoint_stream_type" {
  description = "The type of data stream where real-time log data is sent. The only valid value is Kinesis"
  type        = string

  validation {
    condition     = var.endpoint_stream_type == "Kinesis"
    error_message = "resource_aws_cloudfront_realtime_log_config, endpoint_stream_type must be 'Kinesis'."
  }
}

variable "kinesis_stream_config_role_arn" {
  description = "The ARN of an IAM role that CloudFront can use to send real-time log data to the Kinesis data stream"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.kinesis_stream_config_role_arn))
    error_message = "resource_aws_cloudfront_realtime_log_config, kinesis_stream_config_role_arn must be a valid IAM role ARN."
  }
}

variable "kinesis_stream_config_stream_arn" {
  description = "The ARN of the Kinesis data stream"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kinesis:", var.kinesis_stream_config_stream_arn))
    error_message = "resource_aws_cloudfront_realtime_log_config, kinesis_stream_config_stream_arn must be a valid Kinesis stream ARN."
  }
}