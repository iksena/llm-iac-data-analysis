variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bot_name" {
  description = "The name of the bot."
  type        = string

  validation {
    condition     = length(var.bot_name) > 0
    error_message = "resource_aws_lex_bot_alias, bot_name must not be empty."
  }
}

variable "bot_version" {
  description = "The version of the bot."
  type        = string

  validation {
    condition     = length(var.bot_version) > 0
    error_message = "resource_aws_lex_bot_alias, bot_version must not be empty."
  }
}

variable "description" {
  description = "A description of the alias. Must be less than or equal to 200 characters in length."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 200
    error_message = "resource_aws_lex_bot_alias, description must be less than or equal to 200 characters in length."
  }
}

variable "name" {
  description = "The name of the alias. The name is not case sensitive. Must be less than or equal to 100 characters in length."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 100
    error_message = "resource_aws_lex_bot_alias, name must be between 1 and 100 characters in length."
  }
}

variable "conversation_logs" {
  description = "The settings that determine how Amazon Lex uses conversation logs for the alias."
  type = object({
    iam_role_arn = string
    log_settings = optional(list(object({
      destination  = string
      kms_key_arn  = optional(string)
      log_type     = string
      resource_arn = string
    })))
  })
  default = null

  validation {
    condition = var.conversation_logs == null || (
      length(var.conversation_logs.iam_role_arn) >= 20 &&
      length(var.conversation_logs.iam_role_arn) <= 2048
    )
    error_message = "resource_aws_lex_bot_alias, conversation_logs.iam_role_arn must be between 20 and 2048 characters in length."
  }

  validation {
    condition = var.conversation_logs == null || var.conversation_logs.log_settings == null || alltrue([
      for log_setting in var.conversation_logs.log_settings :
      contains(["CLOUDWATCH_LOGS", "S3"], log_setting.destination)
    ])
    error_message = "resource_aws_lex_bot_alias, conversation_logs.log_settings.destination must be either 'CLOUDWATCH_LOGS' or 'S3'."
  }

  validation {
    condition = var.conversation_logs == null || var.conversation_logs.log_settings == null || alltrue([
      for log_setting in var.conversation_logs.log_settings :
      log_setting.kms_key_arn == null || (
        length(log_setting.kms_key_arn) >= 20 &&
        length(log_setting.kms_key_arn) <= 2048
      )
    ])
    error_message = "resource_aws_lex_bot_alias, conversation_logs.log_settings.kms_key_arn must be between 20 and 2048 characters in length when specified."
  }

  validation {
    condition = var.conversation_logs == null || var.conversation_logs.log_settings == null || alltrue([
      for log_setting in var.conversation_logs.log_settings :
      log_setting.kms_key_arn == null || log_setting.destination == "S3"
    ])
    error_message = "resource_aws_lex_bot_alias, conversation_logs.log_settings.kms_key_arn can only be specified when destination is set to 'S3'."
  }

  validation {
    condition = var.conversation_logs == null || var.conversation_logs.log_settings == null || alltrue([
      for log_setting in var.conversation_logs.log_settings :
      contains(["AUDIO", "TEXT"], log_setting.log_type)
    ])
    error_message = "resource_aws_lex_bot_alias, conversation_logs.log_settings.log_type must be either 'AUDIO' or 'TEXT'."
  }

  validation {
    condition = var.conversation_logs == null || var.conversation_logs.log_settings == null || alltrue([
      for log_setting in var.conversation_logs.log_settings :
      length(log_setting.resource_arn) <= 2048
    ])
    error_message = "resource_aws_lex_bot_alias, conversation_logs.log_settings.resource_arn must be less than or equal to 2048 characters in length."
  }
}