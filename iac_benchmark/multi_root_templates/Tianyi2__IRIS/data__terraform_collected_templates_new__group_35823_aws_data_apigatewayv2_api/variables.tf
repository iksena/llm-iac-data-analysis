variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}(-[a-z]+)?-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_apigatewayv2_api, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "api_id" {
  description = "API identifier."
  type        = string

  validation {
    condition     = var.api_id != null && var.api_id != ""
    error_message = "data_aws_apigatewayv2_api, api_id cannot be null or empty."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.api_id))
    error_message = "data_aws_apigatewayv2_api, api_id must contain only lowercase letters and numbers."
  }
}