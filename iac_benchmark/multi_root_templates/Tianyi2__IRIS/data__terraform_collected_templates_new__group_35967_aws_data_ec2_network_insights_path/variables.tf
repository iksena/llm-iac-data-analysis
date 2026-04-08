variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "network_insights_path_id" {
  description = "ID of the Network Insights Path to select."
  type        = string
  default     = null
}

variable "filter" {
  description = "Configuration block(s) for filtering."
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_network_insights_path, filter: name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_network_insights_path, filter: values must contain at least one value."
  }
}