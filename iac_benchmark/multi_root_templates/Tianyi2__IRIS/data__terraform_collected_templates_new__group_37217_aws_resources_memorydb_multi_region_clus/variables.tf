variable "multi_region_cluster_name_suffix" {
  description = "A suffix to be added to the multi-region cluster name. An AWS generated prefix is automatically applied to the multi-region cluster name when it is created."
  type        = string

  validation {
    condition     = var.multi_region_cluster_name_suffix != null && var.multi_region_cluster_name_suffix != ""
    error_message = "resource_aws_memorydb_multi_region_cluster, multi_region_cluster_name_suffix must be a non-empty string."
  }
}

variable "node_type" {
  description = "The node type to be used for the multi-region cluster."
  type        = string

  validation {
    condition     = var.node_type != null && var.node_type != ""
    error_message = "resource_aws_memorydb_multi_region_cluster, node_type must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description for the multi-region cluster."
  type        = string
  default     = null
}

variable "engine" {
  description = "The name of the engine to be used for the multi-region cluster. Valid values are 'redis' and 'valkey'."
  type        = string
  default     = null

  validation {
    condition     = var.engine == null || contains(["redis", "valkey"], var.engine)
    error_message = "resource_aws_memorydb_multi_region_cluster, engine must be either 'redis' or 'valkey'."
  }
}

variable "engine_version" {
  description = "The version of the engine to be used for the multi-region cluster. Downgrades are not supported."
  type        = string
  default     = null
}

variable "multi_region_parameter_group_name" {
  description = "The name of the multi-region parameter group to be associated with the cluster."
  type        = string
  default     = null
}

variable "num_shards" {
  description = "The number of shards for the multi-region cluster."
  type        = number
  default     = null

  validation {
    condition     = var.num_shards == null || var.num_shards > 0
    error_message = "resource_aws_memorydb_multi_region_cluster, num_shards must be a positive integer."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "tls_enabled" {
  description = "A flag to enable in-transit encryption on the cluster."
  type        = bool
  default     = null
}

variable "create_timeout" {
  description = "Timeout for creating the multi-region cluster."
  type        = string
  default     = "120m"
}

variable "update_timeout" {
  description = "Timeout for updating the multi-region cluster."
  type        = string
  default     = "120m"
}

variable "delete_timeout" {
  description = "Timeout for deleting the multi-region cluster."
  type        = string
  default     = "120m"
}