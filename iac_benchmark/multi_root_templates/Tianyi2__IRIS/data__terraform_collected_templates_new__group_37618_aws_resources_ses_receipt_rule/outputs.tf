output "id" {
  description = "The SES receipt rule name"
  value       = aws_ses_receipt_rule.this.id
}

output "arn" {
  description = "The SES receipt rule ARN"
  value       = aws_ses_receipt_rule.this.arn
}