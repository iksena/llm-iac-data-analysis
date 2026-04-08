variable "region" {
  type        = string
  description = "Region where this resource will be managed"
  default     = null
}

variable "customer_gateway_id" {
  type        = string
  description = "The ID of the customer gateway"

  validation {
    condition     = can(regex("^cgw-[a-z0-9]+$", var.customer_gateway_id))
    error_message = "resource_aws_vpn_connection, customer_gateway_id must be a valid customer gateway ID starting with cgw-."
  }
}

variable "type" {
  type        = string
  description = "The type of VPN connection. The only type AWS supports at this time is ipsec.1"

  validation {
    condition     = var.type == "ipsec.1"
    error_message = "resource_aws_vpn_connection, type must be 'ipsec.1'."
  }
}

variable "transit_gateway_id" {
  type        = string
  description = "The ID of the EC2 Transit Gateway"
  default     = null

  validation {
    condition     = var.transit_gateway_id == null || can(regex("^tgw-[a-z0-9]+$", var.transit_gateway_id))
    error_message = "resource_aws_vpn_connection, transit_gateway_id must be a valid transit gateway ID starting with tgw-."
  }
}

variable "vpn_gateway_id" {
  type        = string
  description = "The ID of the Virtual Private Gateway"
  default     = null

  validation {
    condition     = var.vpn_gateway_id == null || can(regex("^vgw-[a-z0-9]+$", var.vpn_gateway_id))
    error_message = "resource_aws_vpn_connection, vpn_gateway_id must be a valid VPN gateway ID starting with vgw-."
  }
}

variable "static_routes_only" {
  type        = bool
  description = "Whether the VPN connection uses static routes exclusively. Static routes must be used for devices that don't support BGP"
  default     = false
}

variable "enable_acceleration" {
  type        = bool
  description = "Indicate whether to enable acceleration for the VPN connection. Supports only EC2 Transit Gateway"
  default     = false
}

variable "preshared_key_storage" {
  type        = string
  description = "Storage mode for the pre-shared key (PSK). Valid values are Standard or SecretsManager"
  default     = null

  validation {
    condition     = var.preshared_key_storage == null || contains(["Standard", "SecretsManager"], var.preshared_key_storage)
    error_message = "resource_aws_vpn_connection, preshared_key_storage must be either 'Standard' or 'SecretsManager'."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the connection"
  default     = {}
}

variable "local_ipv4_network_cidr" {
  type        = string
  description = "The IPv4 CIDR on the customer gateway (on-premises) side of the VPN connection"
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.local_ipv4_network_cidr, 0))
    error_message = "resource_aws_vpn_connection, local_ipv4_network_cidr must be a valid IPv4 CIDR block."
  }
}

variable "local_ipv6_network_cidr" {
  type        = string
  description = "The IPv6 CIDR on the customer gateway (on-premises) side of the VPN connection"
  default     = "::/0"
}

variable "outside_ip_address_type" {
  type        = string
  description = "Indicates if a Public S2S VPN or Private S2S VPN over AWS Direct Connect. Valid values are PublicIpv4 or PrivateIpv4"
  default     = "PublicIpv4"

  validation {
    condition     = contains(["PublicIpv4", "PrivateIpv4"], var.outside_ip_address_type)
    error_message = "resource_aws_vpn_connection, outside_ip_address_type must be either 'PublicIpv4' or 'PrivateIpv4'."
  }
}

variable "remote_ipv4_network_cidr" {
  type        = string
  description = "The IPv4 CIDR on the AWS side of the VPN connection"
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.remote_ipv4_network_cidr, 0))
    error_message = "resource_aws_vpn_connection, remote_ipv4_network_cidr must be a valid IPv4 CIDR block."
  }
}

variable "remote_ipv6_network_cidr" {
  type        = string
  description = "The IPv6 CIDR on the AWS side of the VPN connection"
  default     = "::/0"
}

variable "transport_transit_gateway_attachment_id" {
  type        = string
  description = "The attachment ID of the Transit Gateway attachment to Direct Connect Gateway. Required when outside_ip_address_type is set to PrivateIpv4"
  default     = null
}

variable "tunnel_inside_ip_version" {
  type        = string
  description = "Indicate whether the VPN tunnels process IPv4 or IPv6 traffic. Valid values are ipv4 or ipv6"
  default     = "ipv4"

  validation {
    condition     = contains(["ipv4", "ipv6"], var.tunnel_inside_ip_version)
    error_message = "resource_aws_vpn_connection, tunnel_inside_ip_version must be either 'ipv4' or 'ipv6'."
  }
}

