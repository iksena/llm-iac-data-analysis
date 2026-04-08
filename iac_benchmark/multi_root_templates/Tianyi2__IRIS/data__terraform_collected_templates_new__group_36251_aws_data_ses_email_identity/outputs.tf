output "arn" {
  description = "The ARN of the email identity"
  value       = data.aws_ses_email_identity.this.arn
}

output "email" {
  description = "Email identity"
  value       = data.aws_ses_email_identity.this.email
}