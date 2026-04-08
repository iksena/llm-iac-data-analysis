output "id" {
  description = "The SES receipt rule set name."
  value       = aws_ses_active_receipt_rule_set.this.id
}

output "arn" {
  description = "The SES receipt rule set ARN."
  value       = aws_ses_active_receipt_rule_set.this.arn
}