resource "aws_sesv2_account_vdm_attributes" "this" {
  vdm_enabled = var.vdm_enabled
  region      = var.region

  dynamic "dashboard_attributes" {
    for_each = var.dashboard_attributes != null ? [var.dashboard_attributes] : []
    content {
      engagement_metrics = dashboard_attributes.value.engagement_metrics
    }
  }

  dynamic "guardian_attributes" {
    for_each = var.guardian_attributes != null ? [var.guardian_attributes] : []
    content {
      optimized_shared_delivery = guardian_attributes.value.optimized_shared_delivery
    }
  }
}