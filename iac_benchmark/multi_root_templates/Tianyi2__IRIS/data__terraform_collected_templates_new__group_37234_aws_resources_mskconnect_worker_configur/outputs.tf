output "arn" {
  description = "The Amazon Resource Name (ARN) of the worker configuration."
  value       = aws_mskconnect_worker_configuration.this.arn
}

output "latest_revision" {
  description = "An ID of the latest successfully created revision of the worker configuration."
  value       = aws_mskconnect_worker_configuration.this.latest_revision
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_mskconnect_worker_configuration.this.tags_all
}

output "name" {
  description = "The name of the worker configuration."
  value       = aws_mskconnect_worker_configuration.this.name
}

output "properties_file_content" {
  description = "Contents of connect-distributed.properties file."
  value       = aws_mskconnect_worker_configuration.this.properties_file_content
  sensitive   = true
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_mskconnect_worker_configuration.this.region
}

output "description" {
  description = "A summary description of the worker configuration."
  value       = aws_mskconnect_worker_configuration.this.description
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = aws_mskconnect_worker_configuration.this.tags
}