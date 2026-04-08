variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "voice_connector_id" {
  description = "The Amazon Chime Voice Connector ID."
  type        = string

  validation {
    condition     = length(var.voice_connector_id) > 0
    error_message = "resource_aws_chime_voice_connector_streaming, voice_connector_id cannot be empty."
  }
}

variable "data_retention" {
  description = "The retention period, in hours, for the Amazon Kinesis data."
  type        = number

  validation {
    condition     = var.data_retention > 0
    error_message = "resource_aws_chime_voice_connector_streaming, data_retention must be greater than 0."
  }
}

variable "disabled" {
  description = "When true, media streaming to Amazon Kinesis is turned off."
  type        = bool
  default     = false
}

variable "streaming_notification_targets" {
  description = "The streaming notification targets. Valid Values: EventBridge | SNS | SQS"
  type        = list(string)
  default     = null

  validation {
    condition = var.streaming_notification_targets == null ? true : alltrue([
      for target in var.streaming_notification_targets : contains(["EventBridge", "SNS", "SQS"], target)
    ])
    error_message = "resource_aws_chime_voice_connector_streaming, streaming_notification_targets must contain only valid values: EventBridge, SNS, SQS."
  }
}

variable "media_insights_configuration" {
  description = "The media insights configuration."
  type = object({
    disabled          = optional(bool, false)
    configuration_arn = optional(string)
  })
  default = null
}