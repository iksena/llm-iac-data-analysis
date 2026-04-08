output "associated_portal_arns" {
  description = "List of web portal ARNs that this IP access settings resource is associated with."
  value       = aws_workspacesweb_ip_access_settings.this.associated_portal_arns
}

output "ip_access_settings_arn" {
  description = "ARN of the IP access settings resource."
  value       = aws_workspacesweb_ip_access_settings.this.ip_access_settings_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_workspacesweb_ip_access_settings.this.tags_all
}