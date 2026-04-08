output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_rds_certificate.this.region
}

output "id" {
  description = "Certificate identifier."
  value       = data.aws_rds_certificate.this.id
}

output "default_for_new_launches" {
  description = "Whether this is the default certificate for new RDS instances."
  value       = data.aws_rds_certificate.this.default_for_new_launches
}

output "latest_valid_till" {
  description = "Whether this certificate has the latest ValidTill."
  value       = data.aws_rds_certificate.this.latest_valid_till
}

output "arn" {
  description = "ARN of the certificate."
  value       = data.aws_rds_certificate.this.arn
}

output "certificate_type" {
  description = "Type of certificate. For example, CA."
  value       = data.aws_rds_certificate.this.certificate_type
}

output "customer_override" {
  description = "Boolean whether there is an override for the default certificate identifier."
  value       = data.aws_rds_certificate.this.customer_override
}

output "customer_override_valid_till" {
  description = "If there is an override for the default certificate identifier, when the override expires."
  value       = data.aws_rds_certificate.this.customer_override_valid_till
}

output "thumbprint" {
  description = "Thumbprint of the certificate."
  value       = data.aws_rds_certificate.this.thumbprint
}

output "valid_from" {
  description = "RFC3339 format of certificate starting validity date."
  value       = data.aws_rds_certificate.this.valid_from
}

output "valid_till" {
  description = "RFC3339 format of certificate ending validity date."
  value       = data.aws_rds_certificate.this.valid_till
}