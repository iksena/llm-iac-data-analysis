variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "abort_statement_messages" {
  description = "A set of messages for the abort statement"
  type = list(object({
    content      = string
    content_type = string
    group_number = optional(number)
  }))

  validation {
    condition     = length(var.abort_statement_messages) > 0
    error_message = "resource_aws_lex_bot, abort_statement_messages must contain at least one message."
  }

  validation {
    condition = alltrue([
      for msg in var.abort_statement_messages : contains(["PlainText", "SSML"], msg.content_type)
    ])
    error_message = "resource_aws_lex_bot, abort_statement_messages content_type must be either 'PlainText' or 'SSML'."
  }
}

variable "abort_statement_response_card" {
  description = "The response card for abort statement"
  type        = string
  default     = null
}

variable "child_directed" {
  description = "Specifies if the bot is directed to children under 13"
  type        = bool

  validation {
    condition     = var.child_directed != null
    error_message = "resource_aws_lex_bot, child_directed is required and must be either true or false."
  }
}

variable "clarification_prompt_max_attempts" {
  description = "The number of times to prompt the user for information"
  type        = number

  validation {
    condition     = var.clarification_prompt_max_attempts > 0 && var.clarification_prompt_max_attempts <= 5
    error_message = "resource_aws_lex_bot, clarification_prompt_max_attempts must be between 1 and 5."
  }
}

variable "clarification_prompt_messages" {
  description = "A set of messages for the clarification prompt"
  type = list(object({
    content      = string
    content_type = string
    group_number = optional(number)
  }))

  validation {
    condition     = length(var.clarification_prompt_messages) > 0
    error_message = "resource_aws_lex_bot, clarification_prompt_messages must contain at least one message."
  }

  validation {
    condition = alltrue([
      for msg in var.clarification_prompt_messages : contains(["PlainText", "SSML"], msg.content_type)
    ])
    error_message = "resource_aws_lex_bot, clarification_prompt_messages content_type must be either 'PlainText' or 'SSML'."
  }
}

variable "clarification_prompt_response_card" {
  description = "The response card for clarification prompt"
  type        = string
  default     = null
}

variable "create_version" {
  description = "Determines if a new bot version is created when the initial resource is created and on each update"
  type        = bool
  default     = false
}

variable "description" {
  description = "A description of the bot"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 200
    error_message = "resource_aws_lex_bot, description must be less than or equal to 200 characters in length."
  }
}

variable "detect_sentiment" {
  description = "When set to true user utterances are sent to Amazon Comprehend for sentiment analysis"
  type        = bool
  default     = false
}

variable "enable_model_improvements" {
  description = "Set to true to enable access to natural language understanding improvements"
  type        = bool
  default     = false
}

variable "idle_session_ttl_in_seconds" {
  description = "The maximum time in seconds that Amazon Lex retains the data gathered in a conversation"
  type        = number
  default     = 300

  validation {
    condition     = var.idle_session_ttl_in_seconds >= 60 && var.idle_session_ttl_in_seconds <= 86400
    error_message = "resource_aws_lex_bot, idle_session_ttl_in_seconds must be a number between 60 and 86400 (inclusive)."
  }
}

variable "locale" {
  description = "Specifies the target locale for the bot"
  type        = string
  default     = "en-US"
}

variable "intents" {
  description = "A set of Intent objects"
  type = list(object({
    intent_name    = string
    intent_version = string
  }))

  validation {
    condition     = length(var.intents) > 0 && length(var.intents) <= 250
    error_message = "resource_aws_lex_bot, intents must contain between 1 and 250 intent objects."
  }

  validation {
    condition = alltrue([
      for intent in var.intents : length(intent.intent_name) <= 100
    ])
    error_message = "resource_aws_lex_bot, intents intent_name must be less than or equal to 100 characters in length."
  }

  validation {
    condition = alltrue([
      for intent in var.intents : length(intent.intent_version) <= 64
    ])
    error_message = "resource_aws_lex_bot, intents intent_version must be less than or equal to 64 characters in length."
  }
}

variable "name" {
  description = "The name of the bot"
  type        = string

  validation {
    condition     = length(var.name) >= 2 && length(var.name) <= 50
    error_message = "resource_aws_lex_bot, name must be between 2 and 50 characters in length."
  }
}

variable "nlu_intent_confidence_threshold" {
  description = "Determines the threshold where Amazon Lex will insert the AMAZON.FallbackIntent"
  type        = number
  default     = 0

  validation {
    condition     = var.nlu_intent_confidence_threshold >= 0 && var.nlu_intent_confidence_threshold <= 1
    error_message = "resource_aws_lex_bot, nlu_intent_confidence_threshold must be a float between 0 and 1."
  }
}

variable "process_behavior" {
  description = "If set to BUILD, Amazon Lex builds the bot so that it can be run"
  type        = string
  default     = "SAVE"

  validation {
    condition     = contains(["BUILD", "SAVE"], var.process_behavior)
    error_message = "resource_aws_lex_bot, process_behavior must be either 'BUILD' or 'SAVE'."
  }
}

variable "voice_id" {
  description = "The Amazon Polly voice ID that you want Amazon Lex to use for voice interactions"
  type        = string
  default     = null
}

variable "create_timeout" {
  description = "Create timeout"
  type        = string
  default     = "5m"
}

variable "update_timeout" {
  description = "Update timeout"
  type        = string
  default     = "5m"
}

variable "delete_timeout" {
  description = "Delete timeout"
  type        = string
  default     = "5m"
}