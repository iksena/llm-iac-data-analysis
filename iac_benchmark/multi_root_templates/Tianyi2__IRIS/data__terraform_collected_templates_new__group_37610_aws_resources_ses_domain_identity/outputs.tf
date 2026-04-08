output "arn" {
  description = "The ARN of the domain identity"
  value       = aws_ses_domain_identity.this.arn
}

output "verification_token" {
  description = "A code which when added to the domain as a TXT record will signal to SES that the owner of the domain has authorized SES to act on their behalf"
  value       = aws_ses_domain_identity.this.verification_token
}