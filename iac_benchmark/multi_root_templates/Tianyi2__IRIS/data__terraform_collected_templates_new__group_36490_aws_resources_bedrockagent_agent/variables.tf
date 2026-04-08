variable "agent_name" {
  description = "Name of the agent"
  type        = string

  validation {
    condition     = can(regex("^.+$", var.agent_name))
    error_message = "resource_aws_bedrockagent_agent, agent_name must be a non-empty string."
  }
}

variable "agent_resource_role_arn" {
  description = "ARN of the IAM role with permissions to invoke API operations on the agent"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+$", var.agent_resource_role_arn))
    error_message = "resource_aws_bedrockagent_agent, agent_resource_role_arn must be a valid IAM role ARN."
  }
}

variable "foundation_model" {
  description = "Foundation model used for orchestration by the agent"
  type        = string

  validation {
    condition     = can(regex("^.+$", var.foundation_model))
    error_message = "resource_aws_bedrockagent_agent, foundation_model must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_bedrockagent_agent, region must be a valid AWS region name or null."
  }
}

variable "agent_collaboration" {
  description = "Agents collaboration role"
  type        = string
  default     = null

  validation {
    condition     = var.agent_collaboration == null || contains(["SUPERVISOR", "SUPERVISOR_ROUTER", "DISABLED"], var.agent_collaboration)
    error_message = "resource_aws_bedrockagent_agent, agent_collaboration must be one of: SUPERVISOR, SUPERVISOR_ROUTER, DISABLED."
  }
}

variable "customer_encryption_key_arn" {
  description = "ARN of the AWS KMS key that encrypts the agent"
  type        = string
  default     = null

  validation {
    condition     = var.customer_encryption_key_arn == null || can(regex("^arn:aws[a-zA-Z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/.+$", var.customer_encryption_key_arn))
    error_message = "resource_aws_bedrockagent_agent, customer_encryption_key_arn must be a valid KMS key ARN or null."
  }
}

variable "description" {
  description = "Description of the agent"
  type        = string
  default     = null
}

variable "guardrail_configuration" {
  description = "Details about the guardrail associated with the agent"
  type = object({
    guardrail_identifier = optional(string)
    guardrail_version    = optional(string)
  })
  default = null
}

variable "idle_session_ttl_in_seconds" {
  description = "Number of seconds for which Amazon Bedrock keeps information about a user's conversation with the agent"
  type        = number
  default     = null

  validation {
    condition     = var.idle_session_ttl_in_seconds == null || (var.idle_session_ttl_in_seconds >= 60 && var.idle_session_ttl_in_seconds <= 3600)
    error_message = "resource_aws_bedrockagent_agent, idle_session_ttl_in_seconds must be between 60 and 3600 seconds or null."
  }
}

variable "instruction" {
  description = "Instructions that tell the agent what it should do and how it should interact with users"
  type        = string
  default     = null

  validation {
    condition     = var.instruction == null || (length(var.instruction) >= 40 && length(var.instruction) <= 20000)
    error_message = "resource_aws_bedrockagent_agent, instruction must be between 40 and 20000 characters or null."
  }
}

variable "memory_configuration" {
  description = "Configurations for the agent's ability to retain the conversational context"
  type = object({
    enabled_memory_types = list(string)
    storage_days         = optional(number)
  })
  default = null

  validation {
    condition = var.memory_configuration == null || (
      var.memory_configuration.storage_days == null ||
      (var.memory_configuration.storage_days >= 0 && var.memory_configuration.storage_days <= 30)
    )
    error_message = "resource_aws_bedrockagent_agent, memory_configuration.storage_days must be between 0 and 30 or null."
  }
}

variable "prepare_agent" {
  description = "Whether to prepare the agent after creation or modification"
  type        = bool
  default     = true
}

