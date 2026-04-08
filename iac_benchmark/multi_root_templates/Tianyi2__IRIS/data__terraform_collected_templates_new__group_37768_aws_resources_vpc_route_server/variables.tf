variable "amazon_side_asn" {
  description = "The Border Gateway Protocol (BGP) Autonomous System Number (ASN) for the appliance."
  type        = number

  validation {
    condition     = var.amazon_side_asn >= 1 && var.amazon_side_asn <= 4294967295
    error_message = "resource_aws_vpc_route_server, amazon_side_asn must be between 1 and 4294967295."
  }
}

variable "persist_routes" {
  description = "Indicates whether routes should be persisted after all BGP sessions are terminated."
  type        = string
  default     = null

  validation {
    condition     = var.persist_routes == null || contains(["enable", "disable", "reset"], var.persist_routes)
    error_message = "resource_aws_vpc_route_server, persist_routes must be one of: enable, disable, reset."
  }
}

variable "persist_routes_duration" {
  description = "The number of minutes a route server will wait after BGP is re-established to unpersist the routes in the FIB and RIB. Required if persist_routes is enabled."
  type        = number
  default     = null

  validation {
    condition     = var.persist_routes_duration == null || (var.persist_routes_duration >= 1 && var.persist_routes_duration <= 5)
    error_message = "resource_aws_vpc_route_server, persist_routes_duration must be between 1 and 5."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "sns_notifications_enabled" {
  description = "Indicates whether SNS notifications should be enabled for route server events."
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}