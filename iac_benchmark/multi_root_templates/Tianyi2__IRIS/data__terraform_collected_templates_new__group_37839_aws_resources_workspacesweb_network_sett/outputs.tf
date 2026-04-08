output "associated_portal_arns" {
  description = "List of web portal ARNs associated with the network settings"
  value       = aws_workspacesweb_network_settings.this.associated_portal_arns
}

output "network_settings_arn" {
  description = "ARN of the network settings resource"
  value       = aws_workspacesweb_network_settings.this.network_settings_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_workspacesweb_network_settings.this.tags_all
}