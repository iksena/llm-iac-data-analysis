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
    error_message = "resource_aws_chime_voice_connector_logging, voice_connector_id must be a non-empty string."
  }
}

variable "enable_sip_logs" {
  description = "When true, enables SIP message logs for sending to Amazon CloudWatch Logs."
  type        = bool
  default     = null
}

variable "enable_media_metric_logs" {
  description = "When true, enables logging of detailed media metrics for Voice Connectors to Amazon CloudWatch logs."
  type        = bool
  default     = null
}