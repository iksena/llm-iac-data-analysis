
output "ip_access_settings_arn" {
  description = "ARN of the IP access settings associated with the portal"
  value       = aws_workspacesweb_ip_access_settings_association.this.ip_access_settings_arn
}

output "portal_arn" {
  description = "ARN of the portal associated with the IP access settings"
  value       = aws_workspacesweb_ip_access_settings_association.this.portal_arn
}