variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "bot_name" {
  type        = string
  description = "Name of the bot."

  validation {
    condition     = var.bot_name != null && var.bot_name != ""
    error_message = "data_aws_lex_bot_alias, bot_name must be a non-empty string."
  }
}

variable "name" {
  type        = string
  description = "Name of the bot alias. The name is case sensitive."

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "data_aws_lex_bot_alias, name must be a non-empty string."
  }
}