output "registry_id" {
  description = "The registry ID the scanning configuration applies to."
  value       = aws_ecr_registry_scanning_configuration.this.registry_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ecr_registry_scanning_configuration.this.region
}

output "scan_type" {
  description = "The scanning type set for the registry."
  value       = aws_ecr_registry_scanning_configuration.this.scan_type
}

output "rule" {
  description = "The scanning rules configured for the registry."
  value       = aws_ecr_registry_scanning_configuration.this.rule
}