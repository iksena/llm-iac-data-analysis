variable "name" {
  description = "The name of the intent, not case sensitive. Must be less than or equal to 100 characters in length."
  type        = string

  validation {
    condition     = length(var.name) <= 100
    error_message = "resource_aws_lex_intent, name must be less than or equal to 100 characters in length."
  }
}

variable "description" {
  description = "A description of the intent. Must be less than or equal to 200 characters in length."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 200
    error_message = "resource_aws_lex_intent, description must be less than or equal to 200 characters in length."
  }
}

variable "create_version" {
  description = "Determines if a new slot type version is created when the initial resource is created and on each update. Defaults to false."
  type        = bool
  default     = false
}

variable "parent_intent_signature" {
  description = "A unique identifier for the built-in intent to base this intent on."
  type        = string
  default     = null
}

variable "sample_utterances" {
  description = "An array of utterances (strings) that a user might say to signal the intent. Must have between 1 and 10 items in the list, and each item must be less than or equal to 200 characters in length."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.sample_utterances) >= 0 && length(var.sample_utterances) <= 10
    error_message = "resource_aws_lex_intent, sample_utterances must have between 0 and 10 items in the list."
  }

  validation {
    condition     = alltrue([for utterance in var.sample_utterances : length(utterance) <= 200])
    error_message = "resource_aws_lex_intent, sample_utterances each item must be less than or equal to 200 characters in length."
  }
}

variable "confirmation_prompt" {
  description = "Prompts the user to confirm the intent. This question should have a yes or no answer."
  type = object({
    max_attempts  = number
    response_card = optional(string)
    messages = list(object({
      content      = string
      content_type = string
      group_number = optional(number)
    }))
  })
  default = null

  validation {
    condition     = var.confirmation_prompt == null || (var.confirmation_prompt.max_attempts >= 1 && var.confirmation_prompt.max_attempts <= 5)
    error_message = "resource_aws_lex_intent, confirmation_prompt max_attempts must be a number between 1 and 5 (inclusive)."
  }

  validation {
    condition = var.confirmation_prompt == null || (
      length(var.confirmation_prompt.messages) >= 1 && length(var.confirmation_prompt.messages) <= 15
    )
    error_message = "resource_aws_lex_intent, confirmation_prompt messages must contain between 1 and 15 messages."
  }

  validation {
    condition = var.confirmation_prompt == null || alltrue([
      for msg in var.confirmation_prompt.messages : length(msg.content) <= 1000
    ])
    error_message = "resource_aws_lex_intent, confirmation_prompt message content must be less than or equal to 1000 characters in length."
  }

  validation {
    condition = var.confirmation_prompt == null || alltrue([
      for msg in var.confirmation_prompt.messages : msg.group_number == null || (msg.group_number >= 1 && msg.group_number <= 5)
    ])
    error_message = "resource_aws_lex_intent, confirmation_prompt message group_number must be a number between 1 and 5 (inclusive)."
  }

  validation {
    condition     = var.confirmation_prompt == null || var.confirmation_prompt.response_card == null || length(var.confirmation_prompt.response_card) <= 50000
    error_message = "resource_aws_lex_intent, confirmation_prompt response_card must be less than or equal to 50000 characters in length."
  }
}

