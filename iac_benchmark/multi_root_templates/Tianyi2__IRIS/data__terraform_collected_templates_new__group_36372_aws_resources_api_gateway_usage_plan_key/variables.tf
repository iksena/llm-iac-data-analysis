variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "key_id" {
  description = "Identifier of the API key resource."
  type        = string

  validation {
    condition     = var.key_id != null && var.key_id != ""
    error_message = "resource_aws_api_gateway_usage_plan_key, key_id must be a non-empty string."
  }
}

variable "key_type" {
  description = "Type of the API key resource. Currently, the valid key type is API_KEY."
  type        = string

  validation {
    condition     = var.key_type == "API_KEY"
    error_message = "resource_aws_api_gateway_usage_plan_key, key_type must be 'API_KEY'."
  }
}

variable "usage_plan_id" {
  description = "Id of the usage plan resource representing to associate the key to."
  type        = string

  validation {
    condition     = var.usage_plan_id != null && var.usage_plan_id != ""
    error_message = "resource_aws_api_gateway_usage_plan_key, usage_plan_id must be a non-empty string."
  }
}