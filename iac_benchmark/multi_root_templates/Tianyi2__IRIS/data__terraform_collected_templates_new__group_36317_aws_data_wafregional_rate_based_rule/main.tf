data "aws_wafregional_rate_based_rule" "this" {
  name   = var.name
  region = var.region
}