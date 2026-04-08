variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the deployment."
  type        = string
  default     = null
}

variable "rest_api_id" {
  description = "REST API identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.rest_api_id)) && length(var.rest_api_id) >= 1
    error_message = "resource_aws_api_gateway_deployment, rest_api_id must be a valid REST API identifier containing only lowercase letters and numbers."
  }
}

variable "triggers" {
  description = "Map of arbitrary keys and values that, when changed, will trigger a redeployment."
  type        = map(string)
  default     = {}
}

variable "variables" {
  description = "Map to set on the related stage."
  type        = map(string)
  default     = {}
}