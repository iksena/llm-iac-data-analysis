output "id" {
  description = "Amazon Resource Name (ARN) of the configuration"
  value       = aws_imagebuilder_infrastructure_configuration.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the configuration"
  value       = aws_imagebuilder_infrastructure_configuration.this.arn
}

output "date_created" {
  description = "Date when the configuration was created"
  value       = aws_imagebuilder_infrastructure_configuration.this.date_created
}

output "date_updated" {
  description = "Date when the configuration was updated"
  value       = aws_imagebuilder_infrastructure_configuration.this.date_updated
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_imagebuilder_infrastructure_configuration.this.tags_all
}