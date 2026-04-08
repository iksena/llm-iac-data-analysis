variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filter" {
  description = "One or more configuration blocks containing name-values filters. See the EC2 API Reference for supported filters."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_instance_types, filter: name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_instance_types, filter: values must contain at least one value."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    read = optional(string, "20m")
  })
  default = null
}