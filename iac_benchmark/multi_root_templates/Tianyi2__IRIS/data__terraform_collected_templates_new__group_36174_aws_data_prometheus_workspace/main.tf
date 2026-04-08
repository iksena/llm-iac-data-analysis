data "aws_prometheus_workspace" "this" {
  region       = var.region
  workspace_id = var.workspace_id
}