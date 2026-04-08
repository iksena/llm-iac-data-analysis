output "user_settings_arn" {
  description = "ARN of the user settings resource"
  value       = aws_workspacesweb_user_settings.this.user_settings_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_workspacesweb_user_settings.this.tags_all
}