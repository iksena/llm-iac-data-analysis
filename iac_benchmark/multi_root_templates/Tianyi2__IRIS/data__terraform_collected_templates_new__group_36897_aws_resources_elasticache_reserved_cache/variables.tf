variable "reserved_cache_nodes_offering_id" {
  description = "ID of the reserved cache node offering to purchase"
  type        = string

  validation {
    condition     = length(var.reserved_cache_nodes_offering_id) > 0
    error_message = "resource_aws_elasticache_reserved_cache_node, reserved_cache_nodes_offering_id cannot be empty."
  }
}

variable "cache_node_count" {
  description = "Number of cache node instances to reserve"
  type        = number
  default     = 1

  validation {
    condition     = var.cache_node_count > 0
    error_message = "resource_aws_elasticache_reserved_cache_node, cache_node_count must be greater than 0."
  }
}

variable "id" {
  description = "Customer-specified identifier to track this reservation"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the reservation"
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for create operations"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_elasticache_reserved_cache_node, create_timeout must be a valid timeout format (e.g., 30m, 1h, 120s)."
  }
}

variable "update_timeout" {
  description = "Timeout for update operations"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.update_timeout))
    error_message = "resource_aws_elasticache_reserved_cache_node, update_timeout must be a valid timeout format (e.g., 30m, 1h, 120s)."
  }
}

variable "delete_timeout" {
  description = "Timeout for delete operations"
  type        = string
  default     = "1m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_elasticache_reserved_cache_node, delete_timeout must be a valid timeout format (e.g., 30m, 1h, 120s)."
  }
}