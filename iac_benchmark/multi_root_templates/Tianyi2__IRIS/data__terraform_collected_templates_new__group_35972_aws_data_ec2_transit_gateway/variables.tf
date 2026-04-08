variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_ec2_transit_gateway, region must be a valid AWS region format (e.g., us-east-1)."
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
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_transit_gateway, filter name must be a non-empty string."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway, filter values must contain at least one value."
  }

  validation {
    condition = alltrue([
      for f in var.filter : alltrue([
        for v in f.values : v != null && v != ""
      ])
    ])
    error_message = "data_aws_ec2_transit_gateway, filter values must be non-empty strings."
  }
}

variable "id" {
  description = "Identifier of the EC2 Transit Gateway."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || can(regex("^tgw-[0-9a-f]{8,17}$", var.id))
    error_message = "data_aws_ec2_transit_gateway, id must be a valid Transit Gateway ID format (e.g., tgw-12345678)."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeouts_read))
    error_message = "data_aws_ec2_transit_gateway, timeouts_read must be a valid duration format (e.g., 20m, 1h, 30s)."
  }
}