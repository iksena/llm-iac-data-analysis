variable "name" {
  description = "Name for the alias"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.name)) && !can(regex("^[0-9]+$", var.name))
    error_message = "resource_aws_lambda_alias, name must contain alphanumeric characters, hyphens, or underscores and cannot be only digits."
  }
}

variable "function_name" {
  description = "Name or ARN of the Lambda function"
  type        = string
}

variable "function_version" {
  description = "Lambda function version for which you are creating the alias"
  type        = string

  validation {
    condition     = can(regex("^(\\$LATEST|[0-9]+)$", var.function_version))
    error_message = "resource_aws_lambda_alias, function_version must match pattern (\\$LATEST|[0-9]+)."
  }
}

variable "description" {
  description = "Description of the alias"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "routing_config" {
  description = "Lambda alias' route configuration settings"
  type = object({
    additional_version_weights = optional(map(number))
  })
  default = null
}