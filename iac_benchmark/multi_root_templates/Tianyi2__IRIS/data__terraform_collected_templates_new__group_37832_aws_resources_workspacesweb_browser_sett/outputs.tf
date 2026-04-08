output "associated_portal_arns" {
  description = "List of web portal ARNs to associate with the browser settings."
  value       = aws_workspacesweb_browser_settings.this.associated_portal_arns
}

output "browser_settings_arn" {
  description = "ARN of the browser settings resource."
  value       = aws_workspacesweb_browser_settings.this.browser_settings_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_workspacesweb_browser_settings.this.tags_all
}