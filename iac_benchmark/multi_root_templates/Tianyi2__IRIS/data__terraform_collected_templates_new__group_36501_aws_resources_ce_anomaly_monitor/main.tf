resource "aws_ce_anomaly_monitor" "this" {
  name                  = var.name
  monitor_type          = var.monitor_type
  monitor_dimension     = var.monitor_dimension
  monitor_specification = var.monitor_specification
  tags                  = var.tags
}