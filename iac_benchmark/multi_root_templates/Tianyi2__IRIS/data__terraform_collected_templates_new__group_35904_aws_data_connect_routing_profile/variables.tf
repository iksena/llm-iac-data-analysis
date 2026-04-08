variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "data_aws_connect_routing_profile, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "Returns information on a specific Routing Profile by name"
  type        = string
  default     = null

  validation {
    condition     = (var.name != null && var.routing_profile_id == null) || (var.name == null && var.routing_profile_id != null)
    error_message = "data_aws_connect_routing_profile - exactly one of 'name' or 'routing_profile_id' must be specified."
  }
}

variable "routing_profile_id" {
  description = "Returns information on a specific Routing Profile by Routing Profile id"
  type        = string
  default     = null

  validation {
    condition     = var.routing_profile_id != null ? can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.routing_profile_id)) : true
    error_message = "data_aws_connect_routing_profile, routing_profile_id must be a valid UUID format when specified."
  }
}