resource "aws_vpn_connection" "this" {
  customer_gateway_id                     = var.customer_gateway_id
  type                                    = var.type
  region                                  = var.region
  transit_gateway_id                      = var.transit_gateway_id
  vpn_gateway_id                          = var.vpn_gateway_id
  static_routes_only                      = var.static_routes_only
  enable_acceleration                     = var.enable_acceleration
  preshared_key_storage                   = var.preshared_key_storage
  tags                                    = var.tags
  local_ipv4_network_cidr                 = var.local_ipv4_network_cidr
  local_ipv6_network_cidr                 = var.local_ipv6_network_cidr
  outside_ip_address_type                 = var.outside_ip_address_type
  remote_ipv4_network_cidr                = var.remote_ipv4_network_cidr
  remote_ipv6_network_cidr                = var.remote_ipv6_network_cidr
  transport_transit_gateway_attachment_id = var.transport_transit_gateway_attachment_id
  tunnel_inside_ip_version                = var.tunnel_inside_ip_version
  tunnel1_inside_cidr                     = var.tunnel1_inside_cidr
  tunnel2_inside_cidr                     = var.tunnel2_inside_cidr
  tunnel1_inside_ipv6_cidr                = var.tunnel1_inside_ipv6_cidr
  tunnel2_inside_ipv6_cidr                = var.tunnel2_inside_ipv6_cidr
  tunnel1_preshared_key                   = var.tunnel1_preshared_key
  tunnel2_preshared_key                   = var.tunnel2_preshared_key
  tunnel1_dpd_timeout_action              = var.tunnel1_dpd_timeout_action
  tunnel2_dpd_timeout_action              = var.tunnel2_dpd_timeout_action
  tunnel1_dpd_timeout_seconds             = var.tunnel1_dpd_timeout_seconds
  tunnel2_dpd_timeout_seconds             = var.tunnel2_dpd_timeout_seconds
  tunnel1_enable_tunnel_lifecycle_control = var.tunnel1_enable_tunnel_lifecycle_control
  tunnel2_enable_tunnel_lifecycle_control = var.tunnel2_enable_tunnel_lifecycle_control
  tunnel1_ike_versions                    = var.tunnel1_ike_versions
  tunnel2_ike_versions                    = var.tunnel2_ike_versions
  tunnel1_phase1_dh_group_numbers         = var.tunnel1_phase1_dh_group_numbers
  tunnel2_phase1_dh_group_numbers         = var.tunnel2_phase1_dh_group_numbers
  tunnel1_phase1_encryption_algorithms    = var.tunnel1_phase1_encryption_algorithms
  tunnel2_phase1_encryption_algorithms    = var.tunnel2_phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms     = var.tunnel1_phase1_integrity_algorithms
  tunnel2_phase1_integrity_algorithms     = var.tunnel2_phase1_integrity_algorithms
  tunnel1_phase1_lifetime_seconds         = var.tunnel1_phase1_lifetime_seconds
  tunnel2_phase1_lifetime_seconds         = var.tunnel2_phase1_lifetime_seconds
  tunnel1_phase2_dh_group_numbers         = var.tunnel1_phase2_dh_group_numbers
  tunnel2_phase2_dh_group_numbers         = var.tunnel2_phase2_dh_group_numbers
  tunnel1_phase2_encryption_algorithms    = var.tunnel1_phase2_encryption_algorithms
  tunnel2_phase2_encryption_algorithms    = var.tunnel2_phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms     = var.tunnel1_phase2_integrity_algorithms
  tunnel2_phase2_integrity_algorithms     = var.tunnel2_phase2_integrity_algorithms
  tunnel1_phase2_lifetime_seconds         = var.tunnel1_phase2_lifetime_seconds
  tunnel2_phase2_lifetime_seconds         = var.tunnel2_phase2_lifetime_seconds
  tunnel1_rekey_fuzz_percentage           = var.tunnel1_rekey_fuzz_percentage
  tunnel2_rekey_fuzz_percentage           = var.tunnel2_rekey_fuzz_percentage
  tunnel1_rekey_margin_time_seconds       = var.tunnel1_rekey_margin_time_seconds
  tunnel2_rekey_margin_time_seconds       = var.tunnel2_rekey_margin_time_seconds
  tunnel1_replay_window_size              = var.tunnel1_replay_window_size
  tunnel2_replay_window_size              = var.tunnel2_replay_window_size
  tunnel1_startup_action                  = var.tunnel1_startup_action
  tunnel2_startup_action                  = var.tunnel2_startup_action

  dynamic "tunnel1_log_options" {
    for_each = var.tunnel1_log_options != null ? [var.tunnel1_log_options] : []
    content {
      dynamic "cloudwatch_log_options" {
        for_each = tunnel1_log_options.value.cloudwatch_log_options != null ? [tunnel1_log_options.value.cloudwatch_log_options] : []
        content {
          log_enabled       = cloudwatch_log_options.value.log_enabled
          log_group_arn     = cloudwatch_log_options.value.log_group_arn
          log_output_format = cloudwatch_log_options.value.log_output_format
        }
      }
    }
  }

  dynamic "tunnel2_log_options" {
    for_each = var.tunnel2_log_options != null ? [var.tunnel2_log_options] : []
    content {
      dynamic "cloudwatch_log_options" {
        for_each = tunnel2_log_options.value.cloudwatch_log_options != null ? [tunnel2_log_options.value.cloudwatch_log_options] : []
        content {
          log_enabled       = cloudwatch_log_options.value.log_enabled
          log_group_arn     = cloudwatch_log_options.value.log_group_arn
          log_output_format = cloudwatch_log_options.value.log_output_format
        }
      }
    }
  }
}