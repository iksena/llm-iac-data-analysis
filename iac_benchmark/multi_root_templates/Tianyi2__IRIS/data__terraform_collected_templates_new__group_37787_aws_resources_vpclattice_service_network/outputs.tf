output "arn" {
  description = "The ARN of the Association."
  value       = aws_vpclattice_service_network_vpc_association.this.arn
}

output "created_by" {
  description = "The account that created the association."
  value       = aws_vpclattice_service_network_vpc_association.this.created_by
}

output "id" {
  description = "The ID of the association."
  value       = aws_vpclattice_service_network_vpc_association.this.id
}

output "status" {
  description = "The operations status. Valid Values are CREATE_IN_PROGRESS | ACTIVE | DELETE_IN_PROGRESS | CREATE_FAILED | DELETE_FAILED"
  value       = aws_vpclattice_service_network_vpc_association.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpclattice_service_network_vpc_association.this.tags_all
}