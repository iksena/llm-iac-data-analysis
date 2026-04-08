output "arn" {
  description = "ARN of the Ingestion Destination"
  value       = aws_appfabric_ingestion_destination.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_appfabric_ingestion_destination.this.tags_all
}