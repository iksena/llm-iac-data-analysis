output "arn" {
  description = "ARN of the Service Network"
  value       = aws_vpclattice_service_network.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_vpclattice_service_network.this.tags_all
}