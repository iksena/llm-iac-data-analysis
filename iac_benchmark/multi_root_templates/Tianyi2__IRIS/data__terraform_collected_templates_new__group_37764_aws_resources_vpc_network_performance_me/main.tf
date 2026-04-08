resource "aws_vpc_network_performance_metric_subscription" "this" {
  region      = var.region
  destination = var.destination
  metric      = var.metric
  source      = var.source_region
  statistic   = var.statistic
}