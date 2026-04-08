resource "aws_ssmcontacts_plan" "this" {
  region     = var.region
  contact_id = var.contact_id

  dynamic "stage" {
    for_each = var.stage
    content {
      duration_in_minutes = stage.value.duration_in_minutes

      dynamic "target" {
        for_each = stage.value.target
        content {
          dynamic "channel_target_info" {
            for_each = target.value.channel_target_info != null ? [target.value.channel_target_info] : []
            content {
              contact_channel_id        = channel_target_info.value.contact_channel_id
              retry_interval_in_minutes = channel_target_info.value.retry_interval_in_minutes
            }
          }

          dynamic "contact_target_info" {
            for_each = target.value.contact_target_info != null ? [target.value.contact_target_info] : []
            content {
              contact_id   = contact_target_info.value.contact_id
              is_essential = contact_target_info.value.is_essential
            }
          }
        }
      }
    }
  }
}