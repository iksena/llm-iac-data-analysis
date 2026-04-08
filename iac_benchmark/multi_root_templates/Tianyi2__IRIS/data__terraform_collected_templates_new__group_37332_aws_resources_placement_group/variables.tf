variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the placement group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_placement_group, name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "partition_count" {
  description = "The number of partitions to create in the placement group. Can only be specified when the strategy is set to partition. Valid values are 1 - 7 (default is 2)."
  type        = number
  default     = null

  validation {
    condition     = var.partition_count == null || (var.partition_count >= 1 && var.partition_count <= 7)
    error_message = "resource_aws_placement_group, partition_count must be between 1 and 7."
  }
}

variable "spread_level" {
  description = "Determines how placement groups spread instances. Can only be used when the strategy is set to spread. Can be host or rack. host can only be used for Outpost placement groups. Defaults to rack."
  type        = string
  default     = null

  validation {
    condition     = var.spread_level == null || contains(["host", "rack"], var.spread_level)
    error_message = "resource_aws_placement_group, spread_level must be either 'host' or 'rack'."
  }
}

variable "strategy" {
  description = "The placement strategy. Can be cluster, partition or spread."
  type        = string

  validation {
    condition     = contains(["cluster", "partition", "spread"], var.strategy)
    error_message = "resource_aws_placement_group, strategy must be one of: cluster, partition, or spread."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}