variable "conclusion_statement" {
  description = "The statement that you want Amazon Lex to convey to the user after the intent is successfully fulfilled by the Lambda function."
  type = object({
    response_card = optional(string)
    messages = list(object({
      content      = string
      content_type = string
      group_number = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.conclusion_statement == null || (
      length(var.conclusion_statement.messages) >= 1 && length(var.conclusion_statement.messages) <= 15
    )
    error_message = "resource_aws_lex_intent, conclusion_statement messages must contain between 1 and 15 messages."
  }

  validation {
    condition = var.conclusion_statement == null || alltrue([
      for msg in var.conclusion_statement.messages : length(msg.content) <= 1000
    ])
    error_message = "resource_aws_lex_intent, conclusion_statement message content must be less than or equal to 1000 characters in length."
  }

  validation {
    condition = var.conclusion_statement == null || alltrue([
      for msg in var.conclusion_statement.messages : msg.group_number == null || (msg.group_number >= 1 && msg.group_number <= 5)
    ])
    error_message = "resource_aws_lex_intent, conclusion_statement message group_number must be a number between 1 and 5 (inclusive)."
  }

  validation {
    condition     = var.conclusion_statement == null || var.conclusion_statement.response_card == null || length(var.conclusion_statement.response_card) <= 50000
    error_message = "resource_aws_lex_intent, conclusion_statement response_card must be less than or equal to 50000 characters in length."
  }
}

variable "dialog_code_hook" {
  description = "Specifies a Lambda function to invoke for each user input."
  type = object({
    message_version = string
    uri             = string
  })
  default = null

  validation {
    condition     = var.dialog_code_hook == null || length(var.dialog_code_hook.message_version) <= 5
    error_message = "resource_aws_lex_intent, dialog_code_hook message_version must be less than or equal to 5 characters in length."
  }
}

variable "follow_up_prompt" {
  description = "Amazon Lex uses this prompt to solicit additional activity after fulfilling an intent."
  type = object({
    prompt = object({
      max_attempts  = number
      response_card = optional(string)
      messages = list(object({
        content      = string
        content_type = string
        group_number = optional(number)
      }))
    })
    rejection_statement = optional(object({
      response_card = optional(string)
      messages = list(object({
        content      = string
        content_type = string
        group_number = optional(number)
      }))
    }))
  })
  default = null

  validation {
    condition     = var.follow_up_prompt == null || (var.follow_up_prompt.prompt.max_attempts >= 1 && var.follow_up_prompt.prompt.max_attempts <= 5)
    error_message = "resource_aws_lex_intent, follow_up_prompt prompt max_attempts must be a number between 1 and 5 (inclusive)."
  }

  validation {
    condition = var.follow_up_prompt == null || (
      length(var.follow_up_prompt.prompt.messages) >= 1 && length(var.follow_up_prompt.prompt.messages) <= 15
    )
    error_message = "resource_aws_lex_intent, follow_up_prompt prompt messages must contain between 1 and 15 messages."
  }

  validation {
    condition = var.follow_up_prompt == null || alltrue([
      for msg in var.follow_up_prompt.prompt.messages : length(msg.content) <= 1000
    ])
    error_message = "resource_aws_lex_intent, follow_up_prompt prompt message content must be less than or equal to 1000 characters in length."
  }

  validation {
    condition = var.follow_up_prompt == null || alltrue([
      for msg in var.follow_up_prompt.prompt.messages : msg.group_number == null || (msg.group_number >= 1 && msg.group_number <= 5)
    ])
    error_message = "resource_aws_lex_intent, follow_up_prompt prompt message group_number must be a number between 1 and 5 (inclusive)."
  }

  validation {
    condition     = var.follow_up_prompt == null || var.follow_up_prompt.prompt.response_card == null || length(var.follow_up_prompt.prompt.response_card) <= 50000
    error_message = "resource_aws_lex_intent, follow_up_prompt prompt response_card must be less than or equal to 50000 characters in length."
  }

  validation {
    condition = var.follow_up_prompt == null || var.follow_up_prompt.rejection_statement == null || (
      length(var.follow_up_prompt.rejection_statement.messages) >= 1 && length(var.follow_up_prompt.rejection_statement.messages) <= 15
    )
    error_message = "resource_aws_lex_intent, follow_up_prompt rejection_statement messages must contain between 1 and 15 messages."
  }

  validation {
    condition = var.follow_up_prompt == null || var.follow_up_prompt.rejection_statement == null || alltrue([
      for msg in var.follow_up_prompt.rejection_statement.messages : length(msg.content) <= 1000
    ])
    error_message = "resource_aws_lex_intent, follow_up_prompt rejection_statement message content must be less than or equal to 1000 characters in length."
  }

  validation {
    condition = var.follow_up_prompt == null || var.follow_up_prompt.rejection_statement == null || alltrue([
      for msg in var.follow_up_prompt.rejection_statement.messages : msg.group_number == null || (msg.group_number >= 1 && msg.group_number <= 5)
    ])
    error_message = "resource_aws_lex_intent, follow_up_prompt rejection_statement message group_number must be a number between 1 and 5 (inclusive)."
  }

  validation {
    condition     = var.follow_up_prompt == null || var.follow_up_prompt.rejection_statement == null || var.follow_up_prompt.rejection_statement.response_card == null || length(var.follow_up_prompt.rejection_statement.response_card) <= 50000
    error_message = "resource_aws_lex_intent, follow_up_prompt rejection_statement response_card must be less than or equal to 50000 characters in length."
  }
}

variable "fulfillment_activity" {
  description = "Describes how the intent is fulfilled. For example, after a user provides all of the information for a pizza order, fulfillment_activity defines how the bot places an order with a local pizza store."
  type = object({
    type = string
    code_hook = optional(object({
      message_version = string
      uri             = string
    }))
  })

  validation {
    condition     = contains(["ReturnIntent", "CodeHook"], var.fulfillment_activity.type)
    error_message = "resource_aws_lex_intent, fulfillment_activity type can be either ReturnIntent or CodeHook."
  }

  validation {
    condition     = var.fulfillment_activity.code_hook == null || length(var.fulfillment_activity.code_hook.message_version) <= 5
    error_message = "resource_aws_lex_intent, fulfillment_activity code_hook message_version must be less than or equal to 5 characters in length."
  }
}

variable "rejection_statement" {
  description = "When the user answers no to the question defined in confirmation_prompt, Amazon Lex responds with this statement to acknowledge that the intent was canceled."
  type = object({
    response_card = optional(string)
    messages = list(object({
      content      = string
      content_type = string
      group_number = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.rejection_statement == null || (
      length(var.rejection_statement.messages) >= 1 && length(var.rejection_statement.messages) <= 15
    )
    error_message = "resource_aws_lex_intent, rejection_statement messages must contain between 1 and 15 messages."
  }

  validation {
    condition = var.rejection_statement == null || alltrue([
      for msg in var.rejection_statement.messages : length(msg.content) <= 1000
    ])
    error_message = "resource_aws_lex_intent, rejection_statement message content must be less than or equal to 1000 characters in length."
  }

  validation {
    condition = var.rejection_statement == null || alltrue([
      for msg in var.rejection_statement.messages : msg.group_number == null || (msg.group_number >= 1 && msg.group_number <= 5)
    ])
    error_message = "resource_aws_lex_intent, rejection_statement message group_number must be a number between 1 and 5 (inclusive)."
  }

  validation {
    condition     = var.rejection_statement == null || var.rejection_statement.response_card == null || length(var.rejection_statement.response_card) <= 50000
    error_message = "resource_aws_lex_intent, rejection_statement response_card must be less than or equal to 50000 characters in length."
  }
}

variable "slots" {
  description = "An list of intent slots. At runtime, Amazon Lex elicits required slot values from the user using prompts defined in the slots."
  type = list(object({
    name              = string
    slot_constraint   = string
    description       = optional(string)
    priority          = optional(number)
    response_card     = optional(string)
    sample_utterances = optional(list(string))
    slot_type         = optional(string)
    slot_type_version = optional(string)
    value_elicitation_prompt = optional(object({
      max_attempts  = number
      response_card = optional(string)
      messages = list(object({
        content      = string
        content_type = string
        group_number = optional(number)
      }))
    }))
  }))
  default = []

  validation {
    condition     = alltrue([for slot in var.slots : length(slot.name) <= 100])
    error_message = "resource_aws_lex_intent, slot name must be less than or equal to 100 characters in length."
  }

  validation {
    condition     = alltrue([for slot in var.slots : slot.description == null || length(slot.description) <= 200])
    error_message = "resource_aws_lex_intent, slot description must be less than or equal to 200 characters in length."
  }

  validation {
    condition     = alltrue([for slot in var.slots : slot.priority == null || (slot.priority >= 1 && slot.priority <= 100)])
    error_message = "resource_aws_lex_intent, slot priority must be between 1 and 100."
  }

  validation {
    condition     = alltrue([for slot in var.slots : slot.response_card == null || length(slot.response_card) <= 50000])
    error_message = "resource_aws_lex_intent, slot response_card must be less than or equal to 50000 characters in length."
  }

  validation {
    condition     = alltrue([for slot in var.slots : slot.sample_utterances == null || (length(slot.sample_utterances) >= 1 && length(slot.sample_utterances) <= 10)])
    error_message = "resource_aws_lex_intent, slot sample_utterances must have between 1 and 10 items in the list."
  }

  validation {
    condition = alltrue([for slot in var.slots :
      slot.sample_utterances == null || alltrue([for utterance in slot.sample_utterances : length(utterance) <= 200])
    ])
    error_message = "resource_aws_lex_intent, slot sample_utterances each item must be less than or equal to 200 characters in length."
  }

  validation {
    condition     = alltrue([for slot in var.slots : slot.slot_type == null || length(slot.slot_type) <= 100])
    error_message = "resource_aws_lex_intent, slot slot_type must be less than or equal to 100 characters in length."
  }

  validation {
    condition     = alltrue([for slot in var.slots : slot.slot_type_version == null || length(slot.slot_type_version) <= 64])
    error_message = "resource_aws_lex_intent, slot slot_type_version must be less than or equal to 64 characters in length."
  }

  validation {
    condition = alltrue([for slot in var.slots :
      slot.value_elicitation_prompt == null || (slot.value_elicitation_prompt.max_attempts >= 1 && slot.value_elicitation_prompt.max_attempts <= 5)
    ])
    error_message = "resource_aws_lex_intent, slot value_elicitation_prompt max_attempts must be a number between 1 and 5 (inclusive)."
  }

  validation {
    condition = alltrue([for slot in var.slots :
      slot.value_elicitation_prompt == null || (length(slot.value_elicitation_prompt.messages) >= 1 && length(slot.value_elicitation_prompt.messages) <= 15)
    ])
    error_message = "resource_aws_lex_intent, slot value_elicitation_prompt messages must contain between 1 and 15 messages."
  }

  validation {
    condition = alltrue([for slot in var.slots :
      slot.value_elicitation_prompt == null || alltrue([for msg in slot.value_elicitation_prompt.messages : length(msg.content) <= 1000])
    ])
    error_message = "resource_aws_lex_intent, slot value_elicitation_prompt message content must be less than or equal to 1000 characters in length."
  }

  validation {
    condition = alltrue([for slot in var.slots :
      slot.value_elicitation_prompt == null || alltrue([for msg in slot.value_elicitation_prompt.messages : msg.group_number == null || (msg.group_number >= 1 && msg.group_number <= 5)])
    ])
    error_message = "resource_aws_lex_intent, slot value_elicitation_prompt message group_number must be a number between 1 and 5 (inclusive)."
  }

  validation {
    condition = alltrue([for slot in var.slots :
      slot.value_elicitation_prompt == null || slot.value_elicitation_prompt.response_card == null || length(slot.value_elicitation_prompt.response_card) <= 50000
    ])
    error_message = "resource_aws_lex_intent, slot value_elicitation_prompt response_card must be less than or equal to 50000 characters in length."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "1m")
    update = optional(string, "1m")
    delete = optional(string, "5m")
  })
  default = {
    create = "1m"
    update = "1m"
    delete = "5m"
  }
}