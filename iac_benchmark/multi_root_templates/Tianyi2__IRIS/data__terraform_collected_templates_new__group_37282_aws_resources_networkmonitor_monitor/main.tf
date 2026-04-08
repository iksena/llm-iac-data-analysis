resource "aws_networkmonitor_monitor" "this" {
  monitor_name       = var.monitor_name
  region             = var.region
  aggregation_period = var.aggregation_period
  tags               = var.tags
}