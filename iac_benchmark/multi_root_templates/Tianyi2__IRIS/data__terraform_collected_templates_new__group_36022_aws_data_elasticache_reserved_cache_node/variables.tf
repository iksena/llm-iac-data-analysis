variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cache_node_type" {
  description = "Node type for the reserved cache node."
  type        = string

  validation {
    condition     = length(var.cache_node_type) > 0
    error_message = "data_aws_elasticache_reserved_cache_node_offering, cache_node_type must be a non-empty string."
  }
}

variable "duration" {
  description = "Duration of the reservation in RFC3339 duration format."
  type        = string

  validation {
    condition     = contains(["P1Y", "P3Y"], var.duration)
    error_message = "data_aws_elasticache_reserved_cache_node_offering, duration must be either 'P1Y' (one year) or 'P3Y' (three years)."
  }
}

variable "offering_type" {
  description = "Offering type of this reserved cache node."
  type        = string

  validation {
    condition = contains([
      "No Upfront",
      "Partial Upfront",
      "All Upfront",
      "Heavy Utilization",
      "Medium Utilization",
      "Light Utilization"
    ], var.offering_type)
    error_message = "data_aws_elasticache_reserved_cache_node_offering, offering_type must be one of: 'No Upfront', 'Partial Upfront', 'All Upfront', 'Heavy Utilization', 'Medium Utilization', or 'Light Utilization'."
  }
}

variable "product_description" {
  description = "Engine type for the reserved cache node."
  type        = string

  validation {
    condition     = contains(["redis", "valkey", "memcached"], var.product_description)
    error_message = "data_aws_elasticache_reserved_cache_node_offering, product_description must be one of: 'redis', 'valkey', or 'memcached'."
  }
}