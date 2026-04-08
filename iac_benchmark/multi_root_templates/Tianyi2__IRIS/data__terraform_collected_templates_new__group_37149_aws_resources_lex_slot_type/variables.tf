variable "name" {
  description = "The name of the slot type. The name is not case sensitive. Must be less than or equal to 100 characters in length."
  type        = string

  validation {
    condition     = length(var.name) <= 100
    error_message = "resource_aws_lex_slot_type, name must be less than or equal to 100 characters in length."
  }
}

variable "enumeration_value" {
  description = "A list of EnumerationValue objects that defines the values that the slot type can take. Each value can have a list of synonyms, which are additional values that help train the machine learning model about the values that it resolves for a slot."
  type = list(object({
    value    = string
    synonyms = optional(list(string))
  }))

  validation {
    condition = alltrue([
      for ev in var.enumeration_value : length(ev.value) <= 140
    ])
    error_message = "resource_aws_lex_slot_type, enumeration_value value must be less than or equal to 140 characters in length."
  }

  validation {
    condition = alltrue([
      for ev in var.enumeration_value : ev.synonyms == null ? true : alltrue([
        for synonym in ev.synonyms : length(synonym) <= 140
      ])
    ])
    error_message = "resource_aws_lex_slot_type, enumeration_value synonyms must each be less than or equal to 140 characters in length."
  }
}

variable "create_version" {
  description = "Determines if a new slot type version is created when the initial resource is created and on each update. Defaults to false."
  type        = bool
  default     = false
}

variable "description" {
  description = "A description of the slot type. Must be less than or equal to 200 characters in length."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 200
    error_message = "resource_aws_lex_slot_type, description must be less than or equal to 200 characters in length."
  }
}

variable "value_selection_strategy" {
  description = "Determines the slot resolution strategy that Amazon Lex uses to return slot type values. ORIGINAL_VALUE returns the value entered by the user if the user value is similar to the slot value. TOP_RESOLUTION returns the first value in the resolution list if there is a resolution list for the slot, otherwise null is returned. Defaults to ORIGINAL_VALUE."
  type        = string
  default     = "ORIGINAL_VALUE"

  validation {
    condition     = contains(["ORIGINAL_VALUE", "TOP_RESOLUTION"], var.value_selection_strategy)
    error_message = "resource_aws_lex_slot_type, value_selection_strategy must be either ORIGINAL_VALUE or TOP_RESOLUTION."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "1m")
    update = optional(string, "1m")
    delete = optional(string, "5m")
  })
  default = null
}