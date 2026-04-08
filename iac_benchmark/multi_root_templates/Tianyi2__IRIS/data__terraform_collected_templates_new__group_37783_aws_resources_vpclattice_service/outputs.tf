output "arn" {
  description = "ARN of the service."
  value       = aws_vpclattice_service.this.arn
}

output "dns_entry" {
  description = "DNS name of the service."
  value       = aws_vpclattice_service.this.dns_entry
}

output "id" {
  description = "Unique identifier for the service."
  value       = aws_vpclattice_service.this.id
}

output "status" {
  description = "Status of the service."
  value       = aws_vpclattice_service.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpclattice_service.this.tags_all
}