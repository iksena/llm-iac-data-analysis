variable "name" {
  description = "Name of the KX environment that you want to create."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_finspace_kx_environment, name must not be empty."
  }
}

variable "kms_key_id" {
  description = "KMS key ID to encrypt your data in the FinSpace environment."
  type        = string

  validation {
    condition     = length(var.kms_key_id) > 0
    error_message = "resource_aws_finspace_kx_environment, kms_key_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description for the KX environment."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "custom_dns_configuration" {
  description = "List of DNS server name and server IP. This is used to set up Route-53 outbound resolvers."
  type = object({
    custom_dns_server_ip   = string
    custom_dns_server_name = string
  })
  default = null

  validation {
    condition = var.custom_dns_configuration == null || (
      length(var.custom_dns_configuration.custom_dns_server_ip) > 0 &&
      length(var.custom_dns_configuration.custom_dns_server_name) > 0 &&
      can(cidrhost("${var.custom_dns_configuration.custom_dns_server_ip}/32", 0))
    )
    error_message = "resource_aws_finspace_kx_environment, custom_dns_configuration requires valid custom_dns_server_ip and custom_dns_server_name."
  }
}

variable "transit_gateway_configuration" {
  description = "Transit gateway and network configuration that is used to connect the KX environment to an internal network."
  type = object({
    routable_cidr_space = string
    transit_gateway_id  = string
    attachment_network_acl_configuration = optional(object({
      cidr_block  = string
      protocol    = string
      rule_action = string
      rule_number = number
      icmp_type_code = optional(object({
        code = number
        type = number
      }))
      port_range = optional(object({
        from = number
        to   = number
      }))
    }))
  })
  default = null

  validation {
    condition = var.transit_gateway_configuration == null || (
      length(var.transit_gateway_configuration.routable_cidr_space) > 0 &&
      length(var.transit_gateway_configuration.transit_gateway_id) > 0 &&
      can(cidrnetmask(var.transit_gateway_configuration.routable_cidr_space)) &&
      tonumber(split("/", var.transit_gateway_configuration.routable_cidr_space)[1]) == 26 &&
      startswith(var.transit_gateway_configuration.routable_cidr_space, "100.64.")
    )
    error_message = "resource_aws_finspace_kx_environment, transit_gateway_configuration requires valid routable_cidr_space (must be /26 range in 100.64.0.0 CIDR space) and transit_gateway_id."
  }

  validation {
    condition = var.transit_gateway_configuration == null || var.transit_gateway_configuration.attachment_network_acl_configuration == null || (
      length(var.transit_gateway_configuration.attachment_network_acl_configuration.cidr_block) > 0 &&
      can(cidrnetmask(var.transit_gateway_configuration.attachment_network_acl_configuration.cidr_block)) &&
      contains(["allow", "deny"], var.transit_gateway_configuration.attachment_network_acl_configuration.rule_action) &&
      var.transit_gateway_configuration.attachment_network_acl_configuration.rule_number >= 1 &&
      var.transit_gateway_configuration.attachment_network_acl_configuration.rule_number <= 32766 &&
      length(var.transit_gateway_configuration.attachment_network_acl_configuration.protocol) > 0
    )
    error_message = "resource_aws_finspace_kx_environment, attachment_network_acl_configuration requires valid cidr_block, protocol, rule_action (allow or deny), and rule_number (1-32766)."
  }

  validation {
    condition = var.transit_gateway_configuration == null || var.transit_gateway_configuration.attachment_network_acl_configuration == null || var.transit_gateway_configuration.attachment_network_acl_configuration.port_range == null || (
      var.transit_gateway_configuration.attachment_network_acl_configuration.port_range.from >= 0 &&
      var.transit_gateway_configuration.attachment_network_acl_configuration.port_range.from <= 65535 &&
      var.transit_gateway_configuration.attachment_network_acl_configuration.port_range.to >= 0 &&
      var.transit_gateway_configuration.attachment_network_acl_configuration.port_range.to <= 65535 &&
      var.transit_gateway_configuration.attachment_network_acl_configuration.port_range.from <= var.transit_gateway_configuration.attachment_network_acl_configuration.port_range.to
    )
    error_message = "resource_aws_finspace_kx_environment, port_range requires from and to values between 0-65535, with from <= to."
  }

  validation {
    condition = var.transit_gateway_configuration == null || var.transit_gateway_configuration.attachment_network_acl_configuration == null || var.transit_gateway_configuration.attachment_network_acl_configuration.icmp_type_code == null || (
      var.transit_gateway_configuration.attachment_network_acl_configuration.icmp_type_code.code >= -1 &&
      var.transit_gateway_configuration.attachment_network_acl_configuration.icmp_type_code.type >= -1
    )
    error_message = "resource_aws_finspace_kx_environment, icmp_type_code requires code and type values >= -1."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "75m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "75m"
  }
}