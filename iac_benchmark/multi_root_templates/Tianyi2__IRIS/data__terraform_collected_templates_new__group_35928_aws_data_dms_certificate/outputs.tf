output "certificate_id" {
  description = "A customer-assigned name for the certificate"
  value       = data.aws_dms_certificate.this.certificate_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_dms_certificate.this.region
}

output "certificate_creation_date" {
  description = "The date that the certificate was created"
  value       = data.aws_dms_certificate.this.certificate_creation_date
}

output "certificate_pem" {
  description = "The contents of a .pem file, which contains an X.509 certificate"
  value       = data.aws_dms_certificate.this.certificate_pem
  sensitive   = true
}

output "certificate_owner" {
  description = "The owner of the certificate"
  value       = data.aws_dms_certificate.this.certificate_owner
}

output "certificate_arn" {
  description = "The Amazon Resource Name (ARN) for the certificate"
  value       = data.aws_dms_certificate.this.certificate_arn
}

output "certificate_wallet" {
  description = "The owner of the certificate"
  value       = data.aws_dms_certificate.this.certificate_wallet
}

output "key_length" {
  description = "The key length of the cryptographic algorithm being used"
  value       = data.aws_dms_certificate.this.key_length
}

output "signing_algorithm" {
  description = "The algorithm for the certificate"
  value       = data.aws_dms_certificate.this.signing_algorithm
}

output "valid_from_date" {
  description = "The beginning date that the certificate is valid"
  value       = data.aws_dms_certificate.this.valid_from_date
}

output "valid_to_date" {
  description = "The final date that the certificate is valid"
  value       = data.aws_dms_certificate.this.valid_to_date
}