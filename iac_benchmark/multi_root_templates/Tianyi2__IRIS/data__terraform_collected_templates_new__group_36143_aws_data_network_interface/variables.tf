variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_network_interface, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "id" {
  description = "Identifier for the network interface."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || can(regex("^eni-[0-9a-f]{8,17}$", var.id))
    error_message = "data_aws_network_interface, id must be a valid ENI identifier starting with 'eni-' followed by 8-17 hexadecimal characters or null."
  }
}

variable "filter" {
  description = "One or more name/value pairs to filter off of. Check describe-network-interfaces in the AWS CLI reference for valid keys."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_network_interface, filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_network_interface, filter values cannot be empty."
  }
}

variable "read_timeout" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_network_interface, read_timeout must be a valid duration format (e.g., 20m, 1h, 30s)."
  }
}