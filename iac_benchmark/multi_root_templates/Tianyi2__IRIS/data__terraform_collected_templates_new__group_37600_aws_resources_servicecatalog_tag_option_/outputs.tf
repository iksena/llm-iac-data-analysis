output "id" {
  description = "Identifier of the association."
  value       = aws_servicecatalog_tag_option_resource_association.this.id
}

output "resource_arn" {
  description = "ARN of the resource."
  value       = aws_servicecatalog_tag_option_resource_association.this.resource_arn
}

output "resource_created_time" {
  description = "Creation time of the resource."
  value       = aws_servicecatalog_tag_option_resource_association.this.resource_created_time
}

output "resource_description" {
  description = "Description of the resource."
  value       = aws_servicecatalog_tag_option_resource_association.this.resource_description
}

output "resource_name" {
  description = "Description of the resource."
  value       = aws_servicecatalog_tag_option_resource_association.this.resource_name
}