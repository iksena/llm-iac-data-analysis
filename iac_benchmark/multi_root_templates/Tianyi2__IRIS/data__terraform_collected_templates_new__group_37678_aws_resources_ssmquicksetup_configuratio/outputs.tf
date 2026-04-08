output "name" {
  description = "Configuration manager name."
  value       = aws_ssmquicksetup_configuration_manager.this.name
}

output "description" {
  description = "Description of the configuration manager."
  value       = aws_ssmquicksetup_configuration_manager.this.description
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ssmquicksetup_configuration_manager.this.region
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = aws_ssmquicksetup_configuration_manager.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ssmquicksetup_configuration_manager.this.tags_all
}

output "manager_arn" {
  description = "ARN of the Configuration Manager."
  value       = aws_ssmquicksetup_configuration_manager.this.manager_arn
}

output "status_summaries" {
  description = "A summary of the state of the configuration manager. This includes deployment statuses, association statuses, drift statuses, health checks, and more."
  value       = aws_ssmquicksetup_configuration_manager.this.status_summaries
}

output "configuration_definition" {
  description = "Definition of the Quick Setup configuration that the configuration manager deploys."
  value       = aws_ssmquicksetup_configuration_manager.this.configuration_definition
}