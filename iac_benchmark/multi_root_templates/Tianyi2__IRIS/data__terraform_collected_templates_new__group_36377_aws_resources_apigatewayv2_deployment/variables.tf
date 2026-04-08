variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "api_id" {
  description = "API identifier."
  type        = string

  validation {
    condition     = length(var.api_id) > 0
    error_message = "resource_aws_apigatewayv2_deployment, api_id cannot be empty."
  }
}

variable "description" {
  description = "Description for the deployment resource. Must be less than or equal to 1024 characters in length."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_apigatewayv2_deployment, description must be less than or equal to 1024 characters in length."
  }
}

variable "triggers" {
  description = "Map of arbitrary keys and values that, when changed, will trigger a redeployment. To force a redeployment without changing these keys/values, use the terraform taint command."
  type        = map(string)
  default     = {}
}