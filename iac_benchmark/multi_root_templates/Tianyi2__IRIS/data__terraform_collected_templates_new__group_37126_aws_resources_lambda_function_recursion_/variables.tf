variable "function_name" {
  description = "Name of the Lambda function"
  type        = string

  validation {
    condition     = length(var.function_name) > 0
    error_message = "resource_aws_lambda_function_recursion_config, function_name must not be empty."
  }
}

variable "recursive_loop" {
  description = "Lambda function recursion configuration. Valid values are Allow or Terminate"
  type        = string

  validation {
    condition     = contains(["Allow", "Terminate"], var.recursive_loop)
    error_message = "resource_aws_lambda_function_recursion_config, recursive_loop must be either 'Allow' or 'Terminate'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}