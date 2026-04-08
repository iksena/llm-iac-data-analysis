variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_connect_bot_association, region must be a valid AWS region format."
  }
}

variable "instance_id" {
  description = "The identifier of the Amazon Connect instance. You can find the instanceId in the ARN of the instance."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "resource_aws_connect_bot_association, instance_id must be a valid UUID format."
  }
}

variable "lex_bot_name" {
  description = "The name of the Amazon Lex (V1) bot."
  type        = string

  validation {
    condition     = length(var.lex_bot_name) > 0 && length(var.lex_bot_name) <= 50
    error_message = "resource_aws_connect_bot_association, lex_bot_name must be between 1 and 50 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z]([a-zA-Z0-9_])*$", var.lex_bot_name))
    error_message = "resource_aws_connect_bot_association, lex_bot_name must start with a letter and contain only letters, numbers, and underscores."
  }
}

variable "lex_bot_lex_region" {
  description = "The Region that the Amazon Lex (V1) bot was created in. Defaults to current region."
  type        = string
  default     = null

  validation {
    condition     = var.lex_bot_lex_region == null || can(regex("^[a-z0-9-]+$", var.lex_bot_lex_region))
    error_message = "resource_aws_connect_bot_association, lex_bot_lex_region must be a valid AWS region format."
  }
}