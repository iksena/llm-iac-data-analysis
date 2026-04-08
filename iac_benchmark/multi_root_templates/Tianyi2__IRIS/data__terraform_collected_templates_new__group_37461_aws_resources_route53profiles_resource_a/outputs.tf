output "id" {
  description = "ID of the Profile Resource Association."
  value       = aws_route53profiles_resource_association.this.id
}

output "name" {
  description = "Name of the Profile Resource Association."
  value       = aws_route53profiles_resource_association.this.name
}

output "resource_type" {
  description = "Type of resource associated with the profile."
  value       = aws_route53profiles_resource_association.this.resource_type
}

output "status" {
  description = "Status of the Profile Association."
  value       = aws_route53profiles_resource_association.this.status
}

output "status_message" {
  description = "Status message of the Profile Resource Association."
  value       = aws_route53profiles_resource_association.this.status_message
}