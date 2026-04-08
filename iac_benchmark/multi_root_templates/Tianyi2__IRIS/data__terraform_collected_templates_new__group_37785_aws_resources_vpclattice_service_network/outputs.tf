output "arn" {
  description = "ARN of the Service Network Resource Association."
  value       = aws_vpclattice_service_network_resource_association.this.arn
}

output "id" {
  description = "ID of the association."
  value       = aws_vpclattice_service_network_resource_association.this.id
}

output "dns_entry" {
  description = "DNS entry of the association in the service network."
  value       = aws_vpclattice_service_network_resource_association.this.dns_entry
}

output "domain_name" {
  description = "The domain name of the association in the service network."
  value       = try(aws_vpclattice_service_network_resource_association.this.dns_entry[0].domain_name, null)
}

output "hosted_zone_id" {
  description = "The ID of the hosted zone containing the domain name."
  value       = try(aws_vpclattice_service_network_resource_association.this.dns_entry[0].hosted_zone_id, null)
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpclattice_service_network_resource_association.this.tags_all
}