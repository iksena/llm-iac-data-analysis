variable "destination_configuration" {
  description = "Object containing destination configuration for where chat activity will be logged. This object must contain exactly one of the following children arguments: cloudwatch_logs, firehose, or s3."
  type = object({
    cloudwatch_logs = optional(object({
      log_group_name = string
    }))
    firehose = optional(object({
      delivery_stream_name = string
    }))
    s3 = optional(object({
      bucket_name = string
    }))
  })

  validation {
    condition = var.destination_configuration != null && (
      (var.destination_configuration.cloudwatch_logs != null ? 1 : 0) +
      (var.destination_configuration.firehose != null ? 1 : 0) +
      (var.destination_configuration.s3 != null ? 1 : 0)
    ) == 1
    error_message = "resource_aws_ivschat_logging_configuration, destination_configuration must contain exactly one of the following: cloudwatch_logs, firehose, or s3."
  }

  validation {
    condition = var.destination_configuration == null || (
      var.destination_configuration.cloudwatch_logs == null ||
      var.destination_configuration.cloudwatch_logs.log_group_name != null
    )
    error_message = "resource_aws_ivschat_logging_configuration, log_group_name is required when cloudwatch_logs is specified in destination_configuration."
  }

  validation {
    condition = var.destination_configuration == null || (
      var.destination_configuration.firehose == null ||
      var.destination_configuration.firehose.delivery_stream_name != null
    )
    error_message = "resource_aws_ivschat_logging_configuration, delivery_stream_name is required when firehose is specified in destination_configuration."
  }

  validation {
    condition = var.destination_configuration == null || (
      var.destination_configuration.s3 == null ||
      var.destination_configuration.s3.bucket_name != null
    )
    error_message = "resource_aws_ivschat_logging_configuration, bucket_name is required when s3 is specified in destination_configuration."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Logging Configuration name."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}