variable "tunnel1_inside_cidr" {
  type        = string
  description = "The CIDR block of the inside IP addresses for the first VPN tunnel. Valid value is a size /30 CIDR block from the 169.254.0.0/16 range"
  default     = null

  validation {
    condition = var.tunnel1_inside_cidr == null || (
      can(cidrhost(var.tunnel1_inside_cidr, 0)) &&
      tonumber(split("/", var.tunnel1_inside_cidr)[1]) == 30 &&
      cidrsubnet("169.254.0.0/16", 14, 0) == cidrsubnet(var.tunnel1_inside_cidr, 14, 0)
    )
    error_message = "resource_aws_vpn_connection, tunnel1_inside_cidr must be a valid /30 CIDR block from the 169.254.0.0/16 range."
  }
}

variable "tunnel2_inside_cidr" {
  type        = string
  description = "The CIDR block of the inside IP addresses for the second VPN tunnel. Valid value is a size /30 CIDR block from the 169.254.0.0/16 range"
  default     = null

  validation {
    condition = var.tunnel2_inside_cidr == null || (
      can(cidrhost(var.tunnel2_inside_cidr, 0)) &&
      tonumber(split("/", var.tunnel2_inside_cidr)[1]) == 30 &&
      cidrsubnet("169.254.0.0/16", 14, 0) == cidrsubnet(var.tunnel2_inside_cidr, 14, 0)
    )
    error_message = "resource_aws_vpn_connection, tunnel2_inside_cidr must be a valid /30 CIDR block from the 169.254.0.0/16 range."
  }
}

variable "tunnel1_inside_ipv6_cidr" {
  type        = string
  description = "The range of inside IPv6 addresses for the first VPN tunnel. Supports only EC2 Transit Gateway. Valid value is a size /126 CIDR block from the local fd00::/8 range"
  default     = null
}

variable "tunnel2_inside_ipv6_cidr" {
  type        = string
  description = "The range of inside IPv6 addresses for the second VPN tunnel. Supports only EC2 Transit Gateway. Valid value is a size /126 CIDR block from the local fd00::/8 range"
  default     = null
}

variable "tunnel1_preshared_key" {
  type        = string
  description = "The preshared key of the first VPN tunnel. The preshared key must be between 8 and 64 characters in length and cannot start with zero(0). Allowed characters are alphanumeric characters, periods(.) and underscores(_)"
  default     = null
  sensitive   = true

  validation {
    condition = var.tunnel1_preshared_key == null || (
      length(var.tunnel1_preshared_key) >= 8 &&
      length(var.tunnel1_preshared_key) <= 64 &&
      !startswith(var.tunnel1_preshared_key, "0") &&
      can(regex("^[A-Za-z0-9._]+$", var.tunnel1_preshared_key))
    )
    error_message = "resource_aws_vpn_connection, tunnel1_preshared_key must be between 8 and 64 characters, cannot start with zero, and only contain alphanumeric characters, periods, and underscores."
  }
}

variable "tunnel2_preshared_key" {
  type        = string
  description = "The preshared key of the second VPN tunnel. The preshared key must be between 8 and 64 characters in length and cannot start with zero(0). Allowed characters are alphanumeric characters, periods(.) and underscores(_)"
  default     = null
  sensitive   = true

  validation {
    condition = var.tunnel2_preshared_key == null || (
      length(var.tunnel2_preshared_key) >= 8 &&
      length(var.tunnel2_preshared_key) <= 64 &&
      !startswith(var.tunnel2_preshared_key, "0") &&
      can(regex("^[A-Za-z0-9._]+$", var.tunnel2_preshared_key))
    )
    error_message = "resource_aws_vpn_connection, tunnel2_preshared_key must be between 8 and 64 characters, cannot start with zero, and only contain alphanumeric characters, periods, and underscores."
  }
}

variable "tunnel1_dpd_timeout_action" {
  type        = string
  description = "The action to take after DPD timeout occurs for the first VPN tunnel. Specify restart to restart the IKE initiation. Specify clear to end the IKE session. Valid values are clear, none, or restart"
  default     = "clear"

  validation {
    condition     = contains(["clear", "none", "restart"], var.tunnel1_dpd_timeout_action)
    error_message = "resource_aws_vpn_connection, tunnel1_dpd_timeout_action must be 'clear', 'none', or 'restart'."
  }
}

