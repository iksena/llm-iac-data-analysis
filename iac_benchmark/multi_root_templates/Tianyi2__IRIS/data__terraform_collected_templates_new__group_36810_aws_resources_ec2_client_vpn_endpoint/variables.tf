variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "authentication_options" {
  description = "Information about the authentication method to be used to authenticate clients."
  type = object({
    type                           = string
    active_directory_id            = optional(string)
    root_certificate_chain_arn     = optional(string)
    saml_provider_arn              = optional(string)
    self_service_saml_provider_arn = optional(string)
  })

  validation {
    condition     = contains(["certificate-authentication", "directory-service-authentication", "federated-authentication"], var.authentication_options.type)
    error_message = "resource_aws_ec2_client_vpn_endpoint, authentication_options.type must be one of: certificate-authentication, directory-service-authentication, federated-authentication."
  }
}

variable "client_cidr_block" {
  description = "The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The CIDR block should be /22 or greater. When traffic_ip_address_type is set to ipv6, it must not be specified."
  type        = string
  default     = null
}

variable "client_connect_options" {
  description = "The options for managing connection authorization for new client connections."
  type = object({
    enabled             = optional(bool, false)
    lambda_function_arn = optional(string)
  })
  default = null
}

variable "client_login_banner_options" {
  description = "Options for enabling a customizable text banner that will be displayed on AWS provided clients when a VPN session is established."
  type = object({
    enabled     = optional(bool, false)
    banner_text = optional(string)
  })
  default = null

  validation {
    condition     = var.client_login_banner_options == null ? true : (var.client_login_banner_options.banner_text == null ? true : length(var.client_login_banner_options.banner_text) <= 1400)
    error_message = "resource_aws_ec2_client_vpn_endpoint, client_login_banner_options.banner_text maximum of 1400 characters."
  }
}

variable "client_route_enforcement_options" {
  description = "Options for enforce administrator defined routes on devices connected through the VPN."
  type = object({
    enforced = optional(bool, false)
  })
  default = null
}

variable "connection_log_options" {
  description = "Information about the client connection logging options."
  type = object({
    enabled               = bool
    cloudwatch_log_group  = optional(string)
    cloudwatch_log_stream = optional(string)
  })
}

variable "description" {
  description = "A brief description of the Client VPN endpoint."
  type        = string
  default     = null
}

variable "disconnect_on_session_timeout" {
  description = "Indicates whether the client VPN session is disconnected after the maximum session_timeout_hours is reached. Default value is false."
  type        = bool
  default     = false
}

variable "dns_servers" {
  description = "Information about the DNS servers to be used for DNS resolution. A Client VPN endpoint can have up to two DNS servers."
  type        = list(string)
  default     = null

  validation {
    condition     = var.dns_servers == null ? true : length(var.dns_servers) <= 2
    error_message = "resource_aws_ec2_client_vpn_endpoint, dns_servers can have up to two DNS servers."
  }
}

variable "endpoint_ip_address_type" {
  description = "IP address type for the Client VPN endpoint. Valid values are ipv4, ipv6, or dual-stack. Defaults to ipv4."
  type        = string
  default     = "ipv4"

  validation {
    condition     = contains(["ipv4", "ipv6", "dual-stack"], var.endpoint_ip_address_type)
    error_message = "resource_aws_ec2_client_vpn_endpoint, endpoint_ip_address_type must be one of: ipv4, ipv6, dual-stack."
  }
}

variable "security_group_ids" {
  description = "The IDs of one or more security groups to apply to the target network. You must also specify the ID of the VPC that contains the security groups."
  type        = list(string)
  default     = null
}

variable "self_service_portal" {
  description = "Specify whether to enable the self-service portal for the Client VPN endpoint. Values can be enabled or disabled. Default value is disabled."
  type        = string
  default     = "disabled"

  validation {
    condition     = contains(["enabled", "disabled"], var.self_service_portal)
    error_message = "resource_aws_ec2_client_vpn_endpoint, self_service_portal must be either enabled or disabled."
  }
}

variable "server_certificate_arn" {
  description = "The ARN of the ACM server certificate."
  type        = string
}

variable "session_timeout_hours" {
  description = "The maximum session duration is a trigger by which end-users are required to re-authenticate prior to establishing a VPN session. Default value is 24."
  type        = number
  default     = 24

  validation {
    condition     = contains([8, 10, 12, 24], var.session_timeout_hours)
    error_message = "resource_aws_ec2_client_vpn_endpoint, session_timeout_hours must be one of: 8, 10, 12, 24."
  }
}

variable "split_tunnel" {
  description = "Indicates whether split-tunnel is enabled on VPN endpoint. Default value is false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "traffic_ip_address_type" {
  description = "IP address type for traffic within the Client VPN tunnel. Valid values are ipv4, ipv6, or dual-stack. Defaults to ipv4. When it is set to ipv6, client_cidr_block must not be specified."
  type        = string
  default     = "ipv4"

  validation {
    condition     = contains(["ipv4", "ipv6", "dual-stack"], var.traffic_ip_address_type)
    error_message = "resource_aws_ec2_client_vpn_endpoint, traffic_ip_address_type must be one of: ipv4, ipv6, dual-stack."
  }
}

variable "transport_protocol" {
  description = "The transport protocol to be used by the VPN session. Default value is udp."
  type        = string
  default     = "udp"
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the Client VPN endpoint. If no security group IDs are specified in the request, the default security group for the VPC is applied."
  type        = string
  default     = null
}

variable "vpn_port" {
  description = "The port number for the Client VPN endpoint. Valid values are 443 and 1194. Default value is 443."
  type        = number
  default     = 443

  validation {
    condition     = contains([443, 1194], var.vpn_port)
    error_message = "resource_aws_ec2_client_vpn_endpoint, vpn_port must be either 443 or 1194."
  }
}