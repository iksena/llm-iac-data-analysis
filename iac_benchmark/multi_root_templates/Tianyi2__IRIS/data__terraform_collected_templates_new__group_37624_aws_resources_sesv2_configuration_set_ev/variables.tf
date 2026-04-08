variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "configuration_set_name" {
  description = "The name of the configuration set."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.configuration_set_name))
    error_message = "resource_aws_sesv2_configuration_set_event_destination, configuration_set_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "event_destination_name" {
  description = "A name that identifies the event destination within the configuration set."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.event_destination_name))
    error_message = "resource_aws_sesv2_configuration_set_event_destination, event_destination_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "event_destination" {
  description = "An object that defines the event destination."
  type = object({
    matching_event_types = list(string)
    enabled              = optional(bool, false)
    cloud_watch_destination = optional(object({
      dimension_configuration = list(object({
        default_dimension_value = string
        dimension_name          = string
        dimension_value_source  = string
      }))
    }))
    event_bridge_destination = optional(object({
      event_bus_arn = string
    }))
    kinesis_firehose_destination = optional(object({
      delivery_stream_arn = string
      iam_role_arn        = string
    }))
    pinpoint_destination = optional(object({
      application_arn = string
    }))
    sns_destination = optional(object({
      topic_arn = string
    }))
  })

  validation {
    condition = alltrue([
      for event_type in var.event_destination.matching_event_types :
      contains(["SEND", "REJECT", "BOUNCE", "COMPLAINT", "DELIVERY", "OPEN", "CLICK", "RENDERING_FAILURE", "DELIVERY_DELAY", "SUBSCRIPTION"], event_type)
    ])
    error_message = "resource_aws_sesv2_configuration_set_event_destination, matching_event_types must contain only valid values: SEND, REJECT, BOUNCE, COMPLAINT, DELIVERY, OPEN, CLICK, RENDERING_FAILURE, DELIVERY_DELAY, SUBSCRIPTION."
  }

  validation {
    condition     = length(var.event_destination.matching_event_types) > 0
    error_message = "resource_aws_sesv2_configuration_set_event_destination, matching_event_types must contain at least one event type."
  }

  validation {
    condition = var.event_destination.cloud_watch_destination != null ? (
      var.event_destination.cloud_watch_destination.dimension_configuration != null &&
      length(var.event_destination.cloud_watch_destination.dimension_configuration) > 0
    ) : true
    error_message = "resource_aws_sesv2_configuration_set_event_destination, cloud_watch_destination dimension_configuration is required and must contain at least one configuration."
  }

  validation {
    condition = var.event_destination.cloud_watch_destination != null ? alltrue([
      for dim in var.event_destination.cloud_watch_destination.dimension_configuration :
      contains(["MESSAGE_TAG", "EMAIL_HEADER", "LINK_TAG"], dim.dimension_value_source)
    ]) : true
    error_message = "resource_aws_sesv2_configuration_set_event_destination, dimension_value_source must be one of: MESSAGE_TAG, EMAIL_HEADER, LINK_TAG."
  }

  validation {
    condition = var.event_destination.event_bridge_destination != null ? (
      can(regex("^arn:aws[a-zA-Z-]*:events:[a-z0-9-]+:[0-9]{12}:event-bus/", var.event_destination.event_bridge_destination.event_bus_arn))
    ) : true
    error_message = "resource_aws_sesv2_configuration_set_event_destination, event_bus_arn must be a valid EventBridge event bus ARN."
  }

  validation {
    condition = var.event_destination.kinesis_firehose_destination != null ? (
      can(regex("^arn:aws[a-zA-Z-]*:firehose:[a-z0-9-]+:[0-9]{12}:deliverystream/", var.event_destination.kinesis_firehose_destination.delivery_stream_arn))
    ) : true
    error_message = "resource_aws_sesv2_configuration_set_event_destination, delivery_stream_arn must be a valid Kinesis Firehose delivery stream ARN."
  }

  validation {
    condition = var.event_destination.kinesis_firehose_destination != null ? (
      can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.event_destination.kinesis_firehose_destination.iam_role_arn))
    ) : true
    error_message = "resource_aws_sesv2_configuration_set_event_destination, iam_role_arn must be a valid IAM role ARN."
  }

  validation {
    condition = var.event_destination.pinpoint_destination != null ? (
      can(regex("^arn:aws[a-zA-Z-]*:mobiletargeting:[a-z0-9-]+:[0-9]{12}:app/", var.event_destination.pinpoint_destination.application_arn))
    ) : true
    error_message = "resource_aws_sesv2_configuration_set_event_destination, application_arn must be a valid Pinpoint application ARN."
  }

  validation {
    condition = var.event_destination.sns_destination != null ? (
      can(regex("^arn:aws[a-zA-Z-]*:sns:[a-z0-9-]+:[0-9]{12}:", var.event_destination.sns_destination.topic_arn))
    ) : true
    error_message = "resource_aws_sesv2_configuration_set_event_destination, topic_arn must be a valid SNS topic ARN."
  }
}