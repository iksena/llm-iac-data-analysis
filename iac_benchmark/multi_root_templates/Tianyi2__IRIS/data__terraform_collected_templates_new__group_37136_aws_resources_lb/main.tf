resource "aws_lb" "this" {
  region                                                       = var.region
  client_keep_alive                                            = var.client_keep_alive
  customer_owned_ipv4_pool                                     = var.customer_owned_ipv4_pool
  desync_mitigation_mode                                       = var.desync_mitigation_mode
  dns_record_client_routing_policy                             = var.dns_record_client_routing_policy
  drop_invalid_header_fields                                   = var.drop_invalid_header_fields
  enable_cross_zone_load_balancing                             = var.enable_cross_zone_load_balancing
  enable_deletion_protection                                   = var.enable_deletion_protection
  enable_http2                                                 = var.enable_http2
  enable_tls_version_and_cipher_suite_headers                  = var.enable_tls_version_and_cipher_suite_headers
  enable_xff_client_port                                       = var.enable_xff_client_port
  enable_waf_fail_open                                         = var.enable_waf_fail_open
  enable_zonal_shift                                           = var.enable_zonal_shift
  enforce_security_group_inbound_rules_on_private_link_traffic = var.enforce_security_group_inbound_rules_on_private_link_traffic
  idle_timeout                                                 = var.idle_timeout
  internal                                                     = var.internal
  ip_address_type                                              = var.ip_address_type
  load_balancer_type                                           = var.load_balancer_type
  name                                                         = var.name
  name_prefix                                                  = var.name_prefix
  security_groups                                              = var.security_groups
  preserve_host_header                                         = var.preserve_host_header
  secondary_ips_auto_assigned_per_subnet                       = var.secondary_ips_auto_assigned_per_subnet
  subnets                                                      = var.subnets
  tags                                                         = var.tags
  xff_header_processing_mode                                   = var.xff_header_processing_mode

  dynamic "access_logs" {
    for_each = var.access_logs != null ? [var.access_logs] : []
    content {
      bucket  = access_logs.value.bucket
      enabled = lookup(access_logs.value, "enabled", false)
      prefix  = lookup(access_logs.value, "prefix", null)
    }
  }

  dynamic "connection_logs" {
    for_each = var.connection_logs != null ? [var.connection_logs] : []
    content {
      bucket  = connection_logs.value.bucket
      enabled = lookup(connection_logs.value, "enabled", false)
      prefix  = lookup(connection_logs.value, "prefix", null)
    }
  }

  dynamic "ipam_pools" {
    for_each = var.ipam_pools != null ? [var.ipam_pools] : []
    content {
      ipv4_ipam_pool_id = ipam_pools.value.ipv4_ipam_pool_id
    }
  }

  dynamic "minimum_load_balancer_capacity" {
    for_each = var.minimum_load_balancer_capacity != null ? [var.minimum_load_balancer_capacity] : []
    content {
      capacity_units = minimum_load_balancer_capacity.value.capacity_units
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping != null ? var.subnet_mapping : []
    content {
      subnet_id            = subnet_mapping.value.subnet_id
      allocation_id        = lookup(subnet_mapping.value, "allocation_id", null)
      ipv6_address         = lookup(subnet_mapping.value, "ipv6_address", null)
      private_ipv4_address = lookup(subnet_mapping.value, "private_ipv4_address", null)
    }
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}