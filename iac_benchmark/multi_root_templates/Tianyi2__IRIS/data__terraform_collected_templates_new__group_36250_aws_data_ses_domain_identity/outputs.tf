output "arn" {
  description = "ARN of the domain identity"
  value       = data.aws_ses_domain_identity.this.arn
}

output "domain" {
  description = "Name of the domain"
  value       = data.aws_ses_domain_identity.this.domain
}

output "verification_token" {
  description = "Code which when added to the domain as a TXT record will signal to SES that the owner of the domain has authorized SES to act on their behalf"
  value       = data.aws_ses_domain_identity.this.verification_token
}