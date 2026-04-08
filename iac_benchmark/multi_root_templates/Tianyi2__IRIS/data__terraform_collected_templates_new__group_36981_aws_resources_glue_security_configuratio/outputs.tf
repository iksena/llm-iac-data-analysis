output "id" {
  description = "Glue security configuration name"
  value       = aws_glue_security_configuration.this.id
}

output "name" {
  description = "Name of the security configuration"
  value       = aws_glue_security_configuration.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_glue_security_configuration.this.region
}