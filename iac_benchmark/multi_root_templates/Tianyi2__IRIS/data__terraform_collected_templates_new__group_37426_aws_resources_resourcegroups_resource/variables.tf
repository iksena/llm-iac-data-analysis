variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_resourcegroups_resource, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "group_arn" {
  description = "Name or ARN of the resource group to add resources to."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:resource-groups:", var.group_arn)) || length(var.group_arn) > 0
    error_message = "resource_aws_resourcegroups_resource, group_arn must be a valid resource group ARN or name."
  }
}

variable "resource_arn" {
  description = "ARN of the resource to be added to the group."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:", var.resource_arn))
    error_message = "resource_aws_resourcegroups_resource, resource_arn must be a valid AWS resource ARN."
  }
}

variable "timeouts" {
  description = "Configuration options for operation timeouts."
  type = object({
    create = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      var.timeouts.create == null || can(regex("^[0-9]+(s|m|h)$", var.timeouts.create)) &&
      var.timeouts.delete == null || can(regex("^[0-9]+(s|m|h)$", var.timeouts.delete))
    )
    error_message = "resource_aws_resourcegroups_resource, timeouts values must be valid duration strings (e.g., '5m', '30s', '1h')."
  }
}