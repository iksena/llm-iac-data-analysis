resource "aws_route53recoveryreadiness_resource_set" "this" {
  resource_set_name = var.resource_set_name
  resource_set_type = var.resource_set_type
  tags              = var.tags

  dynamic "resources" {
    for_each = var.resources
    content {
      readiness_scopes = try(resources.value.readiness_scopes, null)
      resource_arn     = try(resources.value.resource_arn, null)

      dynamic "dns_target_resource" {
        for_each = try(resources.value.dns_target_resource, null) != null ? [resources.value.dns_target_resource] : []
        content {
          domain_name     = try(dns_target_resource.value.domain_name, null)
          hosted_zone_arn = try(dns_target_resource.value.hosted_zone_arn, null)
          record_set_id   = try(dns_target_resource.value.record_set_id, null)
          record_type     = try(dns_target_resource.value.record_type, null)

          dynamic "target_resource" {
            for_each = try(dns_target_resource.value.target_resource, null) != null ? [dns_target_resource.value.target_resource] : []
            content {
              dynamic "nlb_resource" {
                for_each = try(target_resource.value.nlb_resource, null) != null ? [target_resource.value.nlb_resource] : []
                content {
                  arn = nlb_resource.value.arn
                }
              }

              dynamic "r53_resource" {
                for_each = try(target_resource.value.r53_resource, null) != null ? [target_resource.value.r53_resource] : []
                content {
                  domain_name   = try(r53_resource.value.domain_name, null)
                  record_set_id = try(r53_resource.value.record_set_id, null)
                }
              }
            }
          }
        }
      }
    }
  }

  timeouts {
    delete = var.delete_timeout
  }
}