output "id" {
  value       = aws_ssm_maintenance_window.this.id
  description = "The ID of the maintenance window."
}

output "tags_all" {
  value       = aws_ssm_maintenance_window.this.tags_all
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}