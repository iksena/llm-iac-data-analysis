resource "aws_grafana_workspace_api_key" "this" {
  region          = var.region
  key_name        = var.key_name
  key_role        = var.key_role
  seconds_to_live = var.seconds_to_live
  workspace_id    = var.workspace_id
}