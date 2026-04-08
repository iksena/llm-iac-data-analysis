resource "aws_workspacesweb_network_settings" "this" {
  security_group_ids = var.security_group_ids
  subnet_ids         = var.subnet_ids
  vpc_id             = var.vpc_id

  region = var.region
  tags   = var.tags
}