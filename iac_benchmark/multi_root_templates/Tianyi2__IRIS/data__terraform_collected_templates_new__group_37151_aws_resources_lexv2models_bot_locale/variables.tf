variable "bot_id" {
  description = "Identifier of the bot to create the locale for."
  type        = string

  validation {
    condition     = length(var.bot_id) > 0
    error_message = "resource_aws_lexv2models_bot_locale, bot_id must be a non-empty string."
  }
}

variable "bot_version" {
  description = "Version of the bot to create the locale for. This can only be the draft version of the bot."
  type        = string

  validation {
    condition     = length(var.bot_version) > 0
    error_message = "resource_aws_lexv2models_bot_locale, bot_version must be a non-empty string."
  }
}

variable "locale_id" {
  description = "Identifier of the language and locale that the bot will be used in. The string must match one of the supported locales."
  type        = string

  validation {
    condition     = length(var.locale_id) > 0
    error_message = "resource_aws_lexv2models_bot_locale, locale_id must be a non-empty string."
  }
}

variable "n_lu_intent_confidence_threshold" {
  description = "Determines the threshold where Amazon Lex will insert the AMAZON.FallbackIntent, AMAZON.KendraSearchIntent, or both when returning alternative intents."
  type        = number

  validation {
    condition     = var.n_lu_intent_confidence_threshold >= 0 && var.n_lu_intent_confidence_threshold <= 1
    error_message = "resource_aws_lexv2models_bot_locale, n_lu_intent_confidence_threshold must be between 0 and 1."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the bot locale. Use this to help identify the bot locale in lists."
  type        = string
  default     = null
}

variable "voice_settings" {
  description = "Amazon Polly voice ID that Amazon Lex uses for voice interaction with the user."
  type = object({
    voice_id = string
    engine   = optional(string, "standard")
  })
  default = null

  validation {
    condition = var.voice_settings == null || (
      var.voice_settings != null &&
      length(var.voice_settings.voice_id) > 0 &&
      contains(["standard", "neural"], var.voice_settings.engine)
    )
    error_message = "resource_aws_lexv2models_bot_locale, voice_settings.voice_id must be a non-empty string and engine must be either 'standard' or 'neural'."
  }
}

variable "timeouts" {
  description = "Timeouts for create, update, and delete operations."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}