variable "prompt_override_configuration" {
  description = "Configurations to override prompt templates in different parts of an agent sequence"
  type = object({
    override_lambda = optional(string)
    prompt_configurations = list(object({
      base_prompt_template = string
      parser_mode          = string
      prompt_creation_mode = string
      prompt_state         = string
      prompt_type          = string
      inference_configuration = object({
        max_length     = number
        stop_sequences = list(string)
        temperature    = number
        top_k          = number
        top_p          = number
      })
    }))
  })
  default = null

  validation {
    condition = var.prompt_override_configuration == null || (
      var.prompt_override_configuration.override_lambda == null ||
      can(regex("^arn:aws[a-zA-Z-]*:lambda:[a-z0-9-]+:[0-9]{12}:function:.+$", var.prompt_override_configuration.override_lambda))
    )
    error_message = "resource_aws_bedrockagent_agent, prompt_override_configuration.override_lambda must be a valid Lambda function ARN or null."
  }

  validation {
    condition = var.prompt_override_configuration == null || alltrue([
      for config in var.prompt_override_configuration.prompt_configurations :
      contains(["DEFAULT", "OVERRIDDEN"], config.parser_mode)
    ])
    error_message = "resource_aws_bedrockagent_agent, prompt_override_configuration.prompt_configurations.parser_mode must be DEFAULT or OVERRIDDEN."
  }

  validation {
    condition = var.prompt_override_configuration == null || alltrue([
      for config in var.prompt_override_configuration.prompt_configurations :
      contains(["DEFAULT", "OVERRIDDEN"], config.prompt_creation_mode)
    ])
    error_message = "resource_aws_bedrockagent_agent, prompt_override_configuration.prompt_configurations.prompt_creation_mode must be DEFAULT or OVERRIDDEN."
  }

  validation {
    condition = var.prompt_override_configuration == null || alltrue([
      for config in var.prompt_override_configuration.prompt_configurations :
      contains(["ENABLED", "DISABLED"], config.prompt_state)
    ])
    error_message = "resource_aws_bedrockagent_agent, prompt_override_configuration.prompt_configurations.prompt_state must be ENABLED or DISABLED."
  }

  validation {
    condition = var.prompt_override_configuration == null || alltrue([
      for config in var.prompt_override_configuration.prompt_configurations :
      contains(["PRE_PROCESSING", "ORCHESTRATION", "POST_PROCESSING", "KNOWLEDGE_BASE_RESPONSE_GENERATION"], config.prompt_type)
    ])
    error_message = "resource_aws_bedrockagent_agent, prompt_override_configuration.prompt_configurations.prompt_type must be one of: PRE_PROCESSING, ORCHESTRATION, POST_PROCESSING, KNOWLEDGE_BASE_RESPONSE_GENERATION."
  }

  validation {
    condition = var.prompt_override_configuration == null || alltrue([
      for config in var.prompt_override_configuration.prompt_configurations :
      config.inference_configuration.max_length > 0
    ])
    error_message = "resource_aws_bedrockagent_agent, prompt_override_configuration.prompt_configurations.inference_configuration.max_length must be greater than 0."
  }

  validation {
    condition = var.prompt_override_configuration == null || alltrue([
      for config in var.prompt_override_configuration.prompt_configurations :
      config.inference_configuration.temperature >= 0 && config.inference_configuration.temperature <= 1
    ])
    error_message = "resource_aws_bedrockagent_agent, prompt_override_configuration.prompt_configurations.inference_configuration.temperature must be between 0 and 1."
  }

  validation {
    condition = var.prompt_override_configuration == null || alltrue([
      for config in var.prompt_override_configuration.prompt_configurations :
      config.inference_configuration.top_k >= 0 && config.inference_configuration.top_k <= 500
    ])
    error_message = "resource_aws_bedrockagent_agent, prompt_override_configuration.prompt_configurations.inference_configuration.top_k must be between 0 and 500."
  }

  validation {
    condition = var.prompt_override_configuration == null || alltrue([
      for config in var.prompt_override_configuration.prompt_configurations :
      config.inference_configuration.top_p >= 0 && config.inference_configuration.top_p <= 1
    ])
    error_message = "resource_aws_bedrockagent_agent, prompt_override_configuration.prompt_configurations.inference_configuration.top_p must be between 0 and 1."
  }
}

variable "skip_resource_in_use_check" {
  description = "Whether the in-use check is skipped when deleting the agent"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeout configuration for resource operations"
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