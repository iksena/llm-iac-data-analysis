output "arn" {
  description = "The ARN of the certificate"
  value       = aws_transfer_certificate.this.arn
}

output "certificate_id" {
  description = "The unique identifier for the AS2 certificate"
  value       = aws_transfer_certificate.this.certificate_id
}

output "active_date" {
  description = "An date when the certificate becomes active"
  value       = aws_transfer_certificate.this.active_date
}

output "inactive_date" {
  description = "An date when the certificate becomes inactive"
  value       = aws_transfer_certificate.this.inactive_date
}