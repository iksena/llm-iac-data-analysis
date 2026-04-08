variable "name" {
  description = "A friendly name for the Protection you are creating."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_shield_protection, name must not be empty."
  }
}

variable "resource_arn" {
  description = "The ARN (Amazon Resource Name) of the resource to be protected."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:", var.resource_arn))
    error_message = "resource_aws_shield_protection, resource_arn must be a valid AWS ARN."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}