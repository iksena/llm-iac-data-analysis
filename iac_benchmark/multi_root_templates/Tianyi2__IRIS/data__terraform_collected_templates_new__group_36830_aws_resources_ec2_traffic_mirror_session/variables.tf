variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "A description of the traffic mirror session."
  type        = string
  default     = null
}

variable "network_interface_id" {
  description = "ID of the source network interface. Not all network interfaces are eligible as mirror sources. On EC2 instances only nitro based instances support mirroring."
  type        = string

  validation {
    condition     = can(regex("^eni-[0-9a-f]+$", var.network_interface_id))
    error_message = "resource_aws_ec2_traffic_mirror_session, network_interface_id must be a valid network interface ID starting with 'eni-'."
  }
}

variable "traffic_mirror_filter_id" {
  description = "ID of the traffic mirror filter to be used."
  type        = string

  validation {
    condition     = can(regex("^tmf-[0-9a-f]+$", var.traffic_mirror_filter_id))
    error_message = "resource_aws_ec2_traffic_mirror_session, traffic_mirror_filter_id must be a valid traffic mirror filter ID starting with 'tmf-'."
  }
}

variable "traffic_mirror_target_id" {
  description = "ID of the traffic mirror target to be used."
  type        = string

  validation {
    condition     = can(regex("^tmt-[0-9a-f]+$", var.traffic_mirror_target_id))
    error_message = "resource_aws_ec2_traffic_mirror_session, traffic_mirror_target_id must be a valid traffic mirror target ID starting with 'tmt-'."
  }
}

variable "packet_length" {
  description = "The number of bytes in each packet to mirror. These are bytes after the VXLAN header. Do not specify this parameter when you want to mirror the entire packet. To mirror a subset of the packet, set this to the length (in bytes) that you want to mirror."
  type        = number
  default     = null

  validation {
    condition     = var.packet_length == null || (var.packet_length >= 1 && var.packet_length <= 65535)
    error_message = "resource_aws_ec2_traffic_mirror_session, packet_length must be between 1 and 65535 bytes."
  }
}

variable "session_number" {
  description = "The session number determines the order in which sessions are evaluated when an interface is used by multiple sessions. The first session with a matching filter is the one that mirrors the packets."
  type        = number

  validation {
    condition     = var.session_number >= 1 && var.session_number <= 32766
    error_message = "resource_aws_ec2_traffic_mirror_session, session_number must be between 1 and 32766."
  }
}

variable "virtual_network_id" {
  description = "The VXLAN ID for the Traffic Mirror session. For more information about the VXLAN protocol, see RFC 7348. If you do not specify a VirtualNetworkId, an account-wide unique id is chosen at random."
  type        = number
  default     = null

  validation {
    condition     = var.virtual_network_id == null || (var.virtual_network_id >= 1 && var.virtual_network_id <= 16777215)
    error_message = "resource_aws_ec2_traffic_mirror_session, virtual_network_id must be between 1 and 16777215."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}