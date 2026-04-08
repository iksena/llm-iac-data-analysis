resource "aws_oam_link" "this" {
  label_template  = var.label_template
  resource_types  = var.resource_types
  sink_identifier = var.sink_identifier

  region = var.region

  dynamic "link_configuration" {
    for_each = var.link_configuration != null ? [var.link_configuration] : []
    content {
      dynamic "log_group_configuration" {
        for_each = link_configuration.value.log_group_configuration != null ? [link_configuration.value.log_group_configuration] : []
        content {
          filter = log_group_configuration.value.filter
        }
      }

      dynamic "metric_configuration" {
        for_each = link_configuration.value.metric_configuration != null ? [link_configuration.value.metric_configuration] : []
        content {
          filter = metric_configuration.value.filter
        }
      }
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}