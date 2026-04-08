variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_bedrockagent_agent_versions, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "agent_id" {
  description = "Unique identifier of the agent."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9]{10}$", var.agent_id))
    error_message = "data_aws_bedrockagent_agent_versions, agent_id must be a valid agent identifier."
  }
}