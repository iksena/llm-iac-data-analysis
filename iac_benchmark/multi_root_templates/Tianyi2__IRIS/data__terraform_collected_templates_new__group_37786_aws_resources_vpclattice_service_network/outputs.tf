output "arn" {
  description = "The ARN of the Association."
  value       = aws_vpclattice_service_network_service_association.this.arn
}

output "created_by" {
  description = "The account that created the association."
  value       = aws_vpclattice_service_network_service_association.this.created_by
}

output "custom_domain_name" {
  description = "The custom domain name of the service."
  value       = aws_vpclattice_service_network_service_association.this.custom_domain_name
}

output "dns_entry" {
  description = "The DNS name of the service."
  value       = aws_vpclattice_service_network_service_association.this.dns_entry
}

output "dns_entry_domain_name" {
  description = "The domain name of the service."
  value       = try(aws_vpclattice_service_network_service_association.this.dns_entry[0].domain_name, null)
}

output "dns_entry_hosted_zone_id" {
  description = "The ID of the hosted zone."
  value       = try(aws_vpclattice_service_network_service_association.this.dns_entry[0].hosted_zone_id, null)
}

output "id" {
  description = "The ID of the association."
  value       = aws_vpclattice_service_network_service_association.this.id
}

output "status" {
  description = "The operations status. Valid Values are CREATE_IN_PROGRESS | ACTIVE | DELETE_IN_PROGRESS | CREATE_FAILED | DELETE_FAILED."
  value       = aws_vpclattice_service_network_service_association.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpclattice_service_network_service_association.this.tags_all
}