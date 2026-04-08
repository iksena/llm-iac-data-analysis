resource "aws_media_convert_queue" "this" {
  region          = var.region
  name            = var.name
  concurrent_jobs = var.concurrent_jobs
  description     = var.description
  pricing_plan    = var.pricing_plan
  status          = var.status
  tags            = var.tags

  dynamic "reservation_plan_settings" {
    for_each = var.reservation_plan_settings != null ? [var.reservation_plan_settings] : []
    content {
      commitment     = reservation_plan_settings.value.commitment
      renewal_type   = reservation_plan_settings.value.renewal_type
      reserved_slots = reservation_plan_settings.value.reserved_slots
    }
  }
}