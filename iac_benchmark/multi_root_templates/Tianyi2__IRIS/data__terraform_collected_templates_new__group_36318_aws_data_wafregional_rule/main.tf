data "aws_wafregional_rule" "this" {
  name   = var.name
  region = var.region
}