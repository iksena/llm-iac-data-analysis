variable "user_pool_id" {
  description = "The ID of the user pool for which to configure log delivery"
  type        = string

  validation {
    condition     = can(regex("^[\\w-]+_[0-9a-zA-Z]+$", var.user_pool_id))
    error_message = "resource_aws_cognito_log_delivery_configuration, user_pool_id must be a valid user pool ID format."
  }
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_cognito_log_delivery_configuration, region must be a valid AWS region format."
  }
}

variable "log_configurations" {
  description = "Configuration block for log delivery. At least one configuration block is required"
  type = list(object({
    event_source = string
    log_level    = string
    cloud_watch_logs_configuration = optional(object({
      log_group_arn = optional(string)
    }))
    firehose_configuration = optional(object({
      stream_arn = optional(string)
    }))
    s3_configuration = optional(object({
      bucket_arn = optional(string)
    }))
  }))
  default = []

  validation {
    condition     = length(var.log_configurations) > 0
    error_message = "resource_aws_cognito_log_delivery_configuration, log_configurations must contain at least one configuration block."
  }

  validation {
    condition = alltrue([
      for config in var.log_configurations :
      contains(["userNotification", "userAuthEvents"], config.event_source)
    ])
    error_message = "resource_aws_cognito_log_delivery_configuration, event_source must be one of: userNotification, userAuthEvents."
  }

  validation {
    condition = alltrue([
      for config in var.log_configurations :
      contains(["ERROR", "INFO"], config.log_level)
    ])
    error_message = "resource_aws_cognito_log_delivery_configuration, log_level must be one of: ERROR, INFO."
  }

  validation {
    condition = alltrue([
      for config in var.log_configurations :
      (config.cloud_watch_logs_configuration != null ? 1 : 0) +
      (config.firehose_configuration != null ? 1 : 0) +
      (config.s3_configuration != null ? 1 : 0) >= 1
    ])
    error_message = "resource_aws_cognito_log_delivery_configuration, log_configurations must specify at least one destination configuration (cloud_watch_logs_configuration, firehose_configuration, or s3_configuration)."
  }

  validation {
    condition = alltrue([
      for config in var.log_configurations :
      config.cloud_watch_logs_configuration == null || (
        config.cloud_watch_logs_configuration.log_group_arn == null ||
        can(regex("^arn:aws[a-zA-Z-]*:logs:[a-z0-9-]+:[0-9]{12}:log-group:", config.cloud_watch_logs_configuration.log_group_arn))
      )
    ])
    error_message = "resource_aws_cognito_log_delivery_configuration, log_group_arn must be a valid CloudWatch Logs log group ARN."
  }

  validation {
    condition = alltrue([
      for config in var.log_configurations :
      config.firehose_configuration == null || (
        config.firehose_configuration.stream_arn == null ||
        can(regex("^arn:aws[a-zA-Z-]*:firehose:[a-z0-9-]+:[0-9]{12}:deliverystream/", config.firehose_configuration.stream_arn))
      )
    ])
    error_message = "resource_aws_cognito_log_delivery_configuration, stream_arn must be a valid Kinesis Data Firehose delivery stream ARN."
  }

  validation {
    condition = alltrue([
      for config in var.log_configurations :
      config.s3_configuration == null || (
        config.s3_configuration.bucket_arn == null ||
        can(regex("^arn:aws[a-zA-Z-]*:s3:::", config.s3_configuration.bucket_arn))
      )
    ])
    error_message = "resource_aws_cognito_log_delivery_configuration, bucket_arn must be a valid S3 bucket ARN."
  }
}