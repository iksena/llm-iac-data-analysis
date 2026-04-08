variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name to use for the service mesh. Must be between 1 and 255 characters in length."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_appmesh_mesh, name must be between 1 and 255 characters in length."
  }
}

variable "spec" {
  description = "Service mesh specification to apply."
  type = object({
    egress_filter = optional(object({
      type = optional(string)
    }))
    service_discovery = optional(object({
      ip_preference = optional(string)
    }))
  })
  default = null

  validation {
    condition     = var.spec == null || var.spec.egress_filter == null || var.spec.egress_filter.type == null || contains(["ALLOW_ALL", "DROP_ALL"], var.spec.egress_filter.type)
    error_message = "resource_aws_appmesh_mesh, spec.egress_filter.type must be either 'ALLOW_ALL' or 'DROP_ALL'."
  }

  validation {
    condition     = var.spec == null || var.spec.service_discovery == null || var.spec.service_discovery.ip_preference == null || contains(["IPv6_PREFERRED", "IPv4_PREFERRED", "IPv4_ONLY", "IPv6_ONLY"], var.spec.service_discovery.ip_preference)
    error_message = "resource_aws_appmesh_mesh, spec.service_discovery.ip_preference must be one of 'IPv6_PREFERRED', 'IPv4_PREFERRED', 'IPv4_ONLY', or 'IPv6_ONLY'."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}