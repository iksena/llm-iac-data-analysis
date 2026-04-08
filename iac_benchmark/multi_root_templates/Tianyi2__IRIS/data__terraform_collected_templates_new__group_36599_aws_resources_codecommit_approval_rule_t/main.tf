resource "aws_codecommit_approval_rule_template" "this" {
  region      = var.region
  content     = var.content
  name        = var.name
  description = var.description
}