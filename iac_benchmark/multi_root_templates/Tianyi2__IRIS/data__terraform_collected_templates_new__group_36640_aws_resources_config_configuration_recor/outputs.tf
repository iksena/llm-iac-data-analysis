output "region" {
  description = "Region where this resource is managed."
  value       = aws_config_configuration_recorder_status.this.region
}

output "name" {
  description = "The name of the recorder."
  value       = aws_config_configuration_recorder_status.this.name
}

output "is_enabled" {
  description = "Whether the configuration recorder is enabled or disabled."
  value       = aws_config_configuration_recorder_status.this.is_enabled
}