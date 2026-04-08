output "arn" {
  description = "ARN of the service."
  value       = data.aws_vpclattice_service.this.arn
}

output "auth_type" {
  description = "Type of IAM policy. Either NONE or AWS_IAM."
  value       = data.aws_vpclattice_service.this.auth_type
}

output "certificate_arn" {
  description = "Amazon Resource Name (ARN) of the certificate."
  value       = data.aws_vpclattice_service.this.certificate_arn
}

output "custom_domain_name" {
  description = "Custom domain name of the service."
  value       = data.aws_vpclattice_service.this.custom_domain_name
}

output "dns_entry" {
  description = "List of objects with DNS names."
  value       = data.aws_vpclattice_service.this.dns_entry
}

output "id" {
  description = "Unique identifier for the service."
  value       = data.aws_vpclattice_service.this.id
}

output "status" {
  description = "Status of the service."
  value       = data.aws_vpclattice_service.this.status
}

output "tags" {
  description = "List of tags associated with the service."
  value       = data.aws_vpclattice_service.this.tags
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_vpclattice_service.this.region
}

output "name" {
  description = "Service name."
  value       = data.aws_vpclattice_service.this.name
}

output "service_identifier" {
  description = "ID or Amazon Resource Name (ARN) of the service."
  value       = data.aws_vpclattice_service.this.service_identifier
}