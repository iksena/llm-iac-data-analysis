resource "aws_route53recoverycontrolconfig_control_panel" "this" {
  cluster_arn = var.cluster_arn
  name        = var.name
}