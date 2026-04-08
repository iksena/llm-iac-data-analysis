variable "agent_id" {
  description = "ID of the agent to associate the collaborator"
  type        = string

  validation {
    condition     = length(var.agent_id) > 0
    error_message = "resource_aws_bedrockagent_agent_collaborator, agent_id cannot be empty."
  }
}

variable "collaboration_instruction" {
  description = "Instruction to give the collaborator"
  type        = string

  validation {
    condition     = length(var.collaboration_instruction) > 0
    error_message = "resource_aws_bedrockagent_agent_collaborator, collaboration_instruction cannot be empty."
  }
}

variable "collaborator_name" {
  description = "Name of this collaborator"
  type        = string

  validation {
    condition     = length(var.collaborator_name) > 0
    error_message = "resource_aws_bedrockagent_agent_collaborator, collaborator_name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "prepare_agent" {
  description = "Whether to prepare the agent after creation or modification. Defaults to true"
  type        = bool
  default     = true
}

variable "relay_conversation_history" {
  description = "Configure relaying the history to the collaborator"
  type        = string
  default     = null

  validation {
    condition     = var.relay_conversation_history == null || contains(["TO_COLLABORATOR"], var.relay_conversation_history)
    error_message = "resource_aws_bedrockagent_agent_collaborator, relay_conversation_history must be 'TO_COLLABORATOR' or null."
  }
}

variable "agent_descriptor_alias_arn" {
  description = "ARN of the Alias of an Agent to use as the collaborator"
  type        = string

  validation {
    condition     = length(var.agent_descriptor_alias_arn) > 0
    error_message = "resource_aws_bedrockagent_agent_collaborator, agent_descriptor_alias_arn cannot be empty."
  }

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:bedrock:[a-z0-9-]+:[0-9]{12}:agent-alias/[A-Z0-9]{10}/[A-Z0-9]{10}$", var.agent_descriptor_alias_arn))
    error_message = "resource_aws_bedrockagent_agent_collaborator, agent_descriptor_alias_arn must be a valid agent alias ARN."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operations"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_bedrockagent_agent_collaborator, timeouts_create must be a valid duration (e.g., '5m', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operations"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_bedrockagent_agent_collaborator, timeouts_update must be a valid duration (e.g., '5m', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operations"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_bedrockagent_agent_collaborator, timeouts_delete must be a valid duration (e.g., '5m', '1h')."
  }
}