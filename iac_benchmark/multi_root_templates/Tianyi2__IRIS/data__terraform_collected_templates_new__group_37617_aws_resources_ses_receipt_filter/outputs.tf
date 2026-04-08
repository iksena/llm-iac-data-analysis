output "id" {
  description = "The SES receipt filter name."
  value       = aws_ses_receipt_filter.this.id
}

output "arn" {
  description = "The SES receipt filter ARN."
  value       = aws_ses_receipt_filter.this.arn
}