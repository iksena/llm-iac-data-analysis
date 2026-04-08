output "id" {
  description = "ID of the Profile Association."
  value       = aws_route53profiles_association.this.id
}

output "status" {
  description = "Status of the Profile Association."
  value       = aws_route53profiles_association.this.status
}

output "status_message" {
  description = "Status message of the Profile Association."
  value       = aws_route53profiles_association.this.status_message
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_route53profiles_association.this.tags_all
}