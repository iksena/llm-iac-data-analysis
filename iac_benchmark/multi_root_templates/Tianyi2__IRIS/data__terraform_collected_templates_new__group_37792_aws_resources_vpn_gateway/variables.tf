variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_vpn_gateway, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "vpc_id" {
  description = "The VPC ID to create in."
  type        = string
  default     = null

  validation {
    condition     = var.vpc_id == null || can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "resource_aws_vpn_gateway, vpc_id must be a valid VPC ID format (e.g., vpc-12345678)."
  }
}

variable "availability_zone" {
  description = "The Availability Zone for the virtual private gateway."
  type        = string
  default     = null

  validation {
    condition     = var.availability_zone == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}[a-z]{1}$", var.availability_zone))
    error_message = "resource_aws_vpn_gateway, availability_zone must be a valid availability zone format (e.g., us-east-1a, eu-west-1b)."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags)
    error_message = "resource_aws_vpn_gateway, tags must be a valid map of strings."
  }
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway."
  type        = number
  default     = null

  validation {
    condition     = var.amazon_side_asn == null || (var.amazon_side_asn >= 64512 && var.amazon_side_asn <= 65534) || var.amazon_side_asn == 4294967294
    error_message = "resource_aws_vpn_gateway, amazon_side_asn must be in the range 64512-65534 or 4294967294 for Amazon default ASN."
  }
}