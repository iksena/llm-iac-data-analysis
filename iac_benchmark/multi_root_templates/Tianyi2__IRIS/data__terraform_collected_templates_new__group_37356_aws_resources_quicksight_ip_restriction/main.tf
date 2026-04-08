resource "aws_quicksight_ip_restriction" "this" {
  aws_account_id                       = var.aws_account_id
  enabled                              = var.enabled
  ip_restriction_rule_map              = var.ip_restriction_rule_map
  region                               = var.region
  vpc_endpoint_id_restriction_rule_map = var.vpc_endpoint_id_restriction_rule_map
  vpc_id_restriction_rule_map          = var.vpc_id_restriction_rule_map
}