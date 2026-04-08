variable "name" {
  description = "The name of the Amazon Chime Voice Connector."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_chime_voice_connector, name must not be empty."
  }
}

variable "require_encryption" {
  description = "When enabled, requires encryption for the Amazon Chime Voice Connector."
  type        = bool
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_chime_voice_connector, region must be a valid AWS region format."
  }
}

variable "aws_region" {
  description = "The AWS Region in which the Amazon Chime Voice Connector is created."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "resource_aws_chime_voice_connector, aws_region must be a valid AWS region format."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k))])
    error_message = "resource_aws_chime_voice_connector, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{0,256}$", v))])
    error_message = "resource_aws_chime_voice_connector, tags values must be between 0 and 256 characters."
  }
}