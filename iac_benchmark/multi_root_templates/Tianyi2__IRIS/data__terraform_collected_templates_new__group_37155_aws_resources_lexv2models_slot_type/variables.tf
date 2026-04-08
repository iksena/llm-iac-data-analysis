variable "bot_id" {
  description = "Identifier of the bot associated with this slot type"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.bot_id))
    error_message = "resource_aws_lexv2models_slot_type, bot_id must be a valid bot identifier."
  }
}

variable "bot_version" {
  description = "Version of the bot associated with this slot type"
  type        = string

  validation {
    condition     = var.bot_version != ""
    error_message = "resource_aws_lexv2models_slot_type, bot_version cannot be empty."
  }
}

variable "locale_id" {
  description = "Identifier of the language and locale where this slot type is used"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}_[A-Z]{2}$", var.locale_id))
    error_message = "resource_aws_lexv2models_slot_type, locale_id must be in the format 'xx_XX' (e.g., 'en_US')."
  }
}

variable "name" {
  description = "Name of the slot type"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.name)) && length(var.name) >= 1 && length(var.name) <= 100
    error_message = "resource_aws_lexv2models_slot_type, name must be 1-100 characters, start with alphanumeric, and contain only alphanumeric, underscore, or hyphen characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the slot type"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 200
    error_message = "resource_aws_lexv2models_slot_type, description must be 200 characters or less."
  }
}

variable "composite_slot_type_setting" {
  description = "Specifications for a composite slot type"
  type = object({
    sub_slots = optional(list(object({
      name         = string
      slot_type_id = string
    })))
  })
  default = null

  validation {
    condition = var.composite_slot_type_setting == null || (
      var.composite_slot_type_setting.sub_slots == null ||
      alltrue([
        for sub_slot in var.composite_slot_type_setting.sub_slots :
        can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", sub_slot.name)) &&
        length(sub_slot.name) >= 1 && length(sub_slot.name) <= 100 &&
        sub_slot.slot_type_id != ""
      ])
    )
    error_message = "resource_aws_lexv2models_slot_type, composite_slot_type_setting sub_slots must have valid names (1-100 chars, alphanumeric start) and non-empty slot_type_id."
  }
}

variable "external_source_setting" {
  description = "Type of external information used to create the slot type"
  type = object({
    grammar_slot_type_setting = optional(object({
      source = optional(object({
        s3_bucket_name = string
        s3_object_key  = string
        kms_key_arn    = optional(string)
      }))
    }))
  })
  default = null

  validation {
    condition = var.external_source_setting == null || (
      var.external_source_setting.grammar_slot_type_setting == null ||
      var.external_source_setting.grammar_slot_type_setting.source == null ||
      (
        var.external_source_setting.grammar_slot_type_setting.source.s3_bucket_name != "" &&
        var.external_source_setting.grammar_slot_type_setting.source.s3_object_key != ""
      )
    )
    error_message = "resource_aws_lexv2models_slot_type, external_source_setting grammar source must have non-empty s3_bucket_name and s3_object_key."
  }
}

variable "parent_slot_type_signature" {
  description = "Built-in slot type used as a parent of this slot type"
  type        = string
  default     = null

  validation {
    condition     = var.parent_slot_type_signature == null || var.parent_slot_type_signature == "AMAZON.AlphaNumeric"
    error_message = "resource_aws_lexv2models_slot_type, parent_slot_type_signature only supports 'AMAZON.AlphaNumeric'."
  }
}

variable "slot_type_values" {
  description = "List of SlotTypeValue objects that defines the values that the slot type can take"
  type = list(object({
    sample_value = optional(object({
      value = string
    }))
    synonyms = optional(list(object({
      value = string
    })))
  }))
  default = null

  validation {
    condition = var.slot_type_values == null || alltrue([
      for slot_value in var.slot_type_values :
      slot_value.sample_value == null || slot_value.sample_value.value != ""
    ])
    error_message = "resource_aws_lexv2models_slot_type, slot_type_values sample_value must have non-empty value."
  }

  validation {
    condition = var.slot_type_values == null || alltrue([
      for slot_value in var.slot_type_values :
      slot_value.synonyms == null || alltrue([
        for synonym in slot_value.synonyms : synonym.value != ""
      ])
    ])
    error_message = "resource_aws_lexv2models_slot_type, slot_type_values synonyms must have non-empty values."
  }
}

variable "value_selection_setting" {
  description = "Determines the strategy that Amazon Lex uses to select a value from the list of possible values"
  type = object({
    resolution_strategy = string
    advanced_recognition_setting = optional(object({
      audio_recognition_strategy = optional(string)
    }))
    regex_filter = optional(object({
      pattern = string
    }))
  })
  default = null

  validation {
    condition = var.value_selection_setting == null || contains([
      "OriginalValue", "TopResolution", "Concatenation"
    ], var.value_selection_setting.resolution_strategy)
    error_message = "resource_aws_lexv2models_slot_type, value_selection_setting resolution_strategy must be 'OriginalValue', 'TopResolution', or 'Concatenation'."
  }

  validation {
    condition     = var.value_selection_setting == null || var.value_selection_setting.advanced_recognition_setting == null || var.value_selection_setting.advanced_recognition_setting.audio_recognition_strategy == null || var.value_selection_setting.advanced_recognition_setting.audio_recognition_strategy == "UseSlotValuesAsCustomVocabulary"
    error_message = "resource_aws_lexv2models_slot_type, value_selection_setting advanced_recognition_setting audio_recognition_strategy must be 'UseSlotValuesAsCustomVocabulary'."
  }

  validation {
    condition     = var.value_selection_setting == null || var.value_selection_setting.regex_filter == null || var.value_selection_setting.regex_filter.pattern != ""
    error_message = "resource_aws_lexv2models_slot_type, value_selection_setting regex_filter pattern cannot be empty."
  }
}