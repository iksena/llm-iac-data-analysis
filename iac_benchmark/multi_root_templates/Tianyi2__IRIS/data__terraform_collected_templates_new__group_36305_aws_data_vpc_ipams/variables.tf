variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "ipam_ids" {
  description = "IDs of the IPAM resources to query for"
  type        = list(string)
  default     = null
}

variable "filter" {
  description = "Custom filter block"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for f in var.filter : can(regex("^[a-zA-Z0-9._-]+$", f.name))])
    error_message = "data_aws_vpc_ipams, filter name must be a valid filter name containing only alphanumeric characters, periods, underscores, and hyphens."
  }

  validation {
    condition     = alltrue([for f in var.filter : length(f.values) > 0])
    error_message = "data_aws_vpc_ipams, filter values must contain at least one value."
  }
}