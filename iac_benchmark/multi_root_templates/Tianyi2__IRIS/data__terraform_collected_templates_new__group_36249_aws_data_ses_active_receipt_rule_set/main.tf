data "aws_ses_active_receipt_rule_set" "this" {
  region = var.region
}