output "arn" {
  description = "ARN of the resource gateway"
  value       = aws_vpclattice_resource_configuration.this.arn
}

output "id" {
  description = "ID of the resource gateway"
  value       = aws_vpclattice_resource_configuration.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_vpclattice_resource_configuration.this.tags_all
}