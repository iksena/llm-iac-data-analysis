variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_ec2_public_ipv4_pools, region must be a valid AWS region identifier or null."
  }
}

variable "filter" {
  description = "Custom filter block to filter pools by specific criteria."
  type = object({
    name   = string
    values = list(string)
  })
  default = null

  validation {
    condition = var.filter == null || (
      var.filter.name != null &&
      var.filter.name != "" &&
      var.filter.values != null &&
      length(var.filter.values) > 0
    )
    error_message = "data_ec2_public_ipv4_pools, filter must be null or an object with non-empty 'name' string and non-empty 'values' list."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired pools."
  type        = map(string)
  default     = null

  validation {
    condition     = var.tags == null || can(keys(var.tags))
    error_message = "data_ec2_public_ipv4_pools, tags must be null or a valid map of strings."
  }
}