output "arn" {
  description = "Amazon Resource Name (ARN) of the distribution configuration"
  value       = aws_imagebuilder_distribution_configuration.this.arn
}

output "date_created" {
  description = "Date the distribution configuration was created"
  value       = aws_imagebuilder_distribution_configuration.this.date_created
}

output "date_updated" {
  description = "Date the distribution configuration was updated"
  value       = aws_imagebuilder_distribution_configuration.this.date_updated
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_imagebuilder_distribution_configuration.this.tags_all
}

output "name" {
  description = "Name of the distribution configuration"
  value       = aws_imagebuilder_distribution_configuration.this.name
}

output "description" {
  description = "Description of the distribution configuration"
  value       = aws_imagebuilder_distribution_configuration.this.description
}

output "tags" {
  description = "Key-value map of resource tags for the distribution configuration"
  value       = aws_imagebuilder_distribution_configuration.this.tags
}