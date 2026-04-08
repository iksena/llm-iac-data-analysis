resource "aws_evidently_launch" "this" {
  region             = var.region
  description        = var.description
  name               = var.name
  project            = var.project
  randomization_salt = var.randomization_salt
  tags               = var.tags

  dynamic "groups" {
    for_each = var.groups
    content {
      description = groups.value.description
      feature     = groups.value.feature
      name        = groups.value.name
      variation   = groups.value.variation
    }
  }

  dynamic "metric_monitors" {
    for_each = var.metric_monitors
    content {
      metric_definition {
        entity_id_key = metric_monitors.value.metric_definition.entity_id_key
        event_pattern = metric_monitors.value.metric_definition.event_pattern
        name          = metric_monitors.value.metric_definition.name
        unit_label    = metric_monitors.value.metric_definition.unit_label
        value_key     = metric_monitors.value.metric_definition.value_key
      }
    }
  }

  dynamic "scheduled_splits_config" {
    for_each = var.scheduled_splits_config != null ? [var.scheduled_splits_config] : []
    content {
      dynamic "steps" {
        for_each = scheduled_splits_config.value.steps
        content {
          group_weights = steps.value.group_weights
          start_time    = steps.value.start_time

          dynamic "segment_overrides" {
            for_each = steps.value.segment_overrides
            content {
              evaluation_order = segment_overrides.value.evaluation_order
              segment          = segment_overrides.value.segment
              weights          = segment_overrides.value.weights
            }
          }
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}