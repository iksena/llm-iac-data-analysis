resource "aws_prometheus_rule_group_namespace" "this" {
  region       = var.region
  data         = var.data
  name         = var.name
  tags         = var.tags
  workspace_id = var.workspace_id
}