output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_acmpca_certificate.this.region
}

output "arn" {
  description = "ARN of the certificate issued by the private certificate authority."
  value       = data.aws_acmpca_certificate.this.arn
}

output "certificate_authority_arn" {
  description = "ARN of the certificate authority."
  value       = data.aws_acmpca_certificate.this.certificate_authority_arn
}

output "certificate" {
  description = "PEM-encoded certificate value."
  value       = data.aws_acmpca_certificate.this.certificate
}

output "certificate_chain" {
  description = "PEM-encoded certificate chain that includes any intermediate certificates and chains up to root CA."
  value       = data.aws_acmpca_certificate.this.certificate_chain
}