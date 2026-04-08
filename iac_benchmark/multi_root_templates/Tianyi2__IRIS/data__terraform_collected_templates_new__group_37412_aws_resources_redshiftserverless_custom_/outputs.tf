output "workgroup_name" {
  description = "Name of the workgroup."
  value       = aws_redshiftserverless_custom_domain_association.this.workgroup_name
}

output "custom_domain_name" {
  description = "Custom domain associated with the workgroup."
  value       = aws_redshiftserverless_custom_domain_association.this.custom_domain_name
}

output "custom_domain_certificate_arn" {
  description = "ARN of the certificate for the custom domain association."
  value       = aws_redshiftserverless_custom_domain_association.this.custom_domain_certificate_arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_redshiftserverless_custom_domain_association.this.region
}

output "custom_domain_certificate_expiry_time" {
  description = "Expiration time for the certificate."
  value       = aws_redshiftserverless_custom_domain_association.this.custom_domain_certificate_expiry_time
}