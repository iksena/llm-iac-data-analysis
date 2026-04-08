output "arn" {
  description = "Amazon Resource Name (ARN) of the component"
  value       = aws_imagebuilder_component.this.arn
}

output "date_created" {
  description = "Date the component was created"
  value       = aws_imagebuilder_component.this.date_created
}

output "encrypted" {
  description = "Encryption status of the component"
  value       = aws_imagebuilder_component.this.encrypted
}

output "owner" {
  description = "Owner of the component"
  value       = aws_imagebuilder_component.this.owner
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_imagebuilder_component.this.tags_all
}

output "type" {
  description = "Type of the component"
  value       = aws_imagebuilder_component.this.type
}