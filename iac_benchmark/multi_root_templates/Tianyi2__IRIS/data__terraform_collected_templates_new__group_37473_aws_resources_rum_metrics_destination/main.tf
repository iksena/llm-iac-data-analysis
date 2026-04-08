resource "aws_rum_metrics_destination" "this" {
  app_monitor_name = var.app_monitor_name
  destination      = var.destination
  destination_arn  = var.destination_arn
  iam_role_arn     = var.iam_role_arn
  region           = var.region
}