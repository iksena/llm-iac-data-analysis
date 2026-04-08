output "arn" {
  description = "ARN of the connector."
  value       = data.aws_mskconnect_connector.this.arn
}

output "description" {
  description = "Summary description of the connector."
  value       = data.aws_mskconnect_connector.this.description
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = data.aws_mskconnect_connector.this.tags
}

output "version" {
  description = "Current version of the connector."
  value       = data.aws_mskconnect_connector.this.version
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_mskconnect_connector.this.region
}

output "name" {
  description = "Name of the connector."
  value       = data.aws_mskconnect_connector.this.name
}