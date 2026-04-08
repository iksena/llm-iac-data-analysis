output "id" {
  description = "The domain name of the domain identity."
  value       = aws_ses_domain_identity_verification.this.id
}

output "arn" {
  description = "The ARN of the domain identity."
  value       = aws_ses_domain_identity_verification.this.arn
}