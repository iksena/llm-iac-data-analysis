output "arn" {
  description = "Replication configuration template ARN"
  value       = aws_drs_replication_configuration_template.this.arn
}

output "id" {
  description = "Replication configuration template ID"
  value       = aws_drs_replication_configuration_template.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_drs_replication_configuration_template.this.tags_all
}