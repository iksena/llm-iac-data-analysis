variable "function_name" {
  description = "Name of the Lambda function."
  type        = string

  validation {
    condition     = var.function_name != null && var.function_name != ""
    error_message = "data_aws_lambda_function, function_name must not be null or empty."
  }
}

variable "qualifier" {
  description = "Alias name or version number of the Lambda function. E.g., $LATEST, my-alias, or 1. When not included: the data source resolves to the most recent published version; if no published version exists: it resolves to the most recent unpublished version."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}