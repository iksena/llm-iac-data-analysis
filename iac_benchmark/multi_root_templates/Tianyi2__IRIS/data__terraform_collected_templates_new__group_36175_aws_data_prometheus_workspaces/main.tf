data "aws_prometheus_workspaces" "this" {
  region       = var.region
  alias_prefix = var.alias_prefix
}