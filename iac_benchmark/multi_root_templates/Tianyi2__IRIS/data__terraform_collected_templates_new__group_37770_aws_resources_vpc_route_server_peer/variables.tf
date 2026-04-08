variable "route_server_endpoint_id" {
  description = "The ID of the route server endpoint for which to create a peer."
  type        = string

  validation {
    condition     = can(regex("^rse-[a-z0-9]+$", var.route_server_endpoint_id))
    error_message = "resource_aws_vpc_route_server_peer, route_server_endpoint_id must be a valid route server endpoint ID (format: rse-xxxxxxxx)."
  }
}

variable "peer_address" {
  description = "The IPv4 address of the peer device."
  type        = string

  validation {
    condition     = can(cidrhost("${var.peer_address}/32", 0))
    error_message = "resource_aws_vpc_route_server_peer, peer_address must be a valid IPv4 address."
  }
}

variable "bgp_options" {
  description = "The BGP options for the peer, including ASN (Autonomous System Number) and BFD (Bidrectional Forwarding Detection) settings."
  type = object({
    peer_asn                = number
    peer_liveness_detection = optional(string, "bgp-keepalive")
  })

  validation {
    condition     = var.bgp_options.peer_asn >= 1 && var.bgp_options.peer_asn <= 4294967295
    error_message = "resource_aws_vpc_route_server_peer, bgp_options.peer_asn must be between 1 and 4294967295."
  }

  validation {
    condition     = contains(["bgp-keepalive", "bfd"], var.bgp_options.peer_liveness_detection)
    error_message = "resource_aws_vpc_route_server_peer, bgp_options.peer_liveness_detection must be either 'bgp-keepalive' or 'bfd'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = null
}