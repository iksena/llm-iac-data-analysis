variable "name" {
  description = "The name of the configuration set."
  type        = string
}

variable "default_sender_id" {
  description = "The default sender ID to use for this configuration set."
  type        = string
  default     = null
}

variable "default_message_type" {
  description = "The default message type. Must either be 'TRANSACTIONAL' or 'PROMOTIONAL'"
  type        = string
  default     = null

  validation {
    condition     = var.default_message_type == null || contains(["TRANSACTIONAL", "PROMOTIONAL"], var.default_message_type)
    error_message = "resource_aws_pinpointsmsvoicev2_configuration_set, default_message_type must be either 'TRANSACTIONAL' or 'PROMOTIONAL'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}