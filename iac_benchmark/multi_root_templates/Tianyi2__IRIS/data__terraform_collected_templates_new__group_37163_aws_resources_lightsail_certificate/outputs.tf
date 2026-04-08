output "arn" {
  description = "ARN of the certificate"
  value       = aws_lightsail_certificate.this.arn
}

output "created_at" {
  description = "Date and time when the certificate was created"
  value       = aws_lightsail_certificate.this.created_at
}

output "domain_validation_options" {
  description = "Set of domain validation objects which can be used to complete certificate validation"
  value       = aws_lightsail_certificate.this.domain_validation_options
}

output "id" {
  description = "Name of the certificate (matches name)"
  value       = aws_lightsail_certificate.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_lightsail_certificate.this.tags_all
}