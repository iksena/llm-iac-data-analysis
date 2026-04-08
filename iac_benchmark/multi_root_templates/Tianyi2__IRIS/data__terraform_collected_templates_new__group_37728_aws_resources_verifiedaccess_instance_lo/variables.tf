variable "verifiedaccess_instance_id" {
  description = "The ID of the Verified Access instance"
  type        = string

  validation {
    condition     = can(regex("^vai-[0-9a-f]+$", var.verifiedaccess_instance_id))
    error_message = "resource_aws_verifiedaccess_instance_logging_configuration, verifiedaccess_instance_id must be a valid Verified Access instance ID starting with 'vai-'."
  }
}

variable "include_trust_context" {
  description = "Include trust data sent by trust providers into the logs"
  type        = bool
  default     = null
}

variable "log_version" {
  description = "The logging version to use"
  type        = string
  default     = null
}

variable "cloudwatch_logs" {
  description = "Configuration for sending Verified Access logs to CloudWatch Logs"
  type = object({
    enabled   = bool
    log_group = optional(string)
  })
  default = null

  validation {
    condition     = var.cloudwatch_logs == null || var.cloudwatch_logs.enabled != null
    error_message = "resource_aws_verifiedaccess_instance_logging_configuration, cloudwatch_logs enabled field is required when cloudwatch_logs is specified."
  }
}

variable "kinesis_data_firehose" {
  description = "Configuration for sending Verified Access logs to Kinesis Data Firehose"
  type = object({
    enabled         = bool
    delivery_stream = optional(string)
  })
  default = null

  validation {
    condition     = var.kinesis_data_firehose == null || var.kinesis_data_firehose.enabled != null
    error_message = "resource_aws_verifiedaccess_instance_logging_configuration, kinesis_data_firehose enabled field is required when kinesis_data_firehose is specified."
  }
}

variable "s3" {
  description = "Configuration for sending Verified Access logs to S3"
  type = object({
    enabled      = bool
    bucket_name  = optional(string)
    bucket_owner = optional(string)
    prefix       = optional(string)
  })
  default = null

  validation {
    condition     = var.s3 == null || var.s3.enabled != null
    error_message = "resource_aws_verifiedaccess_instance_logging_configuration, s3 enabled field is required when s3 is specified."
  }
}