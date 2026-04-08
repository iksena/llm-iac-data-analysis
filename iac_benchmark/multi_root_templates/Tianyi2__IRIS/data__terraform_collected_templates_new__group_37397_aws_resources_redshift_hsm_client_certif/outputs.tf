output "arn" {
  description = "Amazon Resource Name (ARN) of the Hsm Client Certificate."
  value       = aws_redshift_hsm_client_certificate.this.arn
}

output "hsm_client_certificate_public_key" {
  description = "The public key that the Amazon Redshift cluster will use to connect to the HSM. You must register the public key in the HSM."
  value       = aws_redshift_hsm_client_certificate.this.hsm_client_certificate_public_key
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_redshift_hsm_client_certificate.this.tags_all
}