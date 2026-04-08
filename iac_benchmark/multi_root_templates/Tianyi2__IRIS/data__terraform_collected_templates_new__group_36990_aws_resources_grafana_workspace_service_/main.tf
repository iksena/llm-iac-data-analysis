resource "aws_grafana_workspace_service_account" "this" {
  region       = var.region
  name         = var.name
  grafana_role = var.grafana_role
  workspace_id = var.workspace_id
}