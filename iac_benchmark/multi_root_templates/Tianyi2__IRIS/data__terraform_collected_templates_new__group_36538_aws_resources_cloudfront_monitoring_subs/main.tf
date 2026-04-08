resource "aws_cloudfront_monitoring_subscription" "this" {
  distribution_id = var.distribution_id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = var.realtime_metrics_subscription_status
    }
  }
}