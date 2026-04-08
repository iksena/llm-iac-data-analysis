variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "content" {
  description = "Specifies the content of the Contact Flow, provided as a JSON string, written in Amazon Connect Contact Flow Language. If defined, the filename argument cannot be used."
  type        = string
  default     = null
}

variable "content_hash" {
  description = "Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the Contact Flow source specified with filename."
  type        = string
  default     = null
}

variable "description" {
  description = "Specifies the description of the Contact Flow."
  type        = string
  default     = null
}

variable "filename" {
  description = "The path to the Contact Flow source within the local filesystem. Conflicts with content."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "resource_aws_connect_contact_flow, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "Specifies the name of the Contact Flow."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_connect_contact_flow, name cannot be empty."
  }
}

variable "tags" {
  description = "Tags to apply to the Contact Flow. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Specifies the type of the Contact Flow. Defaults to CONTACT_FLOW. Forces new resource."
  type        = string
  default     = "CONTACT_FLOW"

  validation {
    condition = contains([
      "CONTACT_FLOW",
      "CUSTOMER_QUEUE",
      "CUSTOMER_HOLD",
      "CUSTOMER_WHISPER",
      "AGENT_HOLD",
      "AGENT_WHISPER",
      "OUTBOUND_WHISPER",
      "AGENT_TRANSFER",
      "QUEUE_TRANSFER"
    ], var.type)
    error_message = "resource_aws_connect_contact_flow, type must be one of: CONTACT_FLOW, CUSTOMER_QUEUE, CUSTOMER_HOLD, CUSTOMER_WHISPER, AGENT_HOLD, AGENT_WHISPER, OUTBOUND_WHISPER, AGENT_TRANSFER, QUEUE_TRANSFER."
  }
}