variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Specifies the description of the segment."
  type        = string
  default     = null
  validation {
    condition     = var.description == null || length(var.description) > 0
    error_message = "resource_aws_evidently_segment, description must not be empty if provided."
  }
}

variable "name" {
  description = "A name for the segment."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_evidently_segment, name is required and must not be empty."
  }
  validation {
    condition     = length(var.name) <= 127
    error_message = "resource_aws_evidently_segment, name must be 127 characters or less."
  }
  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_evidently_segment, name must contain only alphanumeric characters, periods, hyphens, and underscores."
  }
}

variable "pattern" {
  description = "The pattern to use for the segment. For more information about pattern syntax, see Segment rule pattern syntax."
  type        = string
  validation {
    condition     = length(var.pattern) > 0
    error_message = "resource_aws_evidently_segment, pattern is required and must not be empty."
  }
  validation {
    condition     = can(jsonencode(jsondecode(var.pattern)))
    error_message = "resource_aws_evidently_segment, pattern must be valid JSON."
  }
}

variable "tags" {
  description = "Tags to apply to the segment."
  type        = map(string)
  default     = {}
}