output "id" {
  description = "The ID of the CloudFront monitoring subscription, which corresponds to the distribution_id."
  value       = aws_cloudfront_monitoring_subscription.this.id
}

output "distribution_id" {
  description = "The ID of the distribution that you are enabling metrics for."
  value       = aws_cloudfront_monitoring_subscription.this.distribution_id
}

output "realtime_metrics_subscription_status" {
  description = "The realtime metrics subscription status for the CloudFront distribution."
  value       = aws_cloudfront_monitoring_subscription.this.monitoring_subscription[0].realtime_metrics_subscription_config[0].realtime_metrics_subscription_status
}