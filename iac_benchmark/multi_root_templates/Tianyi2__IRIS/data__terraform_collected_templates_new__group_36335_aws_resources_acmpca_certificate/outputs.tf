output "arn" {
  description = "ARN of the certificate."
  value       = aws_acmpca_certificate.this.arn
}

output "certificate" {
  description = "PEM-encoded certificate value."
  value       = aws_acmpca_certificate.this.certificate
}

output "certificate_chain" {
  description = "PEM-encoded certificate chain that includes any intermediate certificates and chains up to root CA."
  value       = aws_acmpca_certificate.this.certificate_chain
}