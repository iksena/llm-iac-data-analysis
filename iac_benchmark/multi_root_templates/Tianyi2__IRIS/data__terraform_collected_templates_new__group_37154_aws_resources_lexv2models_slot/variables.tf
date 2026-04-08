variable "bot_id" {
  description = "Identifier of the bot associated with the slot"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.bot_id))
    error_message = "resource_aws_lexv2models_slot, bot_id must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "bot_version" {
  description = "Version of the bot associated with the slot"
  type        = string

  validation {
    condition     = can(regex("^[0-9]+$", var.bot_version)) || var.bot_version == "DRAFT"
    error_message = "resource_aws_lexv2models_slot, bot_version must be a numeric version or 'DRAFT'."
  }
}

variable "intent_id" {
  description = "Identifier of the intent that contains the slot"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.intent_id))
    error_message = "resource_aws_lexv2models_slot, intent_id must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "locale_id" {
  description = "Identifier of the language and locale that the slot will be used in"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}_[A-Z]{2}$", var.locale_id))
    error_message = "resource_aws_lexv2models_slot, locale_id must be in the format 'xx_XX' (e.g., 'en_US')."
  }
}

variable "name" {
  description = "Name of the slot"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.name))
    error_message = "resource_aws_lexv2models_slot, name must start with a letter and contain only alphanumeric characters and underscores."
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 100
    error_message = "resource_aws_lexv2models_slot, name must be between 1 and 100 characters long."
  }
}

variable "value_elicitation_setting" {
  description = "Prompts that Amazon Lex sends to the user to elicit a response that provides the value for the slot"
  type = object({
    slot_constraint = string
    default_value_specification = optional(object({
      default_value_list = list(object({
        default_value = string
      }))
    }))
    prompt_specification = optional(object({
      allow_interrupt            = optional(bool)
      max_retries                = number
      message_selection_strategy = optional(string)
      message_group = list(object({
        message = object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title     = string
            subtitle  = optional(string)
            image_url = optional(string)
            button = optional(list(object({
              text  = string
              value = string
            })))
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })
        variation = optional(list(object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title     = string
            subtitle  = optional(string)
            image_url = optional(string)
            button = optional(list(object({
              text  = string
              value = string
            })))
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })))
      }))
      prompt_attempts_specification = optional(list(object({
        allow_interrupt = bool
        map_block_key   = string
        allowed_input_types = optional(object({
          allow_audio_input = bool
          allow_dtmf_input  = bool
        }))
        audio_and_dtmf_input_specification = optional(object({
          start_timeout_ms = number
          audio_specification = optional(object({
            end_timeout_ms = number
            max_length_ms  = number
          }))
          dtmf_specification = optional(object({
            deletion_character = string
            end_character      = string
            end_timeout_ms     = number
            max_length         = number
          }))
        }))
        text_input_specification = optional(object({
          start_timeout_ms = number
        }))
      })))
    }))
    sample_utterances = optional(list(object({
      utterance = string
    })))
    slot_resolution_setting = optional(object({
      slot_resolution_strategy = string
    }))
    wait_and_continue_specification = optional(object({
      active = optional(bool)
      continue_response = object({
        allow_interrupt = optional(bool)
        message_group = list(object({
          message = object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title     = string
              subtitle  = optional(string)
              image_url = optional(string)
              button = optional(list(object({
                text  = string
                value = string
              })))
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })
          variation = optional(list(object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title     = string
              subtitle  = optional(string)
              image_url = optional(string)
              button = optional(list(object({
                text  = string
                value = string
              })))
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })))
        }))
      })
      waiting_response = object({
        allow_interrupt = optional(bool)
        message_group = list(object({
          message = object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title     = string
              subtitle  = optional(string)
              image_url = optional(string)
              button = optional(list(object({
                text  = string
                value = string
              })))
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })
          variation = optional(list(object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title     = string
              subtitle  = optional(string)
              image_url = optional(string)
              button = optional(list(object({
                text  = string
                value = string
              })))
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })))
        }))
      })
      still_waiting_response = optional(object({
        allow_interrupt      = optional(bool)
        frequency_in_seconds = number
        timeout_in_seconds   = number
        message_groups = list(object({
          message = object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title     = string
              subtitle  = optional(string)
              image_url = optional(string)
              button = optional(list(object({
                text  = string
                value = string
              })))
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })
          variation = optional(list(object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title     = string
              subtitle  = optional(string)
              image_url = optional(string)
              button = optional(list(object({
                text  = string
                value = string
              })))
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })))
        }))
      }))
    }))
  })

  validation {
    condition     = contains(["Required", "Optional"], var.value_elicitation_setting.slot_constraint)
    error_message = "resource_aws_lexv2models_slot, value_elicitation_setting.slot_constraint must be either 'Required' or 'Optional'."
  }

  validation {
    condition     = var.value_elicitation_setting.slot_resolution_setting == null || contains(["EnhancedFallback", "Default"], var.value_elicitation_setting.slot_resolution_setting.slot_resolution_strategy)
    error_message = "resource_aws_lexv2models_slot, value_elicitation_setting.slot_resolution_setting.slot_resolution_strategy must be either 'EnhancedFallback' or 'Default'."
  }

  validation {
    condition     = var.value_elicitation_setting.prompt_specification == null || var.value_elicitation_setting.prompt_specification.message_selection_strategy == null || contains(["Random", "Ordered"], var.value_elicitation_setting.prompt_specification.message_selection_strategy)
    error_message = "resource_aws_lexv2models_slot, value_elicitation_setting.prompt_specification.message_selection_strategy must be either 'Random' or 'Ordered'."
  }

  validation {
    condition     = var.value_elicitation_setting.prompt_specification == null || var.value_elicitation_setting.prompt_specification.max_retries >= 0 && var.value_elicitation_setting.prompt_specification.max_retries <= 5
    error_message = "resource_aws_lexv2models_slot, value_elicitation_setting.prompt_specification.max_retries must be between 0 and 5."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_lexv2models_slot, region must be a valid AWS region format (e.g., 'us-east-1')."
  }
}

