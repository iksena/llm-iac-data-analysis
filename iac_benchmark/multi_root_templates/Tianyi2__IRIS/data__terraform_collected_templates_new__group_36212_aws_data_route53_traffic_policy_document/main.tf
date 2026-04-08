data "aws_route53_traffic_policy_document" "this" {
  record_type    = var.record_type
  start_endpoint = var.start_endpoint
  start_rule     = var.start_rule
  version        = var.traffic_policy_version

  dynamic "endpoint" {
    for_each = var.endpoints
    content {
      id     = endpoint.value.id
      type   = endpoint.value.type
      region = endpoint.value.region
      value  = endpoint.value.value
    }
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      id   = rule.value.id
      type = rule.value.type

      dynamic "primary" {
        for_each = rule.value.primary != null ? [rule.value.primary] : []
        content {
          endpoint_reference     = primary.value.endpoint_reference
          evaluate_target_health = primary.value.evaluate_target_health
          health_check           = primary.value.health_check
          rule_reference         = primary.value.rule_reference
        }
      }

      dynamic "secondary" {
        for_each = rule.value.secondary != null ? [rule.value.secondary] : []
        content {
          endpoint_reference     = secondary.value.endpoint_reference
          evaluate_target_health = secondary.value.evaluate_target_health
          health_check           = secondary.value.health_check
          rule_reference         = secondary.value.rule_reference
        }
      }

      dynamic "location" {
        for_each = rule.value.locations != null ? rule.value.locations : []
        content {
          continent              = location.value.continent
          country                = location.value.country
          endpoint_reference     = location.value.endpoint_reference
          evaluate_target_health = location.value.evaluate_target_health
          health_check           = location.value.health_check
          is_default             = location.value.is_default
          rule_reference         = location.value.rule_reference
          subdivision            = location.value.subdivision
        }
      }

      dynamic "geo_proximity_location" {
        for_each = rule.value.geo_proximity_locations != null ? rule.value.geo_proximity_locations : []
        content {
          bias                   = geo_proximity_location.value.bias
          endpoint_reference     = geo_proximity_location.value.endpoint_reference
          evaluate_target_health = geo_proximity_location.value.evaluate_target_health
          health_check           = geo_proximity_location.value.health_check
          latitude               = geo_proximity_location.value.latitude
          longitude              = geo_proximity_location.value.longitude
          region                 = geo_proximity_location.value.region
          rule_reference         = geo_proximity_location.value.rule_reference
        }
      }

      dynamic "region" {
        for_each = rule.value.regions != null ? rule.value.regions : []
        content {
          endpoint_reference     = region.value.endpoint_reference
          evaluate_target_health = region.value.evaluate_target_health
          health_check           = region.value.health_check
          region                 = region.value.region
          rule_reference         = region.value.rule_reference
        }
      }

      dynamic "items" {
        for_each = rule.value.items != null ? rule.value.items : []
        content {
          endpoint_reference = items.value.endpoint_reference
          health_check       = items.value.health_check
        }
      }
    }
  }
}