resource "aws_route53_records_exclusive" "this" {
  zone_id = var.zone_id

  dynamic "resource_record_set" {
    for_each = var.resource_record_set
    content {
      name = resource_record_set.value.name
      type = resource_record_set.value.type

      dynamic "alias_target" {
        for_each = resource_record_set.value.alias_target != null ? [resource_record_set.value.alias_target] : []
        content {
          dns_name               = alias_target.value.dns_name
          evaluate_target_health = alias_target.value.evaluate_target_health
          hosted_zone_id         = alias_target.value.hosted_zone_id
        }
      }

      failover = resource_record_set.value.failover

      dynamic "geolocation" {
        for_each = resource_record_set.value.geolocation != null ? [resource_record_set.value.geolocation] : []
        content {
        }
      }

      dynamic "geoproximity_location" {
        for_each = resource_record_set.value.geoproximity_location != null ? [resource_record_set.value.geoproximity_location] : []
        content {
          aws_region       = geoproximity_location.value.aws_region
          bias             = geoproximity_location.value.bias
          local_zone_group = geoproximity_location.value.local_zone_group

          dynamic "coordinates" {
            for_each = geoproximity_location.value.coordinates != null ? [geoproximity_location.value.coordinates] : []
            content {
              latitude  = coordinates.value.latitude
              longitude = coordinates.value.longitude
            }
          }
        }
      }

      health_check_id            = resource_record_set.value.health_check_id
      multi_value_answer         = resource_record_set.value.multi_value_answer
      region                     = resource_record_set.value.region
      set_identifier             = resource_record_set.value.set_identifier
      traffic_policy_instance_id = resource_record_set.value.traffic_policy_instance_id
      ttl                        = resource_record_set.value.ttl
      weight                     = resource_record_set.value.weight

      dynamic "resource_records" {
        for_each = resource_record_set.value.resource_records != null ? resource_record_set.value.resource_records : []
        content {
          value = resource_records.value.value
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
  }
}