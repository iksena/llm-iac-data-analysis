variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "instance_type" {
  type        = string
  description = "Type of instance for which to query Spot Price information."
  default     = null
}

variable "availability_zone" {
  type        = string
  description = "Availability zone in which to query Spot price information."
  default     = null

  validation {
    condition     = var.availability_zone == null || can(regex("^[a-z]+-[a-z]+-[0-9]+[a-z]$", var.availability_zone))
    error_message = "data_aws_ec2_spot_price, availability_zone must be a valid AWS availability zone format (e.g., us-west-2a)."
  }
}

variable "filter" {
  type = list(object({
    name   = string
    values = list(string)
  }))
  description = "One or more configuration blocks containing name-values filters."
  default     = null

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.name != null && f.values != null && length(f.values) > 0
    ])
    error_message = "data_aws_ec2_spot_price, filter blocks must have both 'name' and 'values' specified, with at least one value."
  }
}

variable "read_timeout" {
  type        = string
  description = "Read timeout for the data source."
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_ec2_spot_price, read_timeout must be a valid duration format (e.g., 20m, 1h, 30s)."
  }
}