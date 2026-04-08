resource "aws_route53_record" "this" {
  zone_id         = var.zone_id
  name            = var.name
  type            = var.type
  ttl             = var.ttl
  records         = var.records
  set_identifier  = var.set_identifier
  health_check_id = var.health_check_id
  allow_overwrite = var.allow_overwrite

  dynamic "alias" {
    for_each = var.alias != null ? [var.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }

  dynamic "cidr_routing_policy" {
    for_each = var.cidr_routing_policy != null ? [var.cidr_routing_policy] : []
    content {
      collection_id = cidr_routing_policy.value.collection_id
      location_name = cidr_routing_policy.value.location_name
    }
  }

  dynamic "failover_routing_policy" {
    for_each = var.failover_routing_policy != null ? [var.failover_routing_policy] : []
    content {
      type = failover_routing_policy.value.type
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = var.geolocation_routing_policy != null ? [var.geolocation_routing_policy] : []
    content {
      continent   = geolocation_routing_policy.value.continent
      country     = geolocation_routing_policy.value.country
      subdivision = geolocation_routing_policy.value.subdivision
    }
  }

  dynamic "geoproximity_routing_policy" {
    for_each = var.geoproximity_routing_policy != null ? [var.geoproximity_routing_policy] : []
    content {
      aws_region       = geoproximity_routing_policy.value.aws_region
      bias             = geoproximity_routing_policy.value.bias
      local_zone_group = geoproximity_routing_policy.value.local_zone_group

      dynamic "coordinates" {
        for_each = geoproximity_routing_policy.value.coordinates != null ? [geoproximity_routing_policy.value.coordinates] : []
        content {
          latitude  = coordinates.value.latitude
          longitude = coordinates.value.longitude
        }
      }
    }
  }

  dynamic "latency_routing_policy" {
    for_each = var.latency_routing_policy != null ? [var.latency_routing_policy] : []
    content {
      region = latency_routing_policy.value.region
    }
  }

  multivalue_answer_routing_policy = var.multivalue_answer_routing_policy

  dynamic "weighted_routing_policy" {
    for_each = var.weighted_routing_policy != null ? [var.weighted_routing_policy] : []
    content {
      weight = weighted_routing_policy.value.weight
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}