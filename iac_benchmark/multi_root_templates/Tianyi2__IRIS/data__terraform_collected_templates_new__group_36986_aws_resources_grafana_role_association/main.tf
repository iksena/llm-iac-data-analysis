resource "aws_grafana_role_association" "this" {
  role         = var.role
  workspace_id = var.workspace_id

  region    = var.region
  group_ids = var.group_ids
  user_ids  = var.user_ids
}