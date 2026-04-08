resource "aws_glue_trigger" "this" {
  region            = var.region
  description       = var.description
  enabled           = var.enabled
  name              = var.name
  schedule          = var.schedule
  tags              = var.tags
  start_on_creation = var.start_on_creation
  type              = var.type
  workflow_name     = var.workflow_name

  dynamic "actions" {
    for_each = var.actions
    content {
      arguments              = lookup(actions.value, "arguments", null)
      crawler_name           = lookup(actions.value, "crawler_name", null)
      job_name               = lookup(actions.value, "job_name", null)
      timeout                = lookup(actions.value, "timeout", null)
      security_configuration = lookup(actions.value, "security_configuration", null)

      dynamic "notification_property" {
        for_each = lookup(actions.value, "notification_property", null) != null ? [actions.value.notification_property] : []
        content {
          notify_delay_after = lookup(notification_property.value, "notify_delay_after", null)
        }
      }
    }
  }

  dynamic "predicate" {
    for_each = var.predicate != null ? [var.predicate] : []
    content {
      logical = lookup(predicate.value, "logical", "AND")

      dynamic "conditions" {
        for_each = predicate.value.conditions
        content {
          job_name         = lookup(conditions.value, "job_name", null)
          state            = lookup(conditions.value, "state", null)
          crawler_name     = lookup(conditions.value, "crawler_name", null)
          crawl_state      = lookup(conditions.value, "crawl_state", null)
          logical_operator = lookup(conditions.value, "logical_operator", "EQUALS")
        }
      }
    }
  }

  dynamic "event_batching_condition" {
    for_each = var.event_batching_condition != null ? [var.event_batching_condition] : []
    content {
      batch_size   = event_batching_condition.value.batch_size
      batch_window = lookup(event_batching_condition.value, "batch_window", 900)
    }
  }
}