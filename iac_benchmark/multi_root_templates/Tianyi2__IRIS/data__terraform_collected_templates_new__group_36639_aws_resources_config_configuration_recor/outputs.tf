output "id" {
  description = "Name of the recorder"
  value       = aws_config_configuration_recorder.this.id
}

output "name" {
  description = "The name of the recorder"
  value       = aws_config_configuration_recorder.this.name
}

output "role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM role"
  value       = aws_config_configuration_recorder.this.role_arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_config_configuration_recorder.this.region
}

output "recording_group" {
  description = "Recording group configuration"
  value       = aws_config_configuration_recorder.this.recording_group
}

output "recording_mode" {
  description = "Recording mode configuration"
  value       = aws_config_configuration_recorder.this.recording_mode
}