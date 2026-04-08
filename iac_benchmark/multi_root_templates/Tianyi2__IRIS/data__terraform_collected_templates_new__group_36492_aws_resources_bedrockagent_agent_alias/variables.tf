variable "agent_alias_name" {
  description = "Name of the alias"
  type        = string
  validation {
    condition     = length(var.agent_alias_name) > 0
    error_message = "resource_aws_bedrockagent_agent_alias, agent_alias_name must not be empty."
  }
}

variable "agent_id" {
  description = "Identifier of the agent to create an alias for"
  type        = string
  validation {
    condition     = length(var.agent_id) > 0
    error_message = "resource_aws_bedrockagent_agent_alias, agent_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the alias"
  type        = string
  default     = null
}

variable "routing_configuration" {
  description = "Details about the routing configuration of the alias"
  type = object({
    agent_version          = optional(string)
    provisioned_throughput = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts"
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