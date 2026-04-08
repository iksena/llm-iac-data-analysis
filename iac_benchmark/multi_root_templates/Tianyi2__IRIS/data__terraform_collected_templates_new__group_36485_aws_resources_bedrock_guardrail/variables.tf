variable "name" {
  description = "Name of the guardrail"
  type        = string
}

variable "blocked_input_messaging" {
  description = "Message to return when the guardrail blocks a prompt"
  type        = string
}

variable "blocked_outputs_messaging" {
  description = "Message to return when the guardrail blocks a model response"
  type        = string
}

variable "description" {
  description = "Description of the guardrail or its version"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "The KMS key with which the guardrail was encrypted at rest"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "content_policy_config" {
  description = "Content policy config for a guardrail"
  type = object({
    filters_config = optional(list(object({
      input_strength  = optional(string)
      output_strength = optional(string)
      type            = optional(string)
    })))
    tier_config = optional(object({
      tier_name = string
    }))
  })
  default = null

  validation {
    condition = var.content_policy_config == null || (
      var.content_policy_config.tier_config == null ||
      contains(["STANDARD", "CLASSIC"], var.content_policy_config.tier_config.tier_name)
    )
    error_message = "resource_aws_bedrock_guardrail, content_policy_config.tier_config.tier_name must be either 'STANDARD' or 'CLASSIC'."
  }
}

variable "contextual_grounding_policy_config" {
  description = "Contextual grounding policy config for a guardrail"
  type = object({
    filters_config = list(object({
      threshold = number
      type      = string
    }))
  })
  default = null
}

variable "cross_region_config" {
  description = "Configuration block to enable cross-region routing for bedrock guardrails"
  type = object({
    guardrail_profile_identifier = string
  })
  default = null
}

variable "sensitive_information_policy_config" {
  description = "Sensitive information policy config for a guardrail"
  type = object({
    pii_entities_config = optional(list(object({
      action         = string
      input_action   = optional(string)
      output_action  = optional(string)
      input_enabled  = optional(bool)
      output_enabled = optional(bool)
      type           = string
    })))
    regexes_config = optional(list(object({
      action         = string
      input_action   = optional(string)
      output_action  = optional(string)
      input_enabled  = optional(bool)
      output_enabled = optional(bool)
      description    = optional(string)
      name           = string
      pattern        = string
    })))
  })
  default = null

  validation {
    condition = var.sensitive_information_policy_config == null || (
      var.sensitive_information_policy_config.pii_entities_config == null ||
      alltrue([
        for config in var.sensitive_information_policy_config.pii_entities_config :
        contains(["BLOCK", "ANONYMIZE", "NONE"], config.action)
      ])
    )
    error_message = "resource_aws_bedrock_guardrail, sensitive_information_policy_config.pii_entities_config.action must be one of 'BLOCK', 'ANONYMIZE', or 'NONE'."
  }

  validation {
    condition = var.sensitive_information_policy_config == null || (
      var.sensitive_information_policy_config.pii_entities_config == null ||
      alltrue([
        for config in var.sensitive_information_policy_config.pii_entities_config :
        config.input_action == null || contains(["BLOCK", "ANONYMIZE", "NONE"], config.input_action)
      ])
    )
    error_message = "resource_aws_bedrock_guardrail, sensitive_information_policy_config.pii_entities_config.input_action must be one of 'BLOCK', 'ANONYMIZE', or 'NONE'."
  }

  validation {
    condition = var.sensitive_information_policy_config == null || (
      var.sensitive_information_policy_config.pii_entities_config == null ||
      alltrue([
        for config in var.sensitive_information_policy_config.pii_entities_config :
        config.output_action == null || contains(["BLOCK", "ANONYMIZE", "NONE"], config.output_action)
      ])
    )
    error_message = "resource_aws_bedrock_guardrail, sensitive_information_policy_config.pii_entities_config.output_action must be one of 'BLOCK', 'ANONYMIZE', or 'NONE'."
  }

  validation {
    condition = var.sensitive_information_policy_config == null || (
      var.sensitive_information_policy_config.regexes_config == null ||
      alltrue([
        for config in var.sensitive_information_policy_config.regexes_config :
        contains(["BLOCK", "ANONYMIZE", "NONE"], config.action)
      ])
    )
    error_message = "resource_aws_bedrock_guardrail, sensitive_information_policy_config.regexes_config.action must be one of 'BLOCK', 'ANONYMIZE', or 'NONE'."
  }

  validation {
    condition = var.sensitive_information_policy_config == null || (
      var.sensitive_information_policy_config.regexes_config == null ||
      alltrue([
        for config in var.sensitive_information_policy_config.regexes_config :
        config.input_action == null || contains(["BLOCK", "ANONYMIZE", "NONE"], config.input_action)
      ])
    )
    error_message = "resource_aws_bedrock_guardrail, sensitive_information_policy_config.regexes_config.input_action must be one of 'BLOCK', 'ANONYMIZE', or 'NONE'."
  }

  validation {
    condition = var.sensitive_information_policy_config == null || (
      var.sensitive_information_policy_config.regexes_config == null ||
      alltrue([
        for config in var.sensitive_information_policy_config.regexes_config :
        config.output_action == null || contains(["BLOCK", "ANONYMIZE", "NONE"], config.output_action)
      ])
    )
    error_message = "resource_aws_bedrock_guardrail, sensitive_information_policy_config.regexes_config.output_action must be one of 'BLOCK', 'ANONYMIZE', or 'NONE'."
  }
}

variable "topic_policy_config" {
  description = "Topic policy config for a guardrail"
  type = object({
    topics_config = list(object({
      definition = string
      name       = string
      type       = string
      examples   = optional(list(string))
    }))
    tier_config = optional(object({
      tier_name = string
    }))
  })
  default = null

  validation {
    condition = var.topic_policy_config == null || (
      var.topic_policy_config.tier_config == null ||
      contains(["STANDARD", "CLASSIC"], var.topic_policy_config.tier_config.tier_name)
    )
    error_message = "resource_aws_bedrock_guardrail, topic_policy_config.tier_config.tier_name must be either 'STANDARD' or 'CLASSIC'."
  }
}

variable "word_policy_config" {
  description = "Word policy config for a guardrail"
  type = object({
    managed_word_lists_config = optional(list(object({
      type           = string
      input_action   = optional(string)
      input_enabled  = optional(bool)
      output_action  = optional(string)
      output_enabled = optional(bool)
    })))
    words_config = optional(list(object({
      text           = string
      input_action   = optional(string)
      input_enabled  = optional(bool)
      output_action  = optional(string)
      output_enabled = optional(bool)
    })))
  })
  default = null

  validation {
    condition = var.word_policy_config == null || (
      var.word_policy_config.managed_word_lists_config == null ||
      alltrue([
        for config in var.word_policy_config.managed_word_lists_config :
        config.input_action == null || contains(["BLOCK", "NONE"], config.input_action)
      ])
    )
    error_message = "resource_aws_bedrock_guardrail, word_policy_config.managed_word_lists_config.input_action must be one of 'BLOCK' or 'NONE'."
  }

  validation {
    condition = var.word_policy_config == null || (
      var.word_policy_config.managed_word_lists_config == null ||
      alltrue([
        for config in var.word_policy_config.managed_word_lists_config :
        config.output_action == null || contains(["BLOCK", "NONE"], config.output_action)
      ])
    )
    error_message = "resource_aws_bedrock_guardrail, word_policy_config.managed_word_lists_config.output_action must be one of 'BLOCK' or 'NONE'."
  }

  validation {
    condition = var.word_policy_config == null || (
      var.word_policy_config.words_config == null ||
      alltrue([
        for config in var.word_policy_config.words_config :
        config.input_action == null || contains(["BLOCK", "NONE"], config.input_action)
      ])
    )
    error_message = "resource_aws_bedrock_guardrail, word_policy_config.words_config.input_action must be one of 'BLOCK' or 'NONE'."
  }

  validation {
    condition = var.word_policy_config == null || (
      var.word_policy_config.words_config == null ||
      alltrue([
        for config in var.word_policy_config.words_config :
        config.output_action == null || contains(["BLOCK", "NONE"], config.output_action)
      ])
    )
    error_message = "resource_aws_bedrock_guardrail, word_policy_config.words_config.output_action must be one of 'BLOCK' or 'NONE'."
  }
}