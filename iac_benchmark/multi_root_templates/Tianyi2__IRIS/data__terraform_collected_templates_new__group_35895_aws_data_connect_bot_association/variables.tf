variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Identifier of the Amazon Connect instance. You can find the instanceId in the ARN of the instance."
  type        = string

  validation {
    condition     = can(regex("^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$", var.instance_id))
    error_message = "data_aws_connect_bot_association, instance_id must be a valid UUID format."
  }
}

variable "lex_bot_name" {
  description = "Name of the Amazon Lex (V1) bot."
  type        = string

  validation {
    condition     = length(var.lex_bot_name) > 0
    error_message = "data_aws_connect_bot_association, lex_bot_name cannot be empty."
  }
}

variable "lex_bot_lex_region" {
  description = "Region that the Amazon Lex (V1) bot was created in."
  type        = string
  default     = null
}