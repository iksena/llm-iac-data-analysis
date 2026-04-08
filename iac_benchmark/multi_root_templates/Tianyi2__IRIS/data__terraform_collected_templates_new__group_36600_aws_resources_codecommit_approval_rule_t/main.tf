resource "aws_codecommit_approval_rule_template_association" "this" {
  region                      = var.region
  approval_rule_template_name = var.approval_rule_template_name
  repository_name             = var.repository_name
}