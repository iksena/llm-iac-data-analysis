variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "firewall_arn" {
  description = "The Amazon Resource Name (ARN) of the Network Firewall firewall."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:network-firewall:", var.firewall_arn))
    error_message = "resource_aws_networkfirewall_logging_configuration, firewall_arn must be a valid Network Firewall ARN starting with 'arn:aws:network-firewall:'."
  }
}

variable "logging_configuration" {
  description = "A configuration block describing how AWS Network Firewall performs logging for a firewall."
  type = object({
    log_destination_config = set(object({
      log_destination      = map(string)
      log_destination_type = string
      log_type             = string
    }))
  })

  validation {
    condition = alltrue([
      for config in var.logging_configuration.log_destination_config : contains(["S3", "CloudWatchLogs", "KinesisDataFirehose"], config.log_destination_type)
    ])
    error_message = "resource_aws_networkfirewall_logging_configuration, log_destination_type must be one of: S3, CloudWatchLogs, KinesisDataFirehose."
  }

  validation {
    condition = alltrue([
      for config in var.logging_configuration.log_destination_config : contains(["ALERT", "FLOW", "TLS"], config.log_type)
    ])
    error_message = "resource_aws_networkfirewall_logging_configuration, log_type must be one of: ALERT, FLOW, TLS."
  }

  validation {
    condition     = length(var.logging_configuration.log_destination_config) <= 3
    error_message = "resource_aws_networkfirewall_logging_configuration, log_destination_config can have at most 3 blocks."
  }

  validation {
    condition = alltrue([
      for config in var.logging_configuration.log_destination_config : (
        config.log_destination_type == "S3" ? (
          contains(keys(config.log_destination), "bucketName")
          ) : config.log_destination_type == "CloudWatchLogs" ? (
          contains(keys(config.log_destination), "logGroup")
          ) : config.log_destination_type == "KinesisDataFirehose" ? (
          contains(keys(config.log_destination), "deliveryStream")
        ) : false
      )
    ])
    error_message = "resource_aws_networkfirewall_logging_configuration, log_destination must contain the correct key for the log_destination_type: 'bucketName' for S3, 'logGroup' for CloudWatchLogs, 'deliveryStream' for KinesisDataFirehose."
  }
}