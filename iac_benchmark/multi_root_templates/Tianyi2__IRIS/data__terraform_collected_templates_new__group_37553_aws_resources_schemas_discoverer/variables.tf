variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "source_arn" {
  description = "The ARN of the event bus to discover event schemas on."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z0-9-]*:events:[a-z0-9-]+:\\d{12}:event-bus/.+", var.source_arn))
    error_message = "resource_aws_schemas_discoverer, source_arn must be a valid EventBridge event bus ARN."
  }
}

variable "description" {
  description = "The description of the discoverer. Maximum of 256 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 256
    error_message = "resource_aws_schemas_discoverer, description must be 256 characters or less."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}