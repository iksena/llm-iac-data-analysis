variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_customer_gateway, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "id" {
  description = "ID of the gateway."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || length(var.id) > 0
    error_message = "data_aws_customer_gateway, id must not be empty if provided."
  }
}

variable "filter" {
  description = "One or more name-value pairs to filter by."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : length(f.name) > 0
    ])
    error_message = "data_aws_customer_gateway, filter name must not be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_customer_gateway, filter values must contain at least one value."
  }

  validation {
    condition = alltrue([
      for f in var.filter : alltrue([
        for v in f.values : length(v) > 0
      ])
    ])
    error_message = "data_aws_customer_gateway, filter values must not contain empty strings."
  }
}