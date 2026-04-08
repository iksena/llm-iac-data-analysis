variable "name" {
  type        = string
  description = "Name of the bot. The name is case sensitive."

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_lex_bot, name must not be empty."
  }
}

variable "bot_version" {
  type        = string
  description = "Version or alias of the bot."
  default     = null
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}