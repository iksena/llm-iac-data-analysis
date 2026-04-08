variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Identifiers of EC2 Subnets."
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment, subnet_ids must contain at least one subnet ID."
  }
}

variable "transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway."
  type        = string
  validation {
    condition     = length(var.transit_gateway_id) > 0
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment, transit_gateway_id cannot be empty."
  }
}

variable "vpc_id" {
  description = "Identifier of EC2 VPC."
  type        = string
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment, vpc_id cannot be empty."
  }
}

variable "appliance_mode_support" {
  description = "Whether Appliance Mode support is enabled. If enabled, a traffic flow between a source and destination uses the same Availability Zone for the VPC attachment for the lifetime of that flow."
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["disable", "enable"], var.appliance_mode_support)
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment, appliance_mode_support must be either 'disable' or 'enable'."
  }
}

variable "dns_support" {
  description = "Whether DNS support is enabled."
  type        = string
  default     = "enable"
  validation {
    condition     = contains(["disable", "enable"], var.dns_support)
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment, dns_support must be either 'disable' or 'enable'."
  }
}

variable "ipv6_support" {
  description = "Whether IPv6 support is enabled."
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["disable", "enable"], var.ipv6_support)
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment, ipv6_support must be either 'disable' or 'enable'."
  }
}

variable "security_group_referencing_support" {
  description = "Whether Security Group Referencing Support is enabled."
  type        = string
  default     = null
  validation {
    condition     = var.security_group_referencing_support == null || contains(["disable", "enable"], var.security_group_referencing_support)
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment, security_group_referencing_support must be either 'disable' or 'enable'."
  }
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway VPC Attachment."
  type        = map(string)
  default     = {}
}

variable "transit_gateway_default_route_table_association" {
  description = "Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table."
  type        = bool
  default     = true
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table."
  type        = bool
  default     = true
}