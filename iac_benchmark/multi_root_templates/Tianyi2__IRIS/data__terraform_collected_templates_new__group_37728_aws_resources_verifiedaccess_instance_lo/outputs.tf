output "id" {
  description = "The ID of the Verified Access Instance Logging Configuration"
  value       = aws_verifiedaccess_instance_logging_configuration.this.id
}

output "verifiedaccess_instance_id" {
  description = "The ID of the Verified Access instance"
  value       = aws_verifiedaccess_instance_logging_configuration.this.verifiedaccess_instance_id
}