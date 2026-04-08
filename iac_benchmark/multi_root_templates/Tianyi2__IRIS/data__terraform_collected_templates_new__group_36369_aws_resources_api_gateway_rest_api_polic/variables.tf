variable "region" {
  type        = string
  default     = null
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "rest_api_id" {
  type        = string
  description = "ID of the REST API."

  validation {
    condition     = length(var.rest_api_id) > 0
    error_message = "resource_aws_api_gateway_rest_api_policy, rest_api_id must be a non-empty string."
  }
}

variable "policy" {
  type        = string
  description = "JSON formatted policy document that controls access to the API Gateway."

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_api_gateway_rest_api_policy, policy must be a non-empty JSON formatted policy document."
  }

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_api_gateway_rest_api_policy, policy must be valid JSON."
  }
}