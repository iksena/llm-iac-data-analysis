variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ec2_coip_pools, region must be a valid AWS region name or null."
  }
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired aws_ec2_coip_pools."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags)
    error_message = "data_aws_ec2_coip_pools, tags must be a valid map of strings."
  }
}

variable "filter" {
  description = "Custom filter block for filtering COIP pools."
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_coip_pools, filter name must be a non-empty string."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_coip_pools, filter values must contain at least one value."
  }
}

variable "read_timeout" {
  description = "How long to wait for the read operation to complete."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.read_timeout))
    error_message = "data_aws_ec2_coip_pools, read_timeout must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}