variable "tunnel2_dpd_timeout_action" {
  type        = string
  description = "The action to take after DPD timeout occurs for the second VPN tunnel. Specify restart to restart the IKE initiation. Specify clear to end the IKE session. Valid values are clear, none, or restart"
  default     = "clear"

  validation {
    condition     = contains(["clear", "none", "restart"], var.tunnel2_dpd_timeout_action)
    error_message = "resource_aws_vpn_connection, tunnel2_dpd_timeout_action must be 'clear', 'none', or 'restart'."
  }
}

variable "tunnel1_dpd_timeout_seconds" {
  type        = number
  description = "The number of seconds after which a DPD timeout occurs for the first VPN tunnel. Valid value is equal or higher than 30"
  default     = 30

  validation {
    condition     = var.tunnel1_dpd_timeout_seconds >= 30
    error_message = "resource_aws_vpn_connection, tunnel1_dpd_timeout_seconds must be equal or higher than 30."
  }
}

variable "tunnel2_dpd_timeout_seconds" {
  type        = number
  description = "The number of seconds after which a DPD timeout occurs for the second VPN tunnel. Valid value is equal or higher than 30"
  default     = 30

  validation {
    condition     = var.tunnel2_dpd_timeout_seconds >= 30
    error_message = "resource_aws_vpn_connection, tunnel2_dpd_timeout_seconds must be equal or higher than 30."
  }
}

variable "tunnel1_enable_tunnel_lifecycle_control" {
  type        = bool
  description = "Turn on or off tunnel endpoint lifecycle control feature for the first VPN tunnel. Valid values are true or false"
  default     = false
}

variable "tunnel2_enable_tunnel_lifecycle_control" {
  type        = bool
  description = "Turn on or off tunnel endpoint lifecycle control feature for the second VPN tunnel. Valid values are true or false"
  default     = false
}

variable "tunnel1_ike_versions" {
  type        = set(string)
  description = "The IKE versions that are permitted for the first VPN tunnel. Valid values are ikev1 or ikev2"
  default     = null

  validation {
    condition     = var.tunnel1_ike_versions == null || length(setsubtract(var.tunnel1_ike_versions, ["ikev1", "ikev2"])) == 0
    error_message = "resource_aws_vpn_connection, tunnel1_ike_versions must contain only 'ikev1' or 'ikev2'."
  }
}

variable "tunnel2_ike_versions" {
  type        = set(string)
  description = "The IKE versions that are permitted for the second VPN tunnel. Valid values are ikev1 or ikev2"
  default     = null

  validation {
    condition     = var.tunnel2_ike_versions == null || length(setsubtract(var.tunnel2_ike_versions, ["ikev1", "ikev2"])) == 0
    error_message = "resource_aws_vpn_connection, tunnel2_ike_versions must contain only 'ikev1' or 'ikev2'."
  }
}

variable "tunnel1_phase1_dh_group_numbers" {
  type        = set(number)
  description = "List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 1 IKE negotiations. Valid values are 2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24"
  default     = null

  validation {
    condition     = var.tunnel1_phase1_dh_group_numbers == null || length(setsubtract(var.tunnel1_phase1_dh_group_numbers, [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24])) == 0
    error_message = "resource_aws_vpn_connection, tunnel1_phase1_dh_group_numbers must contain only valid DH group numbers: 2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24."
  }
}

variable "tunnel2_phase1_dh_group_numbers" {
  type        = set(number)
  description = "List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 1 IKE negotiations. Valid values are 2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24"
  default     = null

  validation {
    condition     = var.tunnel2_phase1_dh_group_numbers == null || length(setsubtract(var.tunnel2_phase1_dh_group_numbers, [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24])) == 0
    error_message = "resource_aws_vpn_connection, tunnel2_phase1_dh_group_numbers must contain only valid DH group numbers: 2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24."
  }
}

