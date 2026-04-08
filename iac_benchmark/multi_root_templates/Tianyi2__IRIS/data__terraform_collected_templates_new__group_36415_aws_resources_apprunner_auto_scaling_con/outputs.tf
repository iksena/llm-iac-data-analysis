output "arn" {
  description = "ARN of this auto scaling configuration version"
  value       = aws_apprunner_auto_scaling_configuration_version.this.arn
}

output "auto_scaling_configuration_revision" {
  description = "The revision of this auto scaling configuration"
  value       = aws_apprunner_auto_scaling_configuration_version.this.auto_scaling_configuration_revision
}

output "latest" {
  description = "Whether the auto scaling configuration has the highest auto_scaling_configuration_revision among all configurations that share the same auto_scaling_configuration_name"
  value       = aws_apprunner_auto_scaling_configuration_version.this.latest
}

output "status" {
  description = "Current state of the auto scaling configuration"
  value       = aws_apprunner_auto_scaling_configuration_version.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_apprunner_auto_scaling_configuration_version.this.tags_all
}