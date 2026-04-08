variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_nat_gateways, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "vpc_id" {
  description = "VPC ID that you want to filter from."
  type        = string
  default     = null

  validation {
    condition     = var.vpc_id == null || can(regex("^vpc-[0-9a-f]{8}([0-9a-f]{9})?$", var.vpc_id))
    error_message = "data_aws_nat_gateways, vpc_id must be a valid VPC ID format (e.g., vpc-12345678)."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired NAT Gateways."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))])
    error_message = "data_aws_nat_gateways, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}

variable "filter" {
  description = "Custom filter block to filter NAT gateways."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != "" && length(f.values) > 0
    ])
    error_message = "data_aws_nat_gateways, filter name must be non-empty and values must contain at least one element."
  }

  validation {
    condition = alltrue([
      for f in var.filter : alltrue([for v in f.values : v != null && v != ""])
    ])
    error_message = "data_aws_nat_gateways, filter values must be non-empty strings."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_nat_gateways, timeouts_read must be a valid duration format (e.g., 20m, 1h, 30s)."
  }
}