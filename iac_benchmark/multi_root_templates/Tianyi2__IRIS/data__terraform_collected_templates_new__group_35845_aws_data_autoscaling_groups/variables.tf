variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_autoscaling_groups, region must be a valid AWS region format (e.g., us-west-2) or null"
  }
}

variable "names" {
  description = "List of autoscaling group names"
  type        = list(string)
  default     = null

  validation {
    condition     = var.names == null || (length(var.names) > 0 && alltrue([for name in var.names : length(name) > 0]))
    error_message = "data_aws_autoscaling_groups, names must be null or a non-empty list of non-empty strings"
  }
}

variable "filter" {
  description = "Filter used to scope the list e.g., by tags"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : length(f.name) > 0 && length(f.values) > 0 && alltrue([for v in f.values : length(v) > 0])
    ])
    error_message = "data_aws_autoscaling_groups, filter each filter must have a non-empty name and non-empty values list with non-empty strings"
  }

  validation {
    condition = alltrue([
      for f in var.filter : contains(["tag-key", "tag-value"], f.name) || can(regex("^tag:", f.name))
    ])
    error_message = "data_aws_autoscaling_groups, filter name must be 'tag-key', 'tag-value', or start with 'tag:'"
  }
}