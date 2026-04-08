variable "id" {
  description = "ID of the prefix list to select"
  type        = string
  default     = null

  validation {
    condition     = var.id == null || can(regex("^pl-[a-f0-9]{8}([a-f0-9]{9})?$", var.id))
    error_message = "The data_aws_ec2_managed_prefix_list, id must be a valid prefix list ID format (pl-xxxxxxxx or pl-xxxxxxxxxxxxxxxxx)."
  }
}

variable "name" {
  description = "Name of the prefix list to select"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "The data_aws_ec2_managed_prefix_list, name cannot be an empty string."
  }
}

variable "filter" {
  description = "Configuration block(s) for filtering"
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filter : length(filter.name) > 0
    ])
    error_message = "The data_aws_ec2_managed_prefix_list, filter name cannot be empty."
  }

  validation {
    condition = alltrue([
      for filter in var.filter : length(filter.values) > 0
    ])
    error_message = "The data_aws_ec2_managed_prefix_list, filter values must contain at least one value."
  }
}