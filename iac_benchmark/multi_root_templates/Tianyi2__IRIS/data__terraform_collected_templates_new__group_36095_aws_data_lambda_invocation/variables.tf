variable "function_name" {
  description = "Name of the Lambda function"
  type        = string

  validation {
    condition     = length(var.function_name) > 0
    error_message = "data_aws_lambda_invocation, function_name must not be empty."
  }
}

variable "input" {
  description = "String in JSON format that is passed as payload to the Lambda function"
  type        = string

  validation {
    condition     = length(var.input) > 0
    error_message = "data_aws_lambda_invocation, input must not be empty."
  }

  validation {
    condition     = can(jsondecode(var.input))
    error_message = "data_aws_lambda_invocation, input must be valid JSON."
  }
}

variable "qualifier" {
  description = "Qualifier (a.k.a version) of the Lambda function. Defaults to $LATEST"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}