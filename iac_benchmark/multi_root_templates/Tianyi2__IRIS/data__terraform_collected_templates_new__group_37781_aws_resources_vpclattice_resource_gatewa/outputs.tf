output "arn" {
  description = "ARN of the resource gateway."
  value       = aws_vpclattice_resource_gateway.this.arn
}

output "id" {
  description = "ID of the resource gateway."
  value       = aws_vpclattice_resource_gateway.this.id
}

output "status" {
  description = "Status of the resource gateway."
  value       = aws_vpclattice_resource_gateway.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpclattice_resource_gateway.this.tags_all
}