variable "tunnel1_phase1_encryption_algorithms" {
  type        = set(string)
  description = "List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations. Valid values are AES128, AES256, AES128-GCM-16, AES256-GCM-16"
  default     = null

  validation {
    condition     = var.tunnel1_phase1_encryption_algorithms == null || length(setsubtract(var.tunnel1_phase1_encryption_algorithms, ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"])) == 0
    error_message = "resource_aws_vpn_connection, tunnel1_phase1_encryption_algorithms must contain only valid algorithms: AES128, AES256, AES128-GCM-16, AES256-GCM-16."
  }
}

variable "tunnel2_phase1_encryption_algorithms" {
  type        = set(string)
  description = "List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations. Valid values are AES128, AES256, AES128-GCM-16, AES256-GCM-16"
  default     = null

  validation {
    condition     = var.tunnel2_phase1_encryption_algorithms == null || length(setsubtract(var.tunnel2_phase1_encryption_algorithms, ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"])) == 0
    error_message = "resource_aws_vpn_connection, tunnel2_phase1_encryption_algorithms must contain only valid algorithms: AES128, AES256, AES128-GCM-16, AES256-GCM-16."
  }
}

variable "tunnel1_phase1_integrity_algorithms" {
  type        = set(string)
  description = "One or more integrity algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations. Valid values are SHA1, SHA2-256, SHA2-384, SHA2-512"
  default     = null

  validation {
    condition     = var.tunnel1_phase1_integrity_algorithms == null || length(setsubtract(var.tunnel1_phase1_integrity_algorithms, ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"])) == 0
    error_message = "resource_aws_vpn_connection, tunnel1_phase1_integrity_algorithms must contain only valid algorithms: SHA1, SHA2-256, SHA2-384, SHA2-512."
  }
}

variable "tunnel2_phase1_integrity_algorithms" {
  type        = set(string)
  description = "One or more integrity algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations. Valid values are SHA1, SHA2-256, SHA2-384, SHA2-512"
  default     = null

  validation {
    condition     = var.tunnel2_phase1_integrity_algorithms == null || length(setsubtract(var.tunnel2_phase1_integrity_algorithms, ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"])) == 0
    error_message = "resource_aws_vpn_connection, tunnel2_phase1_integrity_algorithms must contain only valid algorithms: SHA1, SHA2-256, SHA2-384, SHA2-512."
  }
}

variable "tunnel1_phase1_lifetime_seconds" {
  type        = number
  description = "The lifetime for phase 1 of the IKE negotiation for the first VPN tunnel, in seconds. Valid value is between 900 and 28800"
  default     = 28800

  validation {
    condition     = var.tunnel1_phase1_lifetime_seconds >= 900 && var.tunnel1_phase1_lifetime_seconds <= 28800
    error_message = "resource_aws_vpn_connection, tunnel1_phase1_lifetime_seconds must be between 900 and 28800."
  }
}

variable "tunnel2_phase1_lifetime_seconds" {
  type        = number
  description = "The lifetime for phase 1 of the IKE negotiation for the second VPN tunnel, in seconds. Valid value is between 900 and 28800"
  default     = 28800

  validation {
    condition     = var.tunnel2_phase1_lifetime_seconds >= 900 && var.tunnel2_phase1_lifetime_seconds <= 28800
    error_message = "resource_aws_vpn_connection, tunnel2_phase1_lifetime_seconds must be between 900 and 28800."
  }
}

variable "tunnel1_phase2_dh_group_numbers" {
  type        = set(number)
  description = "List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 2 IKE negotiations. Valid values are 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24"
  default     = null

  validation {
    condition     = var.tunnel1_phase2_dh_group_numbers == null || length(setsubtract(var.tunnel1_phase2_dh_group_numbers, [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24])) == 0
    error_message = "resource_aws_vpn_connection, tunnel1_phase2_dh_group_numbers must contain only valid DH group numbers: 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24."
  }
}

variable "tunnel2_phase2_dh_group_numbers" {
  type        = set(number)
  description = "List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 2 IKE negotiations. Valid values are 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24"
  default     = null

  validation {
    condition     = var.tunnel2_phase2_dh_group_numbers == null || length(setsubtract(var.tunnel2_phase2_dh_group_numbers, [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24])) == 0
    error_message = "resource_aws_vpn_connection, tunnel2_phase2_dh_group_numbers must contain only valid DH group numbers: 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24."
  }
}

variable "tunnel1_phase2_encryption_algorithms" {
  type        = set(string)
  description = "List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. Valid values are AES128, AES256, AES128-GCM-16, AES256-GCM-16"
  default     = null

  validation {
    condition     = var.tunnel1_phase2_encryption_algorithms == null || length(setsubtract(var.tunnel1_phase2_encryption_algorithms, ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"])) == 0
    error_message = "resource_aws_vpn_connection, tunnel1_phase2_encryption_algorithms must contain only valid algorithms: AES128, AES256, AES128-GCM-16, AES256-GCM-16."
  }
}

variable "tunnel2_phase2_encryption_algorithms" {
  type        = set(string)
  description = "List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. Valid values are AES128, AES256, AES128-GCM-16, AES256-GCM-16"
  default     = null

  validation {
    condition     = var.tunnel2_phase2_encryption_algorithms == null || length(setsubtract(var.tunnel2_phase2_encryption_algorithms, ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"])) == 0
    error_message = "resource_aws_vpn_connection, tunnel2_phase2_encryption_algorithms must contain only valid algorithms: AES128, AES256, AES128-GCM-16, AES256-GCM-16."
  }
}

variable "tunnel1_phase2_integrity_algorithms" {
  type        = set(string)
  description = "List of one or more integrity algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. Valid values are SHA1, SHA2-256, SHA2-384, SHA2-512"
  default     = null

  validation {
    condition     = var.tunnel1_phase2_integrity_algorithms == null || length(setsubtract(var.tunnel1_phase2_integrity_algorithms, ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"])) == 0
    error_message = "resource_aws_vpn_connection, tunnel1_phase2_integrity_algorithms must contain only valid algorithms: SHA1, SHA2-256, SHA2-384, SHA2-512."
  }
}

variable "tunnel2_phase2_integrity_algorithms" {
  type        = set(string)
  description = "List of one or more integrity algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. Valid values are SHA1, SHA2-256, SHA2-384, SHA2-512"
  default     = null

  validation {
    condition     = var.tunnel2_phase2_integrity_algorithms == null || length(setsubtract(var.tunnel2_phase2_integrity_algorithms, ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"])) == 0
    error_message = "resource_aws_vpn_connection, tunnel2_phase2_integrity_algorithms must contain only valid algorithms: SHA1, SHA2-256, SHA2-384, SHA2-512."
  }
}

variable "tunnel1_phase2_lifetime_seconds" {
  type        = number
  description = "The lifetime for phase 2 of the IKE negotiation for the first VPN tunnel, in seconds. Valid value is between 900 and 3600"
  default     = 3600

  validation {
    condition     = var.tunnel1_phase2_lifetime_seconds >= 900 && var.tunnel1_phase2_lifetime_seconds <= 3600
    error_message = "resource_aws_vpn_connection, tunnel1_phase2_lifetime_seconds must be between 900 and 3600."
  }
}

variable "tunnel2_phase2_lifetime_seconds" {
  type        = number
  description = "The lifetime for phase 2 of the IKE negotiation for the second VPN tunnel, in seconds. Valid value is between 900 and 3600"
  default     = 3600

  validation {
    condition     = var.tunnel2_phase2_lifetime_seconds >= 900 && var.tunnel2_phase2_lifetime_seconds <= 3600
    error_message = "resource_aws_vpn_connection, tunnel2_phase2_lifetime_seconds must be between 900 and 3600."
  }
}

variable "tunnel1_rekey_fuzz_percentage" {
  type        = number
  description = "The percentage of the rekey window for the first VPN tunnel (determined by tunnel1_rekey_margin_time_seconds) during which the rekey time is randomly selected. Valid value is between 0 and 100"
  default     = 100

  validation {
    condition     = var.tunnel1_rekey_fuzz_percentage >= 0 && var.tunnel1_rekey_fuzz_percentage <= 100
    error_message = "resource_aws_vpn_connection, tunnel1_rekey_fuzz_percentage must be between 0 and 100."
  }
}

variable "tunnel2_rekey_fuzz_percentage" {
  type        = number
  description = "The percentage of the rekey window for the second VPN tunnel (determined by tunnel2_rekey_margin_time_seconds) during which the rekey time is randomly selected. Valid value is between 0 and 100"
  default     = 100

  validation {
    condition     = var.tunnel2_rekey_fuzz_percentage >= 0 && var.tunnel2_rekey_fuzz_percentage <= 100
    error_message = "resource_aws_vpn_connection, tunnel2_rekey_fuzz_percentage must be between 0 and 100."
  }
}

variable "tunnel1_rekey_margin_time_seconds" {
  type        = number
  description = "The margin time, in seconds, before the phase 2 lifetime expires, during which the AWS side of the first VPN connection performs an IKE rekey. Valid value is between 60 and half of tunnel1_phase2_lifetime_seconds"
  default     = 540

  validation {
    condition     = var.tunnel1_rekey_margin_time_seconds >= 60 && var.tunnel1_rekey_margin_time_seconds <= (var.tunnel1_phase2_lifetime_seconds / 2)
    error_message = "resource_aws_vpn_connection, tunnel1_rekey_margin_time_seconds must be between 60 and half of tunnel1_phase2_lifetime_seconds."
  }
}

variable "tunnel2_rekey_margin_time_seconds" {
  type        = number
  description = "The margin time, in seconds, before the phase 2 lifetime expires, during which the AWS side of the second VPN connection performs an IKE rekey. Valid value is between 60 and half of tunnel2_phase2_lifetime_seconds"
  default     = 540

  validation {
    condition     = var.tunnel2_rekey_margin_time_seconds >= 60 && var.tunnel2_rekey_margin_time_seconds <= (var.tunnel2_phase2_lifetime_seconds / 2)
    error_message = "resource_aws_vpn_connection, tunnel2_rekey_margin_time_seconds must be between 60 and half of tunnel2_phase2_lifetime_seconds."
  }
}

variable "tunnel1_replay_window_size" {
  type        = number
  description = "The number of packets in an IKE replay window for the first VPN tunnel. Valid value is between 64 and 2048"
  default     = 1024

  validation {
    condition     = var.tunnel1_replay_window_size >= 64 && var.tunnel1_replay_window_size <= 2048
    error_message = "resource_aws_vpn_connection, tunnel1_replay_window_size must be between 64 and 2048."
  }
}

variable "tunnel2_replay_window_size" {
  type        = number
  description = "The number of packets in an IKE replay window for the second VPN tunnel. Valid value is between 64 and 2048"
  default     = 1024

  validation {
    condition     = var.tunnel2_replay_window_size >= 64 && var.tunnel2_replay_window_size <= 2048
    error_message = "resource_aws_vpn_connection, tunnel2_replay_window_size must be between 64 and 2048."
  }
}

variable "tunnel1_startup_action" {
  type        = string
  description = "The action to take when the establishing the tunnel for the first VPN connection. By default, your customer gateway device must initiate the IKE negotiation and bring up the tunnel. Specify start for AWS to initiate the IKE negotiation. Valid values are add or start"
  default     = "add"

  validation {
    condition     = contains(["add", "start"], var.tunnel1_startup_action)
    error_message = "resource_aws_vpn_connection, tunnel1_startup_action must be either 'add' or 'start'."
  }
}

variable "tunnel2_startup_action" {
  type        = string
  description = "The action to take when the establishing the tunnel for the second VPN connection. By default, your customer gateway device must initiate the IKE negotiation and bring up the tunnel. Specify start for AWS to initiate the IKE negotiation. Valid values are add or start"
  default     = "add"

  validation {
    condition     = contains(["add", "start"], var.tunnel2_startup_action)
    error_message = "resource_aws_vpn_connection, tunnel2_startup_action must be either 'add' or 'start'."
  }
}

variable "tunnel1_log_options" {
  type = object({
    cloudwatch_log_options = optional(object({
      log_enabled       = optional(bool)
      log_group_arn     = optional(string)
      log_output_format = optional(string)
    }))
  })
  description = "Options for logging VPN tunnel activity for the first tunnel"
  default     = null

  validation {
    condition = var.tunnel1_log_options == null || (
      var.tunnel1_log_options.cloudwatch_log_options == null ||
      var.tunnel1_log_options.cloudwatch_log_options.log_output_format == null ||
      contains(["json", "text"], var.tunnel1_log_options.cloudwatch_log_options.log_output_format)
    )
    error_message = "resource_aws_vpn_connection, tunnel1_log_options.cloudwatch_log_options.log_output_format must be either 'json' or 'text'."
  }
}

variable "tunnel2_log_options" {
  type = object({
    cloudwatch_log_options = optional(object({
      log_enabled       = optional(bool)
      log_group_arn     = optional(string)
      log_output_format = optional(string)
    }))
  })
  description = "Options for logging VPN tunnel activity for the second tunnel"
  default     = null

  validation {
    condition = var.tunnel2_log_options == null || (
      var.tunnel2_log_options.cloudwatch_log_options == null ||
      var.tunnel2_log_options.cloudwatch_log_options.log_output_format == null ||
      contains(["json", "text"], var.tunnel2_log_options.cloudwatch_log_options.log_output_format)
    )
    error_message = "resource_aws_vpn_connection, tunnel2_log_options.cloudwatch_log_options.log_output_format must be either 'json' or 'text'."
  }
}