resource "aws_ecr_replication_configuration" "this" {
  region = var.region

  replication_configuration {
    dynamic "rule" {
      for_each = var.replication_configuration_rules
      content {
        dynamic "destination" {
          for_each = rule.value.destinations
          content {
            region      = destination.value.region
            registry_id = destination.value.registry_id
          }
        }

        dynamic "repository_filter" {
          for_each = rule.value.repository_filter != null ? [rule.value.repository_filter] : []
          content {
            filter      = repository_filter.value.filter
            filter_type = repository_filter.value.filter_type
          }
        }
      }
    }
  }
}