variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "destination" {
  description = "The destination IP address. This must be either IPV4 or IPV6"
  type        = string

  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$", var.destination)) || can(regex("^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$", var.destination))
    error_message = "resource_aws_networkmonitor_probe, destination must be a valid IPv4 or IPv6 address."
  }
}

variable "destination_port" {
  description = "The port associated with the destination. This is required only if the protocol is TCP and must be a number between 1 and 65536"
  type        = number
  default     = null

  validation {
    condition     = var.destination_port == null || (var.destination_port >= 1 && var.destination_port <= 65536)
    error_message = "resource_aws_networkmonitor_probe, destination_port must be a number between 1 and 65536."
  }
}

variable "monitor_name" {
  description = "The name of the monitor"
  type        = string
}

variable "protocol" {
  description = "The protocol used for the network traffic between the source and destination. This must be either TCP or ICMP"
  type        = string

  validation {
    condition     = contains(["TCP", "ICMP"], var.protocol)
    error_message = "resource_aws_networkmonitor_probe, protocol must be either TCP or ICMP."
  }
}

variable "source_arn" {
  description = "The ARN of the subnet"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ec2:[a-zA-Z0-9-]+:[0-9]+:subnet/subnet-[a-zA-Z0-9]+$", var.source_arn))
    error_message = "resource_aws_networkmonitor_probe, source_arn must be a valid subnet ARN."
  }
}

variable "packet_size" {
  description = "The size of the packets sent between the source and destination. This must be a number between 56 and 8500"
  type        = number
  default     = null

  validation {
    condition     = var.packet_size == null || (var.packet_size >= 56 && var.packet_size <= 8500)
    error_message = "resource_aws_networkmonitor_probe, packet_size must be a number between 56 and 8500."
  }
}

variable "tags" {
  description = "Key-value tags for the monitor"
  type        = map(string)
  default     = {}
}