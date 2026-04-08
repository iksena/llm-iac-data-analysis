variable "function_name" {
  type        = string
  description = "Name or ARN of the Lambda function"

  validation {
    condition     = length(var.function_name) > 0
    error_message = "data_aws_lambda_function_url, function_name must not be empty."
  }
}

variable "qualifier" {
  type        = string
  description = "Alias name or $LATEST"
  default     = null
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  default     = null
}