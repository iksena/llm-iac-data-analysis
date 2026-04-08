variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "load_balancer" {
  description = "The load balancer to which the policy should be attached."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.load_balancer)) && length(var.load_balancer) >= 1 && length(var.load_balancer) <= 32
    error_message = "resource_aws_proxy_protocol_policy, load_balancer must be a valid ELB name (1-32 characters, alphanumeric and hyphens, cannot start or end with hyphen)."
  }
}

variable "instance_ports" {
  description = "List of instance ports to which the policy should be applied. This can be specified if the protocol is SSL or TCP."
  type        = list(string)

  validation {
    condition     = length(var.instance_ports) > 0
    error_message = "resource_aws_proxy_protocol_policy, instance_ports must contain at least one port."
  }

  validation {
    condition = alltrue([
      for port in var.instance_ports : can(regex("^[0-9]+$", port)) && tonumber(port) >= 1 && tonumber(port) <= 65535
    ])
    error_message = "resource_aws_proxy_protocol_policy, instance_ports must contain valid port numbers (1-65535)."
  }
}