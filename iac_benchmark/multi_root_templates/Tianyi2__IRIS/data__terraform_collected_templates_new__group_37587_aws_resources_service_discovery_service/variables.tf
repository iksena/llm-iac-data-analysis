variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "name" {
  type        = string
  description = "The name of the service."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_service_discovery_service, name must contain only alphanumeric characters, underscores, and hyphens."
  }
}

variable "description" {
  type        = string
  description = "The description of the service."
  default     = null
}

variable "dns_config" {
  type = object({
    namespace_id   = string
    routing_policy = optional(string)
    dns_records = list(object({
      ttl  = number
      type = string
    }))
  })
  description = "A complex type that contains information about the resource record sets that you want Amazon Route 53 to create when you register an instance."
  default     = null

  validation {
    condition = var.dns_config == null || (
      var.dns_config.namespace_id != null &&
      var.dns_config.dns_records != null &&
      length(var.dns_config.dns_records) > 0
    )
    error_message = "resource_aws_service_discovery_service, dns_config requires namespace_id and at least one dns_record when specified."
  }

  validation {
    condition     = var.dns_config == null || var.dns_config.routing_policy == null || contains(["MULTIVALUE", "WEIGHTED"], var.dns_config.routing_policy)
    error_message = "resource_aws_service_discovery_service, dns_config routing_policy must be either MULTIVALUE or WEIGHTED."
  }

  validation {
    condition = var.dns_config == null || alltrue([
      for record in var.dns_config.dns_records : contains(["A", "AAAA", "SRV", "CNAME"], record.type)
    ])
    error_message = "resource_aws_service_discovery_service, dns_config dns_records type must be one of: A, AAAA, SRV, CNAME."
  }

  validation {
    condition = var.dns_config == null || alltrue([
      for record in var.dns_config.dns_records : record.ttl > 0
    ])
    error_message = "resource_aws_service_discovery_service, dns_config dns_records ttl must be greater than 0."
  }
}

variable "health_check_config" {
  type = object({
    failure_threshold = optional(number)
    resource_path     = optional(string)
    type              = optional(string)
  })
  description = "A complex type that contains settings for an optional health check. Only for Public DNS namespaces."
  default     = null

  validation {
    condition = var.health_check_config == null || var.health_check_config.failure_threshold == null || (
      var.health_check_config.failure_threshold >= 1 && var.health_check_config.failure_threshold <= 10
    )
    error_message = "resource_aws_service_discovery_service, health_check_config failure_threshold must be between 1 and 10."
  }

  validation {
    condition     = var.health_check_config == null || var.health_check_config.type == null || contains(["HTTP", "HTTPS", "TCP"], var.health_check_config.type)
    error_message = "resource_aws_service_discovery_service, health_check_config type must be one of: HTTP, HTTPS, TCP."
  }
}

variable "force_destroy" {
  type        = bool
  description = "A boolean that indicates all instances should be deleted from the service so that the service can be destroyed without error. These instances are not recoverable."
  default     = false
}

variable "health_check_custom_config" {
  type = object({
    failure_threshold = optional(number)
  })
  description = "A complex type that contains settings for ECS managed health checks."
  default     = null

  validation {
    condition     = var.health_check_custom_config == null || var.health_check_custom_config.failure_threshold == null || var.health_check_custom_config.failure_threshold >= 1
    error_message = "resource_aws_service_discovery_service, health_check_custom_config failure_threshold must be at least 1."
  }
}

variable "namespace_id" {
  type        = string
  description = "The ID of the namespace that you want to use to create the service."
  default     = null
}

variable "type" {
  type        = string
  description = "If present, specifies that the service instances are only discoverable using the DiscoverInstances API operation. No DNS records is registered for the service instances. The only valid value is HTTP."
  default     = null

  validation {
    condition     = var.type == null || var.type == "HTTP"
    error_message = "resource_aws_service_discovery_service, type must be HTTP when specified."
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the service."
  default     = {}
}