variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used."
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "resource_aws_vpc_endpoint, vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "auto_accept" {
  description = "Accept the VPC endpoint (the VPC endpoint and service need to be in the same AWS account)."
  type        = bool
  default     = null
}

variable "policy" {
  description = "A policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access."
  type        = string
  default     = null

  validation {
    condition     = var.policy == null || can(jsondecode(var.policy))
    error_message = "resource_aws_vpc_endpoint, policy must be a valid JSON string."
  }
}

variable "private_dns_enabled" {
  description = "Whether or not to associate a private hosted zone with the specified VPC. Applicable for endpoints of type Interface. Most users will want this enabled to allow services within the VPC to automatically use the endpoint. Defaults to false."
  type        = bool
  default     = false
}

variable "dns_options" {
  description = "The DNS options for the endpoint."
  type = object({
    dns_record_ip_type                             = optional(string)
    private_dns_only_for_inbound_resolver_endpoint = optional(bool)
  })
  default = null

  validation {
    condition = var.dns_options == null || (
      var.dns_options.dns_record_ip_type == null ||
      contains(["ipv4", "dualstack", "service-defined", "ipv6"], var.dns_options.dns_record_ip_type)
    )
    error_message = "resource_aws_vpc_endpoint, dns_record_ip_type must be one of: ipv4, dualstack, service-defined, ipv6."
  }
}

variable "ip_address_type" {
  description = "The IP address type for the endpoint. Valid values are ipv4, dualstack, and ipv6."
  type        = string
  default     = null

  validation {
    condition     = var.ip_address_type == null || contains(["ipv4", "dualstack", "ipv6"], var.ip_address_type)
    error_message = "resource_aws_vpc_endpoint, ip_address_type must be one of: ipv4, dualstack, ipv6."
  }
}

variable "resource_configuration_arn" {
  description = "The ARN of a Resource Configuration to connect this VPC Endpoint to. Exactly one of resource_configuration_arn, service_name or service_network_arn is required."
  type        = string
  default     = null

  validation {
    condition     = var.resource_configuration_arn == null || can(regex("^arn:aws:", var.resource_configuration_arn))
    error_message = "resource_aws_vpc_endpoint, resource_configuration_arn must be a valid AWS ARN."
  }
}

variable "route_table_ids" {
  description = "One or more route table IDs. Applicable for endpoints of type Gateway."
  type        = list(string)
  default     = null

  validation {
    condition = var.route_table_ids == null || alltrue([
      for rt in var.route_table_ids : can(regex("^rtb-", rt))
    ])
    error_message = "resource_aws_vpc_endpoint, route_table_ids must be a list of valid route table IDs starting with 'rtb-'."
  }
}

variable "service_name" {
  description = "The service name. For AWS services the service name is usually in the form com.amazonaws.<region>.<service>. Exactly one of resource_configuration_arn, service_name or service_network_arn is required."
  type        = string
  default     = null
}

variable "service_network_arn" {
  description = "The ARN of a Service Network to connect this VPC Endpoint to. Exactly one of resource_configuration_arn, service_name or service_network_arn is required."
  type        = string
  default     = null

  validation {
    condition     = var.service_network_arn == null || can(regex("^arn:aws:", var.service_network_arn))
    error_message = "resource_aws_vpc_endpoint, service_network_arn must be a valid AWS ARN."
  }
}

variable "service_region" {
  description = "The AWS region of the VPC Endpoint Service. If specified, the VPC endpoint will connect to the service in the provided region. Applicable for endpoints of type Interface."
  type        = string
  default     = null
}

variable "subnet_configuration" {
  description = "Subnet configuration for the endpoint, used to select specific IPv4 and/or IPv6 addresses to the endpoint."
  type = list(object({
    ipv4      = optional(string)
    ipv6      = optional(string)
    subnet_id = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.subnet_configuration :
      config.subnet_id == null || can(regex("^subnet-", config.subnet_id))
    ])
    error_message = "resource_aws_vpc_endpoint, subnet_id in subnet_configuration must be a valid subnet ID starting with 'subnet-'."
  }
}

variable "subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type GatewayLoadBalancer and Interface. Interface type endpoints cannot function without being assigned to a subnet."
  type        = list(string)
  default     = null

  validation {
    condition = var.subnet_ids == null || alltrue([
      for subnet in var.subnet_ids : can(regex("^subnet-", subnet))
    ])
    error_message = "resource_aws_vpc_endpoint, subnet_ids must be a list of valid subnet IDs starting with 'subnet-'."
  }
}

variable "security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface. Applicable for endpoints of type Interface. If no security groups are specified, the VPC's default security group is associated with the endpoint."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_group_ids == null || alltrue([
      for sg in var.security_group_ids : can(regex("^sg-", sg))
    ])
    error_message = "resource_aws_vpc_endpoint, security_group_ids must be a list of valid security group IDs starting with 'sg-'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "vpc_endpoint_type" {
  description = "The VPC endpoint type, Gateway, GatewayLoadBalancer, Interface, Resource or ServiceNetwork. Defaults to Gateway."
  type        = string
  default     = "Gateway"

  validation {
    condition     = contains(["Gateway", "GatewayLoadBalancer", "Interface", "Resource", "ServiceNetwork"], var.vpc_endpoint_type)
    error_message = "resource_aws_vpc_endpoint, vpc_endpoint_type must be one of: Gateway, GatewayLoadBalancer, Interface, Resource, ServiceNetwork."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}