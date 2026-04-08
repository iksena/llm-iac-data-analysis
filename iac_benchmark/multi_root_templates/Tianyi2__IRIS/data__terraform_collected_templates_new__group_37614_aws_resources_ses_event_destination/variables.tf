variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the event destination"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ses_event_destination, name must not be empty."
  }
}

variable "configuration_set_name" {
  description = "The name of the configuration set"
  type        = string

  validation {
    condition     = length(var.configuration_set_name) > 0
    error_message = "resource_aws_ses_event_destination, configuration_set_name must not be empty."
  }
}

variable "enabled" {
  description = "If true, the event destination will be enabled"
  type        = bool
  default     = null
}

variable "matching_types" {
  description = "A list of matching types"
  type        = list(string)

  validation {
    condition = alltrue([
      for type in var.matching_types : contains([
        "send", "reject", "bounce", "complaint", "delivery", "open", "click", "renderingFailure"
      ], type)
    ])
    error_message = "resource_aws_ses_event_destination, matching_types must contain valid event types: send, reject, bounce, complaint, delivery, open, click, or renderingFailure."
  }

  validation {
    condition     = length(var.matching_types) > 0
    error_message = "resource_aws_ses_event_destination, matching_types must not be empty."
  }
}

variable "cloudwatch_destination" {
  description = "CloudWatch destination for the events"
  type = object({
    default_value  = string
    dimension_name = string
    value_source   = string
  })
  default = null

  validation {
    condition = var.cloudwatch_destination == null ? true : contains([
      "messageTag", "emailHeader", "linkTag"
    ], var.cloudwatch_destination.value_source)
    error_message = "resource_aws_ses_event_destination, cloudwatch_destination.value_source must be one of: messageTag, emailHeader, or linkTag."
  }

  validation {
    condition     = var.cloudwatch_destination == null ? true : length(var.cloudwatch_destination.default_value) > 0
    error_message = "resource_aws_ses_event_destination, cloudwatch_destination.default_value must not be empty."
  }

  validation {
    condition     = var.cloudwatch_destination == null ? true : length(var.cloudwatch_destination.dimension_name) > 0
    error_message = "resource_aws_ses_event_destination, cloudwatch_destination.dimension_name must not be empty."
  }
}

variable "kinesis_destination" {
  description = "Send the events to a kinesis firehose destination"
  type = object({
    stream_arn = string
    role_arn   = string
  })
  default = null

  validation {
    condition     = var.kinesis_destination == null ? true : length(var.kinesis_destination.stream_arn) > 0
    error_message = "resource_aws_ses_event_destination, kinesis_destination.stream_arn must not be empty."
  }

  validation {
    condition     = var.kinesis_destination == null ? true : length(var.kinesis_destination.role_arn) > 0
    error_message = "resource_aws_ses_event_destination, kinesis_destination.role_arn must not be empty."
  }
}

variable "sns_destination" {
  description = "Send the events to an SNS Topic destination"
  type = object({
    topic_arn = string
  })
  default = null

  validation {
    condition     = var.sns_destination == null ? true : length(var.sns_destination.topic_arn) > 0
    error_message = "resource_aws_ses_event_destination, sns_destination.topic_arn must not be empty."
  }
}