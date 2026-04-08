variable "name" {
  description = "Name of the new event bus. The names of custom event buses can't contain the / character. To create a partner event bus, ensure that the name matches the event_source_name."
  type        = string

  validation {
    condition     = !can(regex("/", var.name))
    error_message = "resource_aws_cloudwatch_event_bus, name: The names of custom event buses can't contain the / character."
  }

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cloudwatch_event_bus, name: Event bus name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "dead_letter_config" {
  description = "Configuration details of the Amazon SQS queue for EventBridge to use as a dead-letter queue (DLQ)."
  type = object({
    arn = optional(string)
  })
  default = null

  validation {
    condition = var.dead_letter_config == null || (
      var.dead_letter_config.arn == null ||
      can(regex("^arn:aws:sqs:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9_-]+$", var.dead_letter_config.arn))
    )
    error_message = "resource_aws_cloudwatch_event_bus, dead_letter_config.arn: Must be a valid SQS queue ARN format."
  }
}

variable "description" {
  description = "Event bus description."
  type        = string
  default     = null

  validation {
    condition = var.description == null || (
      length(var.description) <= 512
    )
    error_message = "resource_aws_cloudwatch_event_bus, description: Description must be 512 characters or less."
  }
}

variable "event_source_name" {
  description = "Partner event source that the new event bus will be matched with. Must match name."
  type        = string
  default     = null

  validation {
    condition = var.event_source_name == null || (
      can(regex("^aws\\.partner\\/[a-zA-Z0-9\\._-]+\\/[a-zA-Z0-9\\._-]+$", var.event_source_name))
    )
    error_message = "resource_aws_cloudwatch_event_bus, event_source_name: Must be a valid partner event source name format (aws.partner/partner-name/source-name)."
  }
}

variable "kms_key_identifier" {
  description = "Identifier of the AWS KMS customer managed key for EventBridge to use, if you choose to use a customer managed key to encrypt events on this event bus. The identifier can be the key Amazon Resource Name (ARN), KeyId, key alias, or key alias ARN."
  type        = string
  default     = null

  validation {
    condition = var.kms_key_identifier == null || (
      can(regex("^(arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key\\/[a-f0-9-]{36}|[a-f0-9-]{36}|alias\\/[a-zA-Z0-9\\/_-]+|arn:aws:kms:[a-z0-9-]+:[0-9]{12}:alias\\/[a-zA-Z0-9\\/_-]+)$", var.kms_key_identifier))
    )
    error_message = "resource_aws_cloudwatch_event_bus, kms_key_identifier: Must be a valid KMS key identifier (ARN, KeyId, alias, or alias ARN)."
  }
}

variable "log_config" {
  description = "Block for logging configuration settings for the event bus."
  type = object({
    include_detail = optional(string, "NONE")
    level          = optional(string, "OFF")
  })
  default = null

  validation {
    condition = var.log_config == null || (
      var.log_config.include_detail == null ||
      contains(["NONE", "FULL"], var.log_config.include_detail)
    )
    error_message = "resource_aws_cloudwatch_event_bus, log_config.include_detail: Valid values are NONE and FULL."
  }

  validation {
    condition = var.log_config == null || (
      var.log_config.level == null ||
      contains(["OFF", "ERROR", "INFO", "TRACE"], var.log_config.level)
    )
    error_message = "resource_aws_cloudwatch_event_bus, log_config.level: Valid values are OFF, ERROR, INFO, and TRACE."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_cloudwatch_event_bus, tags: Tag keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_cloudwatch_event_bus, tags: Tag values must be between 0 and 256 characters."
  }
}