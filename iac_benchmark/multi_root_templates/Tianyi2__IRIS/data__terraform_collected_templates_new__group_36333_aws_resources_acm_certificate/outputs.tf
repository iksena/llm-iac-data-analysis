output "id" {
  description = "ARN of the certificate"
  value       = aws_acm_certificate.this.id
}

output "arn" {
  description = "ARN of the certificate"
  value       = aws_acm_certificate.this.arn
}

output "domain_name" {
  description = "Domain name for which the certificate is issued"
  value       = aws_acm_certificate.this.domain_name
}

output "domain_validation_options" {
  description = "Set of domain validation objects which can be used to complete certificate validation"
  value       = aws_acm_certificate.this.domain_validation_options
}

output "not_after" {
  description = "Expiration date and time of the certificate"
  value       = aws_acm_certificate.this.not_after
}

output "not_before" {
  description = "Start of the validity period of the certificate"
  value       = aws_acm_certificate.this.not_before
}

output "pending_renewal" {
  description = "true if a Private certificate eligible for managed renewal is within the early_renewal_duration period"
  value       = aws_acm_certificate.this.pending_renewal
}

output "renewal_eligibility" {
  description = "Whether the certificate is eligible for managed renewal"
  value       = aws_acm_certificate.this.renewal_eligibility
}

output "renewal_summary" {
  description = "Contains information about the status of ACM's managed renewal for the certificate"
  value       = aws_acm_certificate.this.renewal_summary
}

output "status" {
  description = "Status of the certificate"
  value       = aws_acm_certificate.this.status
}

output "type" {
  description = "Source of the certificate"
  value       = aws_acm_certificate.this.type
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_acm_certificate.this.tags_all
}

output "validation_emails" {
  description = "List of addresses that received a validation email. Only set if EMAIL validation was used"
  value       = aws_acm_certificate.this.validation_emails
}