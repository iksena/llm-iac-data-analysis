output "arn" {
  description = "SES receipt rule set ARN"
  value       = data.aws_ses_active_receipt_rule_set.this.arn
}

output "rule_set_name" {
  description = "Name of the rule set"
  value       = data.aws_ses_active_receipt_rule_set.this.rule_set_name
}