output "user_access_logging_settings_arn" {
  description = "ARN of the user access logging settings associated with the portal"
  value       = aws_workspacesweb_user_access_logging_settings_association.this.user_access_logging_settings_arn
}

output "portal_arn" {
  description = "ARN of the portal associated with the user access logging settings"
  value       = aws_workspacesweb_user_access_logging_settings_association.this.portal_arn
}

output "region" {
  description = "Region where the resource is managed"
  value       = aws_workspacesweb_user_access_logging_settings_association.this.region
}