output "id" {
  description = "Time at which the certificate was issued"
  value       = aws_acm_certificate_validation.this.id
}

output "certificate_arn" {
  description = "ARN of the certificate that is being validated"
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "validation_record_fqdns" {
  description = "List of FQDNs that implement the validation"
  value       = aws_acm_certificate_validation.this.validation_record_fqdns
}