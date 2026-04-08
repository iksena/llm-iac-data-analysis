resource "aws_prometheus_alert_manager_definition" "this" {
  region       = var.region
  workspace_id = var.workspace_id
  definition   = var.definition
}