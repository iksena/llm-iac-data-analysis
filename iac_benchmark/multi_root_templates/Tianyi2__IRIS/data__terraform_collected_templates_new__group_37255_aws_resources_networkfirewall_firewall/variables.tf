variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "availability_zone_change_protection" {
  description = "A setting indicating whether the firewall is protected against changes to its Availability Zone configuration. When set to true, you must first disable this protection before adding or removing Availability Zones."
  type        = bool
  default     = null
}

variable "availability_zone_mapping" {
  description = "Required when creating a transit gateway-attached firewall. Set of configuration blocks describing the availability zones where you want to create firewall endpoints for a transit gateway-attached firewall."
  type = list(object({
    availability_zone_id = string
  }))
  default = []
}

variable "delete_protection" {
  description = "A flag indicating whether the firewall is protected against deletion. Use this setting to protect against accidentally deleting a firewall that is in use."
  type        = bool
  default     = false
}

variable "description" {
  description = "A friendly description of the firewall."
  type        = string
  default     = null
}

variable "enabled_analysis_types" {
  description = "Set of types for which to collect analysis metrics. Valid values: TLS_SNI, HTTP_HOST."
  type        = set(string)
  default     = []

  validation {
    condition = alltrue([
      for type in var.enabled_analysis_types : contains(["TLS_SNI", "HTTP_HOST"], type)
    ])
    error_message = "resource_aws_networkfirewall_firewall, enabled_analysis_types must contain only valid values: TLS_SNI, HTTP_HOST."
  }
}

variable "encryption_configuration" {
  description = "KMS encryption configuration settings."
  type = object({
    key_id = optional(string)
    type   = string
  })
  default = null

  validation {
    condition     = var.encryption_configuration == null ? true : contains(["CUSTOMER_KMS", "AWS_OWNED_KMS_KEY"], var.encryption_configuration.type)
    error_message = "resource_aws_networkfirewall_firewall, encryption_configuration.type must be either CUSTOMER_KMS or AWS_OWNED_KMS_KEY."
  }
}

variable "firewall_policy_arn" {
  description = "The Amazon Resource Name (ARN) of the VPC Firewall policy."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:network-firewall:[a-z0-9-]+:[0-9]{12}:firewall-policy/", var.firewall_policy_arn))
    error_message = "resource_aws_networkfirewall_firewall, firewall_policy_arn must be a valid AWS Network Firewall policy ARN."
  }
}

variable "firewall_policy_change_protection" {
  description = "A flag indicating whether the firewall is protected against a change to the firewall policy association. Use this setting to protect against accidentally modifying the firewall policy for a firewall that is in use."
  type        = bool
  default     = false
}

variable "name" {
  description = "A friendly name of the firewall."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "resource_aws_networkfirewall_firewall, name must be between 1 and 128 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_networkfirewall_firewall, name can only contain alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "subnet_change_protection" {
  description = "A flag indicating whether the firewall is protected against changes to the subnet associations. Use this setting to protect against accidentally modifying the subnet associations for a firewall that is in use."
  type        = bool
  default     = false
}

variable "subnet_mapping" {
  description = "Required when creating a VPC attached firewall. Set of configuration blocks describing the public subnets. Each subnet must belong to a different Availability Zone in the VPC."
  type = list(object({
    ip_address_type = optional(string, "IPV4")
    subnet_id       = string
  }))
  default = []

  validation {
    condition = alltrue([
      for mapping in var.subnet_mapping :
      mapping.ip_address_type == null ? true : contains(["DUALSTACK", "IPV4"], mapping.ip_address_type)
    ])
    error_message = "resource_aws_networkfirewall_firewall, subnet_mapping.ip_address_type must be either DUALSTACK or IPV4."
  }
}

variable "tags" {
  description = "Map of resource tags to associate with the resource."
  type        = map(string)
  default     = {}
}

variable "transit_gateway_id" {
  description = "Required when creating a transit gateway-attached firewall. The unique identifier of the transit gateway to attach to this firewall."
  type        = string
  default     = null

  validation {
    condition     = var.transit_gateway_id == null ? true : can(regex("^tgw-[a-zA-Z0-9]+$", var.transit_gateway_id))
    error_message = "resource_aws_networkfirewall_firewall, transit_gateway_id must be a valid transit gateway ID (tgw-xxxxxxxx)."
  }
}

variable "vpc_id" {
  description = "Required when creating a VPC attached firewall. The unique identifier of the VPC where AWS Network Firewall should create the firewall."
  type        = string
  default     = null

  validation {
    condition     = var.vpc_id == null ? true : can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "resource_aws_networkfirewall_firewall, vpc_id must be a valid VPC ID (vpc-xxxxxxxx)."
  }
}