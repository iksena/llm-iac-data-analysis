output "arn" {
  description = "SES receipt rule set ARN."
  value       = aws_ses_receipt_rule_set.this.arn
}

output "id" {
  description = "SES receipt rule set name."
  value       = aws_ses_receipt_rule_set.this.id
}