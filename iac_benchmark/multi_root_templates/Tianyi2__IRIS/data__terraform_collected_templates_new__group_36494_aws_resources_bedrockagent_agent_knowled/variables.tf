variable "agent_id" {
  description = "Unique identifier of the agent with which you want to associate the knowledge base."
  type        = string

  validation {
    condition     = can(regex("^[A-Z0-9]+$", var.agent_id))
    error_message = "resource_aws_bedrockagent_agent_knowledge_base_association, agent_id must be a valid agent identifier containing only uppercase letters and numbers."
  }
}

variable "description" {
  description = "Description of what the agent should use the knowledge base for."
  type        = string

  validation {
    condition     = length(var.description) > 0 && length(var.description) <= 200
    error_message = "resource_aws_bedrockagent_agent_knowledge_base_association, description must be between 1 and 200 characters."
  }
}

variable "knowledge_base_id" {
  description = "Unique identifier of the knowledge base to associate with the agent."
  type        = string

  validation {
    condition     = can(regex("^[A-Z0-9]+$", var.knowledge_base_id))
    error_message = "resource_aws_bedrockagent_agent_knowledge_base_association, knowledge_base_id must be a valid knowledge base identifier containing only uppercase letters and numbers."
  }
}

variable "knowledge_base_state" {
  description = "Whether to use the knowledge base when sending an InvokeAgent request. Valid values: ENABLED, DISABLED."
  type        = string

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.knowledge_base_state)
    error_message = "resource_aws_bedrockagent_agent_knowledge_base_association, knowledge_base_state must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_bedrockagent_agent_knowledge_base_association, region must be a valid AWS region identifier."
  }
}

variable "agent_version" {
  description = "Version of the agent with which you want to associate the knowledge base. Valid values: DRAFT."
  type        = string
  default     = null

  validation {
    condition     = var.agent_version == null || var.agent_version == "DRAFT"
    error_message = "resource_aws_bedrockagent_agent_knowledge_base_association, agent_version must be 'DRAFT' when specified."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_bedrockagent_agent_knowledge_base_association, timeouts_create must be a valid timeout duration (e.g., '5m', '10s', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_bedrockagent_agent_knowledge_base_association, timeouts_update must be a valid timeout duration (e.g., '5m', '10s', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_bedrockagent_agent_knowledge_base_association, timeouts_delete must be a valid timeout duration (e.g., '5m', '10s', '1h')."
  }
}