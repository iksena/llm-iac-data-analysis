variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "acceptance_required" {
  type        = bool
  description = "Whether or not VPC endpoint connection requests to the service must be accepted by the service owner - true or false."

  validation {
    condition     = var.acceptance_required != null
    error_message = "resource_aws_vpc_endpoint_service, acceptance_required is required and cannot be null."
  }
}

variable "allowed_principals" {
  type        = set(string)
  description = "The ARNs of one or more principals allowed to discover the endpoint service."
  default     = null

  validation {
    condition = var.allowed_principals == null || alltrue([
      for arn in var.allowed_principals : can(regex("^arn:aws.*", arn))
    ])
    error_message = "resource_aws_vpc_endpoint_service, allowed_principals must be valid ARNs starting with 'arn:aws'."
  }
}

variable "gateway_load_balancer_arns" {
  type        = set(string)
  description = "Amazon Resource Names (ARNs) of one or more Gateway Load Balancers for the endpoint service."
  default     = null

  validation {
    condition = var.gateway_load_balancer_arns == null || alltrue([
      for arn in var.gateway_load_balancer_arns : can(regex("^arn:aws:elasticloadbalancing:.*:.*:loadbalancer/gwy/.*", arn))
    ])
    error_message = "resource_aws_vpc_endpoint_service, gateway_load_balancer_arns must be valid Gateway Load Balancer ARNs."
  }
}

variable "network_load_balancer_arns" {
  type        = set(string)
  description = "Amazon Resource Names (ARNs) of one or more Network Load Balancers for the endpoint service."
  default     = null

  validation {
    condition = var.network_load_balancer_arns == null || alltrue([
      for arn in var.network_load_balancer_arns : can(regex("^arn:aws:elasticloadbalancing:.*:.*:loadbalancer/net/.*", arn))
    ])
    error_message = "resource_aws_vpc_endpoint_service, network_load_balancer_arns must be valid Network Load Balancer ARNs."
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}

variable "private_dns_name" {
  type        = string
  description = "The private DNS name for the service."
  default     = null

  validation {
    condition     = var.private_dns_name == null || can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", var.private_dns_name))
    error_message = "resource_aws_vpc_endpoint_service, private_dns_name must be a valid DNS name."
  }
}

variable "supported_ip_address_types" {
  type        = set(string)
  description = "The supported IP address types. The possible values are ipv4 and ipv6."
  default     = null

  validation {
    condition = var.supported_ip_address_types == null || alltrue([
      for ip_type in var.supported_ip_address_types : contains(["ipv4", "ipv6"], ip_type)
    ])
    error_message = "resource_aws_vpc_endpoint_service, supported_ip_address_types must contain only 'ipv4' and/or 'ipv6'."
  }
}

variable "supported_regions" {
  type        = set(string)
  description = "The set of regions from which service consumers can access the service."
  default     = null

  validation {
    condition = var.supported_regions == null || alltrue([
      for region in var.supported_regions : can(regex("^[a-z0-9-]+$", region))
    ])
    error_message = "resource_aws_vpc_endpoint_service, supported_regions must contain valid AWS region names."
  }
}