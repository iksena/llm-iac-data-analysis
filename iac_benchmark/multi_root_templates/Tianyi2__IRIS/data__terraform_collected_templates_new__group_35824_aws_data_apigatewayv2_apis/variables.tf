variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_apigatewayv2_apis, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "name" {
  description = "API name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_apigatewayv2_apis, name must be a non-empty string when specified."
  }
}

variable "protocol_type" {
  description = "API protocol."
  type        = string
  default     = null

  validation {
    condition     = var.protocol_type == null || contains(["HTTP", "WEBSOCKET"], var.protocol_type)
    error_message = "data_aws_apigatewayv2_apis, protocol_type must be either 'HTTP' or 'WEBSOCKET'."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired APIs."
  type        = map(string)
  default     = null

  validation {
    condition     = var.tags == null || can(keys(var.tags))
    error_message = "data_aws_apigatewayv2_apis, tags must be a valid map of strings."
  }
}