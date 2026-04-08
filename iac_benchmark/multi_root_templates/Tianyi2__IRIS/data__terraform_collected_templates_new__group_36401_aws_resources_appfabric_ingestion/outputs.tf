output "arn" {
  description = "ARN of the Ingestion."
  value       = aws_appfabric_ingestion.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appfabric_ingestion.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_appfabric_ingestion.this.region
}

output "app" {
  description = "Name of the application."
  value       = aws_appfabric_ingestion.this.app
}

output "app_bundle_arn" {
  description = "Amazon Resource Name (ARN) of the app bundle."
  value       = aws_appfabric_ingestion.this.app_bundle_arn
}

output "ingestion_type" {
  description = "Ingestion type."
  value       = aws_appfabric_ingestion.this.ingestion_type
}

output "tenant_id" {
  description = "ID of the application tenant."
  value       = aws_appfabric_ingestion.this.tenant_id
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = aws_appfabric_ingestion.this.tags
}