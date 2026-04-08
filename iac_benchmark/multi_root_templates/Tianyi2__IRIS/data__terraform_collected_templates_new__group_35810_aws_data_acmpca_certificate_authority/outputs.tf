output "id" {
  description = "ARN of the certificate authority"
  value       = data.aws_acmpca_certificate_authority.this.id
}

output "certificate" {
  description = "Base64-encoded certificate authority (CA) certificate"
  value       = data.aws_acmpca_certificate_authority.this.certificate
}

output "certificate_chain" {
  description = "Base64-encoded certificate chain that includes any intermediate certificates and chains up to root on-premises certificate"
  value       = data.aws_acmpca_certificate_authority.this.certificate_chain
}

output "certificate_signing_request" {
  description = "The base64 PEM-encoded certificate signing request (CSR) for your private CA certificate"
  value       = data.aws_acmpca_certificate_authority.this.certificate_signing_request
}

output "usage_mode" {
  description = "Specifies whether the CA issues general-purpose certificates that typically require a revocation mechanism, or short-lived certificates"
  value       = data.aws_acmpca_certificate_authority.this.usage_mode
}

output "not_after" {
  description = "Date and time after which the certificate authority is not valid"
  value       = data.aws_acmpca_certificate_authority.this.not_after
}

output "not_before" {
  description = "Date and time before which the certificate authority is not valid"
  value       = data.aws_acmpca_certificate_authority.this.not_before
}

output "revocation_configuration" {
  description = "Nested attribute containing revocation configuration"
  value       = data.aws_acmpca_certificate_authority.this.revocation_configuration
}

output "serial" {
  description = "Serial number of the certificate authority"
  value       = data.aws_acmpca_certificate_authority.this.serial
}

output "status" {
  description = "Status of the certificate authority"
  value       = data.aws_acmpca_certificate_authority.this.status
}

output "tags" {
  description = "Key-value map of user-defined tags that are attached to the certificate authority"
  value       = data.aws_acmpca_certificate_authority.this.tags
}

output "type" {
  description = "Type of the certificate authority"
  value       = data.aws_acmpca_certificate_authority.this.type
}