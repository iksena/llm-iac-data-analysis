variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_inspector_resource_group, region must be a valid AWS region format or null."
  }
}

variable "tags" {
  description = "Key-value map of tags that are used to select the EC2 instances to be included in an Amazon Inspector assessment target."
  type        = map(string)

  validation {
    condition     = length(var.tags) > 0
    error_message = "resource_aws_inspector_resource_group, tags cannot be empty - at least one tag is required."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]*$", k)) && can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]*$", v))
    ])
    error_message = "resource_aws_inspector_resource_group, tags keys and values must contain only valid characters."
  }
}