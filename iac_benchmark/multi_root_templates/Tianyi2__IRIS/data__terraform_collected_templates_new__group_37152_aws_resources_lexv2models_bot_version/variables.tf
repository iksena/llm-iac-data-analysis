variable "bot_id" {
  description = "Identifier of the bot to create the version for."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.bot_id))
    error_message = "resource_aws_lexv2models_bot_version, bot_id must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "locale_specification" {
  description = "Specifies the locales that Amazon Lex adds to this version. You can choose the draft version or any other previously published version for each locale."
  type = map(object({
    source_bot_version = string
  }))

  validation {
    condition = alltrue([
      for locale, spec in var.locale_specification : can(regex("^[a-z]{2}_[A-Z]{2}$", locale))
    ])
    error_message = "resource_aws_lexv2models_bot_version, locale_specification keys must be in format 'xx_XX' (e.g., 'en_US')."
  }

  validation {
    condition = alltrue([
      for locale, spec in var.locale_specification : spec.source_bot_version == "DRAFT" || can(regex("^[0-9]+$", spec.source_bot_version))
    ])
    error_message = "resource_aws_lexv2models_bot_version, locale_specification source_bot_version must be 'DRAFT' or a numeric version."
  }
}

variable "description" {
  description = "A description of the version. Use the description to help identify the version in lists."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = null
}