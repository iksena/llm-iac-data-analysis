variable "name" {
  description = "Name of the bot. The bot name must be unique in the account that creates the bot."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 100
    error_message = "resource_aws_lexv2models_bot, name must be between 1 and 100 characters in length."
  }
}

variable "description" {
  description = "Description of the bot. It appears in lists to help you identify a particular bot."
  type        = string
  default     = null
}

variable "data_privacy" {
  description = "Provides information on additional privacy protections Amazon Lex should use with the bot's data."
  type = object({
    child_directed = bool
  })

  validation {
    condition     = can(var.data_privacy.child_directed)
    error_message = "resource_aws_lexv2models_bot, data_privacy.child_directed is required and must be a boolean value."
  }
}

variable "idle_session_ttl_in_seconds" {
  description = "Time, in seconds, that Amazon Lex should keep information about a user's conversation with the bot."
  type        = number

  validation {
    condition     = var.idle_session_ttl_in_seconds >= 60 && var.idle_session_ttl_in_seconds <= 86400
    error_message = "resource_aws_lexv2models_bot, idle_session_ttl_in_seconds must be between 60 (1 minute) and 86,400 (24 hours) seconds."
  }
}

variable "role_arn" {
  description = "ARN of an IAM role that has permission to access the bot."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_lexv2models_bot, role_arn must be a valid IAM role ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "members" {
  description = "List of bot members in a network to be created."
  type = list(object({
    alias_id   = string
    alias_name = string
    id         = string
    name       = string
    version    = string
  }))
  default = null

  validation {
    condition = var.members == null || alltrue([
      for member in var.members : can(member.alias_id) && can(member.alias_name) && can(member.id) && can(member.name) && can(member.version)
    ])
    error_message = "resource_aws_lexv2models_bot, members must contain alias_id, alias_name, id, name, and version for each member."
  }
}

variable "tags" {
  description = "List of tags to add to the bot. You can only add tags when you create a bot."
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Type of a bot to create."
  type        = string
  default     = "Bot"

  validation {
    condition     = contains(["Bot", "BotNetwork"], var.type)
    error_message = "resource_aws_lexv2models_bot, type must be either 'Bot' or 'BotNetwork'."
  }
}

variable "test_bot_alias_tags" {
  description = "List of tags to add to the test alias for a bot. You can only add tags when you create a bot."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
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