output "region" {
  description = "Region where this resource is managed"
  value       = aws_vpc_network_performance_metric_subscription.this.region
}

output "destination" {
  description = "The target Region or Availability Zone that the metric subscription is enabled for"
  value       = aws_vpc_network_performance_metric_subscription.this.destination
}

output "metric" {
  description = "The metric used for the enabled subscription"
  value       = aws_vpc_network_performance_metric_subscription.this.metric
}

output "source" {
  description = "The source Region or Availability Zone that the metric subscription is enabled for"
  value       = aws_vpc_network_performance_metric_subscription.this.source
}

output "statistic" {
  description = "The statistic used for the enabled subscription"
  value       = aws_vpc_network_performance_metric_subscription.this.statistic
}

output "period" {
  description = "The data aggregation time for the subscription"
  value       = aws_vpc_network_performance_metric_subscription.this.period
}