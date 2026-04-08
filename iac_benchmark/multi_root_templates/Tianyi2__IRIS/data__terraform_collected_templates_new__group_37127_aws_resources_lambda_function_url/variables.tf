variable "authorization_type" {
  description = "Type of authentication that the function URL uses"
  type        = string

  validation {
    condition     = contains(["AWS_IAM", "NONE"], var.authorization_type)
    error_message = "resource_aws_lambda_function_url, authorization_type must be either 'AWS_IAM' or 'NONE'."
  }
}

variable "function_name" {
  description = "Name or ARN of the Lambda function"
  type        = string
}

variable "cors" {
  description = "Cross-origin resource sharing (CORS) settings for the function URL"
  type = object({
    allow_credentials = optional(bool)
    allow_headers     = optional(list(string))
    allow_methods     = optional(list(string))
    allow_origins     = optional(list(string))
    expose_headers    = optional(list(string))
    max_age           = optional(number)
  })
  default = null

  validation {
    condition = var.cors == null || (
      var.cors.max_age == null ||
      (var.cors.max_age >= 0 && var.cors.max_age <= 86400)
    )
    error_message = "resource_aws_lambda_function_url, cors.max_age must be between 0 and 86400 seconds."
  }
}

variable "invoke_mode" {
  description = "How the Lambda function responds to an invocation"
  type        = string
  default     = "BUFFERED"

  validation {
    condition     = contains(["BUFFERED", "RESPONSE_STREAM"], var.invoke_mode)
    error_message = "resource_aws_lambda_function_url, invoke_mode must be either 'BUFFERED' or 'RESPONSE_STREAM'."
  }
}

variable "qualifier" {
  description = "Alias name or $LATEST"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}