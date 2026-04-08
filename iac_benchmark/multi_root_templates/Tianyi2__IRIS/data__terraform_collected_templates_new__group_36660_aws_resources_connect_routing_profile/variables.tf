variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "resource_aws_connect_routing_profile, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "Specifies the name of the Routing Profile."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_connect_routing_profile, name cannot be empty."
  }
}

variable "default_outbound_queue_id" {
  description = "Specifies the default outbound queue for the Routing Profile."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.default_outbound_queue_id))
    error_message = "resource_aws_connect_routing_profile, default_outbound_queue_id must be a valid UUID format."
  }
}

variable "description" {
  description = "Specifies the description of the Routing Profile."
  type        = string

  validation {
    condition     = length(var.description) > 0
    error_message = "resource_aws_connect_routing_profile, description cannot be empty."
  }
}

variable "media_concurrencies" {
  description = "One or more media_concurrencies blocks that specify the channels that agents can handle in the Contact Control Panel (CCP) for this Routing Profile."
  type = list(object({
    channel     = string
    concurrency = number
  }))

  validation {
    condition = alltrue([
      for mc in var.media_concurrencies : contains(["VOICE", "CHAT", "TASK"], mc.channel)
    ])
    error_message = "resource_aws_connect_routing_profile, media_concurrencies channel must be one of: VOICE, CHAT, TASK."
  }

  validation {
    condition = alltrue([
      for mc in var.media_concurrencies :
      mc.channel == "VOICE" ? (mc.concurrency >= 1 && mc.concurrency <= 1) :
      (mc.channel == "CHAT" || mc.channel == "TASK") ? (mc.concurrency >= 1 && mc.concurrency <= 10) : false
    ])
    error_message = "resource_aws_connect_routing_profile, media_concurrencies concurrency must be 1 for VOICE, 1-10 for CHAT and TASK."
  }
}

variable "queue_configs" {
  description = "One or more queue_configs blocks that specify the inbound queues associated with the routing profile. If no queue is added, the agent only can make outbound calls."
  type = list(object({
    channel  = string
    delay    = number
    priority = number
    queue_id = string
  }))
  default = []

  validation {
    condition = alltrue([
      for qc in var.queue_configs : contains(["VOICE", "CHAT", "TASK"], qc.channel)
    ])
    error_message = "resource_aws_connect_routing_profile, queue_configs channel must be one of: VOICE, CHAT, TASK."
  }

  validation {
    condition = alltrue([
      for qc in var.queue_configs : qc.delay >= 0
    ])
    error_message = "resource_aws_connect_routing_profile, queue_configs delay must be a non-negative number."
  }

  validation {
    condition = alltrue([
      for qc in var.queue_configs : qc.priority >= 1
    ])
    error_message = "resource_aws_connect_routing_profile, queue_configs priority must be at least 1."
  }

  validation {
    condition = alltrue([
      for qc in var.queue_configs : can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", qc.queue_id))
    ])
    error_message = "resource_aws_connect_routing_profile, queue_configs queue_id must be a valid UUID format."
  }
}

variable "tags" {
  description = "Tags to apply to the Routing Profile. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}