output "arn" {
  description = "Amazon Resource Name (ARN) of parameter group"
  value       = aws_redshift_parameter_group.this.arn
}

output "id" {
  description = "The Redshift parameter group name"
  value       = aws_redshift_parameter_group.this.id
}

output "name" {
  description = "The name of the Redshift parameter group"
  value       = aws_redshift_parameter_group.this.name
}

output "family" {
  description = "The family of the Redshift parameter group"
  value       = aws_redshift_parameter_group.this.family
}

output "description" {
  description = "The description of the Redshift parameter group"
  value       = aws_redshift_parameter_group.this.description
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_redshift_parameter_group.this.region
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_redshift_parameter_group.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_redshift_parameter_group.this.tags_all
}