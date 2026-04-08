variable "function_name" {
  description = "Name or ARN of the Lambda Function, omitting any version or alias qualifier"
  type        = string

  validation {
    condition     = length(var.function_name) > 0
    error_message = "resource_aws_lambda_function_event_invoke_config, function_name must be a non-empty string."
  }
}

variable "destination_config" {
  description = "Configuration block with destination configuration"
  type = object({
    on_failure = optional(object({
      destination = string
    }))
    on_success = optional(object({
      destination = string
    }))
  })
  default = null

  validation {
    condition = var.destination_config == null || (
      var.destination_config.on_failure != null || var.destination_config.on_success != null
    )
    error_message = "resource_aws_lambda_function_event_invoke_config, destination_config must have at least one of on_failure or on_success configured."
  }
}

variable "maximum_event_age_in_seconds" {
  description = "Maximum age of a request that Lambda sends to a function for processing in seconds. Valid values between 60 and 21600"
  type        = number
  default     = null

  validation {
    condition = var.maximum_event_age_in_seconds == null || (
      var.maximum_event_age_in_seconds >= 60 && var.maximum_event_age_in_seconds <= 21600
    )
    error_message = "resource_aws_lambda_function_event_invoke_config, maximum_event_age_in_seconds must be between 60 and 21600."
  }
}

variable "maximum_retry_attempts" {
  description = "Maximum number of times to retry when the function returns an error. Valid values between 0 and 2. Defaults to 2"
  type        = number
  default     = 2

  validation {
    condition     = var.maximum_retry_attempts >= 0 && var.maximum_retry_attempts <= 2
    error_message = "resource_aws_lambda_function_event_invoke_config, maximum_retry_attempts must be between 0 and 2."
  }
}

variable "qualifier" {
  description = "Lambda Function published version, $LATEST, or Lambda Alias name"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}