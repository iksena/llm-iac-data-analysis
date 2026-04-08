data "aws_codecommit_approval_rule_template" "this" {
  name   = var.name
  region = var.region
}