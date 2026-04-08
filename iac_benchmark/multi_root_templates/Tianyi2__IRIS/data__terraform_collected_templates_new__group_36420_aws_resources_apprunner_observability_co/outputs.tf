output "arn" {
  description = "ARN of this observability configuration."
  value       = aws_apprunner_observability_configuration.this.arn
}

output "observability_configuration_revision" {
  description = "The revision of this observability configuration."
  value       = aws_apprunner_observability_configuration.this.observability_configuration_revision
}

output "latest" {
  description = "Whether the observability configuration has the highest observability_configuration_revision among all configurations that share the same observability_configuration_name."
  value       = aws_apprunner_observability_configuration.this.latest
}

output "status" {
  description = "Current state of the observability configuration. An INACTIVE configuration revision has been deleted and can't be used. It is permanently removed some time after deletion."
  value       = aws_apprunner_observability_configuration.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_apprunner_observability_configuration.this.tags_all
}