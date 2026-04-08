output "id" {
  value       = aws_emr_security_configuration.this.id
  description = "The ID of the EMR Security Configuration (Same as the name)"
}

output "name" {
  value       = aws_emr_security_configuration.this.name
  description = "The Name of the EMR Security Configuration"
}

output "configuration" {
  value       = aws_emr_security_configuration.this.configuration
  description = "The JSON formatted Security Configuration"
}

output "creation_date" {
  value       = aws_emr_security_configuration.this.creation_date
  description = "Date the Security Configuration was created"
}