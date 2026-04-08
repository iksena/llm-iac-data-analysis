output "arn" {
  description = "The ARN of the worker configuration"
  value       = data.aws_mskconnect_worker_configuration.this.arn
}

output "description" {
  description = "A summary description of the worker configuration"
  value       = data.aws_mskconnect_worker_configuration.this.description
}

output "latest_revision" {
  description = "An ID of the latest successfully created revision of the worker configuration"
  value       = data.aws_mskconnect_worker_configuration.this.latest_revision
}

output "properties_file_content" {
  description = "Contents of connect-distributed.properties file"
  value       = data.aws_mskconnect_worker_configuration.this.properties_file_content
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = data.aws_mskconnect_worker_configuration.this.tags
}

output "name" {
  description = "Name of the worker configuration"
  value       = data.aws_mskconnect_worker_configuration.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_mskconnect_worker_configuration.this.region
}