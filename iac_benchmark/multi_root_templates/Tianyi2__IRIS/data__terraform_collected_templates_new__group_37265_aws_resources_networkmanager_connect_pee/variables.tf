variable "connect_attachment_id" {
  description = "ID of the connection attachment"
  type        = string

  validation {
    condition     = length(var.connect_attachment_id) > 0
    error_message = "resource_aws_networkmanager_connect_peer, connect_attachment_id must not be empty."
  }
}

variable "peer_address" {
  description = "Connect peer address"
  type        = string

  validation {
    condition     = length(var.peer_address) > 0
    error_message = "resource_aws_networkmanager_connect_peer, peer_address must not be empty."
  }

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.peer_address))
    error_message = "resource_aws_networkmanager_connect_peer, peer_address must be a valid IPv4 address."
  }
}

variable "bgp_options" {
  description = "Connect peer BGP options"
  type = object({
    peer_asn = optional(number)
  })
  default = null

  validation {
    condition = var.bgp_options == null || (
      var.bgp_options.peer_asn == null ||
      (var.bgp_options.peer_asn >= 1 && var.bgp_options.peer_asn <= 4294967295)
    )
    error_message = "resource_aws_networkmanager_connect_peer, bgp_options.peer_asn must be between 1 and 4294967295."
  }
}

variable "core_network_address" {
  description = "Connect peer core network address"
  type        = string
  default     = null

  validation {
    condition     = var.core_network_address == null || can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.core_network_address))
    error_message = "resource_aws_networkmanager_connect_peer, core_network_address must be a valid IPv4 address."
  }
}

variable "inside_cidr_blocks" {
  description = "Inside IP addresses used for BGP peering. Required when the Connect attachment protocol is GRE"
  type        = list(string)
  default     = null

  validation {
    condition = var.inside_cidr_blocks == null || alltrue([
      for cidr in var.inside_cidr_blocks : can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_networkmanager_connect_peer, inside_cidr_blocks must contain valid CIDR blocks."
  }
}

variable "subnet_arn" {
  description = "Subnet ARN for the Connect peer. Required when the Connect attachment protocol is NO_ENCAP"
  type        = string
  default     = null

  validation {
    condition     = var.subnet_arn == null || can(regex("^arn:aws[a-z\\-]*:ec2:[a-z0-9\\-]+:\\d{12}:subnet/subnet-[0-9a-f]{8,17}$", var.subnet_arn))
    error_message = "resource_aws_networkmanager_connect_peer, subnet_arn must be a valid subnet ARN."
  }
}

variable "tags" {
  description = "Key-value tags for the attachment"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]{1,128}$", k))
    ])
    error_message = "resource_aws_networkmanager_connect_peer, tags keys must be 1-128 characters and contain only letters, numbers, spaces, and the characters _.:/=+-@."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]{0,256}$", v))
    ])
    error_message = "resource_aws_networkmanager_connect_peer, tags values must be 0-256 characters and contain only letters, numbers, spaces, and the characters _.:/=+-@."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "15m")
  })
  default = {}

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_networkmanager_connect_peer, timeouts.create must be a valid duration string (e.g., '10m', '1h')."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_networkmanager_connect_peer, timeouts.delete must be a valid duration string (e.g., '15m', '1h')."
  }
}