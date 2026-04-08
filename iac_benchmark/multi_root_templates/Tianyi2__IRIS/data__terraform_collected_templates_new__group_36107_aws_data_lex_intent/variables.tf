variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the intent. The name is case sensitive."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_lex_intent, name must not be empty."
  }
}

variable "intent_version" {
  description = "Version of the intent."
  type        = string
  default     = null
}