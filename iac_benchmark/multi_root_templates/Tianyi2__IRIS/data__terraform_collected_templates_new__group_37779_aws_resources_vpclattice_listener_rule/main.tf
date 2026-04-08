resource "aws_vpclattice_listener_rule" "this" {
  name                = var.name
  listener_identifier = var.listener_identifier
  service_identifier  = var.service_identifier
  priority            = var.priority
  region              = var.region
  tags                = var.tags

  action {
    dynamic "fixed_response" {
      for_each = var.action.fixed_response != null ? [var.action.fixed_response] : []
      content {
        status_code = fixed_response.value.status_code
      }
    }

    dynamic "forward" {
      for_each = var.action.forward != null ? [var.action.forward] : []
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

  match {
    http_match {
      method = var.match.http_match.method

      dynamic "header_matches" {
        for_each = var.match.http_match.header_matches != null ? var.match.http_match.header_matches : []
        content {
          name           = header_matches.value.name
          case_sensitive = header_matches.value.case_sensitive

          dynamic "match" {
            for_each = header_matches.value.match != null ? [header_matches.value.match] : []
            content {
              contains = match.value.contains
              exact    = match.value.exact
              prefix   = match.value.prefix
            }
          }
        }
      }

      dynamic "path_match" {
        for_each = var.match.http_match.path_match != null ? [var.match.http_match.path_match] : []
        content {
          case_sensitive = path_match.value.case_sensitive

          dynamic "match" {
            for_each = path_match.value.match != null ? [path_match.value.match] : []
            content {
              exact  = match.value.exact
              prefix = match.value.prefix
            }
          }
        }
      }
    }
  }
}