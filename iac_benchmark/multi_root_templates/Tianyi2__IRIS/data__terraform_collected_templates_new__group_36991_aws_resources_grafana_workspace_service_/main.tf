resource "aws_grafana_workspace_service_account_token" "this" {
  name               = var.name
  seconds_to_live    = var.seconds_to_live
  service_account_id = var.service_account_id
  workspace_id       = var.workspace_id
  region             = var.region
}