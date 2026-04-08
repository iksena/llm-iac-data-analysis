variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "customer_id" {
  description = "Amazon Web Services Marketplace customer identifier, when integrating with the Amazon Web Services SaaS Marketplace."
  type        = string
  default     = null
}

variable "include_values" {
  description = "Set this value to true if you wish the result contains the key value. Defaults to false."
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.include_values))
    error_message = "data_aws_api_gateway_api_keys, include_values must be a boolean value."
  }
}