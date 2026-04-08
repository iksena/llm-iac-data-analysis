resource "aws_ses_configuration_set" "this" {
  name                       = var.name
  region                     = var.region
  reputation_metrics_enabled = var.reputation_metrics_enabled
  sending_enabled            = var.sending_enabled

  dynamic "delivery_options" {
    for_each = var.delivery_options != null ? [var.delivery_options] : []
    content {
      tls_policy = delivery_options.value.tls_policy
    }
  }

  dynamic "tracking_options" {
    for_each = var.tracking_options != null ? [var.tracking_options] : []
    content {
      custom_redirect_domain = tracking_options.value.custom_redirect_domain
    }
  }
}