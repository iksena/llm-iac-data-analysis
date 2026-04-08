variable "bgp_asn" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN). Valid values are from 1 to 2147483647. Conflicts with bgp_asn_extended."
  type        = number
  default     = null

  validation {
    condition     = var.bgp_asn == null || (var.bgp_asn >= 1 && var.bgp_asn <= 2147483647)
    error_message = "resource_aws_customer_gateway, bgp_asn must be between 1 and 2147483647."
  }
}

variable "bgp_asn_extended" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN). Valid values are from 2147483648 to 4294967295. Conflicts with bgp_asn."
  type        = number
  default     = null

  validation {
    condition     = var.bgp_asn_extended == null || (var.bgp_asn_extended >= 2147483648 && var.bgp_asn_extended <= 4294967295)
    error_message = "resource_aws_customer_gateway, bgp_asn_extended must be between 2147483648 and 4294967295."
  }
}

variable "certificate_arn" {
  description = "The Amazon Resource Name (ARN) for the customer gateway certificate."
  type        = string
  default     = null
}

variable "device_name" {
  description = "A name for the customer gateway device."
  type        = string
  default     = null
}

variable "ip_address" {
  description = "The IPv4 address for the customer gateway device's outside interface."
  type        = string
  default     = null

  validation {
    condition     = var.ip_address == null || can(regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.ip_address))
    error_message = "resource_aws_customer_gateway, ip_address must be a valid IPv4 address."
  }
}

variable "type" {
  description = "The type of customer gateway. The only type AWS supports at this time is 'ipsec.1'."
  type        = string

  validation {
    condition     = var.type == "ipsec.1"
    error_message = "resource_aws_customer_gateway, type must be 'ipsec.1'."
  }
}

variable "tags" {
  description = "Tags to apply to the gateway."
  type        = map(string)
  default     = {}
}