variable "netbios_name_servers" {
  description = "List of NETBIOS name servers"
  type        = list(string)
  default     = null
}

variable "netbios_node_type" {
  description = "The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network"
  type        = number
  default     = null

  validation {
    condition     = var.netbios_node_type == null || contains([1, 2, 4, 8], var.netbios_node_type)
    error_message = "resource_aws_default_vpc_dhcp_options, netbios_node_type must be 1, 2, 4, or 8."
  }
}

variable "owner_id" {
  description = "The ID of the AWS account that owns the DHCP options set"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}