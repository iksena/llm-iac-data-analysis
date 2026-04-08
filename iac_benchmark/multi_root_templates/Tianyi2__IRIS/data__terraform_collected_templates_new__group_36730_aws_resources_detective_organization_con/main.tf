resource "aws_detective_organization_configuration" "this" {
  auto_enable = var.auto_enable
  graph_arn   = var.graph_arn
  region      = var.region
}