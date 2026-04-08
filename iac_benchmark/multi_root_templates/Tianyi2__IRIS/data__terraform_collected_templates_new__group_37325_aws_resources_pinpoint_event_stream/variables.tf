variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_id" {
  description = "The application ID."
  type        = string

  validation {
    condition     = var.application_id != null && var.application_id != ""
    error_message = "resource_aws_pinpoint_event_stream, application_id must be a non-empty string."
  }
}

variable "destination_stream_arn" {
  description = "The Amazon Resource Name (ARN) of the Amazon Kinesis stream or Firehose delivery stream to which you want to publish events."
  type        = string

  validation {
    condition     = var.destination_stream_arn != null && var.destination_stream_arn != ""
    error_message = "resource_aws_pinpoint_event_stream, destination_stream_arn must be a non-empty string."
  }

  validation {
    condition     = can(regex("^arn:aws:(kinesis|firehose):", var.destination_stream_arn))
    error_message = "resource_aws_pinpoint_event_stream, destination_stream_arn must be a valid ARN for a Kinesis stream or Firehose delivery stream."
  }
}

variable "role_arn" {
  description = "The IAM role that authorizes Amazon Pinpoint to publish events to the stream in your account."
  type        = string

  validation {
    condition     = var.role_arn != null && var.role_arn != ""
    error_message = "resource_aws_pinpoint_event_stream, role_arn must be a non-empty string."
  }

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_pinpoint_event_stream, role_arn must be a valid IAM role ARN."
  }
}