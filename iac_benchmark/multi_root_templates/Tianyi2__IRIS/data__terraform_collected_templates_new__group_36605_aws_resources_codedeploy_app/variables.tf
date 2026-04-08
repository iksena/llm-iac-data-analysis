variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the application."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_codedeploy_app, name must not be empty."
  }
}

variable "compute_platform" {
  description = "The compute platform can either be ECS, Lambda, or Server. Default is Server."
  type        = string
  default     = "Server"

  validation {
    condition     = contains(["ECS", "Lambda", "Server"], var.compute_platform)
    error_message = "resource_aws_codedeploy_app, compute_platform must be one of: ECS, Lambda, Server."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}