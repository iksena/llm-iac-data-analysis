resource "aws_vpclattice_listener" "this" {
  region             = var.region
  name               = var.name
  port               = var.port
  protocol           = var.protocol
  service_arn        = var.service_arn
  service_identifier = var.service_identifier
  tags               = var.tags

  dynamic "default_action" {
    for_each = var.default_action != null ? [var.default_action] : []
    content {
      dynamic "fixed_response" {
        for_each = try(default_action.value.fixed_response, null) != null ? [default_action.value.fixed_response] : []
        content {
          status_code = fixed_response.value.status_code
        }
      }

      dynamic "forward" {
        for_each = try(default_action.value.forward, null) != null ? [default_action.value.forward] : []
        content {
          dynamic "target_groups" {
            for_each = forward.value.target_groups
            content {
              target_group_identifier = target_groups.value.target_group_identifier
              weight                  = target_groups.value.weight
            }
          }
        }
      }
    }
  }
}