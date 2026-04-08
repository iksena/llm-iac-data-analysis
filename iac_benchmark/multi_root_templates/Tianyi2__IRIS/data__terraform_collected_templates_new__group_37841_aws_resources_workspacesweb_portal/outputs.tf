output "browser_type" {
  description = "Browser type of the portal."
  value       = aws_workspacesweb_portal.this.browser_type
}

output "creation_date" {
  description = "Creation date of the portal."
  value       = aws_workspacesweb_portal.this.creation_date
}

output "data_protection_settings_arn" {
  description = "ARN of the data protection settings associated with the portal."
  value       = aws_workspacesweb_portal.this.data_protection_settings_arn
}

output "ip_access_settings_arn" {
  description = "ARN of the IP access settings associated with the portal."
  value       = aws_workspacesweb_portal.this.ip_access_settings_arn
}

output "network_settings_arn" {
  description = "ARN of the network settings associated with the portal."
  value       = aws_workspacesweb_portal.this.network_settings_arn
}

output "portal_arn" {
  description = "ARN of the portal."
  value       = aws_workspacesweb_portal.this.portal_arn
}

output "portal_endpoint" {
  description = "Endpoint URL of the portal."
  value       = aws_workspacesweb_portal.this.portal_endpoint
}

output "portal_status" {
  description = "Status of the portal."
  value       = aws_workspacesweb_portal.this.portal_status
}

output "renderer_type" {
  description = "Renderer type of the portal."
  value       = aws_workspacesweb_portal.this.renderer_type
}

output "session_logger_arn" {
  description = "ARN of the session logger associated with the portal."
  value       = aws_workspacesweb_portal.this.session_logger_arn
}

output "status_reason" {
  description = "Reason for the current status of the portal."
  value       = aws_workspacesweb_portal.this.status_reason
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_workspacesweb_portal.this.tags_all
}

output "trust_store_arn" {
  description = "ARN of the trust store associated with the portal."
  value       = aws_workspacesweb_portal.this.trust_store_arn
}

output "user_access_logging_settings_arn" {
  description = "ARN of the user access logging settings associated with the portal."
  value       = aws_workspacesweb_portal.this.user_access_logging_settings_arn
}

output "user_settings_arn" {
  description = "ARN of the user settings associated with the portal."
  value       = aws_workspacesweb_portal.this.user_settings_arn
}