variable "description" {
  description = "Description of the slot"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || (length(var.description) >= 0 && length(var.description) <= 200)
    error_message = "resource_aws_lexv2models_slot, description must be between 0 and 200 characters long."
  }
}

variable "multiple_values_setting" {
  description = "Whether the slot returns multiple values in one response"
  type = object({
    allow_multiple_values = optional(bool)
  })
  default = null
}

variable "obfuscation_setting" {
  description = "Determines how slot values are used in Amazon CloudWatch logs"
  type = object({
    obfuscation_setting_type = string
  })
  default = null

  validation {
    condition     = var.obfuscation_setting == null || contains(["DefaultObfuscation", "None"], var.obfuscation_setting.obfuscation_setting_type)
    error_message = "resource_aws_lexv2models_slot, obfuscation_setting.obfuscation_setting_type must be either 'DefaultObfuscation' or 'None'."
  }
}

variable "slot_type_id" {
  description = "Unique identifier for the slot type associated with this slot"
  type        = string
  default     = null

  validation {
    condition     = var.slot_type_id == null || can(regex("^[a-zA-Z0-9_-]+$", var.slot_type_id))
    error_message = "resource_aws_lexv2models_slot, slot_type_id must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "sub_slot_setting" {
  description = "Specifications for the constituent sub slots and the expression for the composite slot"
  type = object({
    expression = optional(string)
    slot_specification = optional(list(object({
      slot_type_id = string
      value_elicitation_setting = object({
        slot_constraint = string
        default_value_specification = optional(object({
          default_value_list = list(object({
            default_value = string
          }))
        }))
        sample_utterances = optional(list(object({
          utterance = string
        })))
        slot_resolution_setting = optional(object({
          slot_resolution_strategy = string
        }))
      })
    })))
  })
  default = null

  validation {
    condition = var.sub_slot_setting == null || var.sub_slot_setting.slot_specification == null || alltrue([
      for spec in var.sub_slot_setting.slot_specification :
      contains(["Required", "Optional"], spec.value_elicitation_setting.slot_constraint)
    ])
    error_message = "resource_aws_lexv2models_slot, sub_slot_setting.slot_specification.value_elicitation_setting.slot_constraint must be either 'Required' or 'Optional'."
  }

  validation {
    condition = var.sub_slot_setting == null || var.sub_slot_setting.slot_specification == null || alltrue([
      for spec in var.sub_slot_setting.slot_specification :
      spec.value_elicitation_setting.slot_resolution_setting == null || contains(["EnhancedFallback", "Default"], spec.value_elicitation_setting.slot_resolution_setting.slot_resolution_strategy)
    ])
    error_message = "resource_aws_lexv2models_slot, sub_slot_setting.slot_specification.value_elicitation_setting.slot_resolution_setting.slot_resolution_strategy must be either 'EnhancedFallback' or 'Default'."
  }

  validation {
    condition = var.sub_slot_setting == null || var.sub_slot_setting.slot_specification == null || alltrue([
      for spec in var.sub_slot_setting.slot_specification :
      can(regex("^[a-zA-Z0-9_-]+$", spec.slot_type_id))
    ])
    error_message = "resource_aws_lexv2models_slot, sub_slot_setting.slot_specification.slot_type_id must contain only alphanumeric characters, hyphens, and underscores."
  }
}