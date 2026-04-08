variable "instance_name" {
  type        = string
  description = "Name of the instance for which to open ports."

  validation {
    condition     = length(var.instance_name) > 0
    error_message = "resource_aws_lightsail_instance_public_ports, instance_name must not be empty."
  }
}

variable "port_info" {
  type = list(object({
    from_port         = number
    protocol          = string
    to_port           = number
    cidr_list_aliases = optional(set(string))
    cidrs             = optional(set(string))
    ipv6_cidrs        = optional(set(string))
  }))
  description = "Descriptor of the ports to open for the specified instance. AWS closes all currently open ports that are not included in this argument."

  validation {
    condition     = length(var.port_info) > 0
    error_message = "resource_aws_lightsail_instance_public_ports, port_info must contain at least one port configuration."
  }

  validation {
    condition = alltrue([
      for port in var.port_info : contains(["tcp", "all", "udp", "icmp", "icmpv6"], port.protocol)
    ])
    error_message = "resource_aws_lightsail_instance_public_ports, port_info protocol must be one of: tcp, all, udp, icmp, icmpv6."
  }

  validation {
    condition = alltrue([
      for port in var.port_info : port.from_port >= 0 && port.from_port <= 65535
    ])
    error_message = "resource_aws_lightsail_instance_public_ports, port_info from_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for port in var.port_info : port.to_port >= 0 && port.to_port <= 65535
    ])
    error_message = "resource_aws_lightsail_instance_public_ports, port_info to_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for port in var.port_info : port.from_port <= port.to_port
    ])
    error_message = "resource_aws_lightsail_instance_public_ports, port_info from_port must be less than or equal to to_port."
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "resource_aws_lightsail_instance_public_ports, region must not be empty if specified."
  }
}