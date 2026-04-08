output "associated_portal_arns" {
  description = "List of web portal ARNs that this user access logging settings resource is associated with"
  value       = aws_workspacesweb_user_access_logging_settings.this.associated_portal_arns
}

output "user_access_logging_settings_arn" {
  description = "ARN of the user access logging settings resource"
  value       = aws_workspacesweb_user_access_logging_settings.this.user_access_logging_settings_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_workspacesweb_user_access_logging_settings.this.tags_all
}