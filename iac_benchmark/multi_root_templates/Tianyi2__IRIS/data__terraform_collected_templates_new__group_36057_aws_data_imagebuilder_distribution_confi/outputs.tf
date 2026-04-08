output "arn" {
  description = "ARN of the distribution configuration"
  value       = data.aws_imagebuilder_distribution_configuration.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_imagebuilder_distribution_configuration.this.region
}

output "date_created" {
  description = "Date the distribution configuration was created"
  value       = data.aws_imagebuilder_distribution_configuration.this.date_created
}

output "date_updated" {
  description = "Date the distribution configuration was updated"
  value       = data.aws_imagebuilder_distribution_configuration.this.date_updated
}

output "description" {
  description = "Description of the distribution configuration"
  value       = data.aws_imagebuilder_distribution_configuration.this.description
}

output "distribution" {
  description = "Set of distributions"
  value       = data.aws_imagebuilder_distribution_configuration.this.distribution
}

output "name" {
  description = "Name of the distribution configuration"
  value       = data.aws_imagebuilder_distribution_configuration.this.name
}

output "tags" {
  description = "Key-value map of resource tags for the distribution configuration"
  value       = data.aws_imagebuilder_distribution_configuration.this.tags
}