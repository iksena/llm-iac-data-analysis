variable "function_name" {
  description = "Name or Amazon Resource Name (ARN) of the Lambda Function"
  type        = string

  validation {
    condition     = length(var.function_name) > 0
    error_message = "resource_aws_lambda_provisioned_concurrency_config, function_name must not be empty."
  }
}

variable "provisioned_concurrent_executions" {
  description = "Amount of capacity to allocate. Must be greater than or equal to 1"
  type        = number

  validation {
    condition     = var.provisioned_concurrent_executions >= 1
    error_message = "resource_aws_lambda_provisioned_concurrency_config, provisioned_concurrent_executions must be greater than or equal to 1."
  }
}

variable "qualifier" {
  description = "Lambda Function version or Lambda Alias name"
  type        = string

  validation {
    condition     = length(var.qualifier) > 0
    error_message = "resource_aws_lambda_provisioned_concurrency_config, qualifier must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "skip_destroy" {
  description = "Whether to retain the provisioned concurrency configuration upon destruction. Defaults to false"
  type        = bool
  default     = false
}