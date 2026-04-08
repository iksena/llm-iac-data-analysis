variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "ARN of the Attribute Group to find."
  type        = string
  default     = null
}

variable "id" {
  description = "ID of the Attribute Group to find."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the Attribute Group to find."
  type        = string
  default     = null
}

locals {
  identifier_count = length([
    for v in [var.arn, var.id, var.name] : v if v != null
  ])
}