resource "aws_cloudfront_continuous_deployment_policy" "this" {
  enabled = var.enabled

  staging_distribution_dns_names {
    items    = var.staging_distribution_dns_names_items
    quantity = var.staging_distribution_dns_names_quantity
  }

  traffic_config {
    type = var.traffic_config_type

    dynamic "single_header_config" {
      for_each = var.traffic_config_single_header_config != null ? [var.traffic_config_single_header_config] : []
      content {
        header = single_header_config.value.header
        value  = single_header_config.value.value
      }
    }

    dynamic "single_weight_config" {
      for_each = var.traffic_config_single_weight_config != null ? [var.traffic_config_single_weight_config] : []
      content {
        weight = single_weight_config.value.weight

        dynamic "session_stickiness_config" {
          for_each = single_weight_config.value.session_stickiness_config != null ? [single_weight_config.value.session_stickiness_config] : []
          content {
            idle_ttl    = session_stickiness_config.value.idle_ttl
            maximum_ttl = session_stickiness_config.value.maximum_ttl
          }
        }
      }
    }
  }
}