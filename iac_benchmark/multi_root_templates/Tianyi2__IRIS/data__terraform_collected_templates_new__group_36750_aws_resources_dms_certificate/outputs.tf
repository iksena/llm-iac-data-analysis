output "region" {
  description = "Region where the resource is managed."
  value       = aws_dms_certificate.this.region
}

output "certificate_id" {
  description = "The certificate identifier."
  value       = aws_dms_certificate.this.certificate_id
}

output "certificate_pem" {
  description = "The contents of the .pem X.509 certificate file for the certificate."
  value       = aws_dms_certificate.this.certificate_pem
  sensitive   = true
}

output "certificate_wallet" {
  description = "The contents of the Oracle Wallet certificate for use with SSL."
  value       = aws_dms_certificate.this.certificate_wallet
  sensitive   = true
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = aws_dms_certificate.this.tags
}

output "certificate_arn" {
  description = "The Amazon Resource Name (ARN) for the certificate."
  value       = aws_dms_certificate.this.certificate_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dms_certificate.this.tags_all
}