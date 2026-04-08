variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "logging_configuration_identifiers" {
  description = "List of Logging Configuration ARNs to attach to the room."
  type        = list(string)
  default     = null
}

variable "maximum_message_length" {
  description = "Maximum number of characters in a single message. Messages are expected to be UTF-8 encoded and this limit applies specifically to rune/code-point count, not number of bytes."
  type        = number
  default     = null
}

variable "maximum_message_rate_per_second" {
  description = "Maximum number of messages per second that can be sent to the room (by all clients)."
  type        = number
  default     = null
}

variable "message_review_handler" {
  description = "Configuration information for optional review of messages."
  type = object({
    fallback_result = optional(string)
    uri             = optional(string)
  })
  default = null

  validation {
    condition = var.message_review_handler == null || (
      var.message_review_handler.fallback_result == null ||
      contains(["ALLOW", "DENY"], var.message_review_handler.fallback_result)
    )
    error_message = "resource_aws_ivschat_room, message_review_handler.fallback_result must be either 'ALLOW' or 'DENY'."
  }
}

variable "name" {
  description = "Room name."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
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