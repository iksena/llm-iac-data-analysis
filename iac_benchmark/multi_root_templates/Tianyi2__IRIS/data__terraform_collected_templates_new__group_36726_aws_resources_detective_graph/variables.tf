variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_detective_graph, region must be a valid AWS region format or null."
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the instance. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  default     = {}

  validation {
    condition     = can(tomap(var.tags))
    error_message = "resource_aws_detective_graph, tags must be a map of string values."
  }
}