variable "function_name" {
  description = "Name of the aliased Lambda function"
  type        = string

  validation {
    condition     = length(var.function_name) > 0
    error_message = "data_aws_lambda_alias, function_name must not be empty."
  }

  validation {
    condition     = length(var.function_name) <= 140
    error_message = "data_aws_lambda_alias, function_name must be 140 characters or less."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.function_name))
    error_message = "data_aws_lambda_alias, function_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "name" {
  description = "Name of the Lambda alias"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_lambda_alias, name must not be empty."
  }

  validation {
    condition     = length(var.name) <= 128
    error_message = "data_aws_lambda_alias, name must be 128 characters or less."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.name))
    error_message = "data_aws_lambda_alias, name must contain only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = var.name != "$LATEST"
    error_message = "data_aws_lambda_alias, name cannot be '$LATEST'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_lambda_alias, region must be a valid AWS region format."
  }
}