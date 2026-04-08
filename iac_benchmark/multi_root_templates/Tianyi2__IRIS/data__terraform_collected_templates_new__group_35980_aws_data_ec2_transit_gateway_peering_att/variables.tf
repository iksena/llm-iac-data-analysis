variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_ec2_transit_gateway_peering_attachments, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "filter" {
  description = "One or more configuration blocks containing name-values filters."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != ""
    ])
    error_message = "data_aws_ec2_transit_gateway_peering_attachments, filter name cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_peering_attachments, filter values list cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : alltrue([
        for v in f.values : v != ""
      ])
    ])
    error_message = "data_aws_ec2_transit_gateway_peering_attachments, filter values cannot contain empty strings."
  }
}

variable "read_timeout" {
  description = "Timeout for read operations. Default is 20m."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_ec2_transit_gateway_peering_attachments, read_timeout must be a valid timeout format (e.g., 10s, 5m, 1h)."
  }
}