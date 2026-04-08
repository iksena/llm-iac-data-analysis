variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_ec2_managed_prefix_lists, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "filter" {
  description = "Custom filter blocks to filter managed prefix lists"
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition     = alltrue([for f in var.filter : f.name != null && f.name != ""])
    error_message = "data_aws_ec2_managed_prefix_lists, filter name cannot be null or empty."
  }

  validation {
    condition     = alltrue([for f in var.filter : length(f.values) > 0])
    error_message = "data_aws_ec2_managed_prefix_lists, filter values must contain at least one value."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired managed prefix list"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : k != null && k != "" && v != null])
    error_message = "data_aws_ec2_managed_prefix_lists, tags keys and values cannot be null or empty strings."
  }
}

