variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$|^[a-z]{2}-[a-z]+-[0-9]{1}[a-z]{1}$", var.region))
    error_message = "data_aws_ec2_transit_gateway_vpc_attachments, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "filter" {
  type = list(object({
    name   = string
    values = list(string)
  }))
  description = "One or more configuration blocks containing name-values filters."
  default     = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_transit_gateway_vpc_attachments, filter name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_vpc_attachments, filter values must contain at least one value."
  }

  validation {
    condition = alltrue([
      for f in var.filter : alltrue([
        for v in f.values : v != null && v != ""
      ])
    ])
    error_message = "data_aws_ec2_transit_gateway_vpc_attachments, filter values cannot be null or empty."
  }
}

variable "read_timeout" {
  type        = string
  description = "Timeout for the read operation."
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[mh]$", var.read_timeout))
    error_message = "data_aws_ec2_transit_gateway_vpc_attachments, read_timeout must be in the format of number followed by 'm' (minutes) or 'h' (hours)."
  }
}