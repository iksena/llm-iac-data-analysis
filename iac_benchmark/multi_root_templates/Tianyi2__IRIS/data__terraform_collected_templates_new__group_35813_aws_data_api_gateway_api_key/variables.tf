variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[0-9]{2}$", var.region)) || can(regex("^us-gov-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_api_gateway_api_key, region must be a valid AWS region format (e.g., us-east-1, eu-west-1, ap-southeast-2)."
  }
}

variable "id" {
  description = "ID of the API Key to look up."
  type        = string

  validation {
    condition     = length(var.id) > 0
    error_message = "data_aws_api_gateway_api_key, id cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.id))
    error_message = "data_aws_api_gateway_api_key, id must contain only lowercase alphanumeric characters."
  }
}